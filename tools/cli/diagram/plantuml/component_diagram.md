# Component Diagram

## Component 定義

```text
[First component]
[Another component] as Comp2
component Comp3
component [Last\ncomponent] as Comp4

[First component] -> Comp2
Comp3 -> Comp4

'色指定できる
component [Server] #Yellow
```

* `[xxx]`で定義できる。
* `as`で関係定義時の名前を指定できる。

## Interface 定義

```text
() "First Interface"
() "Another interface" as Interf2
interface Interf3
interface "Last\ninterface" as Interf4
```

* `()` がdirective(丸に見える)
* `interface` keywordでも定義できる。
* `as`で関係定義時の名前を指定できる。

## Relation 定義

定義したComponent/Interfaceの関係を記述する。


* `..`
* `--`
* `-->` : vertical(縦方向)
* `->` : horizon(横方向)
* `<-->`

*`-left->`
*`-right->`
*`-up->`
*`-down->`

関係性について名前をつけられる
* `[ComponentA] ..> Interf1 : use`

```text
[ComponentA] .. Interf1 
Interf1 -- [ComponentB]
```

## Grouping

Component/Interfaceのgroupを記述できる。

* `package`
* `node`
* `folder`
* `frame`
* `cloud`
* `database`

```text
package "Prod" {
    [Kinesis]
    [GatewayService]
    [Service]
}
```

