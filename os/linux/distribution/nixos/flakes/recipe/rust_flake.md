# Rust Flake Recipe

```nix
{
  description = "A Nix-flake-based Rust development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, rust-overlay }:
    let
      overlays = [
        rust-overlay.overlays.default
        (final: prev: {
          rustToolchain =
            let
              rust = prev.rust-bin;
            in
            if builtins.pathExists ./rust-toolchain.toml then
              rust.fromRustupToolchainFile ./rust-toolchain.toml
            else if builtins.pathExists ./rust-toolchain then
              rust.fromRustupToolchainFile ./rust-toolchain
            else
              rust.stable.latest.default;
        })
      ];
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit overlays system; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            rustToolchain
            openssl
            pkg-config
            cargo-make
            cargo-sort
            cargo-nextest
            rust-analyzer
          ];
          shellHook = ''
            exec nu
          '';
        };
      });
    };
}
```

## crane

```nix
{
  description = "Telemetryd flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    crane = {
      url = "github:ipetkov/crane";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        rust-overlay.follows = "rust-overlay";
      };
    };

    flake-utils.url = "github:numtide/flake-utils";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = { self, nixpkgs, flake-utils, crane, rust-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ (import rust-overlay) ];
        };

        rustToolchain = pkgs.rust-bin.stable.latest.default;

        craneLib = (crane.mkLib pkgs).overrideToolchain rustToolchain;

        # Tell crane telemetryd Cargo.toml path to inspect package name and version
        crate = craneLib.crateNameFromCargoToml { cargoToml = ./telemetryd/Cargo.toml; };

        telemetryd = craneLib.buildPackage {
          inherit (crate) pname version;
          src = craneLib.cleanCargoSource (craneLib.path ./.);

          cargoExtraArgs = "--package telemetryd";

          buildInputs = [ ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [ ];
        }; 
      in {
        packages.default = self.packages."${system}".telemetryd;
        packages.telemetryd = telemetryd;

        apps.default = {
          type = "app";
          program = "${telemetryd}/bin/binname";
        };
        apps.opentelemetry-cli = {
          type = "app";
          program = "${telemetryd}/bin/binname";
        };

        devShells.default = pkgs.mkShell { buildInputs = [ pkgs.nixfmt ]; };
      });
}
```

## wasm-pack

rustup targetにwasm-unknown-unknownを追加するのが難しい。  

```nix
{
  description = "wasm-pack setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system: 
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ rust-overlay.overlays.default ];
      };
    in
    {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          cargo
          wasm-pack
          (rust-bin.stable.latest.default.override {
            extensions = [ "rust-src" ];
            targets = [ "wasm32-unknown-unknown" ];
          })
        ];
      };
    });
}
```