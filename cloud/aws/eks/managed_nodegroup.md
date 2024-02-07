# Managed Node Group

## AMI

* AMI Versionという単位で指定できる
  * formatは`k8s_major_version.k8s_minor_version.k8s_patch_version-release_date`
  * 例: `1.29.0-20240202`
  * 具体的な内容は[Changelog](https://github.com/awslabs/amazon-eks-ami/blob/master/CHANGELOG.md)で確認できる

* AMI Type
  * 例: `AL2_x86_64`
