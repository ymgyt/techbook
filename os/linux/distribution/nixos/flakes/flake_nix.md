# flake.nix

## `import nixpkgs`

```nix
{ inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/23.11";
  flake-utils.url = "github:numtide/flake-utils/v1.0.0";
  };

  outputs = { flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # terraform等のunfreeを入れたい場合はallowUnfree = true
        config = { allowUnfree = false; };

        overlay = self: super: {
          hello = super.hello.overrideAttrs (_: { doCheck = false; });
        };

        overlays = [ overlay ];
        
        pkgs = import nixpkgs { inherit system config overlays; };
      in
        { packages.default = pkgs.hello; }
    );
}
```

* なぜ`import nixpkgs`できるか
  * `outPath` attributeをnixpkgsがもっているので、pathとして扱われる
  * `pkgs = import nixpkgs.outPath { ... }`とも書ける
* flakeのinputは`outPath`をもっている

## `inputs`

* inputsの結果はinput URL先のflakeのoutput
* `nixpkgs`の場合は
  * lib,checks,htmlDocs, legacyPackages, nixosModulesをもっている

## `outputs`

```nix
{
  inputs = {
    # ...
  };

  outputs = { self, ...}@inputs: {
    # Executed by nix build
    package."<system>".default = derivation;

    # Used by `nix develop`
    devShells."<system>".default = derivation;

    # Used by `nix develop .#<name>`
    devShells."<system>"."<name>" = derivation;
  }
}
```

### `devShells`

```nix
{
  description = "A Nix-flake-based Node.js development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
  };

  outputs = { self , nixpkgs ,... }: let
    # system should match the system you are running on
    # system = "x86_64-linux";
    system = "x86_64-darwin";
  in {
    devShells."${system}".default = let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (self: super: rec {
            nodejs = super.nodejs-18_x;
            pnpm = super.nodePackages.pnpm;
            yarn = (super.yarn.override { inherit nodejs; });
          })
        ];
      };
    in pkgs.mkShell {
      # create an environment with nodejs-18_x, pnpm, and yarn
      packages = with pkgs; [
        node2nix
        nodejs
        pnpm
        yarn
        nushell
      ];

      # derivationのbuild inputsを追加
      inputsFrom = [];

      shellHook = ''
        echo "node `${pkgs.nodejs}/bin/node --version`"
        exec nu
      '';
    };
  };
}
```

* `pkgs.mkShell`の`package`と`buildInputs`派があり、どう違うのかわかっていない

### app

```nix
{
  description = "runme application";

  inputs = {
    nixpkgs.url = "nixpkgs"; # Resolves to github:NixOS/nixpkgs
    # Helpers for system-specific outputs
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    # Create system-specific outputs for the standard Nix systems
    # https://github.com/numtide/flake-utils/blob/master/default.nix#L3-L9
    flake-utils.lib.eachDefaultSystem (system:
      let
      	pkgs = import nixpkgs { inherit system; };
      in
      {
        # A simple executable package
        packages.default = pkgs.writeScriptBin "runme" ''
          echo "I am currently being run!"
        '';

        # An app that uses the `runme` package
        apps.default = {
          type = "app";
          program = "${self.packages.${system}.runme}/bin/runme";
        };
      });
}
```

appが複数ある場合

```nix
{
  apps = {
    my-linter = {
      type = "app";
      program = "${myLinter}/bin/my-linter";
    };

    my-checker = {
      type = "app";
      program = "${myChecker}/bin/my-checker";
    };
  };
}
```

* `apps.default`だと`nix run .#`で実行できる

### formatter

```nix
{
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
      	pkgs = import nixpkgs { inherit system; };
      in
      {
        formatter = pkgs.nixfmt-rfc-style;
      });
}
```

* outputの`formatter`にformat用のpackageを指定すると`nix fmt`で利用される


## nixConfig

```nix
{ 
  outputs = {};
  nixConfig = {
    extra-substituers = ["https://foo.cachix.org"];
    extra-trusted-public-keys = ["foo.cachix.org-1:xxxx"];
  }
}
```

* project(flake)で利用する追加のsubstituersを指定できる
  * `extra-`をつけると既存に追加してくれる
