# clap

## featurues

```toml
clap = { features = [
    "derive",        # derive生やすのに必要
    "color",         # errorに色つける 
    "help",          # helpのoutputを生成 
    "usage",         # usageの生成
    "error-context", # よくわからず
    "suggestions",   # Did you meanをだす
    "deprecated",    # clapのdeprecatedをだしてくれる?
    "cargo",         # cargo関連の環境変数を読む
    "env",           # 環境変数をparse時に読む
    "unicode",       # emoji等のunicodeをsupport
    "wrap_help",     # helpのtext wrapping処理
    "string",        # default_valueで動的なStringを使えるようになる
    ]
}
```

* `std`は使われていないらしい

## Usage

```rust
use clap::{Parser, Subcommand, Args};

#[derive(Parser, Debug)]
#[command(
    version, 
    propagate_version = true,
    disable_help_subcommand = true,
    help_expected = true,     // argにhelpを必須にする(deny(missing_docs))のruntime版
    infer_subcommands = true, // "f"に対して"foo"を推測する
    bin_name = "foo",         // clapが認識するbin name
    about = "xxx",
)]
pub struct CloudOpsApp {
    #[command(subcommand)]
    command: Command,

    /// GlobalはOption<T>である必要がある
    /// ただし、default値を指定することもできる
    #[arg(long, global = true, default_value_t = "foo".into())]
    global_a: String,
}

#[derive(Subcommand, Debug)]
enum Command {
    /// S3 operations.
    #[command(alias = "s3-alias")]
    S3(S3Command),
}

#[derive(Args, Debug)]
#[command(arg_required_else_help = true)]
pub struct S3Command {
    #[clap(flatten, next_help_heading = "AWS Options")]
    pub aws: AwsOptions,

    #[clap(subcommand)]
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

    /// Parserを指定することもできる
    #[arg(value_parser = parse_region, long)]
    pub region: aws::Region

    /// 30sec, 2hようなformatでDurationを指定
    #[clap(long, value_parser = parse_duration::parse)]
    pub duration: std::time::Duration,

    /// RFC3339形式のflag
    #[arg(long, value_parser = chrono::DateTime::<chrono::FixedOffset>::parse_from_rfc3339,value_name = "TIMESTAMP")]
    start: DateTime<FixedOffset>,
}

fn parse_region(region: &str) -> Result<Region, Infallible> {
    Ok(Region::new(region.to_owned()))
}

impl CloudOpsApp {
    pub fn parse() -> Self {
        clap::Parser::parse()
    }
}
```

### `#[command()]` API
* `flatten`: そこにべた書きしたかのように展開される
* `next_help_heading`: helpでgroupingされる

### `#[arg()]` API

* `visible_alias`: helpにaliasとして表示されるalias
* `value_name`: helpで引数名のplace holderに利用される
* `action = clap::ArgAction::{Set, SetTrue}`
  * boolの使い方を制御できる。`SetTrue`にすると`--flag`だけで有効にできる

## Enum

```rust
#[derive(Copy, Clone, PartialEq, Eq, Debug, clap::ValueEnum)]
enum Format {
    Csv,
    Text,
    Debug,
}

#[derive(clap::Args, Debug)]
pub struct QueryCommand {
    /// Output format
    #[arg(value_enum, long, default_value_t = Format::Debug)]
    format: Format,
}
```

1. `enum`に`clap::ValueEnum`をderiveする
1. structのfieldに`[clap(value_enum)]を付与する

## ArgGroup

複数のうちどれか一つという制約を表現できる

```rust
/// Export gauge data
#[derive(Args, Debug)]
struct ExportGaugeCommand {
    #[command(flatten)]
    value: NumberDataPointValue,
}

#[derive(Args, Debug)]
#[group(required = true)]
struct NumberDataPointValue {
    /// Metrics data point f64 value
    #[arg(long, value_name = "f64")]
    value_as_double: Option<f64>,
    // #[arg(long)]
    /// Metrics data point i64 value
    #[arg(long, value_name = "i64")]
    value_as_int: Option<i64>,
}
```

* `--value-as-double`か`--value-as-int`どちらかが必須になる
* どちらがuserに入力されたかは自分で判断する必要がありそう
  * なのでOptionにしておくのがよい?
* conflictで他のargやargGroupと一緒に使えないという制約も表現できる
