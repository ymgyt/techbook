# objdump

```sh
# sections headerの表示(-h)
objdump --section-headers bin

# program header(segments)の表示
objdump -p bin
```

* `--x86-asm-syntax=intel`
  * asmをintel記法にする
  * `att`もある
