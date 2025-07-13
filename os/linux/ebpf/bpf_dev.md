# BPF Developing

* `man bpf-helpers` : helper functionsを確認する

## debug

### `/sys/kernel/debug/tracing/`

* `bpf_trace_printk`の出力先
* `trace`と`trace_pipe`は同じデータ
* `trace`
  * static data
  * `/sys/kernel/debug/tracing/buffer_size_kb`でサイズが決まる
* `trace_pip`

## flake.nix

```nix

{
  description = "BPF development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # BPF toolchain
            # clang
            llvmPackages_20.clang-unwrapped
            llvm
            libbpf
            linuxHeaders

          ];

          shellHook = ''
            echo "BPF development environment loaded"
            echo "Available tools:"
            echo "  - clang ($(clang --version | head -1))"
            echo "  - libbpf"
            echo "  - kernel headers"
            echo "linux headers - ${pkgs.linuxHeaders}/include"
            echo "bpf   headers - ${pkgs.libbpf}/include"

            # Set header paths for BPF compilation
            export C_INCLUDE_PATH="${pkgs.linuxHeaders}/include:${pkgs.libbpf}/include"
          '';
        };
      }
    );
}
```

## vmlinux.hの生成

```sh
 bpftool btf dump file /sys/kernel/btf/vmlinux format c out> vmlinux.h
```

