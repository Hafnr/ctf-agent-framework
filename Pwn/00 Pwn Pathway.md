---
type: pathway
category: pwn
tags: [ctf, pwn, pathway]
---

# Binary Exploitation Pathway

## Learning order

1. [[Pwn/01 ELF Triage and Mitigations|ELF triage and mitigations]]
2. [[Pwn/02 Stack Corruption and Shellcode|Stack corruption and shellcode]]
3. [[Pwn/03 ROP and ret2libc|ROP and ret2libc]]
4. [[Pwn/04 Format String Exploitation|Format strings]]
5. [[Pwn/05 Heap Exploitation Foundations|Heap foundations]]
6. [[Pwn/06 pwntools Exploit Patterns|pwntools exploit patterns]]
7. [[Pwn/07 Linux Kernel Exploitation|Linux kernel exploitation]]
8. [[Pwn/08 Windows Binary Exploitation|Windows binary exploitation]]
9. [[Pwn/09 SROP seccomp and ret2dlresolve|SROP, seccomp, and ret2dlresolve]]

## Required foundations

- C memory model: arrays, pointers, structs, stack/heap/global storage.
- x86-64 registers, flags, calls, returns, and System V ABI.
- virtual memory, executable formats, dynamic linking, and syscalls.
- debugger use: breakpoints, registers, memory, stack, disassembly.

## Exploit-development loop

```text
triage → reproduce → locate primitive → measure control
      → satisfy constraints → defeat mitigations → automate → stabilize
```

Never begin with a payload. Begin by stating the primitive you have and the primitive you need.

## Primary curriculum

- [pwn.college Program Security](https://pwn.college/dojo/program-security/)
- [pwntools documentation](https://docs.pwntools.com/en/stable/)
- [OpenSecurityTraining2](https://ost2.fyi/)
