# Bash

## Recipe

* scriptのある絶対pathを取得する

```shell
CWD=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
```
