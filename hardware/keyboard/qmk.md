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

* `MT(LAlt,Lang1)`: tapするとLang1, holdすると左Alt

[QMK Keycodes](https://github.com/qmk/qmk_firmware/blob/master/docs/ja/keycodes.md)