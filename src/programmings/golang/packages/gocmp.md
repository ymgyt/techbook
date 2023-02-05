# go-cmp

## options

```go
import (
    "github.com/google/go-cmp/cmp"
    "github.com/google/go-cmp/cmp/cmpopts"
)

// unexportedなfieldをtest対象にしないことを許容する
opt := cmpopts.AllowUnexprted(User{})

// unexportedなfieldを無視する
opt := cmpopts.IgnoreUnexprted(User{})

// 特定のfieldを比較対象から除外する
opt := cmpopts.IgnoreFields(User{}, "ID", "UpdatedAt")

// top level以外も指定できる (User.UserItemsがある想定)
opt := cmpopts.IgnoreFields(UserItems{}, "ID", "UpdatedAt")

// slice比較の際にorderを対象としない
opt := cmpopts.SortSlices(func(i,j int) bool {
	return users[i].Name < users[j].Name
})

// 空sliceとnilを同一視する
opt := cmpopts.EquateEmpty()
```
