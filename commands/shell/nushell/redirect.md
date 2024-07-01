# Redirect

```sh
# Stdout
echo "Hello" out> out.text

# Stderr
echo "Warn" err> err.text

# Both
echo "Hello" out+err > log.log

# Pipe
foo e>| rg 'error'
foo o+e>| rg 'error'
```

* `>out` で出力先を指定する
* `e>`, `err>`でstderrをredirectする
  * `o+e>`, `out+err>`で両方をredirectする

