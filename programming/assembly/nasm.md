# nasm

## Memo

```nasm
; rbxの値をメモリとして参照してraxに代入
mov rax, [rbx]

; Load Effective Address なのでrbxの値をraxに代入
lea rax, [rbx]

; symbolまでの相対距離を計算してraxに代入
lea rax, [rel symbol]
```
