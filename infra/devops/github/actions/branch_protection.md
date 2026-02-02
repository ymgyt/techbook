# Branch Protection

Rulesetsとも

## Require status check to pass

* CIで特定のjobが通らないとマージできないという条件を付与できる。  
* Jobはworkflow namespacedでない
  * workflow-a/check jobとworkflow-b/check jobがあり、`check` jobを条件に指定するとどのjobか曖昧になる

以下のようにgithubはintegration_idとjob名(check)しか保持していない
そして、integration_idはGitHub Actionsのことである。

```sh
gh api /repos/ymgyt/handson/rulesets/$ruslid | from json | get rules | where type == 'required_status_checks' | to json
[
  {
    "type": "required_status_checks",
    "parameters": {
      "strict_required_status_checks_policy": false,
      "do_not_enforce_on_create": false,
      "required_status_checks": [
        {
          "context": "check",
          "integration_id": 15368
        }
      ]
    }
  }
]

gh api $"/repos/($repo)/commits/($sha)/check-runs" | from json | get check_runs | where name == "check-status" | first | get app | select id slug owner.login name description | to json
{
  "id": 15368,
  "slug": "github-actions",
  "owner.login": "github",
  "name": "GitHub Actions",
  "description": "Automate your workflow from idea to production"
}
```

