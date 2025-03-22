# Rust Flake Recipe

## rustPlatform

```nix
{
  description = "Example rust flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: 
    flake-utils.lib.eachDefaultSystem (system: 
    let 
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages.default = pkgs.rustPlatform.buildRustPackage {
        pname = "foo";
        version = "0.1.0";
        src = ./.;

        cargoHash = "sha256-cOxoK8/3nkaXPb6uTefpKRTwvUK7M3oSbOX6yGcG/fQ=";
      };
    });
}
```

* `nix build .`
* `Cargo.toml`,`Cargo.lock`がある前提