# Aya

## 環境構築

```nix
{
  description = "Aya configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [ bpf-linker cargo-generate bpftool ];
          shellHook = "\n            exec nu\n          ";
        };
      });
}
```

```sh
# Install aya-tool
# aya-toolはnixにない
cargo install --git https://github.com/aya-rs/aya -- aya-tool

cargo generate https://github.com/aya-rs/aya-template
```

## Workflow

```sh
# foo-ebpf はnightlyでbuildする
rustup toolchain install nightly --component rust-src```

### bindings(vmlinux)

```sh
# sock sock_commonの型を生成
# CONFIG_DEBUG_INFO_BTF=y が前提
 ~/.cargo/bin/aya-tool generate sock sock_common out> kprobeho-ebpf/src/vmlinux.rs
```
