# sudo

## `$USER is not in the sudoers file`

```sh
# foo userをsudo groupに追加
su -
usermod -aG sudo foo

# fooで再ログイン
```
