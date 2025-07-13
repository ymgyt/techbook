# bpftool

## Usage

```sh
# featureの確認
bpftool feature

# bpf program一覧
bpftool prog list
bpftool prog show

# program詳細
bpftool prog show id 23 --pretty

# List maps
bpftool map list

# mapのdump
bpftool map dump name hello.bss
```


### programの詳細

```sh
bpftool prog show id 123 --json

pbftool dump xlated id 123
```
* idはlist,showで確認
* `--json`, `--pretty`


### Map

```sh
bpftool map show
bpftool map dump id 123
```

### BTF

```sh
# vmlinux.h を生成
bpftool btf dump file /sys/kernel/btf/vmlinux format c
```
