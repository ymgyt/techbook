# kube-rs CustomResourceDefinition

## Example

```rust
use serde::{Deserialize, Serialize};
use kube::CustomResource;
use schemars::JsonSchema;
use garde::Validate;

/// See docs for possible properties
/// https://docs.rs/kube/latest/kube/derive.CustomResource.html#optional-kube-attributes
#[derive(CustomResource, Debug, PartialEq, Clone, Serialize, Deserialize, JsonSchema,Validate)]
#[kube(
    // Required properties
    group = "fraim.co.jp",
    version = "v1alpha",
    kind = "Hello",
    // Optional properties
    singular = "hello",
    plural = "helloes",
    shortname = "hlo",
    namespaced,
)]
pub struct HelloSpec {
    #[garde(range(max=100))]
    pub replicas: u32,
}
```

Generated code

```rust
#[serde(rename_all = "camelCase")]
#[serde(crate = ":: serde")]
pub struct Hello {
    #[schemars(skip)]
    pub metadata: ::k8s_openapi::apimachinery::pkg::apis::meta::v1::ObjectMeta,
    pub spec: HelloSpec,
}

impl Hello {
    /// Spec based constructor for derived custom resource
    pub fn new(name: &str, spec: HelloSpec) -> Self {
        Self {
            metadata: ::k8s_openapi::apimachinery::pkg::apis::meta::v1::ObjectMeta {
                name: Some(name.to_string()),
                ..Default::default()
            },
            spec: spec,
        }
    }
}

impl ::kube::core::Resource for Hello {
    type DynamicType = ();
    type Scope = ::kube::core::NamespaceResourceScope;
    // ...
}
impl ::kube::core::crd::v1::CustomResourceExt for Hello {}
```

* `CustomResource` deriveが生成してくれるもの
  * `Hello` struct
    * `Hello::new(name: &str, spec: HelloSpec) -> Self`
    * `impl kube::core::Resource`
    * `impl kube::core::crd::v1::CustomResouceExt`

* gardeのderiveで生える`Validate()`はkube-rs側で呼んでくれるわけではない?

## Validation

2種類の方法がある。  
* 生成されるCRDのSchemaにvalidationを埋め込む(Server side)
* deriveした`Spec`に`Validate()` methodを生やす(Client side)

### Server side

さらにSchemasがみているvalidate attributeを使うか、
custom schemaで、x-kubernetesを自分で書くかにわかれる


### Client side

なにかkube-rs側がgardeと連携しているわけでない(要確認)  
codeに`Validate()`を呼び出す処理を書かないと誰もvalidateしてくれない。
