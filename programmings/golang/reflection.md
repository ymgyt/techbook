# Reflection


## `reflect.Type`

型の名前、種別、パッケージのパス、メモリ上の割当バイス数といった情報をもつ。

```go
package main

import (
	"fmt"
	"reflect"
)

func ExampleReflectType() {

	isInt := func(v interface{}) bool {
		rt := reflect.TypeOf(v)
		switch rt.Kind() {
		case reflect.Int, reflect.Int8, reflect.Int16, reflect.Int32, reflect.Int64:
			return true
		default:
			return false
		}
	}

	fmt.Println(isInt(1))
	fmt.Println(isInt("1"))
	fmt.Println(isInt(false))
	// Output:
	// true
	// false
	// false
}
```

## `reflect.Value`

処理系内部での値についての情報が反映されたオブジェクト。  
`Type()`で`reflect.Type`が取得でき、`Kind()`で`reflect.Kind`が取得できるので型の情報ももっているといえる。

```go
package main

import (
	"fmt"
	"reflect"
)

func isInt(k reflect.Kind) bool {
	return k == reflect.Int || k == reflect.Int8 || k == reflect.Int16 || k == reflect.Int32 || k == reflect.Int64
}

func ExampleReflectValue() {

	plus := func(v1, v2 interface{}) interface{} {
		rv1, rv2 := reflect.ValueOf(v1), reflect.ValueOf(v2)
		if isInt(rv1.Kind()) && isInt(rv2.Kind()) {
			return interface{}(rv1.Int() + rv2.Int())
		} else if rv1.Kind() == reflect.String && rv2.Kind() == reflect.String {
			return interface{}(rv1.String() + rv2.String())
		}
		return nil
	}

	fmt.Println(plus(100,200))
	fmt.Println(plus("100", "200"))
	fmt.Println(plus(100, "200"))
	// Output:
	// 300
	// 100200
	// <nil>
}
```

## 型の種別を取得する

```go
func TestKind(t *testing.T) {
	assert.True(t, reflect.TypeOf(0).Kind() == reflect.Int)

	assert.True(t, reflect.TypeOf(uint(0)).Kind() == reflect.Uint)

	assert.True(t,reflect.TypeOf(float64(0)).Kind() == reflect.Float64)

	assert.True(t,reflect.TypeOf(false).Kind() == reflect.Bool)

	assert.True(t,reflect.TypeOf("").Kind() == reflect.String)

	assert.True(t,reflect.TypeOf([1]int{}).Kind() == reflect.Array)

	assert.True(t,reflect.TypeOf([]int{}).Kind() == reflect.Slice)

	assert.True(t,reflect.TypeOf(map[int]bool{}).Kind() == reflect.Map)

	assert.True(t,reflect.TypeOf(make(chan int)).Kind() == reflect.Chan)

	assert.True(t,reflect.TypeOf(func() {}).Kind() == reflect.Func)

	type S struct{}
	assert.True(t,reflect.TypeOf(S{}).Kind() == reflect.Struct)

	assert.True(t,reflect.TypeOf(&S{}).Kind() == reflect.Ptr)
}
```

## 元の値を取得する

`reflect.ValueOf(100).Int()`のように基本形にはメソッドが用意されている。不一致だとpanic。  
もうひとつは`Interface()`からのタイプアサーション。
```go
if b, ok := reflect.ValueOf(true).Interface().(bool); ok {
	// ...
}
```

## 元の値の更新

### 更新できるかの確認

```go
func TestCanSetCheck(t *testing.T) {
	// pointerではない。
	v := 1
	assert.False(t,reflect.ValueOf(v).CanSet())

	// Elem()を呼ぶと内部的にflagAddrがセットされ、CanSetのチェックが通る。
	assert.True(t,reflect.ValueOf(&v).Elem().CanSet())

	type S1 struct {
		F1 int
		f2 bool
	}
	vv := S1{F1: 100, f2: true}
	assert.True(t, reflect.ValueOf(&vv).Elem().CanSet())
	// public field
	assert.True(t, reflect.ValueOf(&vv).Elem().FieldByName("F1").CanSet())
	// private field
	assert.False(t, reflect.ValueOf(&vv).Elem().FieldByName("f2").CanSet())
}
```

元の値を更新するための条件

* 元の値がポインターであり`Elem()`によってデリファレンスされていること。
* 元の値が構造体のプライベートフィールドではないこと。

`Elem()`の中で戻り値の`Value`にpointerの値をセットしている。


### 元の値の更新

```go
func TestValue_Set(t *testing.T) {
	i := 1
	rv := reflect.ValueOf(&i).Elem()
	rv.SetInt(2)
	assert.Equal(t, i, 2)

	s := "S1"
	rv = reflect.ValueOf(&s).Elem()
	rv.SetString("S2")
	assert.Equal(t, s, "S2")

	ints := []int{1,2,3}
	rv = reflect.ValueOf(&ints).Elem()
	rv.Set(reflect.ValueOf([]int{2,4,6}))
	assert.Equal(t, ints, []int{2,4,6})
}
```

primitive型用の専用のメソッドと汎用的な`Set()`が用意されている。

## Struct Tagの取得

```go
func ExampleGetTag() {
	type T struct {
		// tagのdelimiterはspace
		F1 string `tag1:"f1" tag2:"string"`
		F2 int `tag1:"f2" tag2:"int"`
	}

	rt := reflect.TypeOf(T{})
	for i := 0; i < rt.NumField(); i++ {
		f := rt.Field(i)
		tag1 := f.Tag.Get("tag1")
		// 存在したかをboolで返してくれる
		tag2, _ := f.Tag.Lookup("tag2")

		fmt.Printf("Type: %s tag1: %s tag2: %s\n",
			f.Name,tag1, tag2,
			)
	}
	// Output:
	// Type: F1 tag1: f1 tag2: string
	// Type: F2 tag1: f2 tag2: int
}
```

## 参考

[Go言語reflectパッケージ詳解](https://booth.pm/ja/items/2400383)
