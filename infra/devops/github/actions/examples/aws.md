# AWS Actions

```yaml
jobs:
  steps:
    - name: configure aws credentials
      id: credentials
      uses: aws-actions/configure-aws-credentials@main
      with:
        role-to-assume: arn:aws:iam::<account>:role/MyRole
        aws-region: ap-northeast-1
        # default 1h(3600)
        role-duration-seconds: 3600
        # 後続で使う場合
        output-credentials: true

    - run: aws sts get-caller-identity

    - name: use aws credentials
      run: "true"
      env:
        AWS_ACCESS_KEY_ID: ${{ steps.credentials.outputs.aws-access-key-id }}
        AWS_SECRET_ACCESS_KEY: ${{ steps.credentials.outputs.aws-secret-access-key }}
        AWS_SESSION_TOKEN: ${{ steps.credentials.outputs.aws-session-token }}
```
