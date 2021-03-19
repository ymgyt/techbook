# Fluentd

## Install

### Mac

https://td-agent-package-browser.herokuapp.com/3/macosx  
制御はlaunchctlで行う。plistは`/Library/LaunchDaemons/td-agent.plist`


## Config

### 全体のlogging level
```
<system>
  @log_level trace
</system>
```

### ファイルの監視(tail)

#### multiline parse

複数行のloggingをひとつのentryにする例
```
<source>
  @type tail
  @log_level trace
  path /path/to/log.log
  pos_file  /path/to/log.log.pos
  tag my.tag

  <parse>
    @type multiline
    format_firstline /^@P/
    format1 /^@P,[^,]*,[^,]*,[^,]*,(?<serialid>[^,]+),(?<data>.*)/
  </parse>
</source>
```
### ファイルへの出力

```
<match my.tag>
  @type file
  @id multiline_out
  @log_level trace
  path /Users/ymgyt/ws/fluentd_out
 <buffer>
    @type memory

    chunk_limit_size 5m
    chunk_limit_records 500
    compress text

    flush_at_shutdown true
    flush_mode interval
    flush_interval 1
    flush_thread_interval 1.0
    overflow_action throw_exception

    retry_type exponential_backoff
    retry_exponential_backoff_base 2
    retry_timeout 72h
    retry_forever false
    retry_randomize true
  </buffer>
</match>
```

### stdout
```
<match my.tag>
  @type stdout
  @id my_output_stdout
</match>
```

