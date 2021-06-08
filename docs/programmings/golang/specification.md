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
