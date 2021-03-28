# Vim

## Key bind 

### move
```
# cursolを画面先頭
zt

# cursolを画面中央
zz

# cursolを画面下
zb
```

## Charset

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
