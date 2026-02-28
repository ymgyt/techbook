# Bedrock

## Memo

```sh
aws bedrock list-inference-profiles \
  --region us-east-1 \
  --query "inferenceProfiles[?contains(modelId,'claude-3-7-sonnet')].id"
  
```

## Cache

* [Prompt Cache](https://aws.amazon.com/jp/blogs/machine-learning/effectively-use-prompt-caching-on-amazon-bedrock/)

## 事前準備

* 以前はModell access機能で事前にモデルごとに有効化する必要があったが廃止された
  * ただし、Anthropicだけは初回ユースケース提出が必要
  * model access有効化時にmarketplace subscribeが実行されていた

* model初回呼び出し時にmarketplace subscribeが実行される
  * Principalに`aws-marketplace:Subscribe` 権限が必要になる
    * `Subscribe`権限がない場合は初回に呼び出してもなにも起きない
  * Console から playground chatでも初回呼び出しとなり、console loginuerが権限をもっていれば、subscribe処理が走る


## Inference Profile

* model呼び出しをどのregion集合にroutingするかを表すリソース
* System-defined
  * Cross region用.
  * Bedrockが最初から用意
* Application inference profile

## Pricing

* Tokyo Region
  * Claude Sonnet 4: Input: $0.003 / 1k token | Output: $0.015 / 1k token
    * 2kで1円くらい
