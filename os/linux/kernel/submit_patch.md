# Submit Patch

* `git commit -s`で `Signed-off-by`をつける

## Memo

```sh
scripts/get_maintainer.pl -f path/to/changed.rs

git format-patch -2 --cover-letter -o /tmp/patch

scripts/checkpatch.pl /tmp/patch

git send-email \
  --dry-run \
  --annotate \
  --thread \
  --no-chain-reply-to \
  --confirm=always \
  --to $to \
  --cc-cmd "scripts/get_maintainer.pl --norolestats --no-sub"
  /tmp/patch
```

## References

* [Submitting patches](https://docs.kernel.org/process/submitting-patches.html)
