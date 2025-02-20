# parquet

## Converted type と Logical type

* どちらも、physical type に対しての解釈(annotation)を提供する仕組み。(byte array を utf-8等)
* Converted type が元々ある機能
  * 迷ったらConverted typeを使えばよい?
* Logical type は新しい仕様
  * 互換性を気にしなくて良い、新規開発ならLogial typeか?

## Definition level

```
message ExampleDefinitionLevel {
  optional group a {
    optional group b {
      optional string c;
    }
  }
}
```

| Value                   | Definition level |
|-------------------------|------------------|
| `a: null`               | 0                |
| `a: { b: null}`         | 1                |
| `a: { b: { c: null }}`  | 2                |
| `a: { b: { c: "foo" }}` | 3                |

* max は 3なので、def level 3の時は値がある


## Repetition level

```
message nestedLists {
  repeated group level1 {
    repeated string level2;
  }
}
```

```
{
  level1: {
    level2: a
    level2: b
    level2: c
  },
  level1: {
    level2: d
    level2: e
    level2: f
    level2: g
  }
}
{
  level1: {
    level2: h
  },
  level1: {
    level2: i
    level2: j
  }
}
```

| Repetition level | Value |
|------------------|-------|
| 0                | a     |
| 2                | b     |
| 2                | c     |
| 1                | d     |
| 2                | e     |
| 2                | f     |
| 2                | g     |
| 0                | h     |
| 1                | i     |
| 2                | j     |


## Reference

* [Fast Parquet reading: From Java to Rust Columnar Readers](https://baarse.substack.com/p/fast-parquet-reading-from-java-to)
* [Dremel made simple with Parquet](https://blog.x.com/engineering/en_us/a/2013/dremel-made-simple-with-parquet)
* [Dremel: A Decade of Interactive SQL Analysis at Web Scale](https://storage.googleapis.com/gweb-research2023-media/pubtools/5750.pdf)
