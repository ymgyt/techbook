# Here Document

* 複数行の文字列をcommandのstdinに渡す方法

```shell
DYNAMODB_CREATE_TABLE_PARAM=$(cat <<EOF
{
    "AttributeDefinitions": [
        {
            "AttributeName": "id",
            "AttributeType": "S"
        },
        {
            "AttributeName": "created_at",
            "AttributeType": "S"
        }
    ]
}
EOF
)

function main() {

  aws dynamodb create-table  --cli-input-json "${DYNAMODB_CREATE_TABLE_PARAM}"
```

## Indent

* `<<-EOF` source code上はindentしたいが出力にはindentを反映させたくない場合
  * indentはTABである必要があるので注意

```she
cat <<-EOF
    aaa
    bbb
EOF
```

```sh
# 出力にはindentが反映されない
aaa
bbb
```

## 変数展開

here documentの中で変数を展開するかどうか制御できる

* `cat <<EOF`   : 変数を展開する
* `cat <<"EOF"` : 変数を展開しない

```sh
VAR=hello

cat <<EOF
$VAR
EOF

# => hello

cat <<"EOF"
$VAR
EOF

# => $VAR
```
