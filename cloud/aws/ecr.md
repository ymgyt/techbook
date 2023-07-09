# ECR

## Login

```shell
# AWS_ACCOUNT=123
# AWS_REGION=ap-northeast-1
# --username AWS はliteral. docker hubのusernameを使ったりはしない
aws ecr get-login-password --region ${AWS_REGION}  | docker login --username AWS --password-stdin https://${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com
```

* docker cliでprivate ECRにimageをpushしたい
* `--username AWS` はliteralなので注意。 docker hubのusernameを使ったりはしない
