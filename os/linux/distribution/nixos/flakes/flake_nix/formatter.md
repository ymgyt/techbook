# formatter

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
