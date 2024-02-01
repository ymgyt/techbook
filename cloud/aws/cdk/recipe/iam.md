# CDK IAM Recipe

## Policy from json

```typescript
import { PolicyDocument } from "aws-cdk-lib/aws-iam";
import * as lbcPolicy from "./lbc-v2.6.1-iam-policy.json";

export const awsLbcPolicyDocument = PolicyDocument.fromJson(lbcPolicy);
```

* jsonをimportしてそのままdocumentを作れる

`tsconfig.json`の`resolveJsonModule: true`が必要

```json
{
  "compilerOptions": {
    "resolveJsonModule": true
  },
}
```

## IRSA Role

EKS IRSA用のRole定義

```typescript
import { FederatedPrincipal, Policy, Role } from "aws-cdk-lib/aws-iam";
import { Construct } from "constructs";
import { awsLbcPolicyDocument } from "../policy/lbc/aws-load-balancer-controller-policy";

export interface LbcIamRoleProps {
	federatedAwsAccountId: string;
	federatedOidcProviderId: string;
	serviceAccountNamespace?: string;
	serviceAccountName?: string;
}

// IAM Role for aws loadbalancer controller
export class LbcIamRole extends Construct {
	constructor(scope: Construct, id: string, props: LbcIamRoleProps) {
		super(scope, id);

		const {
			federatedAwsAccountId: accountId,
			federatedOidcProviderId: oidcProviderId,
			serviceAccountNamespace,
			serviceAccountName,
		} = props;

		const federated = `arn:aws:iam::${accountId}:oidc-provider/${oidcProviderId}`;

		const namespace = serviceAccountNamespace ?? "kube-system";
		const serviceAccount = serviceAccountName ?? "aws-loadbalancer-controller";

		const condition = {
			StringEquals: {
				[`${oidcProviderId}:aud`]: "sts.amazonaws.com",
				[`${oidcProviderId}:sub`]: `system:serviceaccount:${namespace}:${serviceAccount}`,
			},
		};
		const principal = new FederatedPrincipal(
			federated,
			condition,
			"sts:AssumeRoleWithWebIdentity",
		);

		const role = new Role(this, "Role", {
			assumedBy: principal,
			description: "IAM Role for aws loadbalancer controller service account",
		});

		const policy = new Policy(this, "Policy", {
			document: awsLbcPolicyDocument,
		});

		role.attachInlinePolicy(policy);
	}
}
```
