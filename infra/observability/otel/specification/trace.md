# Trace specification

traceに関する仕様について。


## Api

### Tracer

`Span`の作成が責務。  
ConfigurationはTracerの責務ではなく、`TracerProvider`の責務。  


### Span

trace内でのsingle operationを表す。  
Tree上にchild spanを持てる。treeなので、root spanがある。  
root spanとtraceは1:1対応する。


#### Spanの作成

`Tracer`以外が`Span`作成のAPIをもってはいけない(MUST NOT)

