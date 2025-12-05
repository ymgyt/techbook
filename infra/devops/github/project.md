# GitHub Project

## Filter

* multiple filterはAND
  * `label:bug status:"In progress"`

* 同じlevelはOR
  * `label:bug,support`

* `no`でvalueをもっていない
  * `no:label`, `no:assignee`

* Negate
  * `-assignee:USERNAME`

* Has
  * `has:assignee`
  * `has:FIELD`

* state or type
  * `is:open`, `is:closed`, `is:merged`
  * `is:issue`, `is:pr`, `is:draft`

* last updated
  * `updated:Numberdays`
  * `updated:>@today-1w`
