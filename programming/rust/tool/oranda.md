# oranda

* 開発project用のstatic site generator
  * zolaのようにbuildして成果物をgithub pagesで公開できる
    
* `oranda generate ci --output-path .github/workflows/website.yaml --ci github`でGithub pages用のworkflowを生成してくれる


## Workspace

* top levelに`oranda-workspace.json`を置く
* `workspace.members.path`に`oranda.json`が置いてある想定

```json
{
  "workspace": {
    "name": "Syndicationd",
    "members": [
      {
        "slug": "synd-term",
        "path": "./crates/synd_term"
      }
    ]
  }
}
```

## Config

* `oranda.json`に書く

```json
{
  "build": {
    "static_dir": "assets",
    "dist_dir": "website"
  },
  "styles": {
    "theme": "axo_dark",
    "favicon": "https://blog.ymgyt.io/favicon.ico"
  },
  "marketing": {
    "social": {
      "image": "https://blog.ymgyt.io/images/emoji/crab.png",
      "image_alt": "synd",
      "twitter_account": "@YAmaguchixt"
    }
  },
  "components": {
    "changelog": {
      "read_changelog_file": false
    },
    "artifacts": {
      "package_managers": {
        "additional": {
          "nix": "nix profile install github:ymgyt/syndicationd",
          "cargo": "cargo install synd-term --locked"
        }
      }
    }
  }
}
```



