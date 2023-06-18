# function

Nu的にはcommandっぽい。

nuの関数定義。

```nu
def book [ ] {
  hx $"($nu.home-path)/rs/techbook"
}

def greet[name: string] {
  $"hello ($name)"
}

# with default
def ok[n: int = 10] {
  $n
}

# with optional
def greet [name?: string] {
  if ($name == null) {
    "hello, I don't know your name!"
  } else {
    $"hello ($name)"
  }
}

# flag
def greet [
  name: string
  --age (-a): int
] {
  [$name $age]
}

greet "yuta" --age 10
```

引数の型に書けるtype

* any
* block
* cell-path
* duration
* path
* expr
* filesize
* glob
* int
* math
* number
* operator
* range
* cond
* bool
* signature
* string
* variable
* record
* list
* table
* error


## Recipe

### each

```nu
> ls | each { |it|
    cd $it.name
    make
}
```

* cdは`PWD`を変更するが、これはblockに閉じるので次のeachに影響しない