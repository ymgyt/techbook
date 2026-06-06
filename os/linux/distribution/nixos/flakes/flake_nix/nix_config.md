# nixConfig

```nix
{
  outputs = {};
  nixConfig = {
    extra-substituters = ["https://foo.cachix.org"];
    extra-trusted-public-keys = ["foo.cachix.org-1:xxxx"];
  }
}
```

* project(flake)で利用する追加のsubstitutersを指定できる
  * `extra-`をつけると既存に追加してくれる
