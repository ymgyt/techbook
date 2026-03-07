# ALB Integration

ALBのListener ruleでcognitoを登録できる

## Cognito認証結果 HTTP Header

ALBのTarget groupにroutingされるhttp requestには以下のheaderが付与される

* `x-amzn-oidc-accesstoken`
* `x-amzn-oidc-identity`
* `x-amzn-oidc-data`


## References

* [Application Load Balancer を使用してユーザーを認証する](https://docs.aws.amazon.com/ja_jp/elasticloadbalancing/latest/application/listener-authenticate-users.html#user-claims-encoding)
