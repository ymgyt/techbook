# RISC-V

## 特権mode

常にいずれかのmodeで動作している。

* Machine Mode(M-Mode)
  * すべての機能を利用できる
* Supervisor Mode(S-Mode)
  * LinuxのようなOS向け
* User Mode(U-Mode)
  * applicationの動作mode

## Assembly

### Offset

`lw a7, -4(a2)`は`a2` registerから`-4`減じた値を`a7`にsetする  
カッコで、offsetを表現できる。  
これがどこで定義されているか調べられていない。  
RISC-V特有なのかもわかっていないが、説明なしにでてくる。
