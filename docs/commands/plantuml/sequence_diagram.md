# Sequence Diagram


## Participant

```text
participant Client
```

* 実体の定義


## 呼び出しの表現

```text

ComponentA -> ComponentB : Request
ComponentA <- ComponentB : Response
```

## Activate

```text
activate ComponentA
' ...
deactivate ComponentB
```

* Instanceの生存期間的なことを表現できる
