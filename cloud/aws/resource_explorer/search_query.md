# Resource Explorer の検索方法

## CLI

```sh
aws resource-explorer-2 search \
  --query-string "<検索条件>" \
  --view-arn "<View の ARN>" \
  --region ap-northeast-1 \
  --max-results 100
```

```text
<keyword>                          # フリーテキスト検索 (ARN, タグ値などを部分一致)
resourcetype:<type>                # リソースタイプで絞り込み
service:<service>                  # サービスで絞り込み
region:<region>                    # リージョンで絞り込み
accountid:<id>                     # アカウントIDで絞り込み
tag.key:<key>                      # タグキーで絞り込み
tag:<key>=<value>                  # タグのキーバリューで絞り込み
```

* [Resource type一覧](https://docs.aws.amazon.com/resource-explorer/latest/userguide/supported-resource-types.html)
