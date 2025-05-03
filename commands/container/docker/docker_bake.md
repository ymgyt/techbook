# Docker Bake

* `docker buildx bake`
  * `docker-bake.hcl`, `docker-bake.json`, `docker-compose.yaml`等を探しに行く
* target
  * 特定のimage build definition
* group
  * targetのcollection

## Bakefile

```hcl
group "default" {
  targets = ["hello-world"]
}

target "hello-world" {
  context = "./"
  dockerfile = "Dockerfile"
  tags = ["hello-world:test"]
}
```

* `docker buildx bake` を実行すると`default` group を探す


### inherit

```hcl
target "app-dev" {
  args = {
    GO_VERSION = "1.20"
    BUILDX_EXPERIMENTAL = 1
  }
  tags = ["docker.io/username/myapp"]
  dockerfile = "app.Dockerfile"
  labels = {
    "org.opencontainers.image.source" = "https://github.com/username/myapp"
  }
}

target "_release" {
  args = {
    BUILDKIT_CONTEXT_KEEP_GIT_DIR = 1
    BUILDX_EXPERIMENTAL = 0
  }
}

target "app-release" {
  inherits = ["app-dev", "_release"]
  platforms = ["linux/amd64", "linux/arm64"]
}
```
