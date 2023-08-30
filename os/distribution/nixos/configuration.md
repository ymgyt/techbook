# Configuration

設定fileは`/etc/nixos/configuration.nix`

data sourceはnix-channelに頼っているのでreproducibilityがflakesに比べて落ちる

* `nixos-help`でmanualみれる

`sudo nixos-rebuild switch`

### Options

何が設定できるか以下を検索

* [NixOS Options Search](https://search.nixos.org/options)
* [Manual](https://nixos.org/manual/nixos/unstable/index.html#ch-configuration)


## `/etc/nixos/configuration.nix`

```nix
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ja_JP.UTF-8";
    LC_IDENTIFICATION = "ja_JP.UTF-8";
    LC_MEASUREMENT = "ja_JP.UTF-8";
    LC_MONETARY = "ja_JP.UTF-8";
    LC_NAME = "ja_JP.UTF-8";
    LC_NUMERIC = "ja_JP.UTF-8";
    LC_PAPER = "ja_JP.UTF-8";
    LC_TELEPHONE = "ja_JP.UTF-8";
    LC_TIME = "ja_JP.UTF-8";
  };
  
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-mozc ];
  };
  
  fonts.fonts = with pkgs; [ 
    rictydiminished-with-firacode
    ipafont
  ];
  
  fonts.fontconfig.defaultFonts = {
    monospace = [
      "IPAGothic"
    ];
    sansSerif = [
      "IPAGothic"
    ];
    serif = [
      "IPAPMincho"
    ];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.ymgyt = {
    isNormalUser = true;
    description = "ymgyt";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    bat
    fd
    git
    helix
    rustup
  ];
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "22.11"; # Did you read the comment?
}
```

### Flake

`nix.settings.experimental-features = [ "nix-command" "flakes" ];`  
flakesを有効にすると`/etc/nixos/flake.nix`が優先される
