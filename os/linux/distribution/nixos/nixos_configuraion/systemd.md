# systemd 


## Example

opentelemetry-collectorを動かす例。

```nix
systemd.services.opentelemetry-collector = {
  description = "Opentelemetry Collector Serivice";
  wantedBy = ["multi-user.target"];
  serviceConfig = let 
    conf = "${config.environment.etc."opentelemetry-collector/config.yaml".source.outPath}";
    ExecStart = "${pkgs.opentelemetry-collector-contrib}/bin/otelcontribcol --config=file:${conf}";
    in
  {
    inherit ExecStart;
    DynamicUser = true;
    Restart = "always";
    ProtectSystem = "full";
    DevicePolicy = "closed";
    NoNewPrivileges = true;
    WorkingDirectory = "/var/lib/opentelemetry-collector";
    StateDirectory = "opentelemetry-collector";
  };
};
```


### Timer

shell scriptを一定間隔で起動する例

```nix
{ pkgs, ...}:
{
  systemd.timers."cpu-temp-metrics" = {
    # これを書いておかないと定期実行されない
    wantedBy = [ "timers.target" ];
    timerConfig = {
      Unit = "cpu-temp-metrics.service";
      OnCalendar = "minutely";
      Persistent = "false";
      AccuracySec = "1m";
     };
  };

  systemd.services."cpu-temp-metrics" = {
    # scriptの中で依存しているtool
    path = [ pkgs.gawk ];
    script = builtins.readFile ./script.sh;
    serviceConfig = {
      Type = "oneshot";
      DynamicUser = "true";
      Nice = "19";
    };
  };
}
```

* 1分おきにscriptが実行される