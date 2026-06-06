# CSS Selector

propertyの適用範囲の宣言。  

- [MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Selectors)

## Combinators

### Descendant

The `" "`(space) combinator selects nodes that are descendants of the first element.

`div span`は`<div>`の中にある全ての`<span>`にmatchする。  
`<div>`と`<span>`の間のふ深さは問わない。


### Child 

The `>` combinator selects nodes that are direct children of the first element.  
`ul > li`は`<ul>`直下の全ての`<li>`にマッチする

## Pseudo classes

### 状態

defaultでruntime(broser?)が管理してくれているstateがある

```css
button:hover {
  color: blue;
}
```

* `:hover`
* `:focus`

### Tree

* `:first-child`
* `:last-child`

containerからみた親子関係を指定できる

* `:first-of-type`
* `:last-of-type`

親子関係をみてくれる点は`first-child`と同じだが,異なるtypeのsibligingsを無視してくれる

```html
<section>
  <h1>H1</h1>
  <p>paragraph</p>
</section>  
```

```css
p:first-of-type {
  color: red;
}
```

## Presudo elements

elementの"sub elements"  
明示的に宣言していないが、cssで指定されるとDOMが生成される

* `::before`
* `::after`

実質的に`<span>`を前後に生成していると考えられる

```html
<style>
  p::before {
    content: '→ ';
    color: deeppink;
  }
  
  p::after {
    content: ' ←';
    color: deeppink;
  }
</style>

<p>
  This paragraph has little arrows!
</p>
```

上記は実質的に以下と同じ

```html
<style>
.pseudo-pseudo {
  color: deeppink;
}
</style>

<p>
  <span class="pseudo-pseudo">→ </span>
  This paragraph has little arrows!
  <span class="pseudo-pseudo"> ←</span>
</p>
```