# flake.nix inputs and outputs

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
    packages."<system>".default = derivation;

    # Used by `nix develop`
    devShells."<system>".default = derivation;

    # Used by `nix develop .#<name>`
    devShells."<system>"."<name>" = derivation;
  }
}
```
