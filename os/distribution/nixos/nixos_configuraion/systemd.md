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