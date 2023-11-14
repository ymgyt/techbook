# Function prologue and epilogue

https://en.wikipedia.org/wiki/Function_prologue_and_epilogue

基本的にはcompilerが関数の前後に挿入するcodeのこと

## prologue

課題: 関数終了時に呼び出しもと(caller)のstackの位置(sp)を復元したい。  

1. base pointerをstackにpushする
  * base pointerは現在の関数の呼び出しもとのstackの位置
2. stack pointerの値をbase pointerにセットする
3. stack pointerを拡張する(arch依存だが、0に向かって減らす)

x86でGCCの場合、以下のcodeになる

```
push ebp
mov	ebp, esp
sub	esp, N
```

* Nはcalleeのlocal変数による
`enter`でも同じことができる

```
enter	N, 0  
```

## epilogue

prologueと逆のことをする

1. base pointerの値をstack pointerにセットする
2. base pointerをstackからpopして、base pointerにセットする
3. stackに積んである呼び出しもとの命令(pc)をpopして、jumpする
  * prologueで積んでなくない?

```
mov	esp, ebp
pop	ebp
ret
```

x86では同じことを行う命令がある

```
leave
ret  
```

`leave`が`mov`と`pop`を実行する