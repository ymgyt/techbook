# Custom Property

* Repositoryにpropertyを設定できる

* Requirement
  * required
  * default

* Value
  * string or string_list or null

* `props.owner:team-x` のような検索が可能になる 

* 誰が編集できるか(`values_editable_by`)
  * `org_actors`: org adminのみ
  * `org_and_repo_actors`: org admin と repo admin
