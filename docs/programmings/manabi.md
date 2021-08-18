# 学び

言語に依らない一般的な設計、API, 注意点をまとめる。

## リソースの扱いについて

### リソースの型と作成に必要な型を分ける。

作成に必要な情報とライフサイクルとして保持したい情報は一致しないので型をわける。

### 状態の更新処理は必ずテストを書く

現在の状態と変更を表現したいアクションを引数にして、新しい状態とエラーを返す関数を必ず用意する。

```go
// 戻り値としてリソースを返すか、更新だけするかはリソースのサイズに依る。
func UpdateResource(current: *Resource, action: UpdateAction) (*Resourece, error) {
	// ...
}

// のようにimmutableな引数にできるならしたい。
func UpdateResource(current: Resource, action: UpdateAction) (Resourece, error) {
// ...
}
```


## デフォルトの挙動を提供しつつ、管理者によるオーバライドを許すようにする

jobを作ったときに、リカバリー用だったりして状況を限定したいことなんかがあった。

