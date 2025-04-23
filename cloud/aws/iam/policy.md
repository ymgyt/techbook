# IAM Policy

## 種類

* AWS Managed Policy
* Customer Managed Policy
* Inline Policy

## Action

* 具体的なAPIの指定

https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_action.html

```json
"Action": "ec2:StartInstances",
"Action": "s3:*"
"Action": "iam:*AccessKey*",
```

* `*`をpartialで利用できる

## Policy の評価

このフローチャートが神

https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/images/PolicyEvaluationVerticalRCP.png

## Condition

* Policy評価時にAWSはRequestの情報から、Contextというjsonを組み立てる
  * conditionは暗黙的にこのcontext jsonに対して書く

```json
"Condition": {
  "<Operator>": {
    "<Context Key>": "<Expected Value>"
  }
}
```

のように書いて、requestの`<Context Key> <Operator> <Expected Value>` を表現する

* [Operator一覧](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_condition_operators.html)
* `<Context Key>` がrequestにない場合、falseで評価される
  * `StringNotEqual`のようなnot系を使うと、keyが存在しないので、false -> not -> trueのように判定するのでムズい
  * `<Context key>`には可用性(availability)という概念がある
  * `<Context key>`がない場合、trueに倒したいなら、`StringEqualsIfExists`のように`IfExists`をつける

* Global condition key
  * どのpolicyでも使えるkey
  * 必ずrequestに含まれているとは限らない
  * [一覧](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_condition-keys.html)

* requestに含まれていたら評価したい場合は `...IfExists` operatorを使う
  * requestに含まれていない場合は trueに評価される

```json
"Condition": {
    "IpAddressIfExists": {"aws:SourceIp" : ["xxx"] },
    "StringEqualsIfExists" : {"aws:SourceVpc" : ["yyy"]} 
}
```

### Multivalued context keys

* Context keyによっては型がString listのように複数の値をもつ場合がある
  * policyではなく、request contextが複数の値をもつ場合
* その場合は、`Condition.ForAllValues:StringLike` のように、operatorを複数用に修飾する必要がある

* `Condition.ForAllValues:<operator>`
  * request の値の集合が、policyのsub setであることを要求
  * 直感としては、すべてのrequestの値が、policyで列挙されてる値に該当すればよい

* `Condition.ForAnyValues:<operator>`
  * requestの値のいずれかが、policyの値にmatchすればよい



### Policy variable

* poilcy中で使える変数
  * `${var}` と書くと、評価時に置換される
  * `${aws:username, 'anonymous'}`のようなfallback用のdefaultを指定できる?
  * 利用できるvariableは`Version`に紐づいているので必ず指定する
* request contenxtに変数がない場合は、そのstatementは無効になる

* principalに付与されたteam tagに一致するprefixへのアクセスを許可する例
  * teamごとに値を変えた、policyを複数定義することを避けられる


```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],      
      "Resource": ["arn:aws:s3:::amzn-s3-demo-bucket"],
      "Condition": {"StringLike": {"s3:prefix": ["${aws:PrincipalTag/team}/*"]}}
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],      
      "Resource": ["arn:aws:s3:::amzn-s3-demo-bucket/${aws:PrincipalTag/team}/*"]
    }
  ]
}
```


### IAM STS condition keys

* [IAM Condition keys](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_iam-condition-keys.html)

## Version

* `2012-10-17`: 現行の最新、基本これを指定する

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListAllMyBuckets",
      "Resource": "*"
    }
  ]
}
```
