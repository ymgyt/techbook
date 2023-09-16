# Overlays

* derivationをglobalに修正するための仕組み
  * localな修正がoverride
* flake以前は`~/.config/nixpkgs/overlays.nix`に設定していた


## Example

```nix
{ config, pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    # Overlay 1: Use `self` and `super` to express the inheritance relationship
    (self: super: {
      google-chrome = super.google-chrome.override {
        commandLineArgs =
          "--proxy-server='https=127.0.0.1:3128;http=127.0.0.1:3128'";
      };
    })

    # Overlay 2: Use `final` and `prev` to express the relationship between the new and the old
    (final: prev: {
      steam = prev.steam.override {
        extraPkgs = pkgs: with pkgs; [
          keyutils
          libkrb5
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
        ];
        extraProfile = "export GDK_SCALE=2";
      };
    })

    # Overlay 3: Define overlays in other files
    # The content of overlay3.nix is the same as above:
    # `(final: prev: { xxx = prev.xxx.override { ... }; })`
    (import ./overlays/overlay3.nix)
  ];
}
```

* `final: prev`が推奨  
  * `self: super`も使われるがfinalのほうがよいらしい

* `final`: overlayがappliedされたあとのnixpkgs
  * 今からoverlayを適用するのに適用後の`final`があるところがpoint
* `prev`: overlayがapplyされる前のnixpkgs

```nix
final: prev: {
  firefox = prev.firefox.override { ... };
  myBrowser = final.firefox;
}
```