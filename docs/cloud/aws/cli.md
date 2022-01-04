# AWS CLI

aws cliに関すること。

## Install

```sh
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

```

## STS

```shlell
# roleをassumeする
# assume roleできるpermissionが必要。
# duration secondsでは最大12時間まで指定できるが、role自体の上限が設定されていれば適用される。
aws sts assume-role \
    --role-arn=<role_arn> \
    --role-session-name=<adhoc_session_name> \
    --duration-seconds=3600
```
