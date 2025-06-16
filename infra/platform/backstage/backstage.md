# Backstage

## Configurations

* `app-config.yaml`
  * `app-config.local.yaml`があるとoverride
  * `--config <path>`でも渡せる
    * `--config`を渡すと`app-config.yaml`はデフォルトではloadされないので明示的に複数渡す
    * `--config a.yaml --config b.yaml`
* appとbackendで共有される

### Environment substitution

```yaml
app:
  baseUrl: https://${HOST:-localhost:3000}
```
* `HOST`がなければdefault値が使われる

## References

* [Deploy to k8s](https://breaking.computer/blog/deploying-a-backstage-app-on-kubernetes#:~:text=By%20default%2C%20Backstage%27s%20frontend%20and,UI%20directly%20from%20the%20backend)
* [AWSへのDeploy](https://stratusgrid.com/blog/aws-backstage-production#:~:text=Backstage%20consists%20primarily%20of%20two,is%20stored%20in%20Aurora%20PostgreSQL)


## Memo

```sh
# init
npx @backstage/create-app@latest

```
