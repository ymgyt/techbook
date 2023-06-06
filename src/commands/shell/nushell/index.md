# Nushell

## Install

cloneしてきて、cargo build

## Alias


## Usage

```console

# CPU使用率が高いprocessを表示
ps | where cpu > 20 
```

### Environment variable

```
echo $nu.env
```

## Redirect

```sh
echo 'Hello' out> out.text
```

* `>out` で出力先を指定する
