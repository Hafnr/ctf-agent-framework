---
type: technical-guide
category: forensics
tags: [ctf, forensics, windows]
---

# Windows Artifact Analysis

## Artifact map

| Question | Useful artifacts |
| --- | --- |
| What executed? | Prefetch, Amcache, Shimcache, event logs, SRUM, process memory |
| What did the user open? | LNK, Jump Lists, RecentDocs, shellbags |
| What persisted? | Services, scheduled tasks, Run keys, startup folders, WMI |
| What accounts/logons? | Security event log, SAM, profile data, RDP artifacts |
| What devices connected? | Registry USB artifacts, setup logs, event logs |
| What network activity? | Firewall logs, SRUM, browser data, DNS cache, memory |

No single artifact is complete. Correlate multiple sources.

## Event logs

Preserve channel, provider, event ID, record ID, timestamp, computer, user/SID, and relevant fields. Event IDs have meaning only within their provider/channel and OS/audit configuration.

## Registry

Important hives include SYSTEM, SOFTWARE, SAM, SECURITY, and each user's NTUSER.DAT/UsrClass.dat. Record hive path, key path, value name/type/data, and last-write time.

## Prefetch

Prefetch can indicate program execution and referenced files, depending on OS configuration/version. Absence is not proof a program did not run.

## LNK and Jump Lists

These may retain target paths, volume identifiers, timestamps, and network locations even after the original file is gone.

## Timeline correlation

Normalize timestamps, then correlate execution artifacts, file creation, logons, network activity, and persistence. Treat copied timestamps and timestomping as hypotheses requiring corroboration.

## Tools

KAPE, Registry Explorer, EvtxECmd, PECmd, MFTECmd, and Timeline Explorer are common artifact-focused tools. Validate parsed results against raw artifacts for decisive findings.
