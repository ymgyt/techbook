# std

## fs

### create file

fileを作成してpermissionを設定する。 unix前提。

```rust
#[cfg(target_family = "unix")]
fn create_file<P, R>(
    dest: P,
    mut content: R,
    mode: u32,
) -> Result<()>
where
    P: AsRef<Path>,
    R: io::Read,
{
    use std::os::unix::fs::{OpenOptionsExt, PermissionsExt};

    let mut file = fs::OpenOptions::new()
        .write(true)
        .truncate(true) // overwrite if exists
        .create(true) // create if not exists.
        .mode(mode)
        .open(dest)?;

    io::copy(&mut content, &mut file)?;

    // set permission explicitly because when file already exists, the mode specification at open does not.
    let mut perm = file.metadata()?.permissions();
    perm.set_mode(mode);
    file.set_permissions(perm)?;

    Ok(())
```

### create symlink

```rust
#[cfg(target_family = "unix")]
fn create_symbolic_link<P, Q>(
    original: P, link: Q) -> Result<()>
where
    P: AsRef<Path>,
    Q: AsRef<Path>,
{
    return match std::os::unix::fs::symlink(&original, &link) {
        Ok(_) => Ok(()),
        Err(io_err) => {
            if let io::ErrorKind::AlreadyExists = io_err.kind() {
                // TODO: care infinite loop.
                debug!("{} already exists, try removing", link.as_ref().display());
                
                fs::remove_file(&link)?;
                return create_symbolic_link(original, link);
            }
            Err(io_err.into())
        }
    };
}


```
