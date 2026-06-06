# structopt

## field

```rust
use structopt::StructOpt;

// 矛盾する指定も説明のためにいれている
pub struct Opt {
    #[structopt(
        short = "v",
        long = "verbose",
        global = true,
        help = "logging verbose. (v=DEBUG, vv=TRACE)",
        parse(from_occurrences),
        env = "MYENV_LOGGING",
        hide_env_values = false,
        alias = "logv",
        conflicts_with = "log-level",
        default_value = 0,
        possible_values = &["aaa","bbb","ccc"],
        required = true,
        min_values = 2,
    )]
    pub verbose: u8,
}
```

## top level

```rust
use structopt::{
    clap::{self, AppSettings},
    StructOpt,
};

#[derive(StructOpt)]
#[structopt(
    name = "app",
    about = "dev ops bot",
    version(env!("CARGO_PKG_VERSION")),
    setting(AppSettings::ArgRequiredElseHelp),
   global_settings(&[
       clap::AppSettings::ColoredHelp,
       clap::AppSettings::ColorAuto,
       clap::AppSettings::VersionlessSubcommands,
       clap::AppSettings::DisableHelpSubcommand,
       clap::AppSettings::DeriveDisplayOrder,
   ])
)]
pub struct Opt {
    // fields...
    
    #[structopt(subcommand)]
    pub command: SubCommand,
}

#[derive(StructOpt)]
pub enum SubCommand {
    CommandA(xxx::CommandAOpt),
    #[structopt(alias = "xx")]
    CommandB(yyy::CommandBOpt),
}

pub fn opt() -> Opt {
    Opt::from_args()
}
```

## enum

マクロを使うと、`variants()`をenumに生成してくれるので、選択肢を限定したい場合に便利。

```rust
use structopt::clap::arg_enum;

arg_enum! {
    #[derive(Debug,Serialize,Deserialize,Clone,Copy)]
    pub enum SentimentFeatureReaction {
        Context,
        Emoji,
    }
}

impl Default for SentimentFeatureReaction {
    fn default() -> Self {
        SentimentFeatureReaction::Emoji
    }
}
```

```rust
use structopt::StructOpt;

#[derive(StructOpt, Debug)]
pub struct EnableOpt {
    #[structopt(
    long,
    help = "specify how bot reaction",
    possible_values = &spec::SentimentFeatureReaction::variants(),
    default_value = spec::SentimentFeatureReaction::default().as_str(),
    case_insensitive = true,
    )]
    pub reaction: spec::SentimentFeatureReaction,
}
```
