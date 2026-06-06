# system

```nix
{
  config = {
    # 最初にDeployしたversion
    # 変更してはいけない, nixpkgsをupgradeしてもそのままでよい
    # migration処理の起点に利用されているらしい
    system.stateVersion = "23.11";
  };
}
```
