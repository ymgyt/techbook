# CloudTrail

## Events

3種類に分類される

* Management events
* Data events
* Insights events

すべてのAPI/Serviceが記録されるわけではない。  
https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-aws-service-specific-topics.html

### Management events

defaultで有効。


### Data events

Resourceの操作に関わるevent。


## Eventの格納方法

CloudTrailがどのようにeventの集合をuserに提供するか。

* Event History
  * management events専用
  * 90 days
  * free(no charge)

* CloudTrail Lake

* Trails
  * これはs3への書き出しのこと?



## Logfileの検証

AuditとしてS3に保存してもそれが削除されたり改ざんされたら意味がない。  
CloudTrailはlogifleが変更/削除されていないことを検証できる仕組みを用意している。

前提としてtrailのLog file validationが有効になっている必要がある

### CLIによる検証

```
aws cloudtrail validate-logs \
  --verbose \
  --profile profile \
  --trail-arn arn:aws:cloudtrail:ap-northeast-1:12345:trail/mytrail \
  --start-time "2023-10-01T00:00:00+09:00" \
  --end-time "2024-10-01T00:00:00+09:00" \
  --account-id "4567"
```

* `--verbose`を付与することで、fileがCloudTrailによって配信されたかどうかをチェックできる

### 検証の仕組み

[Doc](https://docs.aws.amazon.com/ja_jp/awscloudtrail/latest/userguide/cloudtrail-log-file-validation-digest-file-structure.html)

ダイジェストファイルが以下の様に格納される 
`s3://s3-bucket-name/optional-prefix/AWSLogs/O-ID/aws-account-id/CloudTrail-Digest/region/digest-end-year/digest-end-month/digest-end-date/aws-account-id_CloudTrail-Digest_region_trail-name_region_digest_end_timestamp.json.gz`


ダイジェストには前のダイジェストへの参照が含まれておりこれによってダイジェスト自身を検証できる。
