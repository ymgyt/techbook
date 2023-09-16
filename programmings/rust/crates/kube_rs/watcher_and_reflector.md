# Watcher And Reflector

* defaultの`watcher::Config`はApiのscopeのobjectを全てwatchする
  * `Api::namespaced`ならそのnamespace
  * `Api::all`ならclusterの全てのobject
* watcherは`Api::watch`と`Api::list`をcombineした`Stream`を提供する


特定のnamespaceを処理の対象外とするには

```rust
  let ignoring_system_namespaces = [
    "cert-manager",
    "flux2",
    "linkerd",
    "linkerd-jaeger",
    "linkerd-smi",
    "linkerd-viz",
    "gatekeeper-system",
    "kube-node-lease",
    "kube-public",
    "kube-system",
]
.into_iter()
.map(|ns| format!("metadata.namespace!={ns}"))
.collect::<Vec<_>>()
.join(",");
let cfg = watcher::Config::default().fields(&ignoring_system_namespaces);
```

labelも利用できる

```rust
let cfg = Config::default().labels("environment in (production, qa)");
```