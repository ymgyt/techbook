# Event

```json
{
  "version": "0",
  "id": "UUID",
  "detail-type": "event name",
  "source": "event source",
  "account": "ARN",
  "time": "timestamp",
  "region": "region",
  "resources": [
    "ARN"
  ],
  "detail": {
    JSON object
  }
}
```

* `version`: 基本0
* `id`: UUID
* `source`
  * `aws.` がawsのevent
