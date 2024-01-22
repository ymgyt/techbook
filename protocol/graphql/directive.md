# Directive

```graphql
query MyQuery($shouldInclude: Boolean) {
  myField @include(if: $shouldInclude)
}
```
