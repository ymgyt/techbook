# GOT と PLT

* ELFのsection

* PLTとGOTに分離する狙い
  * 書き換え箇所を1箇所にする。call printf の命令を書き換えると呼び出し箇所を全部修正する必要がある
  * 実行コードをそもそも書き換えたくない

```
call site A ─┐
call site B ─┼→ printf@plt → GOT[printf]
call site C ─┘                 │
                               ▼
                         printf address
```

論理的帰結ではなく、GCC `-fno-plt` も可能らしい

```asm
call *printf@GOTPCREL(%rip)
```

## PLT

Procedure Linkage Table

```asm
printf@plt:
    jmp  *printf@GOT(%rip) # GOT jump
    push $7                # GOT 未解決時ここにくる
    jmp  plt0               
```

* GOT側でprintfが未解決だと `push $7`等の次の命令が実行されるようになっており、ここで、GOTを解決する
* `$7` は`.rela.plt[7]` のindex


## GOT

Global Offset Table

```asm
printf@GOT:
    0x00007f........ 
```

* 未解決時はPLT側の解決用コードをいれておくのがポイント
