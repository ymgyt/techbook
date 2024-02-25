# cargo-dist

* bin crateをdistributionしてくれる
  * installerやbinaryをbuildしてGithub Releaseに登録してくれる

* `cargo dist init` CI(github action workflow)を生成してくれる

* `cargo dist plan --tag=foo-v0.1.2 --output-format=json`でCIでなにをするか出力してくれる

* workspaceのCargo.tomlの`[workspace.metadata.dist]`で全体の設定、個別のcrateは`[package.metadata.dist]`で行える

* 内部的にはいろいろmodel/mode(artifactとか)があるようだがわかっていない
