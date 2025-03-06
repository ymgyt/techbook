# codec

## `FramedRead`

1. data を underlying `AsyncRead`から読んで、自身のbufferに保持する
2. internal buffer を `Decoder`に渡し、item が返ってきたら、`Stream`の実装として、item を yieldする
  * `Decoder`は不要なdata をinternal bufferから取り除く責務をもつ
    * `FramedRead`はappendしかしない

* `Decoder`の挙動
  * bufferが不十分なら`Ok(None)`を返す
  * bufferが十分なら、`Ok(Some(Item))`を返す


## `Decoder`

* 文字列の長さ + 文字列をdecodeする実装例


```rust
use tokio_util::codec::Decoder;
use bytes::{BytesMut, Buf};

struct MyStringDecoder {}

const MAX: usize = 8 * 1024 * 1024;

impl Decoder for MyStringDecoder {
    type Item = String;
    type Error = std::io::Error;

    fn decode(
        &mut self,
        src: &mut BytesMut
    ) -> Result<Option<Self::Item>, Self::Error> {
        if src.len() < 4 {
            // Not enough data to read length marker.
            return Ok(None);
        }

        // Read length marker.
        let mut length_bytes = [0u8; 4];
        length_bytes.copy_from_slice(&src[..4]);
        let length = u32::from_le_bytes(length_bytes) as usize;

        // Check that the length is not too large to avoid a denial of
        // service attack where the server runs out of memory.
        if length > MAX {
            return Err(std::io::Error::new(
                std::io::ErrorKind::InvalidData,
                format!("Frame of length {} is too large.", length)
            ));
        }

        if src.len() < 4 + length {
            // The full string has not yet arrived.
            //
            // We reserve more space in the buffer. This is not strictly
            // necessary, but is a good idea performance-wise.
            src.reserve(4 + length - src.len());

            // We inform the Framed that we need more bytes to form the next
            // frame.
            return Ok(None);
        }

        // Use advance to modify src such that it no longer contains
        // this frame.
        let data = src[4..4 + length].to_vec();
        src.advance(4 + length);

        // Convert the data to a string, or fail if it is not valid utf-8.
        match String::from_utf8(data) {
            Ok(string) => Ok(Some(string)),
            Err(utf8_error) => {
                Err(std::io::Error::new(
                    std::io::ErrorKind::InvalidData,
                    utf8_error.utf8_error(),
                ))
            },
        }
    }
}
```

## `FramedWrite`

* underlying の`AsyncWrite` への書き込みと、bufferの制御が責務

```rust
use tokio::io::AsyncWriteExt;
use bytes::Buf; // for advance

const MAX: usize = 8192;

let mut buf = bytes::BytesMut::new();
loop {
    tokio::select! {
        num_written = io_resource.write(&buf), if !buf.is_empty() => {
            buf.advance(num_written?);
        },
        frame = next_frame(), if buf.len() < MAX => {
            encoder.encode(frame, &mut buf)?;
        },
        _ = no_more_frames() => {
            io_resource.write_all(&buf).await?;
            io_resource.shutdown().await?;
            return Ok(());
        },
    }
}
```

## `Encoder`

```rust

use tokio_util::codec::Encoder;
use bytes::BytesMut;

struct MyStringEncoder {}

const MAX: usize = 8 * 1024 * 1024;

impl Encoder<String> for MyStringEncoder {
    type Error = std::io::Error;

    fn encode(&mut self, item: String, dst: &mut BytesMut) -> Result<(), Self::Error> {
        // Don't send a string if it is longer than the other end will
        // accept.
        if item.len() > MAX {
            return Err(std::io::Error::new(
                std::io::ErrorKind::InvalidData,
                format!("Frame of length {} is too large.", item.len())
            ));
        }

        // Convert the length into a byte array.
        // The cast to u32 cannot overflow due to the length check above.
        let len_slice = u32::to_le_bytes(item.len() as u32);

        // Reserve space in the buffer.
        dst.reserve(4 + item.len());

        // Write the length and string to the buffer.
        dst.extend_from_slice(&len_slice);
        dst.extend_from_slice(item.as_bytes());
        Ok(())
    }
}
```
