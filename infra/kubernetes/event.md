# Event

## Schema

Group: `events.k8s.io`
Kind: `Event`

* `action`: 何が実行されたか/失敗したか。処理の対象は`regarding` objectで表現される
* `deprecatedXxx`: 一旦気にしない。
* `note`: human redable description of the status of this operation
* `reason`: なぜこのactionが実行されたか
* `regarding`: 大体はcontrollerを指すらしい?
* `series`: わかってない
* `type`: Normal,Warning。将来的に追加されるかも
