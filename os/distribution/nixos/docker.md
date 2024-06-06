# Build Docker Image 

Nixからdocker imageの生成について

## Build Image

```nix
# syndApiもderivation
# Create derivation
syndApiImage = pkgs.dockerTools.buildImage {
  name = "synd-api";
  config = { Cmd = [ "${syndApi}/bin/synd-api" "--help" ]; };
};

# outputはpackages
in {
  packages = {
    synd-api-image = syndApiImage;  
}
```
