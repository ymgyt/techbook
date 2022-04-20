# Mermaid.js

## Directive

```
%%{init: configration-object}%%
```
```
%%{init: {
  "theme": "default",
  "logLevel": 5,
  "sequence": {"mirrorActors": false}
  }
}%%
```

* `theme`
    * base, forest,dark, neutral
* `logLevel`
    * consoleにloggingされる
    * 1:debug, 2:info, 3:warn, 4:error, 5:fatal

* `8.6.0`から導入されたらしい

### Wrap text

```mermaid
%%{wrap}%%
sequenceDiagram 
  A->>B: A long text which will illustrate the effects of the wrap directive participant B as A long actor name illustrating the effects of the wrap directive 
   Note left of B: A long note illustrating the effects of the wrap directive
```

* 長いtextがboxに収まるようにする

```mermaid
graph TD
A[Start] --> B(Eat)
B --> C(Sleep)
C --> D(Netflix)
D --> |loop|B
D --> E[END]
```

## Sequence Diagram

```mermaid
%%{init: {"sequence": {"mirrorActors": false}}}%%

sequenceDiagram
  Cook->>+Timer: Remind me in 3 minutes
  Timer-->>-Cook: Done!
  Note left of Timer: mirrorActors turned off
```

* `mirrorActors`
    * sequenceの主体ブロックを下にも表示するかどうか

## ER diagram

```
%%{init: {
    "er": {
        "layoutDirection": "TB",
        "entityPadding": 15,
        "useMaxWidth": true,
    }
}}%%
```

* `layoutDirection` layoutの方向性
    * `TB`: top to bottom. `BT`: bottom to top.
    * `LR`: left to right. `RL`: right to left.

* `entityPadding`: わかっていない
* `useMaxWidth`: 巨大なdiagramの場合はfalseにした方が良い?
