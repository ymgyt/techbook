# bundle

## localのgemを利用する

`foo` というgem をlocalに切り替える

```sh
# 有効化
bundle config local.foo /path/to/foo
bundle install

# 元に戻す
bundle config --delete local.foo
```

* local override を利用すると、bundleはGemfile内で、branch の指定を要求する
  * Gemfileのbranch指定と実際にcheckoutされたlocal のbranchが一致しないとエラーになる

```
source 'https://rubygems.org'

gem 'foo', git: 'https://github.com/ymgyt/foo.git', branch: 'feature-branch'
```
  

* gem 参照している場合は、`path`の指定だけでうまくいった
  * 逆にこの場合、bundle config local.foo はうまくいかなかった。なぜ?

```
source 'https://rubygems.org'

# gem 'foo', '~> 0.2.0'
gem 'foo', path: '/home/ymgyt/ae/foo'
```
