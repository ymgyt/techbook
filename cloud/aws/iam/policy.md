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
