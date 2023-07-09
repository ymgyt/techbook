# clap

## Example

```rust
use clap::{Parser, Subcommand, Args};

#[derive(Parser, Debug)]
#[command(
    version, 
    propagate_version = true,
    disable_help_subcommand = true,
    about = "xxx",
)]
pub struct CloudOpsApp {
    #[command(subcommand)]
    command: Command,
}

#[derive(Subcommand, Debug)]
enum Command {
    /// S3 operations.
    S3(S3Command),
}

#[derive(Args, Debug)]
#[command(arg_required_else_help = true)]
pub struct S3Command {
    #[command(flatten)]
    pub aws: AwsOptions,

    #[command(subcommand)]
    pub command: S3Subcommand,
}

#[derive(Subcommand, Debug)]
pub enum S3Subcommand {
    /// S3 buckets operations.
    #[arg(visible_alias = "bkt")]
    Bucket(bucket::BucketCommand),

    /// Put file onto s3 bucket.
    #[arg(next_help_heading = "PUT_OPTIONS")]
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

#[derive(Args)]
pub struct TracingOptions {
    /// Enable color(ansi) logging.
    /// --ansi=false のように書ける
    #[arg(
        long,
        default_value_t = true,
        action = clap::ArgAction::Set,
        visible_alias = "color",
    )]
    pub ansi: bool,

    /// Show tracing callsite file and line number.
    #[arg(long, default_value_t = false)]
    pub source_code: bool,
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
* `action = clap::ArgAction::{Set, SetTrue}`
  * boolの使い方を制御できる。`SetTrue`にすると`--flag`だけで有効にできる

## Features

* `env`: `#[clap(env = XXX)]`に必要
* `wrap_help`: terminalの長さを考慮してhelp表示してくれる。基本有効で良い?
