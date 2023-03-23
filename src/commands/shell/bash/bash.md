# Bash

## Background実行

```shell
./app &
[1] 1234

kill 1234
```

* `&`をつける
  * 実行したprocess idが出力される

## shebang

```sh
#!/usr/bin/env bash
```

とすると`PATH`から`bash`を探して実行してくれる。  
`bash`がinstallされるpathは環境依存だが、`env`はこのpathにある可能性が高いことを利用している