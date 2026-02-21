# `jobs.<job_id>.strategy.matrix`

環境やversionだけ変えてjobを実行させる

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      # fail-fastと排他でcontinue-on-errorもあるらしい
      fail-fast: false
      max-parallel: 4
      matrix:
        key1: ["a", "b"]
        key2: [1,2]
    steps:
      - runs: echo "${{ matrix.key1 }}" "${{ matrix.key2 }}"
```

このjobは、(a,1), (a,2), (b,1), (b,2) の組み合わせで実行される

## exclude


```yaml
    strategy:
      matrix:
        key1: ["a", "b"]
        key2: [1,2]
        exclude:
          - key1: "b"
            key2: 2
```

excludeを指定すると(b,2)は実行されない

## include

```yaml
    strategy:
      matrix:
        key1: ["a", "b"]
        key2: [1,2]
        include:
          - key1: "c"
            key2: 1

          - key1: "a"
            key2: 1
            ext: true
    steps:
      # ...
      - if: ${{ matrix.ext }}
        run: : (a,1) case
```

* 特別ケースを追加できる
* 他にないfieldを追加できる

### Dynamic matrix generation

```yaml
test:
  needs: prepare
  runs-on: ubuntu-latest
  strategy:
    matrix:
      include: ${{ fromJSON(needs.prepare.outputs.matrix) }}
  steps:
    - run: : ${{ matrix.key1 }} ${{ matrix.key2 }}
```

ここで、`[ {"key1": "a","key2": 1}, {"key1": "b", "key2": 2} ]` のように動的に生成すれば同じことができる
