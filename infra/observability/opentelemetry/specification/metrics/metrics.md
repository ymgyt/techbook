# Metrics

## API

### MeterProvider

* `Meter`へのaccessを提供する
* configurationを保持するstate fulなobjectという想定
* Globalな`MeterProvider`へのset/registerが必要

## SDK

### MetricReader

* Instrumentにdefault Viewを設定する
* MetricProducerを設定する
* SDKと登録されたMetricProducerからmetricsをcollectする
* ForceFlushとShutdownをhandlingする

## Data Model

### Temporality

[仕様](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/metrics/data-model.md#temporality)

報告された値と以前の値との関係を表す概念。  
OTLPのmetric data pointは２つのtimestampをもつ

* `TimeUnixNano`
  * 必須
  * 値が観測された時点
* `StartTimeUnixNano`
  * optional
  * 連続するdata pointが壊れていないかの情報


#### Cumulative temporality

`StartTimeUnixNano`はいつからcomulativeされているかを表す。  
`StartTimeUnixNano`から現在までの状態を保持しておく必要があるのでmemory costはあがる


#### Delta temporality

`StartTimeUnixNano`から、`TimeUnixNano`の値をexportしたら、それを忘れることができる。  
またそのたびに、`StartTimeUnixNano`は更新されていく。  
(Tn,Tm)を`StartTimeUnixNano`,`TimeUnixNano`のpairとすると、delta temporlityにおいて連続するdataは  
(T0,T0), (T0,T1), (T1, T2)のように、`StartTimeUnixNano`は前回のdataの`TimeUnixNano`を指す


### Instrument and Aggregation temporality

applicationははdeltaにしつつ、SDK側で状態を保持して、cumulative temporalityを実現するというようなことがしたい。  
これによって、applicationをstatelessにできる。


