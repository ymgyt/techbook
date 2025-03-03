# Athena

```hcl
resource "aws_athena_workgroup" "foo" {
  name        = "foo"
  description = "foo athena workgroup"
  state       = "ENABLED"

  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = false

    engine_version {
      selected_engine_version = "Athena engine version 3"
    }

    result_configuration {
      output_location = "s3://ymgyt-bucket/athena/result/"

      encryption_configuration {
        encryption_option = "SSE_S3"
      }
    }
  }
}
```
