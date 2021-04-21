# bash

## recipe

### commandがinstallされているか

```
command -v docker > /dev/null || { echo "dockerをインストールしてください"; exit 1; }
```
