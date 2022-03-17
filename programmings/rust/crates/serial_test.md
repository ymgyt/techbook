# serial_test

* testのserial実行を実現してくれる
  * dockerに建てたdatastore(db,dynamo,...)を利用したintegration test時に便利


## Usage

```rust
#[test]
#[serial]
fn test_serial_one() {
  // Do things
}

#[test]
#[serial]
fn test_serial_another() {
  // Do things
}
```

こう書くと, 各test caseがserial実行される。

```rust
#[tokio::test]
#[serial]
async fn test_serial_another() {
  // Do things
}

```

`#[tokio::test]`も利用できる。`#[serial]`より上に書く必要があるらしい。

### Integration横断でのserial実行

```rust
#[test]
#[file_serial]
fn test_serial_three() {
  // Do things
}
```

`test/a.rs`と`test/b.rs`は別のbinaryになってparallelで実行される。  
process間でserial実行したい場合は`#[file_serial]`を利用できる。

```rust
#[test]
#[file_serial(scope_x)]
fn test_serial_three() {
  // Do things
}
```

`#[file_serial(scope)`でserialの粒度を指定できる
