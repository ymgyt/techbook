# nix profile

## Usage

```sh
# Install from nixpkgs master branch
nix profile install nixpkgs/master#nushell

# Localのhelixをinstall
# 衝突したのでpriorityを導入したが仕組みわかっておらず
cd helix
nix profile install . --priority 4

# profileでinstallしたpackage一覧
nix profile list

# listで番号表示されるので
nix profile upgrade 0
```
