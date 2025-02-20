# 設計関連の話

## 単一責任の原則(Single Responsibility Principle)

* クラスの変更理由は一つ
* 観点は凝集性(cohesion)
  * 凝集性とは、要素同士が機能的に関連しているか
* あてはまらない場合もある
  * 大事なのは保守しやすいかどうか
  * 余計な分割は不要な複雑さをもたらす


## 依存関係逆転の法則(Dependency Inversion Principle)

* 抽象はその抽象を使うモジュールによって所有されるべき
  * 抽象を利用するモジュールがその抽象をもっとも有効活用できる方法で定義する


## インターフェイス分離の原則 (Interface Segregation Principle)

* 使用しないメソッドに依存させるべきではない
  * インターフェイスを利用するコードはそのインターフェイスのメソッドをすべて使うべき
  * 単一責任とも関連する


## 過度な注入 (Constructor Over-Injection)

* Constructでの依存注入が4つ以上になったら黄色信号
  * 単一責任の原則逸脱の兆候
* 解消のアプローチ
  * 依存の中で相互作用しているものを捉えて、一つの依存にまとめる
  * 変化をdomain eventとして表現して処理を移譲する


## SOLID原則

* Single Responsibility Principles
* Open/Closed Principle
* Liskov Substitution Principle
* Interface Segregation Principle
* Dependency Inversion Principle

## DRY (Don't Repeat Yourself)

* すべての知識はシステム内において、単一、かつ明確な、そして信頼できる表現になっていなければならない
  * 複数あると同期しないといけないから
