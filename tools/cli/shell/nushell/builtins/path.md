# path

## Usage

```nu
const p = "~/.config/nu/hello.nu"
if ($p | path expand | path exists) {
  source $p
}
```
