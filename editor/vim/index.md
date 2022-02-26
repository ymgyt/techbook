# Vim

## Key bind 

### convert

* `U`: 選択範囲をuppercase
* `u`: 選択範囲をlowercase

### move
```
# cursolを画面先頭
zt

# cursolを画面中央
zz

# cursolを画面下
zb
```

### surround

```

# 文字をかこむ

a[a]a

# you surround inner word
ysiw'

"aaa"

'a[a]a'

cs'"

"aaa"

# `(` で囲むと余分なspaceが加えられる
# `)` で囲むとよい
```
### yank

clipboardにyankする

```
# *がsystem register
"*y
```
## Command

### ロードしている設定ファイルの場所

```
:scriptnames
```

### Charset

開いているファイルのcharsetを変えて開き直す。
```
:edit ++encoding=sjis
:edi ++enc=cp932

# 確認
:se enc?
```

指定の文字コードでファイルを保存する。

```
:set fileencoding=sjis
:se fenc=cp932
```


