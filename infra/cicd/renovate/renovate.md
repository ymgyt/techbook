# Renovate

## Repository 処理の概要

1. repositoryをscanして、 "package file" を探す
2. "package file" から "dependency" を見つける
3. "dependency" に対応する "datasource" を検索し、新しいversionがあるか調べる


## Manager

* Package manager
* Repositoryのfileからupdateするべきdependencyをみつける
  * cargoなら、`Cargo.toml`をparseして依存をみつける
* [managerの実装](https://github.com/renovatebot/renovate/tree/main/lib/modules/manager)

* cargo manager がanyhowを更新する場合のデータ

```json
 "manager": "cargo",
         "packageFiles": [
           {
             "deps": [
               {
                 "currentValue": "1.0.0",
                 "managerData": {"nestedVersion": true},
                 "datasource": "crate",
                 "depName": "anyhow",
                 "depType": "dependencies",
                 "lockedVersion": "1.0.1"
               }
             ],
             "packageFileVersion": "0.1.0",
             "lockFiles": ["Cargo.lock"],
             "packageFile": "Cargo.toml"
           }
         ]
```

## Datasource

* Managerがfileから抽出した、dependencyがもつ、参照元
  * 新versionを探しにいくところ
  * docker registry, github-release, cargo


## Dependency Dashboard

* Renovateが作成するissue
  * defaultだと"Dependency Dashboard"
* Renovateが認識しているmanager, package fileがや作成中のPRがのっている
