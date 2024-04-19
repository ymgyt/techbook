# Git tag

* 2種類のtagがある
  * lightweight tag
  * annotated tag

## Annotated tag

object storeに格納されるfirst class object

## Lightweight tag

commit objectに対する参照

## Usage

```shell
# create
git tag v0.1.0
# annotated
git tag -a v0.1.0 HEAD

# push to remote
git push --tags

# delete
git tag --delete v0.1.0

# push deletion to remote
git push --delete origin v0.1.0
```
