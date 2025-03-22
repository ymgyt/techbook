# Develop environment flake

```nix
{
  description = "A Nix-flake-based development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , flake-utils
    }:

    # Support ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"]
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      pkgs-unstable = import nixpkgs-unstable { inherit system; }; 
    in
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          # for makers
          pkgs-unstable.cargo-make
          
          shellcheck
          terraform
        ];
        shellHook = ''
          export CARGO_MAKE_HOME=".config/makers" 
        '';
      };
    });
}
```

## Allow unfree

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.11";
  };

  outputs =
    { self
    , nixpkgs
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { 
        inherit system;
        # terraform change licence to unfree
        config.allowUnfree = true;
      };
    in
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          terraform
        ]; 
      };
    };
```

* defaultではunfreeなpackageがあると失敗する
* nixpkgs import時に指定する