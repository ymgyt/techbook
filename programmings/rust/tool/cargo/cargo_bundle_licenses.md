# cargo-bundle-licenses

```just
# Generate dependencies licenses
license: 
    cargo bundle-licenses --format toml --output THIRDPARTY.toml

# Check dependencies licenses
license-check:
    RUST_LOG=error cargo bundle-licenses --format toml --output __CHECK --previous THIRDPARTY.toml --check-previous
    try {rm __CHECK}
```
