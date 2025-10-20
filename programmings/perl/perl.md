# perl


## Memo

* `my` local 変数宣言
* `our` global変数宣言
* `qr{...}`: quote regexでregex objectの宣言
  * delimiter(`{`)はなんでも良い(正規表現かきやすいように変えられる)


## sub(function)

```perl
sub greet {
    my ($name, $age) = @_; 
    print "Hello $name, age $age\n";
}

greet("me", 30);
# => Hello me, age 30
```

* 引数は宣言しない
  * `@_`に渡された引数が入る

## variables

* `$<ident>`: scalar
* `@<ident>`: 配列宣言
* `%<ident>`: hash宣言

## builtin

* `$!` 直近のsystem error(`errno`)
