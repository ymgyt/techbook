# Authentication methods

Clientがvault apiを利用する前に、auth methodを利用してauthenticateしてtokenを取得する必要がある。    
このtokenにはpolicyがattachされているので、policyによる統制が図られる。  
auth methodもnamespaced。

## AppRole

RoleIdとSecretIdはuserにおけるusernameとpasswordの関係にある