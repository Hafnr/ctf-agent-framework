---
type: playbook
category: host
tags: [ctf, linux, windows, privilege-escalation]
---

# Host and Privilege Escalation Playbook

> [!warning]
> Use only on the CTF host assigned to you. Avoid persistence and destructive changes unless the challenge explicitly requires them.

## Linux enumeration

```bash
id
uname -a
sudo -l
find / -perm -4000 -type f 2>/dev/null
getcap -r / 2>/dev/null
```

- [ ] Users, groups, shell history, environment, and home-directory permissions
- [ ] Sudo rules, SUID/SGID files, and Linux capabilities
- [ ] Running processes, services, cron jobs, timers, and writable scripts
- [ ] Listening ports and services bound only to localhost
- [ ] Credentials in configs, backups, logs, repositories, and process arguments
- [ ] Container membership, mounts, sockets, and host exposure
- [ ] Kernel/version checks only after simpler paths are exhausted

Cross-check discovered binaries against [GTFOBins](https://gtfobins.org/).

## Windows enumeration

```powershell
whoami /all
systeminfo
Get-Process
Get-Service
Get-NetTCPConnection -State Listen
```

- [ ] Token privileges and group membership
- [ ] Services with weak permissions or unquoted paths
- [ ] Scheduled tasks and writable scripts/binaries
- [ ] Stored credentials, configuration files, history, and registry secrets
- [ ] Local-only services and named pipes
- [ ] Installed software and patch level

Cross-check relevant signed binaries against [LOLBAS](https://lolbas-project.github.io/).

## Validation rule

For every candidate path, write down:

1. Current privilege.
2. Misconfiguration or primitive.
3. Exact boundary crossed.
4. Minimal reversible proof.
5. Cleanup required.
