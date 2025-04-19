# Amazon Q Developer

* Bedrock使っている
* Tiers
  * Pro
    * 有料subscription
  * Free tier
    * AWS Builder ID で authentication する

## Subscription

### Pro

* accountの形態に応じて、方式が変わる
  * standalone account
  * management account
  * member account

### Free tier

AWS Builder ID で authentication する

## Install

* Linux
  * https://desktop-release.codewhisperer.us-east-1.amazonaws.com/latest/amazon-q.appimage

## Pricing


## Troubleshoot

```
amazon-q.appimage
dlopen(): error loading libfuse.so.2

AppImages require FUSE to run.
You might still be able to extract the contents of this AppImage
if you run it with the --appimage-extract option.
See https://github.com/AppImage/AppImageKit/wiki/FUSE
for more information 
```

* NixOS `programs.appimage.binfmt = true;`
  * https://nixos.wiki/wiki/Appimage
