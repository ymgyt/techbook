# QMK

## そもそもファームウェアとは

hardwareのメモリに埋め込まれた命令。

1. keyboardのkeyを押す
2. そのkeyに対応したピンの電圧の変化が伝わる
3. eventをUSBケーブルを通してkeycodeとして伝える


## PCに文字が入力される仕組み

1. keyboardのkeyが押される
2. matrics scanがファームウェアでなされる([2,0])
3. ファームウェア(QMK)のkey mappingでkey codeに変換[2,0] -> Shift + 2
4. OSが言語設定で解釈するShift + 2 -> `@`

OSの設定でkeyboard layoutを設定することはOS側でのkeycodeの解釈がおこなわれるから。
JIS配列だとShift + 2が`#`となるが、USだと`@`的な。


## Keycode

[QMK Keycodes](https://github.com/qmk/qmk_firmware/blob/master/docs/ja/keycodes.md)

### MT (Mod-Tap)

* そのkeyを押しながら(Mod)別のkeyを押した場合と単体で押した(Tap)場合で違うkey codeを
* `MT(LALT,Escape)` :押しっぱなしでALTとして機能するが単体で押すとEscapeになる

### LT (Layer-Tap)

* 押しながらだとlayerを切り替える、単体で押すと別のkey code
* `LT(Layer1, Enter)`: 押しながらだとLayer1を適用し、単体で押すとEnterになる