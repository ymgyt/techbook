# git format-patch

commitからpatch fileを作成する

## Usage

```sh
# 直近のコミットのpatchを作成
git format-patch -1 HEAD --stdout out> /tmp/my_patch

# 適用
git apply /tmp/my_patch
```
