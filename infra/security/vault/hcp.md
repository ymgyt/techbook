# HCP

Hashicorp Cloud Platform。 
https://developer.hashicorp.com/vault/tutorials/cloud/vault-introduction#self-managed-vs-hcp-vault-cluster 

## Public connection

Public connectionを有効にするか否かを選択できる。  
無効にした場合はUserのAWS VPCとHCP側でperringを設定することで信頼したcomponentからのみアクセスできる環境を構築できる。  

## Self-managedとの比較

You have reached the maximum number of allowed organizations you can create. Currently you are limited to one organization.

* HCP Vault runs vault enterprise
* root namespace of HCP is `admin`

## Price

* https://www.hashicorp.com/products/vault/pricing
  * 機能比較もある
* https://developer.hashicorp.com/hcp/docs/hcp/admin/billing 

## AWSとの接続

* Amazon transit gatewayとは
  * https://developer.hashicorp.com/hcp/tutorials/networking/amazon-transit-gateway

* VPC Peering
  * https://developer.hashicorp.com/hcp/tutorials/networking/amazon-peering-hcp 
