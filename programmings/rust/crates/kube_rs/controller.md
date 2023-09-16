# Controller

kube-rsのruntime controller関連。

## Reconciliation

* reconciliationが発生した理由は意図的に`reconcile()`のsignatureに含まれていない
  * これは特定のevnet(理由)を含めてもそれが確実にoperatorに届く保証がないから
  * 結果的にすべての確認処理を行う必要がありこれが、idempotencyにつながる

## Subresource

* controllerは関連するresourceの変更でreconcileをtriggerしたい場合は指定する必要がある
  * `Controller::owns`で行う

### Owned Relation

```rust
let cmgs = Api::<ConfigMapGenerator>::all(client.clone());
let cms = Api::<ConfigMap>::all(client.clone());

Controller::new(cmgs, watcher::Config::default())
    .owns(cms, watcher::Config::default())  
```

* `ConfigMapGenerator` instanceを削除すると, `ownerReferences`に`ConfigMapGenerator`をもつ`ConfigMap`も削除される
  * 親の削除は子にcascadeされる
*  managedな`ConfigMap`を変更すると、`ConfigMapGenerator`のreconcileがtriggerされる

子Resourceに親への参照をもたせるには以下のようにする

```rust
let oref = generator.controller_owner_ref(&()).unwrap();
let cm = ConfigMap {
    metadata: ObjectMeta {
        name: generator.metadata.name.clone(),
        owner_references: Some(vec![oref]),
        ..ObjectMeta::default()
    },
    data: Some(contents),
    ..Default::default()
};
```

1. CRの`controller_owner_ref()`で識別子を取得
1. 子作成時に`metadata.owner_references`に識別子を設定