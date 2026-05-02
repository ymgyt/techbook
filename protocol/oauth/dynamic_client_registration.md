# Dynamic Client Registration

* APIで動的にOAuth Clientを登録する仕様
* RFC7591


## Memo

* Registration API自体はOAuth protected resourceとして振る舞い、access tokenで保護してもよい(MAY)
* 3.1
  * The HTTP Entity Payload is a JSON document consisting of a JSON object and all requested client metadata values as top-level members of that JSON object
