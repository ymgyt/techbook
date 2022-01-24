# Keybind

ubuntuでKeybindを設定する方法  
とくにHHKを前提にした日本語変換の設定方法

## dual-functions-keys

* https://gitlab.com/interception/linux/plugins/dual-function-keys/
* 特定のkeyが押されたときに別のkeyへ変換を定義できる

### Tweaks

* Keyboard & Mouse > Additional Layout Option > Alt/Win key behavior > Meta is mapped to Winにcheck
  * これでHHKのLeft/Write Super KeyがMetakeyとして認識される

### interseptionのinstall

* https://gitlab.com/interception/linux/tools

```sh
# install
sudo add-apt-repository ppa:deafmute/interception
sudo apt install interception-tools
```

* `/etc/interception/udevmon.d/my-keyboads.yaml`を作成

```yaml
- JOB: "intercept -g $DEVNODE | dual-function-keys -c /etc/interception/dual-function-keys/mappings.yaml | uinput -d $DEVNODE"
  DEVICE:
    EVENTS:
     EV_KEY: [ KEY_LEFTMETA, KEY_RIGHTMETA ]
```

### 設定file

* `/etc/interception/dual-function-keys/mappings.yaml`を作成

```yaml
MAPPINGS:
  - KEY: KEY_LEFTMETA
    TAP: KEY_MUHENKAN
    HOLD: KEY_LEFTMETA

  - KEY: KEY_RIGHTMETA
    TAP: KEY_HENKAN
    HOLD: KEY_RIGHTMETA
```

* TAPは短く押したとき、HOLDは別のkeyと押したときの挙動
  * この書き方で、Meta(Super)key単独でおしたときは独立したkeyにできるのでshortcutを割り当てられる


### enable udevmon

```sh
sudo systemctl restart udevmon
```

### create 日本語shortcut

* Settings > Keyboard > Custom Shortcuts
  * `gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell --method org.gnome.Shell.Eval "imports.ui.status.keyboard.getInputSourceManager().inputSources[0].activate()"`
  * `gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell --method org.gnome.Shell.Eval "imports.ui.status.keyboard.getInputSourceManager().inputSources[1].activate()"`
  * それぞれにHekan/Muhenkanを設定する
