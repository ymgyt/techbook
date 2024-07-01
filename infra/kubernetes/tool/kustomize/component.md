# kustomize component

## モチベーション

* overlaydごとに選択的に利用したいcomponent(kustomize directory)がある

## 概要

以下のようなdirectory構成

```text
├── base
│   ├── deployment.yaml
│   └── kustomization.yaml
├── components
│   ├── external_db
│   │   ├── configmap.yaml
│   │   ├── dbpass.txt
│   │   ├── deployment.yaml
│   │   └── kustomization.yaml
│   ├── ldap
│   │   ├── configmap.yaml
│   │   ├── deployment.yaml
│   │   ├── kustomization.yaml
│   │   └── ldappass.txt
│   └── recaptcha
│       ├── deployment.yaml
│       ├── kustomization.yaml
│       ├── secret_key.txt
│       └── site_key.txt
└── overlays
    ├── community
    │   └── kustomization.yaml
    ├── dev
    │   └── kustomization.yaml
    └── enterprise
        └── kustomization.yaml
```

* `kustomize build overlays/dev`

## manifest

`components/foo/kustomization.yaml`

```yaml
# alphaかも?
apiVersion: kustomize.config.k8s.io/v1alpha1
kind: Component
resources:
  - resource.yaml
```

`overlays/aaa/kustomization.yaml`

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
components:
  - ../../components/foo
```

## Troubleshoot

### Namespace confict

https://github.com/kubernetes-sigs/kustomize/issues/3142#issuecomment-717601008

## 参考

* [公式doc](https://kubectl.docs.kubernetes.io/guides/config_management/components/)
* [KEP](https://github.com/kubernetes/enhancements/tree/master/keps/sig-cli/1802-kustomize-components)


