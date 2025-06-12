# Bedrock

## Memo

```sh
aws bedrock list-inference-profiles \
  --region us-east-1 \
  --query "inferenceProfiles[?contains(modelId,'claude-3-7-sonnet')].id"
  
```

## Cache

* [Prompt Cache](https://aws.amazon.com/jp/blogs/machine-learning/effectively-use-prompt-caching-on-amazon-bedrock/)

## Pricing

* Tokyo Region
  * Claude Sonnet 4: Input: $0.003 / 1k token | Output: $0.015 / 1k token
    * 2kで1円くらい
