# Caller Identity

## IAM Identity Center Role

```sh
aws sts get-caller-identity
{
    "UserId": "[REDACTED]",
    "Account": "111111111111",
    "Arn": "arn:aws:sts::111111111111:assumed-role/AWSReservedSSO_RoleName_[RANDOM]/UserName"
}
```

ARNはSession名
これに対応するRoleは

```sh
arn:aws:iam::[MNG_ACCOUNT_ID]:role/aws-reserved/sso.amazonaws.com/[REGION]/AWSReservedSSO_[RoleName]_[RANDOM]`
```
