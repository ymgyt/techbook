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

## Two stage build

┌────────────┐                ┌────────────┐                ┌────────────┐
│            │                │            │ nix-store      │            │
│ Nix        │nix-instantiate │ Store      │  --realize     │ Store      │
│ Expression ├───────────────►│ Derivation ├───────────────►│ Derivation │
│            │                │            │                │ Output     │
└────────────┘                └────────────┘                └────────────┘

* nix expressionから直接buildされず、store derivationという中間結果を経由する
* store delivationは要はなにをbuildで実行すべきかを表現している。


## nix-build

内部的には

1. nix-instantiateしてstore derivationを生成
2. nix-store --realizeでstore derivationをrealize


## Phase

1. Unpack
2. Patch
3. Configure
4. Build
5. Check
6. Install
7. Fixup
8. Installcheck

[公式のPhase Manual](https://nixos.org/manual/nixpkgs/stable/#sec-stdenv-phases)
