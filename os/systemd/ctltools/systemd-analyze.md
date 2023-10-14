# systemd-analyze

## Usage

```sh
# 設定のsecurity的な評価
systemd-analyze security opentelemetry-collector

# graphvizで可視化
 systemd-analyze dot multi-user.target | dot -Tsvg out> /tmp/target.svg

## Unitの探索directory
systemd-analyze unit-paths
```
