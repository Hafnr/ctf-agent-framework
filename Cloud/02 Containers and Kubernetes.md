---
type: technical-guide
category: cloud
tags: [ctf, cloud, containers, kubernetes]
---

# Containers and Kubernetes

## Container boundary questions

- What namespace/cgroup isolation exists?
- Is the container privileged?
- Which capabilities are present?
- Which host paths, sockets, devices, or credentials are mounted?
- Is a container runtime socket reachable?
- What seccomp/AppArmor/SELinux policy applies?
- Is the kernel shared and vulnerable?

```bash
id
cat /proc/1/cgroup
cat /proc/self/status
mount
find / -xdev -perm -4000 -type f 2>/dev/null
```

## Kubernetes identity

Inside a pod, inspect namespace, service-account token, CA, and API host environment. Determine the service account and use authorization checks where permitted.

```bash
kubectl auth can-i --list
kubectl get pods -A
kubectl get rolebindings,clusterrolebindings -A
```

## Common escalation relationships

- create/patch pods with a stronger service account;
- create privileged pods or hostPath mounts;
- access secrets/config maps;
- exec into higher-privilege workloads;
- modify deployments/jobs/controllers;
- impersonate users/groups/service accounts;
- bind roles or modify admission policy;
- access cloud workload identity through a pod.

## Network

Kubernetes NetworkPolicy is allow-list oriented and only effective with a supporting CNI. DNS, API server, node-local services, and metadata access are important trust boundaries.

## Source

- [Kubernetes security documentation](https://kubernetes.io/docs/concepts/security/)
- [Cloud Security CTF directory](https://csoh.org/ctfs.html)
