# import nixpkgs in flake.nix

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
