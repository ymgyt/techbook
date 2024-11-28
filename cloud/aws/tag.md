# AWS Tag

* key valueのpair
  * valueはoptional

* user-definedとaws generated tagsがある
  * aws generated tags
    * `aws` prefixがつく。user-definedではこのprefixはつけられない
    * tagの個数制限では考慮されない
    * ex. `aws:cloudformation:stack-name`
  * user-defined tags
    * `ymgyt:xyz`のようにnamespaceにしておくのがよい

* 1 resourceに対して50個まで付与できる


## Tag戦略

一般的にはTagに以下の役割をもたせる

* Resoruceの管理
  * grouping化したり

* Cost管理
  * cost allocation tag

* Operation Automation
  * なんらかの運用時の処理対象

* Access制御

## References

* [Best Practices for Tagging AWS Resources](https://docs.aws.amazon.com/whitepapers/latest/tagging-best-practices/tagging-best-practices.html)
