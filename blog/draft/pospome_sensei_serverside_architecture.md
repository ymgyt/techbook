# pospome先生のサーバサイドアーキテクチャ

## memo

* [誤字脱字報告フォーム](https://docs.google.com/forms/d/e/1FAIpQLSf1DBv8I2L3dHhsFERl2UjRQiwHtVlIIZE7LWFyXdZw3C9tAg/viewform)
* [BOOTH](https://pospome.booth.pm/)

アイコンは羊ではなくポメラニアン。

## 1

### レイヤーとは

Webアプリケーションにおいて普遍的な責務をもつパッケージ(モジュール)で、使う側と使われる側の関係が決まっている。(単方向依存)

#### レイヤーのメリット

* 修正による影響範囲が予測できる。単方向依存なので、影響範囲は依存関係の逆方向に限定される。
  
* コードを書く場所が決まる。
  * 実装者のスキルや好みでブレなくなる。 
  * キャッチアップがしやすくなる。

*  レイヤは普遍的な責務を持つパッケージなので依存関係は適切。(実装者のスキルに依存しない、最低限の秩序)

#### レイヤーのデメリット

* コード量が増える。

## 3

### 4章 詳解DDDの仕様パターン

#### validation logicはどこにおくか。

##### そのobject自体に置く

* constructorの中
* validation methodをもたせる


##### そのobject以外に置く

validation logicが複数のobjectをまたぐ場合にはmethodにすると不自然になりがち。  
この場合、関数に切り出すが、複数のobjectをもつ上位のobjectのmethodに定義したりすることになる。

#### 仕様パターン

object自体に実装すると不自然になるlogicを外部に切り出す考え。  
集約やentityに定義できる場合は定義する。  
validationが複数packageで参照されるようなら仕様として名前をつけて管理するとよい。

##### 構造体を利用する場合

状態がないなら関数でもよい。

```go
type XxxSpecification struct {
    entities []*Entity	
}

func (s *XxxSpecification) Satisfy() bool {
	// validation logic ...
}
```

#### 仕様パターン 3つの用法

大切なのはdomain logicがapplication層に漏れないこと。

##### 検証

validationと同じ。

##### 選択

専用のslice型をきる場合。

```go
type UserList []*User

func (u UserList) SelectPremiumUsers() []*User {
	users := make([]*User, 0, len(u))
	
	for _, user := range u {
		if user.Status == "Premium" {
			users = append(users,user)
        }   
    }   
    
    return users
}
```

フィルタリングする際に依存する型があるなら
```go
type XxxSpecification struct {
	users []*Users
	teams []*Team
	event *Event
}

func (s *XxxSpecification) SelectXXX() []*User {
	// ...
}
```
