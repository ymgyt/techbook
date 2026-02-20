# Nix package

以下でpackageを検索できる。  
https://search.nixos.org/packages

## Branch

違いはHydraのtestらしい

* `nixos-*`: NixOS user向け
  * `nixos-unstable`: masterに追従している
* `nixpkgs-*`: 非NixOS user向け
  * `nixpkgs-unstable`: masterに追従している


## `pkgs.callPackage`

`pkgs.callPackage import ./foo.nix { arg1 = "useThis" }`

* foo.nixで宣言された関数の引数とpkgs自身のattribute setをmergeした上で、第二引数のattributeを優先してmergeしてくれる。


## Linux Kernel

* [6.19の追加PR](https://github.com/NixOS/nixpkgs/pull/488627/changes)
  * aliasまわりの正体がわかる
