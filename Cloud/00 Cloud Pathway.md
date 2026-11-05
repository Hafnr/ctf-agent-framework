---
type: pathway
category: cloud
tags: [ctf, cloud, pathway]
---

# Cloud and Container Pathway

## Learning order

1. [[Cloud/01 Cloud Identity and Metadata|Cloud identity and metadata]]
2. [[Cloud/02 Containers and Kubernetes|Containers and Kubernetes]]
3. [[Cloud/03 CI-CD and Infrastructure as Code|CI/CD and infrastructure as code]]

## Core model

```text
principal + credential + policy + resource policy + organization guardrails
          + network path + workload identity → effective capability
```

Cloud CTFs are usually identity and trust-relationship puzzles more than port-scanning exercises.

## Safe practice

Use hosted labs or isolated disposable accounts. Vulnerable-by-design environments can create billable or publicly exposed resources; follow teardown instructions and verify cleanup.

## Practice directory

- [Cloud Security CTF Challenges](https://csoh.org/ctfs.html)
