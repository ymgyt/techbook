# Nu Data types

Nushellがsupportするdata型

| Type       | Example                                                               |
| ---        | ---                                                                   |
| Integers   |	`-65535`                                                             |
| Decimals   | `9.9999`, `Infinity`                                                  |
| Strings	   | `"hole 18"`, `'hole 18'`, `hole 18`, `hole18`                         |
| Booleans	 | `true`                                                                |
| Dates	     | `2000-01-01`                                                          |
| Durations	 | `2min `+ `12sec`                                                      |
| File sizes | `64mb`                                                                |
| Ranges	   | `0..4`, `0..<5`, `0..`, `..4`                                         |
| Binary	   | `0x[FE FF]`                                                           |
| Lists	     | `[0 1 'two' 3]`                                                       |
| Records	   | `{name:"Nushell", lang: "Rust"}`                                      |
| Tables	   | `[{x:12, y:15}, {x:8, y:9}],` `[[x, y]; [12, 15], [8, 9]]`            |
| Closures	 | `{|e| $e + 1 | into string }`, `{ $in.name.0 | path exists }`         |
| Blocks	   | `if true { print "hello!" }`, `loop { print "press ctrl-c to exit" }` |
| Null	     | `null`                                                                |



## Null

* `$null_value | into string`で空文字にできる

## Datetime

```nu
"2022-02-02T14:30:00+05:00" | into datetime
```
