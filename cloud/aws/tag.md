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


## References

* [Best Practices for Tagging AWS Resources](https://docs.aws.amazon.com/whitepapers/latest/tagging-best-practices/tagging-best-practices.html)
