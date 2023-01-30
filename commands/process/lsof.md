# lsof

list open fileの略。

## Usage

```shell
# pidを指定
lsof -p 1234

# TCP 443をlistenしているprocess
# lsof -i[protocol][@host][:port]
lsof -iTCP:443

# TCPをlistenしている
lsof -iTCP -sTCP:LISTEN
```