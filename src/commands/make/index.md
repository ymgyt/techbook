# Make

## Rule

target: 生成したいファイル  
dependency: targetが依存しているファイル
recipe:  targetを作成するためのコマンド
```makefile
target: dependency
    recipe
```

## 実行の流れ

* ruleに対して、dependencyをtargetにしているruleがあれば実行する。  
* targetのtimestampがdependencyより古い(=dependencyが更新されている)場合はrecipeを実行する。
* 引数なしでmakeを実行すると最初のruleが実行される

## Variable

* `$()`か`${}`で参照する。
```makefile
OBJS = main.o

xxx.o: $(OBJS)
```

* `AAA := BBB` BBBを評価してAAAにassignする。
* `=`は遅延評価される。その変数が評価されるたびに、right armが評価される。
* `AAA ?= BBB` AAAに値がないor空文字だったらBBBをassignする。評価は遅延。

### 変数の渡し方

* `make KEY=VALUE`とすると、Makefile内の`KEY`を上書きできる。
* `KEY=VALUE make`とするとshellが解釈することになるがMakefile内の`KEY`は上書きされない

### Builtin Variable

| variable | description                           |
| ---      | ---                                   |
| `$<`     | dependencyの先頭1つ                   |
| `$^`     | dependencyをすべてspaceでjoinしたもの |
| `$@`     | target(拡張子含む)                    | 
| `$*`     | patternのstem                         |

## shell

* `contents := $(shell cat hello.txt)`のように`$(shell xxx)`でshellの実行結果を利用できる。
* `@`をつけるとechoが走らない
  * 実行時のoutputに実行されるコマンドが表示されない

## PHONY

targetが実在しないファイルであることを表す。
```makefile
.PHONY: all
all: $(TARGET)
```

## 参考

* [Automatic Variables](https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html)
