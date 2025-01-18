# AWS Config

## Cost

### `COnfigurationItemRecorded` が高い

* Cost explorer > Service Config > Dimension Usage type 


```sh
# delivery の設定を調べる
aws configservice describe-delivery-channels
```

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
ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe' LOCATION '';  
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

```
SELECT configurationItem.resourceType,
         configurationItem.resourceId,
         COUNT(configurationItem.resourceId) AS NumberOfChanges
FROM default.awsconfig
CROSS JOIN UNNEST(configurationitems) AS t(configurationItem)
WHERE "$path" LIKE '%ConfigHistory%'
        AND configurationItem.configurationItemCaptureTime >= '2024-12-01T%'
        AND configurationItem.configurationItemCaptureTime <= '2024-12-07T%'
GROUP BY  configurationItem.resourceType, configurationItem.resourceId
ORDER BY  NumberOfChanges DESC  
```
