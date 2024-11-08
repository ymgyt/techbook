# aws-vault

## Memo

```sh
aws-vault add ymgyt
# Input Access Key ID and Secret Key

# 一時的な権限取得
aws-vault exec ymgyt -- aws sts get-caller-identity

# 権限を取得したshell nuもok
aws-vault exec ymgyt

aws-vault list
```
