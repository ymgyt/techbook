# Recipe

## `sync`

### `sync.Pool`

```go
import (
	"bytes"
	"sync"
)

var bufferPool = &bufferPoolWrapper{
	pool: &sync.Pool {
		New: func() interface{} {
			return new(bytes.Buffer)
		},
	},
}

type bufferPoolWrapper struct {
	pool *sync.Pool
}

func (w *bufferPoolWrapper) Get() (_ *bytes.Buffer, cleanup func()) {
	b := w.pool.Get().(*bytes.Buffer)
	b.Reset()

	return b, func() { w.pool.Put(b)}
}

func main() {
    b, cleanup := bufferPool.Get()
    defer cleanup()
}
```

`interface{}`の型castだけ行うwrapperの例。
