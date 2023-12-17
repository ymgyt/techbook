# Nu Recipe


## Debug

```nu
# data typeを確認
42 | describe
```

## List

```nu
# 要素の追加
["aaa","bbb"] | append "ccc" # => ["aaa","bbb","ccc"]

# List<String> -> String
["a","b"] | str join "," # => "a,b"
```