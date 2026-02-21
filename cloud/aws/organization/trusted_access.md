# Trusted Access for AWS Account Management

* OrganizationsのMember accountのroot user emailやaccount nameをmanagement accountから変更するために必要

```sh
# management accountで操作する

# 現状確認
 aws organizations list-aws-service-access-for-organization

# 有効化
aws organizations enable-aws-service-access --service-principal account.amazonaws.com

# 無効化
aws organizations disable-aws-service-access --service-principal account.amazonaws.com
```
