# environment

* jobから参照できる
* environment に設定されているruleが満たされてから、environmentを参照するjobはrunnerに送られる
  * environmentにreviewerが指定された場合、approveされてからでないとjobは実行されない
* environmentごとにsecretやvariableを保持できるので、同じdeploy jobに対して、environmentの切り替えだけで、production, staging deployを実現できる

```yaml
jobs:
  deploy:
    environment: production
    steps:
      - name: deploy
```

## Reference

* [reusable workflowへの環境の渡し方](https://colinsalmcorner.com/consuming-environment-secrets-in-reusable-workflows/)
