# Opentelemetry

仕様: https://github.com/open-telemetry/opentelemetry-specification/tree/main/specification

## Resource

telemetryが記録されたentityに関する情報を保持する。  
例えば、Kubernetes containerでcaptureされたmetricsはnamespaceやpod,node,container name等を保持する

https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/overview.md#resources

## Attribute

ResourceやSpan, Span events等が保持するkey,valueの集合。  
もろもろ共通の仕様が決まっている。(nullのkeyは禁止等)  
https://github.com/open-telemetry/opentelemetry-specification/tree/main/specification/common

### Semantic conventions

* いわゆる環境(staging, production,...)は`deployment.environment`で表現する
  * https://opentelemetry.io/docs/reference/specification/resource/semantic_conventions/deployment_environment/
* requestの主体であるuserは`endouser.{id,role}`で表現する
  * AWS X-Rayで特別扱いされたりする(x-ray側のuserにmappingされる)

## Metrics等の名前の付け方

[Resource Semantic Conventions](https://opentelemetry.io/docs/reference/specification/resource/semantic_conventions/)で定義されているので準拠する。


## Sampling

問題意識としては、trace等のtelemetry dataを減らしたいという課題にどう向き合うかということ  

アプローチの方向性としては2種類ある

* application level
* collector level

### Traces

traceにおけるsamplingとは、spanをprocessするかdropするかという話。  
決定の責務は`Sampler`がもつ。  
`Saimpler`は`TracerProvider`に渡す。  

#### Context propagateとの関係

Traceをsamplingするという決断がなされるとそれはPropagatorで他のserviceでもrespectされる


### Sampling strategy

* Head sampling
* Tail sampling

#### Head sampling

最初のspan(root span)を作成する際に、traceをsamplingするか否かを決定する。  
samplingする決定がなされた場合、後続のserviceにsamplerがいてもrespectしてくれる認識(要調査)  

* Pro
  * もっともresourceの観点から効率的
* Con
  * 全体の情報を取得する前に決定を下す必要がある。A -> Bとなった場合にBでerrorが発生してもdropされる場合がある


#### Tail sampling

* Pro
  * Always sampling traces that contain an error
  * Sampling traces based on overall latency
  * Sampling traces based on the presence or value of specific attributes on one or more spans in a trace; for example, sampling more traces originating from a newly deployed service
  * Applying different sampling rates to traces based on certain criteria