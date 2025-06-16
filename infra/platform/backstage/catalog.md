# Catalog

> The Backstage Software Catalog is a centralized system that keeps track of ownership and metadata for all the software in your ecosystem (services, websites, libraries, data pipelines, etc).

## Catalogの追加

* metadata yamlのURLを手動で追加する

* static file
```yaml
catalog:
  locations:
    - type: url
      target: https://github.com/backstage/backstage/blob/master/packages/catalog-model/examples/components/artist-lookup-component.yaml
```


## Static file

```yaml
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: artist-web
  description: The place to be, for great artists
spec:
  type: website
  lifecycle: production
  owner: artist-relations-team
  system: artist-engagement-portal
  dependsOn:
    - resource:default/artists-db
  dependencyOf:
    - component:default/artist-web-lookup
  providesApis:
    - artist-api
```
