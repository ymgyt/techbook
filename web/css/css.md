# CSS

## Inheritance

* propertyによっては親の値が子に継承される
  * color, font, line-height, text-*等のtypography relatedがinherited

* children: 直下の子
* descendant: 子のsubtree

[List of css properties that are inherited](https://www.sitepoint.com/css-inheritance-introduction/#list-css-properties-inherit)

### Forcing inheritance

```css
a { 
  color: inherit;
}
```

color propertyはinheritだが、anchorにはbrowserのdefault styleが適用されるのでinheritされた値を上書きしてしまう。  
そこで`inherit`を明示的に指定すると親のcolorを使える

## Cascade

ある要素のpropertyに異なる値が指定されているとき、どの指定が採用されるかを決める仕組み。  

### 詳細度

* (0,0,0,0)で計算される
  * 左の値が高いほど高い
* selectorの種別によって設定される詳細度の位置が決まっている
* `!import`を付与すると詳細度が最も高くなる


## Memo

* Browser(user-agent)もCSSを適用する。
  * cascadeの関係で優先度が低い

## Media query

```css
@media (max-width: 300px) {
  .small {
    color: red;
  }
}
```

* `max-width: n`は`[0, n]`を指定できる
* `@media (condition)`のconditionに書けるのはmedia feature
  * max-widthはたまたまcss propertyと同じだっただけ


## Box Model

* `box-sizing: content-box`の場合
  * `width: 100%`の指定はcontentにのみ適用されるので、そこにpaddingとboarderが加算される。(親をはみ出す)
* `box-sizing: border-box`にすると`width: 100%`の指定がcontent + padding + boarderに対して適用される

```css
*,
*::before,
*::after {
	box-sizing: border-box;
}
```

* `*::before`のようなpseudo-elementは`*`指定できないので必要

### Logical properties

* `margin-block-start` (`margin-top`)
* `margin-block-end` (`margin-bottom`)
* `margin-inline-start` (`margin-left`)
* `margin-inline-end` (`margin-right`)

margin,paddingも同様。  blockは上から下、inlineは左から右は特定のwrite modelを前提にしている

