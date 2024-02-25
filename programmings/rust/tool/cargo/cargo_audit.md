# cargo-audit

## Config

* pathは`.cargo/audit.toml`
* https://docs.rs/crate/cargo-audit/0.10.0/source/audit.toml.example
* advisory-dbという別のgit repositoryが必要で暗黙的に? git cloneしている

```toml
# Example `~/.cargo/audit.toml` file
# All of the options which can be passed via CLI arguments can also be
# permanently specified in this file.

[advisories]
# 許容する対象を指定する
ignore = [] # advisory IDs to ignore e.g. ["RUSTSEC-2019-0001", ...]
informational_warnings = ["unmaintained"] # warn for categories of informational advisories
severity_threshold = "low" # CVSS severity ("none", "low", "medium", "high", "critical")

# Advisory Database Configuration
[database]
path = "~/.cargo/advisory-db" # Path where advisory git repo will be cloned
url = "https://github.com/RustSec/advisory-db.git" # URL to git repo
fetch = true # Perform a `git fetch` before auditing (default: true)
stale = false # Allow stale advisory DB (i.e. no commits for 90 days, default: false)

# Output Configuration
[output]
color = "auto" # Display colors? ("always", "never", or "auto")
deny_warnings = false # exit on error if any warnings are found
format = "terminal" # "terminal" (human readable report) or "json"
quiet = false # Only print information on error
show_tree = true # Show inverse dependency trees along with advisories (default: true)

# Target Configuration
[target]
arch = "x86_64" # Ignore advisories for CPU architectures other than this one
os = "linux" # Ignore advisories for operating systems other than this one
```
