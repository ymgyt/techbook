# bpf-helper

## `bpf_get_current_pid_tgid()`

* Get the current pid and tgid.
* Return A 64-bit integer containing the current tgid and pid

## `bpf_printk`

* `libbpf`の`bpf/bpf_helpers.h`に定義されているmacro
* 内部的には`bpf_trace_printk`を呼び出す
