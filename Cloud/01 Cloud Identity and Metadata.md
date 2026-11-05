---
type: technical-guide
category: cloud
tags: [ctf, cloud, iam]
---

# Cloud Identity and Metadata

## Enumerate current identity first

Determine provider, account/project/subscription, principal type, credential source, expiry, and effective permissions. Do not assume the CLI profile name describes the active identity.

## IAM reasoning

For each action, evaluate:

- identity policy;
- resource policy;
- permission boundary;
- session policy;
- organization/SCP or equivalent;
- explicit deny;
- trust/assume-role conditions;
- region/project/resource scope.

## Privilege paths

Look for combinations that let a principal:

- pass or attach a more privileged role to a workload;
- modify a policy, trust relationship, function, startup script, or build;
- read credentials/secrets used by another principal;
- impersonate service accounts;
- create access keys or tokens;
- trigger a privileged automation path.

The individual permission may appear harmless; the combination creates escalation.

## Metadata services

Cloud workloads may obtain temporary identity credentials from a link-local metadata service. Access controls, required headers/tokens, hop limits, and endpoint paths vary by provider and version. In SSRF challenges, first prove server-side reachability and identify the environment rather than assuming one provider.

## Storage

Check both identity and bucket/object resource policy, public-access controls, signed URLs, ACLs, encryption/key permissions, object versions, and logs. “Public” and “authenticated but cross-account” are different states.

## Evidence

Record every principal ARN/ID, policy statement, condition, resource, region, and credential expiry. Cloud state changes rapidly.
