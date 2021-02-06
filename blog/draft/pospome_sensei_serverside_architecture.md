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

###### 仕様パターンとリポジトリパターンの併用

仕様をもらって、SQLで全件取得するパターン。  
メモリに全件のるので使える場面が限られる。

```go
type UserSpecification struct {}

func (u *UserSpecification) IsSatisfyPremiumUser(user *User) bool { 
	return user.Status == "premium"
}

func (u *UserRepository) GetPremiumUser(spec *UserSpecification) []*User { 
	allUsers := db.GetAllUser()
    result := make([]*User, 0)
    
    for _, user := range allUsers {
        if spec.IsSatisfyPremiumUser(user) { 
        	result = append(result, user)
        } 
    }
    return result
}
```

仕様側にSQLを定義する。

```go
type UserSpecification interface {
	SQL() string
}

type PremiumUserSpecification struct {}

func (p *PremiumUserSpecification) SQL() string {
    return "WHERE status = 'premium'"
}
```

##### 生成


## 4 

### 本質的な設計スキル

* 人によって階層を切る際の粒度が異なる可能性があるので、packageの責務の粒度と階層について方針を決めておく必要がある。


