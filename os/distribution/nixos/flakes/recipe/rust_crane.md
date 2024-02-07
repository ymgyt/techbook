# Rust crane recipe

```nix
{
  description = "syndicationd";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.11";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, fenix, crane, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ fenix.overlays.default ];
        pkgs = import nixpkgs { inherit system overlays; };
        rustToolchain = fenix.packages.${system}.fromToolchainFile {
          file = ./rust-toolchain.toml;
          sha256 = "sha256-SXRtAuO4IqNOQq+nLbrsDFbVk+3aVA8NNpSZsKlVH/8=";
        };

        craneLib = crane.lib.${system}.overrideToolchain rustToolchain;
        src = craneLib.cleanCargoSource (craneLib.path ./.);

        commonArgs = {
          inherit src;
          strictDeps = true;

          # pname and version required, so set dummpy values
          pname = "syndicationd-workspace";
          version = "0.1";

          buildInputs = [ ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [ pkgs.libconv pkgs.darwin.apple_sdk.frameworks.Security ];
        };

        cargoArtifacts = craneLib.buildDepsOnly commonArgs;

        syndtermCrate = craneLib.crateNameFromCargoToml {
          cargoToml = ./syndterm/Cargo.toml;
        };
        syndterm = craneLib.buildPackage (commonArgs // {
          inherit cargoArtifacts;
          inherit (syndtermCrate) pname version;
          cargoExtraArgs = "--package ${syndtermCrate.pname}";
        });

        syndapiCrate = craneLib.crateNameFromCargoToml {
          cargoToml = ./syndapi/Cargo.toml;
        };
        syndapi = craneLib.buildPackage (commonArgs // {
          inherit cargoArtifacts;
          inherit (syndapiCrate) pname version;
          cargoExtraArgs = "--package ${syndapiCrate.pname}";
        });

        checks = {
          inherit syndterm;

          clippy = craneLib.cargoClippy (commonArgs // {
            inherit cargoArtifacts;
            cargoClippyExtraArgs = "--workspace -- --deny warnings";
          });

          nextest = craneLib.cargoNextest (commonArgs // {
            inherit cargoArtifacts;

            CARGO_PROFILE = "";
          });

          fmt = craneLib.cargoFmt commonArgs;
        };
      in {
        inherit checks;

        packages.default = self.packages."${system}".syndterm;
        packages.syndterm = syndterm;
        packages.syndapi = syndapi;

        apps.default = flake-utils.lib.mkApp {
          drv = syndterm;
        };

        devShells.default = craneLib.devShell {
          packages = with pkgs; [
            # cargo and rustc provided by default
            just
            cargo-nextest
            graphql-client
            nixfmt
            rust-analyzer
            nushell
          ];

          shellHook = ''
            # Use nushell as default shell
            exec nu
          '';
        };
      });
}
```

## Source filter


```nix
{
    inherit (pkgs) lib;
    
    src = lib.cleanSourceWith {
      src = ./.; # The original, unfiltered source
      filter = path: type:
        (lib.hasSuffix "\.html" path) ||
        (lib.hasSuffix "\.scss" path) ||
        # Example of a folder for images, icons, etc
        (lib.hasInfix "/assets/" path) ||
        # Default filter from crane (allow .rs files)
        (craneLib.filterCargoSources path type)
      ;
    };

    # Common arguments can be set here to avoid repeating them later
    commonArgs = {
      inherit src;
      # ...
    };
}
```

* `.rs`以外にも依存している場合にfilterを書ける
  * `path: type: bool`の型
  * `path`には`/nix/store/...`のfull pathが入る
  * `type`にはfileやdirectoryが入る
