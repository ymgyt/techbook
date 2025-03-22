# Nix

## Install

https://nixos.org/download.html#nix-install-macos

`sh <(curl -L https://nixos.org/nix/install)`

`nix-shell -p nix-info --run "nix-info -m"`

## `nix.conf`

* `/etc/nix/nix.conf`
* `$HOME/.config/nix/nix.conf`
  * `/root/.config/nix/nix.conf`

```
experimental-features = nix-command flakes repl-flake
access-tokens = github.com=ghp_<REDACED>
```

* `experimenta-features`で有効にしたいfeatureを指定する
* `access-tokens` private repo取得時に設定される

### sudoをつけた時にBad Credential


* `/root/.config/nix/nix.conf` の tokenを確認する
