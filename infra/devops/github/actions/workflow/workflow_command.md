# workflow command

* actionsのログ出力でrunner に指示を送れる仕様

```sh
echo "::workflow-command parameter1={data},parameter2={data}::{command value}"
```

## log level

```sh
# debug
echo "::debug::Debug Message"

# notice
echo "::notice file={name},line={line},title={title}::{message}"
```

* message level
  * `debug`, `notice`, `warning`, `error`


## log group

```sh
echo "::group::My title"
echo "Inside group"
echo "::endgroup::"
```

* Clickで拡張できるようになる


## add mask

```sh
echo "::add-mask::SecretValue"
```
