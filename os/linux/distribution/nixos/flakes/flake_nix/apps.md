# apps

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
          program = "${self.packages.${system}.default}/bin/runme";
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
