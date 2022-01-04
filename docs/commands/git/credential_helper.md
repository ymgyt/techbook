# git credential helper

* gitがprivate repositoryとやり取りする際の認証情報を管理する仕組み
* [my implementation](https://github.com/ymgyt/git-credential-helper)

## config

```toml
[credential]
  helper = "/home/ymgyt/.cargo/bin/git-credential-helper"
```

* if you put an absolute path in the helper, git will call it when credential need

## how it work

* communicate with git via stdin/stdout
* the expectd behavior changes depending on the first argument
  * in the case of store, output the credential of user to stdout

## references

* https://git-scm.com/docs/gitcredentials#_custom_helpers



