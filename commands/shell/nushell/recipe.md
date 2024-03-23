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

## each

```nu
aws foo
| from json
| get output.bar
| each {|x| let v = (aws describe -v=$x 
  | from json
  | get hoge
  ); printf "%s15s : %s\n" $x $v}
```

## Kill process

```nu
ps  | where name =~ "synd" | get pid | first | kill $in
```
