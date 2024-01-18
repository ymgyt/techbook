# NixOS Module

* Nix languageとmoduleは関係ない
  * `nixpkgs/lib/modules.nix`配下でそう実装されているだけ
* 最終的に1つのattribute setにcompositeされる
  * `config.system.build.toplevel` attributeをもつ
    * これがNixOSをbuildするderivation
    * `nixpkgs/nixos/modules/system/activation/top-level.nix`
  * `lib.evanModules`が担っている

## Structure

```nix
{ config, lib, pkgs, ... }:

{
  # Other modules to import
  # 省略化
  imports = [
    #...
  ];

  # Options this module declares
  # 省略化
  options = {
    #...
  };

  # Options this module defines
  # 省略化
  config = {
    #...
  }
}
```

* 引数
  * `config` system全体のconfig
  * `pkgs` Nixpkgs
  * 省略してattribute setを返すこともできる
* `imports`はNixOS module専用の関数で引数に他のmoduleを期待している
* `options`はmoduleのinterface
* `config`

```nix
{ config = {
  services.foo.enable = true;
}}
```

```nix
{ services.foo.enable = true; }
```

* **`config`を省略してtop levelに書いた場合、`config`の中に書いたことになる**


## Example

```nix
{ lib, pkgs, config, ... }:
with lib;                      
let
  # Shorter name to access final settings a 
  # user of hello.nix module HAS ACTUALLY SET.
  # cfg is a typical convention.
  cfg = config.services.hello;
in {
  # Declare what settings a user of this "hello.nix" module CAN SET.
  options.services.hello = {
    enable = mkEnableOption "hello service";
    greeter = mkOption {
      type = types.str;
      default = "world";
    };
  };

  # Define what other settings, services and resources should be active IF
  # a user of this "hello.nix" module ENABLED this module 
  # by setting "services.hello.enable = true;".
  config = mkIf cfg.enable {
    systemd.services.hello = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = "${pkgs.hello}/bin/hello -g'Hello, ${escapeShellArg cfg.greeter}!'";
    };
  };
}
```

利用側

```nix
{
  imports = [ ./hello.nix ];
  ...
  services.hello = {
    enable = true;
    greeter = "Bob";
  };
}
```


