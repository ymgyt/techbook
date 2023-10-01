# etc

`/etc`の設定

```nix
{
  environment.etc = {
    "opentelemetry-collector/config.yaml" = {
      mode = "0644";
      text = ''
      # configuration...
  '';
    };
  };
}
```

* `/etc/opentelemetry-collector/config.yaml`が生成される

参照するには

```nix
{config, ...}: {
  systemd.services.opentelemetry-collector = {
    serviceConfig = let 
      conf = "${config.environment.etc."opentelemetry-collector/config.yaml".source.outPath}";
      in
    {
      #...
    }
}
```

* `${config.environment.etc."xxx".source.outPath}`を参照する
