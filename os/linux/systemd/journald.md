# journald

* log fileをbinaryで保持している
* log fileは`/var/log/journal`配下にある 

## Configuration

`/etc/systemd/journald.conf`

```text
[Journal]
# logを永続化するかどうか
# volatileだと永続化されない
Storage=persistent
RateLimitInterval=30s
RateLimitBurst=10000
```