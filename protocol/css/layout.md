# Layout

* `display: block | inline | inline-block`

## Rule

* Blockのwidthは`width`等で指定されていない親一杯まで広がる
  * `width: auto`がdefault
	* `width: 100%`は親elementのcontent spaceを基準にする
  * 含んでいるcontent(text)の量がすくなくても関係ない
	* `width: fit-content`すると縮む
* Blockは一つ前のBlockの横にどれだけspaceがあってもstackしていく

* Blockのwidthはchildlenのheightで決まる
* 幅は親を参照し、高さは子を参照する
* html,body,root-divそれぞれに`height:100%`を指定していけば画面の高さを`%`で指定できる



## Inline block

inline context(`<p>`の中)のspanで`display: inline-block`を指定して、widthやmargin等のblock用のpropertyを指定するのがusecase.   
親(`<p>`)からみるとinline要素?  
欠点はinlineだとline-wrapしてくれるがinline-blockだとline-wrapされなくなる

## Overflow

* `overflow: visible`がdefault
  * `overflow: scroll`
  * macは挙動がwindows,linuxと違う
  * 実態は`overflow-x`と`overflow-y`のshorthand
  * `overflow: auto`は必要ならscroll barだしてくれる
  * `overflow: hidden`にして(...)にするみたいなパターンもある

* `overflow`を設定すると値にかかわらずそのboxはscroll containerになる
  * scroll containerのchildlenはscroll containerをはみ出さないようになる
  * ただし、`overflow: clip`にするとscroll containerはつくられずはみ出したもの見えなくなる


## `white-space`

wordsとinline elementのwrapを制御する

### overflow-wrap

* `overflow-wrap: break-word`
  * 単語が長すぎてwidthに収まらない場合に単語を分割することを許可する
  * word-wrapはIEの名前
  * `hyphens:auto`をつけると単語を分割した際に`-`つけてくれるかもしれない

## Flexbox

* containerに`display:flex`を指定する
  * containerはflow layoutのまま, childからflex layoutになる


* `flex-direction: row | column`
  * rowの場合, horizonがprimary axis, vertialがcoross axisになる
  * elementはcross axisの方向に伸びる, primary axisの方向にstackする

* `justify-content: flex-start | space-evenly | between-space`
  * primaxy axisのspaceをどう分配するか

* `align-items: stretch | center | baseline`
  * cross axis方向の調整
  * baselineはtextをあわせるのに便利
  * 特定の子だけ違うalignを適用したい場合は子に`align-self`を指定できる

* flexboxのwidthは子のcontentの合計. 子のcontentは最も長いwordで決まる。

* There are two important sizes when dealing with Flexbox: the minimum content size, and the hypothetical size.
  * The minimum content size is the smallest an item can get without its contents overflowing.
  * Setting width in a flex row (or height in a flex column) sets the hypothetical size. It isn't a guarantee, it's a suggestion.
  * flex-basis has the same effect as width in a flex row (height in a column). You can use them interchangeably, but flex-basis will win if there's a conflict.
  * flex-grow will allow a child to consume any excess space in the container. It has no effect if there isn't any excess space.
  * flex-shrink will pick which item to consume space from, if the container is too small. It has no effect if there is any excess space.
  * flex-shrink can't shrink an item below its minimum content size.

* `flex-grow`: extra spaceをどう分配するか。
  * `flex-basis: 0`を指定するとelementのhypothetical sizeが0になるのでwidthすべてが分配の対象になる

### 参考

* https://www.joshwcomeau.com/css/interactive-guide-to-flexbox/