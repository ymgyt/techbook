# which

command/binary名から実行pathの解決をしてくれる。  
Windowsの挙動も吸収してくれる。

* absolute pathの場合、fileの存在とexecutableかを確認してくれる。
* relative pathの場合、absoluteに解決したうえで探してきてくれる。
* それ以外の場合は `$PATH`を考慮して探してきてくれる。

```rust
pub fn resolve_binary_path(path: impl AsRef<OsStr>) -> Result<PathBuf> {
    which::which(path)
}
```
