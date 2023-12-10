# NixOS Module

## Structure

```
{ config, pkgs, ... }:

{
  imports =
    [ *paths of other modules*
    ];

  options = {
    *option declarations*
  };

  config = {
    *option definitions*
  };
}
```

* `config` system全体のconfig
* `pkgs` Nixpkgs
* `config`と`pkgs`に依存しない場合は単なるsetの場合もある
* `imports`はNixOS module専用の関数で引数に他のmoduleを期待している
* `options`はmoduleのinterface


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