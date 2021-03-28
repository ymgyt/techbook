# nkf

## options

* `-L[uwm]` : 改行コードの変換
    * `-Lw` : windows用のCRLF
    * `-Lu` : unix/mac LF

* `-w` : UTF8を出力する


* `--guess` : 文字コードを推測する。


## Usage

```
# 文字コードを推測する
nkf --guess file.txt

# Shift JISファイルを生成する
echo -n "はじめまして" | nkf -Lw -s > sjis.txt
```
