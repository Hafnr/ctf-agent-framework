---
type: index
updated: 2026-11-05
tags: [ctf, handbook, start]
---

# CTF Handbook — Start Here

This vault has two layers:

1. [[Playbook/00 Master Playbook|Master Playbook]] and category playbooks for fast use during a competition.
2. In-depth technical pathways for study, troubleshooting, and technique-specific reference.

## AI agent use

Agents that support repository instructions automatically load [[AGENTS|AGENTS.md]] from the vault root. Open this vault as the agent's workspace, provide the authorized challenge scope and files, and the agent will create a challenge-local investigation record before solving.

## Technical pathways

| Pathway | Coverage |
| --- | --- |
| [[Web/00 Web Pathway|Web exploitation]] | HTTP, authentication, access control, injection, server/client-side vulnerabilities, protocol attacks |
| [[Pwn/00 Pwn Pathway|Binary exploitation]] | ELF, mitigations, stack corruption, shellcode, ROP, format strings, heap, pwntools |
| [[Reverse/00 Reverse Engineering Pathway|Reverse engineering]] | Assembly, Ghidra, debugging, managed code, bytecode, packing, anti-analysis |
| [[Crypto/00 Cryptography Pathway|Cryptography]] | Encoding, XOR, number theory, RSA, AES modes, hashes, PRNGs, DH, ECC, solvers |
| [[Forensics/00 Forensics Pathway|Digital forensics]] | Files, carving, disks, filesystems, memory, PCAP, Windows artifacts, media, documents |
| [[Steganography/00 Steganography Pathway|Steganography]] | PNG/JPEG, bit planes, LSB, audio, text, containers, polyglots |
| [[OSINT/00 OSINT Pathway|OSINT]] | Search, identity pivots, archives, geolocation, chronolocation, verification |
| [[Mobile/00 Mobile Pathway|Mobile]] | Android, iOS, static/dynamic analysis, Frida instrumentation |
| [[Cloud/00 Cloud Pathway|Cloud and containers]] | IAM, metadata, storage, containers, Kubernetes, CI/CD, IaC |
| [[Identity/00 Identity Pathway|Identity and enterprise domains]] | Active Directory, LDAP, Kerberos, trusts, credentials and tickets |
| [[Blockchain/00 Blockchain Pathway|Blockchain]] | Solidity, EVM state, smart-contract auditing and exploit verification |
| [[Hardware/00 Hardware Pathway|Hardware and radio]] | Firmware, UART, JTAG/SWD, embedded debugging and SDR captures |
| [[Misc/00 Misc Pathway|Games and misc]] | Unity Mono/IL2CPP, assets, custom formats, VMs and unusual puzzles |

## Competition workflow

1. Duplicate [[Templates/Challenge|Challenge template]].
2. Open [[00 CTF Dashboard.canvas|CTF Dashboard]].
3. Classify the challenge using [[Playbook/00 Master Playbook|Master Playbook]].
4. Follow the relevant quick playbook.
5. Open the deeper pathway only when you need the underlying technique.
6. Copy [[Commands/Command Log Template|Command Log Template]] to `Commands/Command Log.md` and record exact commands there.
7. Convert the final solution into [[Writeups/Writeup Template|Writeup Template]].

## Sources

See [[Playbook/Technical Sources and Attribution|Technical Sources and Attribution]] for the maintained upstream courses, labs, and documentation used to build this original handbook.

> [!warning] Authorized use only
> Apply offensive techniques only to CTF infrastructure, deliberately vulnerable labs, or systems you have explicit permission to test.
## Document every attack path

For each challenge, copy [[Writeups/Attack Path Worklog Template]] into the challenge folder as `worklog.md` and copy `Templates/Attack Path Canvas Template.canvas` as `attack-path.canvas`. Record each meaningful hypothesis as `AP-01`, `AP-02`, and so on in both files. The canvas shows branch depth and failure points visually; the worklog stores exact tests and evidence. Use [[Writeups/Writeup Template]] for the final reproducible report.

For a live view, open `LIVE Attack Status.md` or `attack-path.canvas` in Obsidian while the agent works. Agents update the view before and after each meaningful test through `Scripts/Update-AttackPath.ps1`.
