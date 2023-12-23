# Logs

## LogRecord

* traceのeventとどういう関連があるのか..?

* `Timestamp` uint64 nanoseconds since unix epoch
  * eventが発生した時間をsourceで記録したもの

* `ObservedTimestamp` collection systemにevnetがobserveされた時間

* Trace Context
  * `TraceId` logを発生させたtraceのid. optional
  * `SpanId` logを発生さえたspanのid. optional

* Severity
  * `Severitytext` loglevel. setされない場合は、SeverityNumberに対応するものが使われる optional
  * `SeverityNumber` 高い数字がより緊急(error, critical), 低い数字はdebug

* `Body` logの中身
  * any型。anyの候補は決まっている
  * https://opentelemetry.io/docs/specs/otel/logs/data-model/#type-any

* `Resource` logを発生させたentityの情報

* `InstrumentationScope` logger nameをいれるのが推奨?

* `Attributes` resourceと違い、log毎に変わる追加の情報

### Severity

| SeverityNumber range | Range name | Meaning |
| --- | --- | --- |
|  1-4  | TRACE | debugging event |
|  5-8  | DEBUG | debugging event |
|  9-12 | INFO  | information     |
| 13-16 | WARN  | warning         |
| 17-20 | ERROR | error           |
| 21-24 | FATAL | fatal           |