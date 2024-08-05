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


## Filter

```nu
[] | filter {|user| $user.name | str starts-with 'foo' } | select id name

# where版
[] | where ($it.name | str starts-with 'foo') | select id name
```

## Kill process

```nu
ps  | where name =~ "synd" | get pid | first | kill $in
```

## Parse git log

```nu
# 直近1週間のcommit
git log --pretty=%h»¦«%s»¦«%aN»¦«%aE»¦«%aD -n 25 
| lines 
| split column "»¦«" commit subject name email date 
| upsert date {|d| $d.date | into datetime} 
| where ($it.date > ((date now) - 7day))

# contributorの集計
git log --pretty=%h»¦«%s»¦«%aN»¦«%aE»¦«%aD 
| lines | split column "»¦«" commit subject name email date 
| upsert date {|d| $d.date | into datetime} 
| group-by name 
| transpose 
| upsert column1 {|c| $c.column1 | length} 
| sort-by column1 
| rename name commits 
| reverse 
| first 10 
| table -n 1
```

## format

結果のformat

```nu
> ls | format pattern '{name}: {size}'
```

## compose record

```nu
'{"name": "Alice", "age": 30}'
| from json
| {name: $in.name, age: ($in.age + 5)}
```

* `{ ... }`でrecord型を生成できる

## parse

```nu
'INFO foo {"message": "log message"}' | parse "{level} {module} {log}" | describe
table<level: string, module: string, log: string>```
