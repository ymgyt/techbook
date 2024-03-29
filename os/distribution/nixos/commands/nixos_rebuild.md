# nix-rebuild

`/etc/nixos/configuration.nix`の変更を反映する

```sh
sudo nixos-rebuild switch --flake '.#output'
```

```nix
{
  description = "NixOS Flake for ymgyt local";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";            
    };
    
    helix.url = "github:helix-editor/helix/23.05";
  };
  
  outputs = { 
    nixpkgs, 
    home-manager,  
    ... 
  }: {
    nixosConfigurations = {
      xps15 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [ 
          ./hosts/xps15
        
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ymgyt = import ./home;
          }
        ];
      };
    };
  };
}
```

 こんな`flake.nix`がある場合`--flake '.#xps15'`を指定するとnixosのrebuildが実行される
