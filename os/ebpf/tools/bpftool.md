# bpftool

## Usage

```sh
# bpf program一覧
bpftool prog list

# program詳細
bpftool prog show id 23 --pretty

# List maps
bpftool map list

# mapのdump
bpftool map dump name hello.bss
```
