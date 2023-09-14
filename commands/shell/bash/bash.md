# Bash

## Background実行

```shell
./app &
[1] 1234

kill 1234
```

* `&`をつける
  * 実行したprocess idが出力される

## shebang

```sh
#!/usr/bin/env bash
```

とすると`PATH`から`bash`を探して実行してくれる。  
`bash`がinstallされるpathは環境依存だが、`env`はこのpathにある可能性が高いことを利用している

* Linux kernelがfileの先頭に`#!`があるかどうか確認して、呼び分けている

## Redirect

* `> /dev/null`: stdoutの指定
* `2>&1` stderrをstdoutに向ける

* redirectは左から評価される

```sh
ping hello 2>&1 > /dev/null
```

この場合、stderrはstdoutとして出力される

```sh
ping hello > /dev/null 2>&1
```

この場合、なにも出力されなくなる

## Command List

* 単純コマンド
  * `ls -l`のような実行コマンドと引数のこと
* 複合コマンド
  * if,case,for,while, sub shell, group command, shell functionのこと
  * 複合コマンド一つでcommandとして扱われるので、whileにredirectするみたいな発想になる

* command
  * 単純コマンドと複合コマンドのこと
* pipeline
  * command | command
  * 終了ステータスはpipelineの最後のcommand f

## 終了ステータス(exit code)

### localの罠

```sh
function foo() {
  local bar=$(exit 1)
  local exit_status=$?
  echo ${exit_status}
}

foo # => 0
```

should

```sh
function foo() {
  local bar=""
  bar=$(exit 1)
  local exit_status=$?
  echo ${exit_status}
}

foo # 1
```

* `local foo=$(cmd)`とするとcmdの終了ステータスに関わりなく、`$?`は0になる
  * `local`が内部的にはcmdで成功扱いされる模様
