# agenix

agenixによるsecrets管理。

## 概要

Secretの暗号化/復号化に用いるssh key pairがある前提。  
ageのcliで暗号化したいfileを暗号化する。 
agenixに情報を伝えるためのfileに暗号化したfileと暗号化用の公開鍵を記載する。  

Secretを展開したいNixOS serverに対応する秘密鍵を配置する。  
NisOSのconfigurationにageのnixos moduleとagecliで作成したfileを指定する。  
nixos-rebuildするとageが復号化したのち指定のpathに配置してくれるので、利用したいsystemはplain textとして読み込む。


## Usage

### Secretの作成

`mysecrets`というprivate git repositoryにいる前提。  
`ssh-keygen`で`mykey`と`mykey.pub`を作ってある前提。  

`secrets.nix`を作成する。  

```
let nixos_age = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIImldYRTvidAq85iAt3fgWRmhKlcGdE6RyTY3EYl6pJW age";

in
{
  "foo.age".publicKeys = [ nixos_age ];
} 
```

管理したいsecret `foo.age`を生成する

```
nix run github:yaxitech/ragenix -- -e foo.age  
```

`$EDITOR`が開くのでsecretを入力する。 


### Secretの配置

`ragenix`と`mysecrets`をinputsに加える。

`flake.nix`

```
{
  inputs = {
    # ... 

    # secrets management
    ragenix.url = "github:yaxitech/ragenix";
    mysecrets = {
      url = "github:ymgyt/mysecrets/main";
      flake = false;
    };
  };

  outputs =
    { 
    # ...
    , ragenix
    , mysecrets
    , ...
    }@inputs:
    let
      systems = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];

      forAllSystems = nixpkgs.lib.genAttrs systems;
      specialArgs = {
        inherit telemetryd ragenix mysecrets;
      };
    in
    {
      nixosConfigurations = {
        foo = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          inherit specialArgs;

          modules = [
            # ...
            ./secrets
          ];
        };
      };
    }
}
```

`secrets/default.nix`

```
{ ragenix, mysecrets, ... }:
{
  imports = [
    ragenix.nixosModules.default
  ];

  # 生成したkey pairの秘密鍵へのpath
  age.identityPaths = [
    "/home/foo/.ssh/mykey"
  ];

  age.secrets."foo" = {

    symlink = false;
    # Plaintextのpath
    path = "/etc/agehandson/foo";
    # 暗号化されたage path
    file = "${mysecrets}/foo.age";
    mode = "0400";
    owner = "root";
    group = "root";
  };
}
```

1. `age.identityPaths`に指定した秘密鍵をdeploy対象serverに配置する
2. deploy-rs等でdeployする。