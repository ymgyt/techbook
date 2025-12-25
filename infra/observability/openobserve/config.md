# Configuration

* `ZO_NODE_ROLE_GROUP`
  * routerがqueryをroutingする際に参照する
  * `interactive`, `background` がある
    * UIからのリクエストはinteractiveに流して、alertはbackgroundに流せば、UIが重くなるのを避けられるという狙い
