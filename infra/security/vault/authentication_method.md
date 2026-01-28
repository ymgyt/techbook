# Authentication methods

Clientがvault apiを利用する前に、auth methodを利用してauthenticateしてtokenを取得する必要がある。    
このtokenにはpolicyがattachされているので、policyによる統制が図られる。  
auth methodもnamespaced。

## Memo

* token_type
  * default-serviceとserviceはclient側が指定できるかどうかっぽい

## AppRole

RoleIdとSecretIdはuserにおけるusernameとpasswordの関係にある

## Github
