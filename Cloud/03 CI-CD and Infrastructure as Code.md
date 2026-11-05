---
type: technical-guide
category: cloud
tags: [ctf, cloud, cicd, iac]
---

# CI/CD and Infrastructure as Code

## CI/CD trust model

Map:

- who can modify workflow definitions or referenced scripts;
- which events trigger privileged jobs;
- secrets and token permissions available to each event;
- whether untrusted pull-request code runs with trusted context;
- artifact/cache provenance;
- deployment approvals and environment protection;
- self-hosted runner isolation.

## Common challenge patterns

- expression or shell injection from branch/issue/PR metadata;
- unpinned third-party actions or dependencies;
- artifact poisoning between low- and high-privilege jobs;
- cache poisoning;
- secrets printed through debug/error paths;
- overprivileged repository tokens;
- self-hosted runner persistence or cross-job leakage;
- unsafe checkout of untrusted code before privileged steps.

## Infrastructure as code

Review Terraform/CloudFormation/Bicep/Kubernetes manifests for:

- wildcard IAM actions/resources;
- public storage/network exposure;
- secret values in state or outputs;
- insecure defaults and optional protections;
- overly broad trust relationships;
- unencrypted data and logs;
- mutable image/action/module references;
- lifecycle rules that preserve exposed resources.

## State files

IaC state can contain resource identifiers and sensitive values. Treat it as a secret, control backend access, enable locking/versioning, and avoid publishing it as an artifact.

## Verification

Static scanner output is a lead. Confirm the actual deployed configuration, inherited policy, and reachable path before declaring impact.
