# CSS

## Inheritance

propertyによっては親の値が子に継承される

* children: 直下の子
* descendant: 子のsubtree

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