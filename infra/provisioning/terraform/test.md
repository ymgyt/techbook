# Terraform test

* defaultでは、実際にapplyしてresourceを作成する
* test fileの検索path
  * `.tftest.hcl`, `.tftest.json` が test用 file
  * top level
  * `tests` dir配下
    * cli flag(`-test-directory`)でoverrideはできる
* `run` block を順番に実行する
* `variables`, `provider` の順番は関係ない


## Syntax

* top level
  * `run` blocks (one to many)
  * `variables` block (zero to one)
  * `provider` blocks (zero to many)


```hcl
variables {
  bucket_prefix = "test"
}

run "valid_concat" {
  command = plan

  assert {
    condition = aws_s3_bucket.bucket.bucket == "test-bucket"
    error_message = "S3 bucket name did not match expected"
  }
}
```

* `command`
  * `apply` (default)
  * `plan`

* `plan_options`
  * `mode`
    * `normal`
    * `refresh-only`
  * `refresh`: boolean (default: true)
