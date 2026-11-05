---
type: technical-guide
category: pwn
tags: [ctf, pwn, stack, shellcode]
---

# Stack Corruption and Shellcode

## Stack-frame model

On x86-64 System V, a typical frame may contain local variables, saved frame state, and a saved return address. Compiler optimization can omit the frame pointer or rearrange locals, so verify the actual disassembly.

## Measuring an overwrite

```python
from pwn import *

pattern = cyclic(400, n=8)
# Send pattern, collect the overwritten instruction pointer or stack value.
offset = cyclic_find(0x6161616161616166, n=8)
print(offset)
```

Confirm the offset in the debugger. Do not assume a crash implies instruction-pointer control.

## Control taxonomy

| Observation | Primitive |
| --- | --- |
| overwrite saved return address | control flow after function returns |
| overwrite function pointer | indirect call/jump control |
| overwrite length/index | out-of-bounds read/write amplifier |
| overwrite adjacent variable | data-only or authentication bypass |
| controlled pointer and value | write primitive |

## Shellcode constraints

- architecture and operating system;
- allowed syscalls or seccomp filter;
- executable memory availability;
- forbidden bytes and input terminators;
- maximum length and alignment;
- known address or reliable landing region;
- registers clobbered before control transfer.

Generate and inspect rather than blindly paste:

```python
from pwn import *
context.arch = 'amd64'
code = asm(shellcraft.amd64.linux.cat('/flag'))
print(len(code), enhex(code))
print(disasm(code))
```

## NOP sled reasoning

A sled increases tolerance when the exact landing address is uncertain, but it does not solve ASLR by itself. The guessed address must still land within a mapped executable range.

## Partial overwrites

Little-endian layouts and page-aligned ASLR may let a low-byte overwrite redirect within the same mapping. Calculate which bytes are stable and estimate success probability. Input functions that append a null byte can create an off-by-one null overwrite.

## Sources

- [pwn.college Program Security](https://pwn.college/dojo/program-security/module/program-security)
- [pwntools cyclic utilities](https://docs.pwntools.com/en/stable/util/cyclic.html)
- [pwntools shellcraft](https://docs.pwntools.com/en/stable/shellcraft.html)
