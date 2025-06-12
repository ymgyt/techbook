# IPAM (IP Address Manager)

## なぜ VPC CIDRが重複すると問題になるか

* VPCピアリングできない
* Security policy
  * (10.0.1.0/24)からを許可が曖昧になる
* 監査ログが複雑化

## PoolとScope

* Scope
  * TopLevel ContainerでNetworkを表す
    * 暗黙的にInstanceがtoplevelでは?
  * Scopeが違うと同じIPを使える

* DefaultでPrivate,Public scopeが作成される

* Pool
  * CIDR(連続したIP Range)
  * Scope内に作成する
  * 階層構造をもてる
  * 共有にはRAMが関わってくる?
  * Provision
    * PoolにCIDRを追加すること
  * Allocation
    * ProvisionされたCIDRをVPCに割り当てる

```sh
# allocationの申請
aws ec2 allocate-ipam-pool-cidr \
--ipam-pool-id ipam-pool-0533048da7d823723 \
--netmask-length 24

{
"IpamPoolAllocation": {
  "Cidr": "10.0.0.0/24",
  "IpamPoolAllocationId": "ipam-pool-alloc-018ecc28043b54ba38e2cd99943cebfbd",
  "ResourceType": "custom",
  "ResourceOwner": "123456789012”
  }
}
```

## Region

* Home Region
  * IPAMのメタ情報を管理するRegion
    * 監査ログやログはここにでる
  * IP Addressは管理されない
  * Operational RegionからデータがReplicateされる

* Operational Region
  * IPAMが追跡するRegion
  * ここで指定しないRegionは管理対象外になる


## Tier

* Advanced Tier
  * Private IPが管理できる

* Free Tier
  * Private IPを管理できないので利用用途が限定的

## VPC

* VPC作成時にIPAM Poolから払い出される
  * ipv4_ipam_pool_idの参照がおそらく設定にある

## Organizations

* 各アカウントにAWSServiceRoleForIPAM service link roleが自動生成される

1. Management AccountからIPAM管理 AccにDelegateする
2. IPAM Instanceの作成
3. TopLevel IPAM Poolの作成
