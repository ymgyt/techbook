# string 

```nu
# 先頭一致
echo "prefix-foo" | str starts-with 'prefix-'

# Replace
echo "xxx hello" |  str replace 'xxx ' ''
```

## regex

```nu
# path/to/file.rs:10:20 
let cap = $file_path | parse -r '(?P<path>.*?):(?P<line>\d+)(:\d+)?$' | first
let path = $cap | get path
let line_number = $cap | get line
```

* `(?P<match_name> regexp )`でmatchに名前をつけてcaptureできる
