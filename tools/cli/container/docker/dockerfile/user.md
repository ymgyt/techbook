# USER

* 以降のstageで実行するuserを指定する
* RUN, ENTRYPOINT, CMDに影響する

```dockerfile
USER <user>[:<group>]

USER UID[:GID]
```


```dockerfile
RUN adduser yuta
RUN "whoami # => root
USER yuta
RUN whoami # => yuta
```

## Reference

* [Understanding the Docker USER Instruction](https://www.docker.com/blog/understanding-the-docker-user-instruction/)
