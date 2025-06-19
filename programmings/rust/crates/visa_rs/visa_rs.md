# visa_rs

```rust
fn main() -> visa_rs::Result<()>{
    use std::ffi::CString;
    use std::io::{BufRead, BufReader, Read, Write};
    use visa_rs::prelude::*;

    // open default resource manager
    let rm: DefaultRM = DefaultRM::new()?;

    // expression to match resource name
    let expr = CString::new("?*KEYSIGH?*INSTR").unwrap().into();

    // find the first resource matched
    let rsc = rm.find_res(&expr)?;

    // open a session to the resource, the session will be closed when rm is dropped
    let instr: Instrument = rm.open(&rsc, AccessMode::NO_LOCK, TIMEOUT_IMMEDIATE)?;

    // write message
    (&instr).write_all(b"*IDN?\n").map_err(io_to_vs_err)?;

    // read response
    let mut buf_reader = BufReader::new(&instr);
    let mut buf = String::new();
    buf_reader.read_line(&mut buf).map_err(io_to_vs_err)?;

    eprintln!("{}", buf);
    Ok(())
}
```

1. Resourceを検索する
2. OpenしてInstrumentをえる
3. Instrumentに命令をだす
4. Bufferにresponseを書き出す


## 環境構築

1. 公式HPからNI-VISAをDL

```sh
^ls NILinux2025Q2DeviceDrivers/

ni-opensuse155-drivers-2025Q2.rpm
ni-opensuse155-drivers-stream.rpm
ni-opensuse156-drivers-2025Q2.rpm
ni-opensuse156-drivers-stream.rpm
ni-rhel8-drivers-2025Q2.rpm
ni-rhel8-drivers-stream.rpm
ni-rhel9-drivers-2025Q2.rpm
ni-rhel9-drivers-stream.rpm
ni-ubuntu2204-drivers-2025Q2.deb
ni-ubuntu2204-drivers-stream.deb
ni-ubuntu2404-drivers-2025Q2.deb
ni-ubuntu2404-drivers-stream.deb

cd ls NILinux2025Q2DeviceDrivers

dpkg-deb -x ni-ubuntu2404-drivers-2025Q2.deb out

cat out/etc/apt/sources.list.d/ni-software-2025-noble.list
deb [signed-by=/usr/share/keyrings/ni-software-2025-noble.asc] https://download.ni.com/ni-linux-desktop/2025/Q2/deb/ni/noble noble ni

BASE=https://download.ni.com/ni-linux-desktop/2025/Q2/deb/ni/noble
```
