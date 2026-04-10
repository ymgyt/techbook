# Cognito User Management

## Password Reset

```sh
aws cognito-idp admin-set-user-password \
    --user-pool-id ap-northeast-1_dGYzwOc0h \
    --username <ユーザー名> \
    --password '<新しいパスワード>' \
    --permanent
```
