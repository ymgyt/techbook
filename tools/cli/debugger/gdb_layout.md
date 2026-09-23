# gdb layout

```
pane    := src | asm | regs | cmd | status
group   := { [-horizontal] 項目 重み... }
```

```sh
tui new-layout cmdsrc {-horizontal cmd 1 src 1} 1
```

### 縦：sourceの下にcommand

```sh
tui new-layout vertical src 2 cmd 1
layout vertical
```
┌──── src ────┐
│             │
├──── cmd ────┤
│             │
└─────────────┘

### 横：commandの右にsource

```sh
tui new-layout cmdsrc {-horizontal cmd 1 src 2} 1
layout cmdsrc
```

┌── cmd ──┬──── src ────┐
│         │             │
└─────────┴─────────────┘


### 入れ子：左にcommand、右にsourceとassembly

```sh
tui new-layout debug {-horizontal cmd 1 {src 1 asm 1} 2} 1
layout debug
```

┌── cmd ──┬──── src ────┐
│         ├──── asm ────┤
└─────────┴─────────────┘
