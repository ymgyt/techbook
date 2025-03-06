# volta

* Install
  * `curl https://get.volta.sh | bash`
* rustupのように, `node`, `npm` の versionを管理する

## Configure

* environment variable `VOLTA_HOME` に `$HOME/.volta`を指定する
* `$VOLTA_HOME/bin` を PATHの先頭にprependする

## Usage

```sh
# nodeのinstall
volta install node@22

# projectのnodeを指定(pin)
volta pin node@20
```

* `volta pin node@<version>`
  * `package.json`に記録している


* globalにinstallしても管理してくれる?

```sh
npm install --global typescript

cd /path/to/project-using-typescript-4.9.5
tsc --version # 4.9.5

cd /path/to/project-using-typescript-5.5.4
tsc --version # 5.5.4
```
