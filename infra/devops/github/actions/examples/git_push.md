# Git Push

```shell
function git_push() {
  git config user.email "githubactions@example.com"
  git config user.name "github actions"
  git status
  git commit -am "doc: update er diagram"
  git push origin master
}
```

* 特に設定しなくても自repositoryならgitの権限がありそう
* `user.{email,name}`は設定する必要がある
  * 特にvalidationはないので適当な値で良さそう
* push triggerの中でpushするとloopになってしまうので注意
