# ps

```nu
ps | where name =~ "synd_api$" | first | kill $in.pid
```
