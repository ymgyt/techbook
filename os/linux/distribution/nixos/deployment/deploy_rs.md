# deploy-rs

* flakeが前提


## Example

```nix
{
  description = "Deployment for my home server cluster";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    deploy-rs.url = "github:serokell/deploy-rs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, deploy-rs, flake-utils, }:
    let
      spec = {
        user = "ymgyt";
        defaultGateway = "192.168.10.1";
        nameservers = [ "8.8.8.8" ];
      };
    in {
      nixosConfigurations = {
        rpi4-01 = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = spec;
          modules = [ ./hosts/rpi4-01.nix ];
        };
        rpi4-02 = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = spec;
          modules = [ ./hosts/rpi4-02.nix ];
        };
      };

      deploy = {
        # Deployment options applied to all nodes
        sshUser = spec.user;
        # User to which profile will be deployed.
        user = "root";
        sshOpts = [ "-p" "22" "-F" "./ssh.config" ];

        fastConnection = false;
        autoRollback = true;
        magicRollback = true;

        # Or setup cross compilation
        remoteBuild = true;

        nodes = {
          rpi4-01 = {
            hostname = "rpi4-01";
            profiles.system = {
              path = deploy-rs.lib.aarch64-linux.activate.nixos
                self.nixosConfigurations.rpi4-01;
            };
          };
          rpi4-02 = {
            hostname = "rpi4-02";
            profiles.system = {
              path = deploy-rs.lib.aarch64-linux.activate.nixos
                self.nixosConfigurations.rpi4-02;
            };
          };
        };
      };

      checks = builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    } // flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = pkgs.mkShell { buildInputs = [ pkgs.deploy-rs pkgs.nixfmt ]; };
      });
}
```

* flakeのoutputに`deploy`を追加する
  * `deploy-rs`が読み込んでくれる
  * nodeの設定は通常のnixosConfigurationで行える
* nodeごとにnixのprofileの単位で制御できる
  * profileの切り分けはまだうまくできていない
* `remoteBuild`
  * host machineとnodeの`system`が違う場合にremoteでbuild実行できる


## Deploy

```sh
# Deploy all nodes
deploy --skip-checks --interactive .

# Deploy rpi4-01 node
deploy .#rpi4-01
```

* `--skip-checks`でcheckを飛ばせる
  * systemが違ったりでうまくいかない場合に使える
* `--interactive`で実行前に確認できる

* `<flake>#<node>.<profile>`という指定でnodeやprofileを制御できる
  * `deploy .`              : 全nodeのdeploy
  * `deploy .#node1`        : node1のdeploy
  * `deploy .#node1.system` : node1のsystem profileのdeploy


## Memo

deployの情報は`nix eval --json .#deploy` で取得している

- main()
- run()
  - parse args
  - init logger
  - parse flake url
    - ".#<node>.<profile>"の処理
  - cli flagをdeploy::CmdOerridesにbind
  - flakeのsupportの判定
- check_deployment()
  - nix flake checkの実行
- get_deployment_data() -> deploy::data::Data
  - `nix flake eval --json --apply`でflake.nixのdeployから対象のnode, profileを抽出
  - serde_jsonでdeserialize
- run_deploy()
  - make_deploy_data()でsettingの適用階層を解決
    - cliのoverride, node個別のssh設定等
    - deploy::data::Dataは生のflakeに対応
    - deploy::DeployDataは解決後の値
  - for each part
    - prompt_deployment() or print_deployment()
  - for each part
    - deploy::push::build_profile()
      - if remote_build
        - build_profile_remotely()
          - `nix copy -s --to ssh-ng://${ssh_user}@${hostname} --derivation /nix/store/abc...xyz-activatable-nixos-system-host-xyz.drv^out`
          - `nix build /nix/store/abc...xyz-activatable-nixos-system-host-xyz.drv^out --eval-store auto --store ssh-ng://${ssh_user}@${hostname}`
      - else
        - build_profile_locally()
          - `nix build /nix/store/abc...xyz-activatable-nixos-system-host-xyz.drv^out --no-link`
  - for each part
    - deploy::push::push_profile()
      - if not remote_build
        - `nix copy --substitute-on-destination --no-check-sigs --to ssh://${ssh_user}@${hostname} /nix/store/abc...xyz-activatable-nixos-system-host-xyz`
  - for each part
    - deploy::deploy::deploy_profile()
      - TODO: debug activate_command
      - TODO: debug wait_command
      - spawn activate
      - spawn and wait wait command
      - wait success
      - confirm_profile()
        - ssh rm ${canary}
      - join activate command
      - if error
        - for each succeeded
          - deploy::deploy::revoke()

## types

- DeployFlake: flake.nixのpath, node, profileを保持
- DeployData: 設定の優先度を反映してEffectiveな値
- DeployDefs: ssh user, sudo profile user等のuserに関する設定を保持

## derivations

- ${profile}/deploy-rs-activate
- ${profile}/activate-rs
  - deploy-rs bin activate
    - deploy-rs.deploy-rs/bin/activate
