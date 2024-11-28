# Cloudwatch Logs Insight


## Usage

```
fields @logstream, @timestamp, @message
| sort @timestamp desc
| filter @logStream like /authenticator/
| limit 50
```
