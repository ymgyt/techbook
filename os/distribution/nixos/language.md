# Nix language

## REPL

* `nix repl`でREPLに入れる

### Builtin commands

* `:p`でexpressionをprint
  * `:p { a.b.c = 1; }`


## File


```sh
echo 1 + 2 > file.nix
nix-instantiate --eval file.nix
```

* `nix-instantiate`に引数のfile指定しないと`default.nix`を読んでくれる


## Attribute set

```nix
{
  string = "hello";
  integer = 1;
  float = 3.141;
  bool = true;
  null = null;
  list = [ 1 "two" false ];
  attribute-set = {
    a = "hello";
    b = 2;
    c = 2.718;
    d = false;
  }; # comments are supported
}
```

```nix
let
  attrset = { a = { b = { c = 1; }; }; };
in
attrset.a.b.c
```

```nix
{ a.b.c = 1; }

# evaluated to { a = { b = { c = 1; }; }; }
```

### Recursive

```nix
rec {
  one = 1;
  two = one + 1;
  three = two + 1;
}

# evaluated  { one = 1; three = 3; two = 2; }
```

* `rec`つけるとfieldの中でfiledを参照できる


## `let ... in ...`

```nix
let
  b = a + 1;
  a = 1;
in
a + b
```

* `let`は`in`がscopeになる


## `with ...; ...`


```nix
let
  a = {
    x = 1;
    y = 2;
    z = 3;
  };
in
with a; [ x y z ]

# equivalent to [ a.x a.y a.z ]
```

* `with`つけると名前空間がそのattribute setになる感じ


## `inherit ...`

```nix
et
  x = 1;
  y = 2;
in
{
  inherit x y;
}

# equivalent to x = x; y = y;
```

```nix
let
  a = { x = 1; y = 2; };
in
{
  inherit (a) x y;
}

# equivalent to x = a.x; y = a.y;
```

* `inherit (a)`で後続のscopeのattribute set指定できる


## String interpolation

```nix
let
  name = "Nix";
in
"hello ${name}"
```

## Multiline strings

```nix
''
multi
line
string
''

# equivalent to "multi\nline\nstring\n"
```

## Filesystem path

* `./.`はnix file directory
* `<nixpkgs>`
  * `/nix/var/nix/profiles/per-user/root/channels/nixpkgs`


## Functions

* `:`の左がargument、右がbody
  * 引数は必ず1つ

* `x: x + 1`

* `x: y: x + y`

* `{ a, b }: a + b`

* `{ a, b ? 0 }: a + b`
  * ?でdefault指定

* `{ a, b, ...}: a + b`
  * additional

* `args@{ a, b, ...}: a + b + args.c`
  * `{ a, b, ...}@args: a + b + args.c`

### Calling

applicationとも


```nix
let 
  f = x: x + 1;
in f 1
```

### builtins

* `builtins.toString`


#### `import`

pathのnix fileを評価して返す。  
directoryの場合は`default.nix`を探す

```nix
imports = [
  a.nix
  b.nix
];
```

ここで  
`a.nix`が`foo.list = [1 2 3]`
`b.nix`が`foo.list = [4 5 6]`  
を返した場合、importsは`foo.list = [1 2 3 4 5 6]`のように同じattributeをmergeしてくれる




## `pkgs.lib`

```nix
let
  pkgs = import <nixpkgs> {};
in
pkgs.lib.strings.toUpper "search paths considered harmful"
```

* `import path/to/pkg`の評価結果がfunctionの場合でも動くように引数として`{}`渡している。

```nix
{ pkgs, ... }:
pkgs.lib.strings.removePrefix "no " "no true scotsman"
```

* 慣習としてNixpkgs attribute setが渡せるようにしておく
  * `lib` attributeは仮定してよい

`nix-instantiate --eval test.nix --arg pkgs 'import <nixpkgs> {}'`