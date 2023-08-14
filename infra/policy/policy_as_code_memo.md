# Policy as Code 入門

[スライド](https://docs.google.com/presentation/d/1Q9lc2GeI05WJkGkotowTxUkL-zFKc4R9xOqovfkFSGc/edit#slide=id.g237f33b2f58_0_4)
[演習資料Repository](https://github.com/m-mizutani/seccamp-2023-b7)

## PolicyのCode化

Policyとは?  
=> 政党や企業などが合意または選択した行動の計画
=> 組織やグループによって合意、選択されたあるべき状態、禁止された状態、基準

従来のポリシーの特徴  
* 自然言語なので曖昧
* 暗黙の前提知識や文脈
* 人間が適合性をチェック
* 他のPolicyとの競合は人間がチェック

人的な監査は実施コストが高く、頻度や網羅性を維持できない  
そこで、継続的監査(Continuous Auditing)  
* 実施コストが低いので高頻度化が可能
* 対象に変更があったタイミングで実施できる
  * 検知までの時間短縮
  * 検出ではなく、中断といった行動が可能になる

Policy運用は失敗する
例外や環境の変化(注力ビジネスの変化等)によって、Policyが適切に機能しない
=> Policyが修正されない, Policy無視が常態化
=> Policyが形骸化

なぜPolicyは形骸化するのか  
* 追加、更新したPolicyのtestが必要
* 既存Policyへの影響の調査
* 既存Policyの文脈の理解が必要
  * 過去の変更の経緯
  * 変更者ごとの記述ブレ
* 変更後のPolicyの展開作業
=> これってプログラムと同じでは
=> Policyをcodeで表現して、ソフトウェア開発におけるプラクティスを活用

Policy as Codeのメリット  
* 機械可読性(lintできる)
* 再現性
  * 同じ検査対象(入力)に対して同じ結果(出力)になる
* テスト可能性
  * 意図通りの変更か自信をもてる
  * サイドエフェクトが確認できる
* 展開(Deploy)の自動化
  * 変更に関する心理的負荷の軽減
* Version管理やReviewの仕組みを利用できる

Policy as Codeの本質
* Policy一度決めたら変更しないものではない
  * 運用によって不具合が明らかになる
  * 外的要因の変化によってPolicyの有効性も変化する
  * 効果的でないPolicyの運用は弊害の方が大きい
* 必要に応じて、自信を持って積極的に変更できることが重要
  * DevOpsと同じ

Iac(Infrastrucutre as Code)との違いは?
=> PaCは制約、IaCは実現したいことを記述する
=> Iacやそれが実現されたリソース、そこから発生したイベントへの監査を記述するのがPac


## Policy as Codeを実現するためのOPA & Rego

汎用Policy記述言語: Rego  
* Prolog, Datalogから着想を得た言語

```rego
// 名前空間,必ず宣言が必要
package db

// ルール名
// { ... }がPolicyの本体でルールと言われる
is_allowed_db_access {
  // input経由で構造データが渡される
  // 1つ以上の評価式が必要
  input.role == "admin"
}
```
(`//`がコメントなのは適当)

Regoの特徴
* 宣言型
* (原則) 外部入出力を使わない
* 入力と出力のスキーマは任意

OPA: Regoの評価エンジン  
* https://github.com/open-policy-agent/opa
* CLI, HTTP Server, Go SDKとして使える


OPAの実行例
```sh
>  echo '{"role": "admin"}' | opa eval -b . -I data
{
  "result": [
    {
      "expressions": [
        {
          "value": {
            "db": {
              "is_allowed_db_access": true
            }
          },
          "text": "data",
          "location": {
            "row": 1,
            "col": 1
          }
        }
      ]
    }
  ]
}
```

OPAとは
* 入力された構造データ(JSON)をRegoで評価し、結果の構造データを出力するだけのエンジン
* 入出力の構造データのスキーマは自由
```text
Input -> OPA -> Output
          ↑
         Rego
```

OPAの具体的な利用方法
* CLIでevalする
  * CI
* HTTP Serverとして
  * HTTP Requestを入力として結果をResponseで返す
  * ProductとServiceを分離できる
    * 実運用でこれは実はつらい。Ubieでも使われなくなった
    * 認証/認可を紐づけるのがつらい?
* 3rd partyプロダクト,サービスがライブラリとして組み込む
  * この利用方法が多いと思われる

OPA?Regoの利用事例
* ソフトウェアへの組み込み
  * Gatekeeper: KUbernetesのポリシーコントローラ
  * conftest: KUbernetesの設定ファイル検査
  * tfsec: terraformの設定検査
  * trivy: 検知する脆弱性の無視ルールを設定
* 検査
  * クラウドサービスのリソース状態の継続的監査
  * コードの静的解析+規約違反の検出
  * 認可の制御

* OPAをSDKとして利用したツール
  * https://github.com/m-mizutani/alertchain
  * https://github.com/m-mizutani/goast
  * https://github.com/m-mizutani/ghnotify
  * Goじゃないと使いづらいけど、Goならおすすめ

わざわざRegoで書かなくてもよくないですか?
=> YesでもありNoでもある
=> 目的に特化した言語のほうが比較的習得しやすい
=> Policyに集中する役割の人にとって適切
(よくあるDSLのトレードオフ: 私見)
=> 実装とPolicyを分離できる
  * ロジックとPolicyの境界が明確
  * Policyの変更によってソフトウェアに影響がないことを保証できる

## Rego入門

https://github.com/m-mizutani/seccamp-2023-b7

```rego
package ex1

allow {
	input.method == "GET"
	input.path == "/api/v1/health"
}
```

ex1

```sh
opa eval -i input/ex1/good.json -f pretty -b ./exercises/ex1/ data
{
  "ex1": {
    "allow": true
  }
}

opa eval -i input/ex1/bad2.json -f pretty -b ./exercises/ex1/ data
{
  "ex1": {}
}
```

* `-b`: policy directoryを指定
* `-i`: inputの指定 `-I`はstdin
* `data`: query

```rego
package main

allowed_db := "production" {
  input.role == "developer"
}

allowed_db := db {
  input.role == "staff"
  db := "staging"
}
```

Iteration

```rego
package main

allowed_roles := [
	"admin",
	"developer",
]

allow {
	input.role == allowed_roles[_]
}
# allow {
#   input_role == allowed_roles[0]
# }
# allow {
#   input_role == allowed_roles[1]
# }
```

```rego
package main

roles := [
    {"name": "admin", "allowed_db": ["staging", "production"]},
    {"name": "staff", "allowed_db": ["staging"]},
]

allow {
	role := roles[_]
	role.name == input.role
	role.allowed_db[_] == input.db
}
```

以下のように展開される

```rego
allow {
	role := {"name": "admin", "allowed_db": ["staging", "production"]}
	role.name == input.role
	role.allowed_db[0] == input.db
}

allow {
	role := {"name": "admin", "allowed_db": ["staging", "production"]}
	role.name == input.role
	role.allowed_db[1] == input.db
}

allow {
	role := {"name": "staff", "allowed_db": ["staging"]},
	role.name == input.role
	role.allowed_db[0] == input.db
}
```

分岐

```rego
package main

permission := "read_only" {
    input.role == "staff"
} else := "write" {
    input.db == "staging"
} else := "write" {
    input.role == "admin"
}
```

ex2

```rego
package ex2

allowed_regions := ["Tokyo", "Osaka"]

can_attend {
    input.age >= 18
    allowed_regions[_] == input.region
}
```

```sh
opa eval -i input/ex2/good1.json -f pretty -b ./exercises/ex2/ data
{
  "ex2": {
    "allowed_regions": [
      "Tokyo",
      "Osaka"
    ],
    "can_attend": true
  }
}
```

debug

```rego
debug {
    print(input)
}
```

test

```rego
package ex2

test_ok {
	can_attend with input as {"age": 20, "region": "Tokyo" }
}

test_bad_age {
	not can_attend with input as {"age": 15 }
}

test_bad_region {
	not can_attend with input as { "region": "Kyoto", "age": 20 }
}```

```sh
opa test -v ./exercises/ex2
exercises/ex2/main_test.rego:
data.ex2.test_ok: PASS (481.083µs)
data.ex2.test_bad_age: PASS (171.625µs)
data.ex2.test_bad_region: PASS (176.042µs)
-------------------------------------------
PASS: 3/3
```

## まとめ

* Policy as Codeにより自動化やテストといったソフトウェア開発のプラクティスを監査の世界に持ち込めるようになった
* PaCの手段の一つとしてOPA/Rego
* 日本でも先進的な組織しか取り組めておらず今後の普及に期待


## Memo

* Regoがかける監査の人を探したが、日本にいるのか?
* GoのSDKしかないので、Go以外に組み込めなくない..?
* Vaultのaudito log(json)をopaに渡して、監査とかできる?
* Applicationのlogをopaに渡して、監査もできる?
