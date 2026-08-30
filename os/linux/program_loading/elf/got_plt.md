# GOT と PLT

* ELF の動的リンクで使われる仕組み
* PLT はコード、GOT はアドレスを保持するデータ

## PLT と GOT に分離する狙い

* dynamic linker が書き換える場所を GOT に集約できる

  * `call printf` の命令そのものを書き換える方式だと、呼び出し箇所ごとに修正が必要になる
* `.text` / `.plt` の実行コードを基本的に書き換えずに済む

```text
call site A ─┐
call site B ─┼→ printf@plt → GOT[printf]
call site C ─┘                 │
                               ▼
                         printf address
```

PLT を経由すること自体は必須ではない。

例えば GCC の `-fno-plt` では、PLT を経由せず GOT から直接関数アドレスを取得して indirect call できる。

```asm
call *printf@GOTPCREL(%rip)
```

`@GOTPCREL` は、現在の命令位置から `GOT[printf]` までの PC-relative displacement を linker に計算させるための relocation modifier。

`(%rip)` 自体が `@GOT` を相対値に変換するわけではない。

AT&T syntax の

```text
disp(base)
```

は単に

```text
effective address = base + disp
```

というアドレス指定。

したがって、

```asm
printf@GOTPCREL(%rip)
```

では、

```text
effective address
    = RIP + PC-relative displacement
    = address of GOT[printf]
```


## PLT

Procedure Linkage Table。

traditional な lazy binding 用 PLT entry は概念的には次のようになっている。

```asm
printf@plt:
    jmp  *disp32(%rip)   # GOT[printf] の中身へ indirect jump
    push $reloc_index    # GOT 未解決時にここへ来る
    jmp  plt0
```

最初の命令の `disp32(%rip)` は、実行時に

```text
address of GOT[printf]
```

になるよう linker が displacement を決めている。

```asm
jmp *disp32(%rip)
```

```text
1. RIP + disp32 で GOT[printf] のアドレスを求める
2. GOT[printf] に入っている 8 byte のアドレスを読む
3. そのアドレスへ jump する
```

### lazy binding

lazy binding では、未解決の `GOT[printf]` に NULL や不正なアドレスが入っているわけではない。

初期状態では、`GOT[printf]` は `printf@plt` の `push` 側へ戻るためのアドレスを保持している。

```text
main
  │
  │ call printf@plt
  ▼
printf@plt
  │
  │ jmp *GOT[printf]
  ▼
GOT[printf]
  │
  │ 未解決時は printf@plt の後半を指す
  ▼
push $reloc_index
  │
  ▼
plt0
  │
  ▼
dynamic linker resolver
```

`push $reloc_index` によって、dynamic linker はどの PLT relocation を解決すべきか特定できる。

dynamic linker が `printf` を解決すると、

```text
GOT[printf] = libc 内の printf の実アドレス
```

に書き換える。

そのため2回目以降は、

```text
main
  │
  ▼
printf@plt
  │
  │ jmp *GOT[printf]
  ▼
libc::printf
```

となり、resolver を経由しない。

## GOT

Global Offset Table。

GOT は実行時に解決されたアドレスを保持するデータ領域。

概念的には、

```text
GOT[printf]:
    0x00007f........
```

のように関数アドレスが入る。

lazy binding では状態が次のように変わる。

```text
未解決:

GOT[printf]
    ↓
printf@plt の resolver 側コード


解決後:

GOT[printf]
    ↓
libc の printf
```

PLT のコード自体を変更するのではなく、GOT entry の中身を変更するのがポイント。

