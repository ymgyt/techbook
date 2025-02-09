# Version constraint

* `version = <operator> <version>[, <operator> <version>]`


* operator
  * `=` exact version
  * `>=`, `<=`
  * `~>` right-most version をincrementできる
    * `~> 1.0.4` なら、`1.0.5`, `1.0.10`はOK, `1.1.0`はだめ
    * `~> 1.1` は、`1.2`, `1.10`は OK, `2.0`はだめ
