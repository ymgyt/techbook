# fnm

Fast Node Manager

## Install

```
cargo install fnm
```

in `.bashrc` (or shell rc)

```
eval "$(fnm env)"
```

## Usage

```sh

# list installable versions
fnm list-remote

# install
fnm install v16.13.1

# pin specific node version to project(directory)
fnm use v16.13.1
```