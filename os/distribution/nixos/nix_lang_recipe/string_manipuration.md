# Nix string manipulation

## Join

```nix
ignoreAdvisories = pkgs.lib.concatStrings
  (pkgs.lib.strings.intersperse " " (map (x: "--ignore ${x}") [
    "RUSTSEC-2024-0003"
    "RUSTSEC-2021-0041"
    "RUSTSEC-2023-0052"
    "RUSTSEC-2021-0139"
    "RUSTSEC-2021-0145"
  ]));
# => "--ignroe RESTSEC-... --ignore RUSTSEC-... "
```
