# AWS Config

## Aggregator

* 複数のsource account のAWS Configを集約して、aggregate先にviewを作る機能

## Cost

### `ConfigurationItemRecorded` が高い

* Cost explorer > Service Config > Dimension Usage type 


```sh
# delivery の設定を調べる
aws configservice describe-delivery-channels
```

### Athena

* Configの変更履歴はS3に保管されるので、Athenaから調べられる
* [AWS Configの請求内容を把握する方法を教えてください](https://repost.aws/ja/knowledge-center/retrieve-aws-config-items-per-month)

```
CREATE EXTERNAL TABLE awsconfig (
         fileversion string,
         configSnapshotId string,
         configurationitems ARRAY < STRUCT < configurationItemVersion : STRING,
         configurationItemCaptureTime : STRING,
         configurationStateId : BIGINT,
         awsAccountId : STRING,
         configurationItemStatus : STRING,
         resourceType : STRING,
         resourceId : STRING,
         resourceName : STRING,
         ARN : STRING,
         awsRegion : STRING,
         availabilityZone : STRING,
         configurationStateMd5Hash : STRING,
         resourceCreationTime : STRING > >
)
ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe' LOCATION 's://<bucket>/AWSLogs/<account>/Config/<region>/';  
```

```
SELECT result.configurationitemcapturetime,
         count(result.configurationitemcapturetime) AS NumberOfChanges
FROM
    (SELECT regexp_replace(configurationItem.configurationItemCaptureTime,
         '(.+)(T.+)', '$1') AS configurationitemcapturetime
    FROM default.awsconfig
    CROSS JOIN UNNEST(configurationitems) AS t(configurationItem)
    WHERE "$path" LIKE '%ConfigHistory%'
            AND configurationItem.configurationItemCaptureTime >= '2024-12-01T%'
            AND configurationItem.configurationItemCaptureTime <= '2024-12-07T%') result
GROUP BY  result.configurationitemcapturetime
ORDER BY  result.configurationitemcapturetime  
```

