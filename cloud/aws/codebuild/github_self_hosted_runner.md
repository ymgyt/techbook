# GitHubとの連携

## Actions Workflow

```yaml

name: Job on CodeBuild
on: workflow_dispatch
jobs:
  build-on-codebuild:
    runs-on:
      - codebuild-<project-name>-${{ github.run_id }}-${{ github.run_attempt }}
      - image:ubuntu-7.0
      - instance-size:xlarge
```

* codebuildが認識しないものは無視される(errorにはならない)
* `runs-on` 
  * `codebuild-` prefixでcodebuild hosted runner上での実行になる
  * `-<project-name>-`: codebuild project nameを指定する
  * `image:<environment-type>-<image-identifier>`
    * example `- image:ubuntu-7.0`
    * 指定できるenvironment-typeは[doc](https://docs.aws.amazon.com/codebuild/latest/userguide/sample-github-action-runners-update-yaml.images.html)
    * [docker imageのsource](https://github.com/aws/aws-codebuild-docker-images/tree/master/ubuntu/standard/7.0)
  * `instance-size`
    * 指定できる値はimageに依る
    * [具体的なspec](https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html#environment.types)

## 参考

* [Label overrides](https://docs.aws.amazon.com/codebuild/latest/userguide/sample-github-action-runners-update-labels.html)
  * workflow側からinstance size等を指定できる
