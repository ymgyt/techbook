# Artifact

* Job間でfileを永続化(upload/download)できる仕組み
* artifactはfile or files
* 保持期間は90 days
  * 実行ログと同じ
  * 変更できない
* UploadしたartifactはCIのsummary UIからもみれる
  * zip化される


## Upload


## Download

* 同じworkflow runでuploadされたartifactのみdownloadできる
