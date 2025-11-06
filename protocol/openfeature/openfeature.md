# OpenFeature

## Components

* Client
  * appとのinterface
* Provider
  * flag評価の実装
  * flag backendとの仲介もここ
  * `ResolutionDetails`で結果を返す
* Evaluation Context
  * flag評価の際に参照する情報(user.id等)
* Evaluation Details
  * clientが`get_details()`で返す
