# PID 1

* container起動プロセス(ENTRYPOINT, CMDで実行するコマンド)はPID 1として実行される
* PID 1 は以下の責務を担う
  * Signalを受け取る(TERM,INT,QUIT)

* bashを経由してコマンドを実行した場合
  * bashはsignalを子プロセスに伝播しない
  * bashからコマンド実行時に `exec command`を実行し、実行プロセスをPID 1にしておく

* [`tiny`](https://github.com/krallin/tini)
  * signalをforwardして、zombie process を回収してくれる

```dockerfile
# Add Tini
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

# Run your program under Tini
CMD ["/your/program", "-and", "-its", "arguments"]
# or docker run your-image /your/program ...
```

## Reference

* [Git Labの対応](https://gitlab.com/gitlab-org/charts/gitlab/-/issues/3249)
  * execしていなかった
