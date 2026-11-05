---
type: reference
updated: 2026-11-05
tags: [ctf, sources, attribution]
---

# Technical Sources and Attribution

## Specialized and advanced domains

- [Linux kernel documentation](https://docs.kernel.org/) — kernel interfaces, hardening, debugging, and seccomp.
- [Microsoft Open Specifications](https://learn.microsoft.com/en-us/openspecs/) — PE/COFF, Active Directory, LDAP, and Windows protocol behavior.
- [Solidity documentation](https://docs.soliditylang.org/) and [Ethereum developer documentation](https://ethereum.org/developers/docs/) — EVM and smart-contract semantics.
- [GraphQL specification](https://spec.graphql.org/) and [IETF RFC index](https://www.rfc-editor.org/) — GraphQL, WebSocket, HTTP, JWT, OAuth, and Kerberos protocol details.
- [angr documentation](https://docs.angr.io/) and [Z3 guide](https://microsoft.github.io/z3guide/) — symbolic execution and constraint solving.
- [SageMath documentation](https://doc.sagemath.org/) — exact algebra, number theory, and lattice reduction.
- [OpenOCD](https://openocd.org/doc/html/), [GNU Radio](https://wiki.gnuradio.org/), [YARA](https://yara.readthedocs.io/), and [Unity](https://docs.unity3d.com/) — embedded, radio, artifact classification, and game build internals.

This vault contains original summaries, workflows, examples, and checklists. It does not reproduce complete third-party courses. Follow the linked sources for their full explanations and labs.

## Primary curriculum

| Area | Source | Use |
| --- | --- | --- |
| General CTF | [Trail of Bits CTF Field Guide](https://trailofbits.github.io/ctf/) | Broad methodology, tradecraft, toolkits, web, exploitation, and forensics |
| Web | [PortSwigger Web Security Academy](https://portswigger.net/web-security/all-topics) | Detailed vulnerability theory and interactive labs |
| Web payload reference | [PayloadsAllTheThings](https://github.com/swisskyrepo/PayloadsAllTheThings) | Testing patterns and bypass reference |
| Pwn | [pwn.college Program Security](https://pwn.college/dojo/program-security/) | Shellcode, reverse engineering, ROP, allocator misuse, exploitation |
| Exploit automation | [pwntools documentation](https://docs.pwntools.com/en/stable/) | Python exploit development API |
| Architecture | [OpenSecurityTraining2](https://ost2.fyi/) | Assembly, architecture, debugging, and low-level security |
| Reverse engineering | [Ghidra](https://github.com/NationalSecurityAgency/ghidra) | Official reverse-engineering framework and documentation |
| Malware analysis | [Malware Unicorn workshops](https://malwareunicorn.org/workshops/re101) | Static/dynamic analysis and anti-analysis |
| Crypto | [CryptoHack courses](https://cryptohack.org/courses/) | Encoding, number theory, AES, RSA, DH, ECC |
| Advanced crypto | [Cryptopals](https://cryptopals.com/) | Practical attacks on real cryptographic constructions |
| Memory forensics | [Volatility 3 documentation](https://volatility3.readthedocs.io/en/latest/) | Current memory-analysis framework |
| Network forensics | [Wireshark User's Guide](https://www.wireshark.org/docs/wsug_html_chunked/) | Capture, filters, protocol analysis, and object extraction |
| Mobile | [OWASP MASTG](https://mas.owasp.org/MASTG/) | Android/iOS knowledge, techniques, tests, tools, and demos |
| OSINT | [Bellingcat Toolkit](https://bellingcat.gitbook.io/toolkit) | Ethical online investigation tools and workflows |
| Cloud practice | [Cloud Security CTFs](https://csoh.org/ctfs.html) | AWS, Azure, GCP, Kubernetes, and IaC labs |

## How to use sources during a CTF

1. Use this vault to classify the problem and choose a controlled test.
2. Follow the chapter's primary source when you need full theory or a lab.
3. Use HackTricks or PayloadsAllTheThings as lookup references, not as proof that a technique applies.
4. Record only validated commands in your own challenge note.
5. Note tool and target versions; many techniques are version-dependent.

## Scope

All offensive procedures are intended for CTFs, intentionally vulnerable labs, or systems for which you have explicit authorization.
