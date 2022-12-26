# scp

## Usage

* `scp <src> <dest>`
  * remoteの場合は`<user>@<host>:<file_path>`

```shell
# remoteのfileをlocalにfetch
scp ec2-user@${REMOTE_IP}:/path/to/file ./local/path/file
```
