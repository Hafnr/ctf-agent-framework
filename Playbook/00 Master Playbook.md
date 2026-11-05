---
type: playbook
updated: 2026-11-04
tags:
  - ctf
  - playbook
---

# CTF Master Playbook

> [!warning] Scope
> Use these techniques only on CTF infrastructure and systems you are explicitly authorized to test.

## First five minutes

- [ ] Read the complete prompt; record the expected flag format.
- [ ] Save every supplied file without modifying the original.
- [ ] Hash files and identify their real types.
- [ ] Search visible strings, metadata, comments, and obvious encodings.
- [ ] Decide the likely category and open its playbook.
- [ ] Record facts separately from hypotheses.
- [ ] Choose the cheapest test that can disprove the leading hypothesis.

```bash
sha256sum *
file *
strings -a -n 6 <file> | head -200
xxd -l 256 <file>
```

## Investigation loop

```text
Observe → classify → hypothesize → run one controlled test
   ↑                                      ↓
record evidence ← compare expected and actual result
```

After two failed variations, stop and ask:

1. What assumption am I treating as a fact?
2. Is this actually a different category?
3. Did the error, timing, length, status code, or crash change?
4. Can a teammate independently reproduce the observation?

## Category routing

| Signal | Open |
| --- | --- |
| URL, request, cookie, API, source map | [[Web Playbook]] |
| ELF, PE, service with a supplied binary | [[Pwn Playbook]] |
| Executable, APK, bytecode, obfuscated logic | [[Reverse Playbook]] |
| Ciphertext, RSA values, XOR, strange encoding | [[Crypto and Encoding Playbook]] |
| PCAP, disk image, memory dump, media, document | [[Forensics Playbook]] |
| Person, place, account, image provenance | [[OSINT Playbook]] |
| Full Linux or Windows host | [[Host and Privilege Escalation Playbook]] |
| Linux kernel/module, PE crash, restricted syscall binary | [[Pwn/00 Pwn Pathway|Binary exploitation pathway]] |
| Windows domain, LDAP, Kerberos ticket, trust | [[Identity/00 Identity Pathway|Identity pathway]] |
| Solidity, EVM bytecode, contract address, RPC | [[Blockchain/00 Blockchain Pathway|Blockchain pathway]] |
| Firmware, board, UART/JTAG, radio capture | [[Hardware/00 Hardware Pathway|Hardware pathway]] |
| Game build, Unity assets, custom VM or odd format | [[Misc/00 Misc Pathway|Misc pathway]] |

## In-depth technical pathways

The quick playbooks above are for use under time pressure. Use these pathways for deeper study and technique-specific reference:

- [[Web/00 Web Pathway|Web exploitation]]
- [[Pwn/00 Pwn Pathway|Binary exploitation / pwn]]
- [[Reverse/00 Reverse Engineering Pathway|Reverse engineering]]
- [[Crypto/00 Cryptography Pathway|Cryptography]]
- [[Forensics/00 Forensics Pathway|Digital forensics]]
- [[Steganography/00 Steganography Pathway|Steganography]]
- [[OSINT/00 OSINT Pathway|OSINT]]
- [[Mobile/00 Mobile Pathway|Mobile]]
- [[Cloud/00 Cloud Pathway|Cloud and containers]]
- [[Identity/00 Identity Pathway|Active Directory and Kerberos]]
- [[Blockchain/00 Blockchain Pathway|Blockchain and smart contracts]]
- [[Hardware/00 Hardware Pathway|Hardware, firmware, and SDR]]
- [[Misc/00 Misc Pathway|Games, Unity, and unusual challenges]]
- [[Playbook/Technical Sources and Attribution|Technical sources and attribution]]

## Evidence discipline

- Preserve original files; work on copies.
- Log exact commands and full errors in a local copy of [[Commands/Command Log Template|Command Log Template]].
- Timestamp useful discoveries.
- Save request/response pairs, not just payloads.
- Mark credentials as `unverified`, `valid`, or `dead`.
- Once solved, reduce the path to a reproducible sequence.

## Stop conditions

- A destructive step could break a shared challenge instance.
- The target is outside the event scope.
- A downloaded file may be malicious and no sandbox is available.
- You cannot explain what the next command changes.

## Quick references

- [CTF101](https://ctf101.org/) — compact fundamentals by category.
- [HackTricks](https://book.hacktricks.wiki/) — broad service and technique reference.
- [PayloadsAllTheThings](https://github.com/swisskyrepo/PayloadsAllTheThings) — maintained web methodology and payload reference.
- [CyberChef](https://gchq.github.io/CyberChef/) — encoding, compression, crypto, and data transformations.
- [GTFOBins](https://gtfobins.org/) — Unix binary behavior under sudo, SUID, and capabilities.
- [LOLBAS](https://lolbas-project.github.io/) — Windows signed binaries and scripts.
