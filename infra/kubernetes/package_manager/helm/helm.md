# Helm

* Kubernetesのためのpackage manager
  * yaml filesのためのregistryを管理している

## Helm Chart 

### Structure

```text
# name of chart
mychart/
  # meta info about chart
  Chart.yaml
  # values for the template files
  values.yaml
  # chart dependencies
  charts/
  # the actual tempalte file
  templates
```

## Usage

```shell
helm install <chartname>

# inject values into template
helm install --values=my-values.yaml <chartname>

```
