# Cache
```yaml
name: Caching with npm

on: push

jobs:
  build:
  runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Cache node modules
        uses: actions/cache@v2
        env:
          cache-name: cache-node-modules
        with:
          # npm cache files are stored in `~/.npm` on Linux/macOS
          path: ~/.npm
          key: ${{ runner.os }}-build-${{ env.cache-name }}-${{ hashFiles('**/package-lock.json') }}
          restore-keys: |
            ${{ runner.os }}-build-${{ env.cache-name }}-
            ${{ runner.os }}-build-
            ${{ runner.os }}-

      - name: Install Dependencies
        run: npm install

      - name: Build
        run: npm build

      - name: Test
        run: npm test
```

* `path`がcache対象
* keyがcacheの識別子
* `restore-keys`と部分検索して一致したらpathが復元されるイメージ
  * 複数指定できるので、`xxx-feature-`としておくと他のfeatureのcacheが復元されてないよりましな感じにできる
* cacheの保存処理はPostの仕組みで行われているっぽいので明示的なsave stepがない?

## Rust 

```yaml
- uses: actions/cache@v3
  with:
    path: |
      ~/.cargo/bin/
      ~/.cargo/registry/index/
      ~/.cargo/registry/cache/
      ~/.cargo/git/db/
      target/
    key: ${{ runner.os }}-cargo-${{ hashFiles('**/Cargo.lock') }}
    restore-keys: |
      ${{ runner.os }}-cargo-
```

