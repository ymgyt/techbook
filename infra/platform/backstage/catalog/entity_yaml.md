# Catalog Entity yaml

```yaml
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: artist-web
  namespace: foo
  description: The place to be, for great artists
  labels:
    example.com/custom: custom_label_value
  annotations:
    example.com/service-discovery: artistweb
    circleci.com/project-slug: github/example-org/artist-website
  tags:
    - java
  links:
    - url: https://admin.example-org.com
      title: Admin Dashboard
      icon: dashboard
      type: admin-dashboard
spec:
  type: website
  lifecycle: production
  owner: artist-relations-team
  system: public-websites
```

* `apiVersion`
  * 現状、`backstage.io/v1alpha1`

* `metadata`
  * `name`(required)
    * namepsace * kind内でunique
    * Strings of length at least 1, and at most 63
    * Must consist of sequences of [a-z0-9A-Z] possibly separated by one of [-_.]

  * `namespace`(optional)


## Annotations

* [Well-known annotations](https://backstage.io/docs/features/software-catalog/well-known-annotations/#githubcomproject-slug)

* `github.com/project-slug`
  * `github.com/project-slug: ymgyt/foo`
  * github repositoryの参照

## Substitutions

* `$text`, `$json`, `$yaml` で参照先ファイルの中身に置換できる
* URL or relative path


```yaml
spec:
  definition:
    $yaml: path/to/openapi.yaml
```
