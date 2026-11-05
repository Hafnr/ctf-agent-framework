---
type: technical-guide
category: forensics
tags: [ctf, forensics, memory, volatility]
---

# Memory Forensics with Volatility 3

## Start broad

```bash
python3 vol.py -f memory.raw windows.info
python3 vol.py -f memory.raw windows.pslist
python3 vol.py -f memory.raw windows.pstree
python3 vol.py -f memory.raw windows.cmdline
python3 vol.py -f memory.raw windows.netscan
```

Plugin names and requirements vary by OS and Volatility version. Use `vol.py -h` and plugin help.

## Process analysis

Compare:

- process list vs scan results;
- parent/child relationships;
- image name vs executable path;
- command line and environment;
- start/exit times;
- loaded modules and handles;
- network connections;
- memory regions with unusual permissions or content.

A strange name is weak evidence. A process with inconsistent lineage, path, modules, network behavior, and injected regions is much stronger.

## High-value Windows plugins

Common categories include process enumeration, DLLs, handles, command lines, network state, registry hives, user activity, credentials/hashes where appropriate, and malicious-memory scanning. Check current documentation for exact plugin names.

## Dumping

Record why an object is suspicious before dumping. Hash the dump and preserve its originating process, virtual address, and plugin command.

## Memory strings

Strings can reveal commands, URLs, keys, and fragments, but lack context. Map interesting strings back to process address spaces and nearby memory.

## Linux memory

Symbol tables must match the captured kernel. Start with banners, process lists/trees, shell history, network interfaces, and suspicious memory mappings.

## Source

- [Volatility 3 documentation](https://volatility3.readthedocs.io/en/latest/)
- [Volatility 3 Windows tutorial](https://volatility3.readthedocs.io/en/latest/getting-started-windows-tutorial.html)
