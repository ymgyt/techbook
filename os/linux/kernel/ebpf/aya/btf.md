# BTF

```rust

fn main() {
    let btf = aya::Btf::parse_file(
        "/sys/kernel/btf/processor_thermal_device",
        aya::Endianness::default(),
    )
    .unwrap();
    println!("{btf:#?}");
}
```
