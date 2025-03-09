# Service

* twingateにおける、プログラムをUserとして表現する方法
* ServiceKeyでtwingateに認証する
  * expireの期限をもつ
* アクセスできるResourceはServiceごとに割り当てる


## Headless Mode

* GUI環境以外で、twingate clientを動かす方法
* `twingate setup --headless path/to/key`
* [Github actions](https://github.com/Twingate/github-action/blob/main/action.yml)

### ECS Task defintion

以下のようにcontainer に capabilities と device を渡す必要がある
```jsonnet
{
  containerDefinitions: [
    {
      name: "example",
      linuxParameters: {
        capabilities: {
          "add": ["NET_ADMIN"],
        },
        devices: [
          {
            hostPath: "/dev/net/tun",
            containerPath: "/dev/net/tun",
            permissions: ["read", "write"]
          }
        ]
      }
    }
  ],
}
```
