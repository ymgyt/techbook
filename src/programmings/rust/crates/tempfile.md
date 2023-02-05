# tempfile

## tempfileの作成

```rust
use tempfile::NamedTempFile;

fn test() {
    let (data_file, data_file_path) = NamedTempFile::new().unwrap().into_parts();
}
```
