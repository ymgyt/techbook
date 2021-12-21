# Sequence Diagram


## Participant

```text
participant Client
```

* 実体の定義


## 呼び出しの表現

```text

ComponentA -> ComponentB : Request
activate HeadlessChrome

HeadlessChrome -> InternalHttpServer : Request index.html
HeadlessChrome <- InternalHttpServer : Response index.html
HeadlessChrome -> HeadlessChrome     : Start React

HeadlessChrome -> InternalHttpServer : Request PDF Param
HeadlessChrome <- InternalHttpServer : Response PDF Param

HeadlessChrome -> HeadlessChrome     : Render PDF like dom
HeadlessChrome -> HeadlessChrome     : Convert to PDF

HttpServer    <- HeadlessChrome      : PDF bytes
deactivate HeadlessChrome


```

## Activate

```text
activate ComponentA
' ...
deactivate ComponentB
```

* Instanceの生存期間的なことを表現できる
