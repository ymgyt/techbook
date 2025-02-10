# OpenID Connect

* `permissions: { id-token: write}`

## 実行の流れ

1. GitHub actionsのjobがGitHubのOIDC Providerにjwtの発行を依頼する
2. GitHub はrepository,branch等の実行contextを設定したjwtを生成する
3. jobは発行されたjwtを使って、Roleをassumeする
4 AWS では事前に設定されたOID Connect providerにしたがって、条件に合致すれば、roleのtokenを返す

## AWSのRoleをassumeする

1. AWS上にGitHub Actions の workflowを信頼する OIDC Trust(OIDC connect provider)を設定する
  * provider url: `https://token.actions.githubusercontent.com`
  * audience: `sts.amazonaws.com`


```hcl
# console から作って、importしている

import {
  id = "arn:aws:iam::<account>:oidc-provider/token.actions.githubusercontent.com"
  to = aws_iam_openid_connect_provider.gha
}

resource "aws_iam_openid_connect_provider" "gha" {
  client_id_list = ["sts.amazonaws.com"]
  tags           = {}
  tags_all = {}
  thumbprint_list = ["d89eAAAAAAAAAABBBBBBBBBBBBCCCCCCCCCCC"]
  url             = "https://token.actions.githubusercontent.com"
}
```

2. GitHub Actionで利用(assume)するRoleを定義する

3. 2で発行したjwtをAWSに渡して、Roleをassumeする

### AWS の OIDC 設定

* `"token.actions.githubusercontent.com:sub": "repo:octo-org/octo-repo:ref:refs/heads/demo-branch"`


### GitHub がOIDC Provider として発行する jwt

```text
{
  "typ": "JWT",
  "alg": "RS256",
  "x5t": "example-thumbprint",
  "kid": "example-key-id"
}
{
  "jti": "example-id",
  "sub": "repo:octo-org/octo-repo:environment:prod",
  "environment": "prod",
  "aud": "https://github.com/octo-org",
  "ref": "refs/heads/main",
  "sha": "example-sha",
  "repository": "octo-org/octo-repo",
  "repository_owner": "octo-org",
  "actor_id": "12",
  "repository_visibility": "private",
  "repository_id": "74",
  "repository_owner_id": "65",
  "run_id": "example-run-id",
  "run_number": "10",
  "run_attempt": "2",
  "runner_environment": "github-hosted"
  "actor": "octocat",
  "workflow": "example-workflow",
  "head_ref": "",
  "base_ref": "",
  "event_name": "workflow_dispatch",
  "ref_type": "branch",
  "job_workflow_ref": "octo-org/octo-automation/.github/workflows/oidc.yml@refs/heads/main",
  "iss": "https://token.actions.githubusercontent.com",
  "nbf": 1632492967,
  "exp": 1632493867,
  "iat": 1632493567
}
```

* `sub`
  * `repo:<org>/<repo>:ref:refs/heads/<branch>`
     * `repo:ymgyt/handson:ref:refs/heads/main`
