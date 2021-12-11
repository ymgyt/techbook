# Crate

* crateはbinaryかlibraryに分類される

## Package

* Cargo.tomlをもつ
* crates.ioへのpublishの単位
* packageはone or zeroのlibraryを含む
* packageは任意の数のbinaryを含む
* Cargo.tomlへのdependencyにpackageを追加したとき、packageの中のlibrary crateをconsumeしている
* `src/main.rs`はpackageと同名のbinary crateを表す慣習がある(cargo)
* `src/lib.rs`はpackageと同名のlib crateを表す慣習がある(cargo)
