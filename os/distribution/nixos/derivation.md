# Derivation

## Memo

* Nix Languageからすると単なるattribute set
* `derivation` functionのattribute setに必須のfieldは3つ
  * `name`
  * `system`: system in which the derivation can be built
    * `x86_64-linux`とか
  * `builder`: binary program that builds the derivation

* `buildInputs `- Dependencies that should exist in the runtime environment.
* `propagatedBuildInputs `- Dependencies that should exist in the runtime environment and also propagated to downstream runtime environments.
* `nativeBuildInputs `- Dependencies that should only exist in the build environment.
* `propagatedNativeBuildInputs`- Dependencies that should only exist in the build environment and also propagated to downstream build environments.
* derivationがやってくれること
  * builderの起動
  * builderに依存を環境変数でみせてくれる

```
:l <nixpkgs>
derivation { name = "simple", ... coreutils = coreutils; }
```

derivationのfieldはbuild処理からは環境変数としてみえる

```
export PATH="$coreutils/bin"
```


## nix-build

内部的には

1. nix-instantiateしてstore derivationを生成
2. nix-store --realizeでstore derivationをrealize


## `builtins`

```
# System
builtins.currentSystem

# Get attribute names
builtins.attrnames <expr>

# Stringify
builtins.toString <expr>
```

```sh
derivation {
  name = "simple";

  builder = "${(import <nixpkgs> {}).bash}/bin/bash";
  args = ["-c" "echo foo > $out" ];
  src = ./.;
  system = builtins.currentSystem;
}
```

`"${(import <nixpkgs> {})}/bin/bash"`  
はまず、`(import <nixpkgs> {})`が解決されて、derivationの集合が手に入る。  
次に`.bash`を参照すると、それはbashのderivationで、`"${}"`はderivationをnix storeへのpathに変換する。  

```text
nix-repl> p = import <nixpkgs> {}

nix-repl> p.bash
«derivation /nix/store/sr6b1h6by3fkdhsbz8phrxvcjxxg6vbr-bash-5.1-p16.drv»

nix-repl> "${p.bash}"
"/nix/store/kga2r02rmyxl14sg96nxbdhifq3rb8lc-bash-5.1-p16"

nix-repl> "${p.bash}/bin/bash"
"/nix/store/kga2r02rmyxl14sg96nxbdhifq3rb8lc-bash-5.1-p16/bin/bash"
```



