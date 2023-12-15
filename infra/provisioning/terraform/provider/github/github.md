# Github reciepe

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