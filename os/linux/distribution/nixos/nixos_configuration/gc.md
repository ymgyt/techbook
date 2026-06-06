# Garbage collection

```nix
{ 
  # garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
    persistent = true;
    randomizedDelaySec = "30sec";
  };
}
```