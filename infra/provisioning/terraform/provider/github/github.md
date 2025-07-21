# Github reciepe

## Authentication

* github cli
  [`gh auth login`](https://cli.github.com/manual/gh_auth_login) を使う
* PAT
```hcl
provider "github" {
  token = var.token # or `GITHUB_TOKEN`
}
```
* GitHub App
```hcl
provider "github" {
  owner = var.github_organization
  app_auth {
    id              = var.app_id              # or `GITHUB_APP_ID`
    installation_id = var.app_installation_id # or `GITHUB_APP_INSTALLATION_ID`
    pem_file        = var.app_pem_file        # or `GITHUB_APP_PEM_FILE`
  }
}
```
> [!WARNING]
> app経由だと利用できるendpointに制限がある
> https://docs.github.com/en/rest/authentication/endpoints-available-for-github-app-installation-access-tokens?apiVersion=2022-11-28

認証に関してはCIはappで、localでplanはgh cli 経由がよさそう。


## Resources

使いそうなリソースの概要

* Actions
  * [actions_organization_secret](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_organization_secret)
    * repository scopeもある
  * [actions_organization_secret_repositories](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_organization_secret_repositories)
  * [actions_organization_variable](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_organization_variable)
    * repository scopeもある
  * [actions_repository_access_level](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_repository_access_level)
    * repositoryのworkflowを他repoから使えるかの設定

* Apps
  * [app_installation_repositories](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/app_installation_repositories)
    * installation_id とrepositoriesの紐づけ
    * 1:1 は [app_installation_repository](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/app_installation_repository)

* Branch
  * [branch](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch)
  * [branch_default](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_default)
  * [branch_protection_v3](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_protection_v3)

* Issue
  * [issue_labels](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/issue_labels)

* Membership
  * [membership](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/membership)

* Team
  * [team](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team)
  * [team_members](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_members)
  * [team_membership](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_membership)
  * [team_repository](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_repository)

* Organization
  * [organization_custom_role](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/organization_custom_role)
  * [organization_settings](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/organization_settings)
  * [organization_webhook](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/organization_webhook)

* Repository
  * [repository](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository)
  * [repository_collaborators](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_collaborators)

## Data Sources

* Apps
  * [app](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/app)

* Repository
  * [repositories](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/repositories)
    * [query](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/repositories)がかける
      * ex. `org:arkedge`

* Users
  * [users](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/users)

## Member

Github Organizationへのmemberの招待。  
Userはgithub上に既に存在する前提。

```hcl
# Terraformで管理しない
# 間違っても消えない
data "github_membership" "ymgyt" {
  username = "ymgyt"
}

resource "github_membership" "ymgyt" {
  username = "ymgyt"
  role     = "admin"
}
```

* `role`
  * `member`: 一般User
  * `admin`: UI上のOwner


## Team

```hcl
resource "github_team" "developer" {
  name        = "developer"
  description = "Developer team"
  privacy     = "closed"
}
```

* `privacy`
  * `secret`: Organization上でも所属していないと見えなくなる
  * `closed`: これが通常の状態


### Teamとmemberの紐付け

```hcl
resource "github_team_members" "developer_members" {
  team_id = github_team.developer.id

  members {
    username = data.github_membership.ymgyt.username
    role     = "maintainer"
  }

  members {
    username = data.github_membership.foo.username
    role     = "member"
  }
}
```

* `role`
  * `maintainer`: 具体的にどういう権限が付与されるか曖昧
  * `member`


## Repository

```hcl
resource "github_repository" "example" {
  name        = "example"
  description = "Example"

  visibility = "private"

  has_issues      = true
  has_discussions = true
  has_wiki        = false

  allow_merge_commit = false
  allow_squash_merge = true
  allow_rebase_merge = false

  #  The following are valid combinations for the squash commit title and message: 
  # PR_TITLE and PR_BODY, PR_TITLE and BLANK, PR_TITLE and COMMIT_MESSAGES, COMMIT_OR_PR_TITLE and COMMIT_MESSAGES
  squash_merge_commit_title   = "COMMIT_OR_PR_TITLE"
  squash_merge_commit_message = "COMMIT_MESSAGES"

  delete_branch_on_merge = true
  auto_init              = true
}

resource "github_team_repository" "developer_example" {
  team_id    = github_team.developer.id
  repository = github_repository.example.name
  permission = "push"
}
```

* `permission`: teamに付与するrepositoryへの権限(はterraform側の対応と思われるやつ)
  * `read(pull)`: Recommended for non-code contributors who want to view or discuss your project
  * `triage(triage)`: Recommended for contributors who need to proactively manage issues, discussions, and pull requests without write access
  * `write(push)`: Recommended for contributors who actively push to your project
  * `maintain(maintain)`: Recommended for project managers who need to manage the repository without access to sensitive or destructive actions
  * `admin(admin)`: Recommended for people who need full access to the project, including sensitive and destructive actions like managing security or deleting a repository
  * [より詳細な権限テーブル](https://docs.github.com/en/organizations/managing-user-access-to-your-organizations-repositories/repository-roles-for-an-organization#permissions-for-each-role)


### Collaboratorの招待

repositoryにcollaboratorを招待する

```hcl
resource "github_repository_collaborator" "foo" {
  repository = "hoge"
  username   = "ymgyt"
  permission = "read"
}
```

* user `ymgyt`をcollaboratorとして追加
* permissionはteamと同じ
  * docには`read`がなかったが有効だった
* `github_repository_collaborators`(sがつく)はその定義以外を無効にする(authoritive)で、これは既存に関与しないという違いがありそう
)
