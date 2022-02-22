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

* `$()`で参照する。
```makefile
OBJS = main.o

xxx.o: $(OBJS)
```

* `AAA := BBB` BBBを評価してAAAにassignする。`=`は遅延評価される
* `AAA ?= BBB` AAAに値がないor空文字だったらBBBをassignする。評価は遅延。

### Builtin Variable

| variable | description                           |
| ---      | ---                                   |
| `$<`     | dependencyの先頭1つ                   |
| `$^`     | dependencyをすべてspaceでjoinしたもの |
| `$@`     | target(拡張子含む)                    | 
| `$*`     | patternのstem                         |

## PHONY

targetが実在しないファイルであることを表す。
```makefile
.PHONY: all
all: $(TARGET)
```

## 参考

* [Automatic Variables](https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html)
