# ALB Integration

ALBのListener ruleでcognitoを登録できる

## Cognito認証結果 HTTP Header

ALBのTarget groupにroutingされるhttp requestには以下のheaderが付与される

* `x-amzn-oidc-accesstoken`
* `x-amzn-oidc-identity`
* `x-amzn-oidc-data`

## Session Cookie

* `AWSELBAuthSessionCookie-{0,1}`を発行しておりこれがあると認証が通る

```sh
# curlで通す
 curl --cookie 'AWSELBAuthSessionCookie-0=<Cookie-0-Value>; AWSELBAuthSessionCookie-1=<Cookie-1-Value>' https://blog.ymgyt.io
```


## References

* [Application Load Balancer を使用してユーザーを認証する](https://docs.aws.amazon.com/ja_jp/elasticloadbalancing/latest/application/listener-authenticate-users.html#user-claims-encoding)
