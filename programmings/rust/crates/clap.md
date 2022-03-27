# clap

## Example

```rust
use clap::{Parser, Subcommand, Args};

#[derive(Parser, Debug)]
#[clap(version, propagate_version = true)]
pub struct CloudOpsApp {
    #[clap(subcommand)]
    command: Command,
}

#[derive(Subcommand, Debug)]
enum Command {
    /// S3 operations.
    S3(S3Command),
}

#[derive(Args, Debug)]
#[clap(arg_required_else_help = true)]
pub struct S3Command {
    #[clap(flatten)]
    pub aws: AwsOptions,

    #[clap(subcommand)]
    pub command: S3Subcommand,
}

#[derive(Subcommand, Debug)]
pub enum S3Subcommand {
    /// S3 buckets operations.
    #[clap(visible_alias = "bkt")]
    Bucket(bucket::BucketCommand),

    /// Put file onto s3 bucket.
    #[clap(next_help_heading = "PUT_OPTIONS")]
    Put {
        /// Src file path to put.
        #[clap(long, value_name = "FILE_PATH")]
        src: Utf8PathBuf,

        /// Dest bucket.
        #[clap(long)]
        bucket: String,

        /// Object key.
        #[clap(long, alias = "object-key")]
        key: String,
    },
}

impl CloudOpsApp {
    pub fn parse() -> Self {
        clap::Parser::parse()
    }
}
```

### `#[clap()] API`

* `visible_alias`: helpにaliasとして表示されるalias
* `flatten`: そこにべた書きしたかのように展開される
* `next_help_heading`: helpでgroupingされる
* `value_name`: helpで引数名のplace holderに利用される

## Features

* `env`: `#[clap(env = XXX)]`に必要
* `wrap_help`: terminalの長さを考慮してhelp表示してくれる。基本有効で良い?
