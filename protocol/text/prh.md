# prh

## Example

```yaml
version: 1

rules:
  # defaultだと
  # pattern: [Gg][Ii]...のようにcase insensitiveでマッチしてくれる
  - expected: Git # patternは複数記述可能 patterns としてもOK

  # patternは複数書ける
  - expected: ハードウェア
    patterns:
      - ハードウエアー # 正規表現に変換する都合上、より長いものを先に書いたほうがよい
      - ハードウェアー
      - ハードウエアHub


  # specsでunit testを書ける
  - expected: 又は
    pattern: または
    specs:
      - from: または
        to: 又は

  # regexMustEmptyで適用範囲を限定できる
  - expected: また
    pattern: /又(は)?/
    regexMustEmpty: $1
    specs:
      - from: 又、その後に
        to: また、その後に

  # なんかregexMustEmptyが効かなかったケース
  # (?!)は否定先読みで、"は"がない場合のみマッチ
  - expected: また
    pattern: /又(?!は)/
    specs:
      - from: 又、その後に
        to: また、その後に
      - from: A又はB
        to: A又はB


  # expectedで参照できる
  - expected: １$1
    pattern: /一(次|回)/
    specs:
      - from: 一覧
        to: 一覧
      - from: 一次
        to: １次
```
