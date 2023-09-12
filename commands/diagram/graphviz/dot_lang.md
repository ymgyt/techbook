# Dot Language

* graphの種類
  * `graph`: 無向グラフ
  * `digraph`: 有向グラフ

## Example

`[strict] (graph | digraph) [ID] '{'' stmt_list '}`

```dot
digraph {
  // graphのlabel
  graph [
  		label="UML Class diagram demo"
  		labelloc="t" // t(top) | b(bottom)
  		fontname="Helvetica,Arial,sans-serif"
      // 矢印をClusterで止める
      compound=true;
  ]

  // Defaultの指定
  node [ shape=square ];
  A; B; C;

  // 配置がかなりかわる
  layout=dot

  // nodeの設定はcontextっぽい
  node [ shape = circle, width = 0.9]
  1; 2; 3;

  edge [ style=dashed ];

  fontname="Noto Sans CJK JP"
  rankdir="TB"
  hello [ 
    label = "Hello",
    style="
      filled, // 塗りつぶす
      rounded, // 角まるめる
      dashed, // 枠がdot
      solid, // 太線
    "
    ];
  a -> b; [ color="red", penwidth="2.0"]

  subgraph cluster_x {
    label="Foo"
    color="yellow"
    rank = same

    subgraph cluster_x_1 {
      label="Nexted"
      x_1_a -> x_1_b;
    }
  }

  subgraph cluster_y {
    y_a -> y_c
    y_a -> y_b
    y_b -> y_c [constraint=false];
  }

  // 矢印をclusterのboundaryで止める
  node1 -> node2 [ltail="cluste_bar", lhead=cluster_foo];
  // とも書ける
  A -> {B, C, D}
  // 矢印の向き
  // Rankの指定と表現としての方向を制御できる
  lpha -> beta [dir = forward];
  gamma -> delta [dir = back];
  epsilon -> zeta [dir = both];
  eta -> theta [dir = none];

  // rank (top|leftからの距離)
  { rank=same aX aY aZ }
  { rank=same bX bY bZ }
}
```

* `layout`: 配置のengine
  * `dot`(default)
  * `fdp`
  * `osage`
  * [engine一覧](https://graphviz.org/docs/layouts/)
* `rankdir`: graphのlayoutの方向
  * `TB`: top to bottom, `BT`もある
  * `LR`: left to right
* `label`: nodeの表示を変えられる
* `color`: 表示の色を指定する
  * graph, node, edgeに指定できる
* `fotnname`: fontの指定
  * edge,node,graph, clusterに書ける
  * 複数指定できる
    * `Helvetica,Arial,sans-serif`
* `subgraph cluster_`ではじめるとclusterとして意図どおりにgroupingしてくれる
  * `cluster_`は特別な意味をもつらしい
  * nestできる
* `constraint=false`を渡すと上下関係(rank)の制約をうけつ並んでくれる
* `lhead,ltail`: 矢印をcluster boundaryに設定する
  * compound=trueが前提
* `penwidth`: 線の太さ。default1.0
  * cluster,node,edge

## Record

```dot
digraph {
  rankdir=LR;
  node [ shape=record ];

  struct1 [
      label = "a|b|<port1>c";
  ];
  
  struct2 [
      label = "a|{<port2>b1|b2}|c";
  ];
  
  struct1:port1 -> struct2:port2 [ label="xyz" ];
```
構造体の関係も表現できる

## HTML like label

labelが`<>`でencoloseされるとhtml likeになる

## 参考

* [FLow char tutorial](https://sketchviz.com/flowcharts-in-graphviz)
* [Qiitaの網羅的な記事](https://qiita.com/rubytomato@github/items/51779135bc4b77c8c20d)