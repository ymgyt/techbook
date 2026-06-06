# Control flow

## if 

### if null

```nu
def main [filter?: string] {
  let unreferenced = if ($filter == null) {
    "delete"
  } else {
    "ignore"
  }
}
```

* `$var == null`

### if (expression)

```nu
if ($line | str starts-with 'typo> error: ' ) { }
```

* `if (expression)`

### 空チェック

```nu
 if ($list | is-not-empty) {
  let item = $list | first
}
```

## errorを無視

```nu
do -i { somecommand } | lines
```

* pipeは`{ }`の外に書くらしい

## loop

### each


```nu
'[1, 2, 3, 4, 5]'
| from json
| each { |x| $x * 2 } # each { $in * 2}
```

* 暗黙的に`$in` にbindされるから、変数(`|x|`)を省略したければできる

## error handling

```nu

try {
  nu -c 'exit 42'
} catch {|e|
  print $e.exit_code? # prints 42
}
```
* Only the exit code of the last command of a pipeline is checked and can cause an error. The exit codes of all the previous commands in a pipeline are ignored. In the future, we may check and track the exit codes of all commands in a pipeline to provide an equivalent to bash's set -o pipefail, but this would require a major refactor. So for now, this functionality is only a potential future addition.

* If a command was terminated by a unix signal (e.g., SIGTERM, SIGINT), then the exit_code value in the catch error record will contain the negation of the signal number. For example, if SIGINT is signal number 2, then exit_code would be reported as -2. This is similar to how Python reports exit codes.

* The one exception is SIGPIPE. If a command is terminated due to SIGPIPE, then it is not treated as an error.

https://www.nushell.sh/blog/2024-09-17-nushell_0_98_0.html#non-zero-exit-codes-are-now-errors-toc
