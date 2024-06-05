# step

## `GITHUB_ENV`で環境変数を後続のstepに渡す

```yaml
- run: |
  if [ -n "${{ inputs.tag }}" ]; then
    echo "tag=${{ inputs.tag }}" >> $GITHUB_ENV
  else
    echo "tag=${{ github.ref_name }}" >> $GITHUB_ENV
  fi
- run: nix develop .#ci --accept-flake-config --command nu scripts/docker/build_and_push.nu ${{ env.tag }}
```

* `echo "foo" >> $GITHUB_ENV`をするとstepを超えて永続化する
  * 同一stepでは見えないらしい
