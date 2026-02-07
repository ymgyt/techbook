# sendmsg

## SCM_RIGHTS

* プロセスが保持しているfdを他プロセスに渡せる
  * fdを整数としても渡しても意味がない
* `memfd_create()`で作ったfdを共有して、`mmap()`でメモリ共有
