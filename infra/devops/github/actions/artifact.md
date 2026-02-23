# Artifact

* RunIDを指定してobjectを永続化する仕組み
  * 同一workflowならJob間でfileを永続化(upload/download)できる
  * Runが同じ(workflow_call)なら、workflowをまたげる
  * なんらかの方法でRUN IDを知れるならworkflowをまたげる
* artifactはfile or files
* 保持期間は90 days(max)
  * 実行ログと同じ
  * 変更できない
* UploadしたartifactはCIのsummary UIからもみれる
  * zip化される


## Upload

* path: uploadする成果物
* name: artifactの識別子。downloadはnameを参照する
* `permissions`の`actions:write`が必要

```yaml
- uses: actions/upload-artifact@v6
  with:
    # artifactの識別子。downloadはこれを意識する
    name:

    # uploadするファイル
    path:

    # fileがない場合の挙動
    # Available Options:
    #   warn: Output a warning but do not fail the action
    #   error: Fail the action with an error message
    #   ignore: Do not output any warnings or errors, the action does not fail
    # Optional. Default is 'warn'
    if-no-files-found:

    # Duration after which artifact will expire in days. 0 means using default retention.
    # Minimum 1 day.
    # Maximum 90 days unless changed from the repository settings page.
    # Optional. Defaults to repository settings.
    retention-days:

    # The level of compression for Zlib to be applied to the artifact archive.
    # The value can range from 0 to 9.
    # For large files that are not easily compressed, a value of 0 is recommended for significantly faster uploads.
    # Optional. Default is '6'
    compression-level:

    # If true, an artifact with a matching name will be deleted before a new one is uploaded.
    # If false, the action will fail if an artifact for the given name already exists.
    # Does not fail if the artifact does not exist.
    # Optional. Default is 'false'
    overwrite:

    # Whether to include hidden files in the provided path in the artifact
    # The file contents of any hidden files in the path should be validated before
    # enabled this to avoid uploading sensitive information.
    # Optional. Default is 'false'
    include-hidden-files:
```

## Download

* 同じworkflow runでuploadされたartifactのみdownloadできる
* `permissions`の`actions:read`が必要

```yaml
steps:
  - name: Download result artifacts
    uses: actions/download-artifact@v7
    with:
      pattern: artifact-name-*
      path: ___results
      merge-multiple: false
```

* `__results` dir配下にartifact nameにディレクトリが作られその中にartifact fileがある
