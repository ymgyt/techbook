# NodeClass

## EC2NodeClass

aws固有の設定を定義できる

```yaml
apiVersion: karpenter.sh/v1beta1
kind: NodePool
metadata:
  name: default
spec:
  template:
    spec:
      nodeClassRef:
        apiVersion: karpenter.k8s.aws/v1beta1
        kind: EC2NodeClass
        name: default
---
apiVersion: karpenter.k8s.aws/v1beta1
kind: EC2NodeClass
metadata:
  name: default
spec:
  # Required, resolves a default ami and userdata
  amiFamily: AL2

  # Required, discovers subnets to attach to instances
  # Each term in the array of subnetSelectorTerms is ORed together
  # Within a single term, all conditions are ANDed
  subnetSelectorTerms:
    # Select on any subnet that has the "karpenter.sh/discovery: ${CLUSTER_NAME}" 
    # AND the "environment: test" tag OR any subnet with ID "subnet-09fa4a0a8f233a921"
    - tags:
        karpenter.sh/discovery: "${CLUSTER_NAME}"
        environment: test
    - id: subnet-09fa4a0a8f233a921

  # Required, discovers security groups to attach to instances
  # Each term in the array of securityGroupSelectorTerms is ORed together
  # Within a single term, all conditions are ANDed
  securityGroupSelectorTerms:
    # Select on any security group that has both the "karpenter.sh/discovery: ${CLUSTER_NAME}" tag 
    # AND the "environment: test" tag OR any security group with the "my-security-group" name 
    # OR any security group with ID "sg-063d7acfb4b06c82c"
    - tags:
        karpenter.sh/discovery: "${CLUSTER_NAME}"
        environment: test
    - name: my-security-group
    - id: sg-063d7acfb4b06c82c

  # Optional, IAM role to use for the node identity.
  # The "role" field is immutable after EC2NodeClass creation. This may change in the
  # future, but this restriction is currently in place today to ensure that Karpenter
  # avoids leaking managed instance profiles in your account.
  # Must specify one of "role" or "instanceProfile" for Karpenter to launch nodes
  role: "KarpenterNodeRole-${CLUSTER_NAME}"

  # Optional, IAM instance profile to use for the node identity.
  # Must specify one of "role" or "instanceProfile" for Karpenter to launch nodes
  instanceProfile: "KarpenterNodeInstanceProfile-${CLUSTER_NAME}"

  # Optional, discovers amis to override the amiFamily's default amis
  # Each term in the array of amiSelectorTerms is ORed together
  # Within a single term, all conditions are ANDed
  amiSelectorTerms:
    # Select on any AMI that has both the "karpenter.sh/discovery: ${CLUSTER_NAME}" tag 
    # AND the "environment: test" tag OR any AMI with the "my-ami" name 
    # OR any AMI with ID "ami-123"
    - tags:
        karpenter.sh/discovery: "${CLUSTER_NAME}"
        environment: test
    - name: my-ami
    - id: ami-123
      
  # Optional, use instance-store volumes for node ephemeral-storage
  instanceStorePolicy: RAID0

  # Optional, overrides autogenerated userdata with a merge semantic
  userData: |
    echo "Hello world"    

  # Optional, propagates tags to underlying EC2 resources
  tags:
    team: team-a
    app: team-a-app

  # Optional, configures IMDS for the instance
  metadataOptions:
    httpEndpoint: enabled
    httpProtocolIPv6: disabled
    httpPutResponseHopLimit: 2
    httpTokens: required

  # Optional, configures storage devices for the instance
  blockDeviceMappings:
    - deviceName: /dev/xvda
      ebs:
        volumeSize: 100Gi
        volumeType: gp3
        iops: 10000
        encrypted: true
        kmsKeyID: "1234abcd-12ab-34cd-56ef-1234567890ab"
        deleteOnTermination: true
        throughput: 125
        snapshotID: snap-0123456789

  # Optional, configures detailed monitoring for the instance
  detailedMonitoring: true
status:
  # Resolved subnets
  subnets:
    - id: subnet-0a462d98193ff9fac
      zone: us-east-2b
    - id: subnet-0322dfafd76a609b6
      zone: us-east-2c
    - id: subnet-0727ef01daf4ac9fe
      zone: us-east-2b
    - id: subnet-00c99aeafe2a70304
      zone: us-east-2a
    - id: subnet-023b232fd5eb0028e
      zone: us-east-2c
    - id: subnet-03941e7ad6afeaa72
      zone: us-east-2a

  # Resolved security groups
  securityGroups:
    - id: sg-041513b454818610b
      name: ClusterSharedNodeSecurityGroup
    - id: sg-0286715698b894bca
      name: ControlPlaneSecurityGroup-1AQ073TSAAPW

  # Resolved AMIs
  amis:
    - id: ami-01234567890123456
      name: custom-ami-amd64
      requirements:
        - key: kubernetes.io/arch
          operator: In
          values:
            - amd64
    - id: ami-01234567890123456
      name: custom-ami-arm64
      requirements:
        - key: kubernetes.io/arch
          operator: In
          values:
            - arm64

  # Generated instance profile name from "role"
  instanceProfile: "${CLUSTER_NAME}-0123456778901234567789"
```