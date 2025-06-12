# Cloudwatch Logs

## S3 へのexport

* `aws logs create-export-task` でexport taskを作成できる


## Filter


* JSONのfilter

```
{ $.eventType = "UpdateTrail" }

{ $.span.uri != "/health" }                             
```
