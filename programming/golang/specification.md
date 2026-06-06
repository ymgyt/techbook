# Specification

## `defer`

ある関数内での複数呼び出しはstack形式で管理される。(最初に呼んだ処理は最後)
```go
package main

import "fmt"

func main() {
	fmt.Println("counting")
	for i := 0; i < 5; i++ {
		defer fmt.Println(i)
	}
	fmt.Println("done")
}
```

```text
counting
done
4
3
2
1
0
```

## closure

### closureとloop変数

**closureにloop変数を捕捉させないように注意**

```go
for _, v := range values {
    v := v // create a new 'v'.
    go func() {
        fmt.Println(v)
        done <- true
    }()
}
```

`v := v` がないと、closureはloop変数を捕捉する。  
closure実行時にloop変数を参照するので、意図したとおりにならない。(大抵最後の値がはいっている)  
loop内でlocal変数にbindしておくと、loopごとに独立する。


## `sync`

### `errgroup`

```go

import "golang.org/x/sync/errgroup"

func (s *Service) Do(ctx context.Context) error {
	const apiMaxCount = 100
	const defaultConcurrency = 5
	
	eg, ctx := errgroup.WithContext(ctx)
	sem := make(chan struct{}, defaultConcurrency)

	for i, n := 0, len(req.PrimaryKeys); i < n; i += apiMaxCount {
		from, to := i, i+apiMaxCount // closureにloop変数を捕捉させないためにlocal変数にbindしておく。
		if to > n {
			to = n
		}

		sem <- struct{}{}

		eg.Go(func() error {
			defer func() { <-sem }()

			// work...
			return nil
		})
	}

	if err := eg.Wait(); err != nil {
		return nil, err
	}

	return nil
}
```

同時実行数を制御しながら、`errgroup`を使う。  
`Group.Go()`の引数のclosureは`func() error`なので引数のloop変数をわたしてbindする方式がとれない。  
ので、いったんlocal変数にbindしておく。
