# Fork

```sh

$ git remote -v
> origin  https://github.com/YOUR-USERNAME/YOUR-FORK.git (fetch)
> origin  https://github.com/YOUR-USERNAME/YOUR-FORK.git (push)

# fork元(upstream)を追加する
git remote add upstream https://github.com/ORIGINAL-OWNER/ORIGINAL-REPOSITORY.git

get fetch upstream
git checkout main
git merge upstream/main
```
