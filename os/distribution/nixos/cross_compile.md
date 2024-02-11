# Nix Cross Compile

host machineが`x86_64-linux`でbuildしたい対象が`aarch64-linux`の場合にどうするか

1. cross-compilation toolchainを使う
2. QEMUでemulateする

## crossSystem

```nix
{
  description = "NixOS running on LicheePi 4A";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
  };

  outputs = inputs@{ self, nixpkgs, ... }: {
    nixosConfigurations.foo = nixpkgs.lib.nixosSystem {
      # native platform
      system = "x86_64-linux";
      modules = [

        # add this module, to enable cross-compilation.
        {
          nixpkgs.crossSystem = {
            # target platform
            system = "riscv64-linux";
          };
        }

        # ...... other modules
      ];
    };
  };
}
```

## Emulation

hostのnixos moduleに以下を追加
```nix
{ ... }:
{
  # Enable binfmt emulation.
  boot.binfmt.emulatedSystems = [ "aarch64-linux" "riscv64-linux" ];
}
```
flake

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
  };

  outputs = inputs@{ self, nixpkgs, ... }: {
    nixosConfigurations.lp4a = nixpkgs.lib.nixosSystem {
      # native platform
      system = "aarch64-linux";
      modules = [
        # ...... other modules
      ];
    };
  };
}
```

hostのsystemと違うと透過的にemulationでbuildされる

## 参考

* [this cute world](https://nixos-and-flakes.thiscute.world/development/cross-platform-compilation)
