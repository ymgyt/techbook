# BPF maps

* `include/linux/uapi/bpf.h`の`enum bpf_map_type`に定義されている
* userspaceからは`bpf` syscallでcreate/update等の操作を行う

## 参考

- [Oracle Linux Blog: BPF In Depth: Communicating with Userspace](https://blogs.oracle.com/linux/post/bpf-in-depth-communicating-with-userspace)
