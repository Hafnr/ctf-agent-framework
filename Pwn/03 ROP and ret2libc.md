---
type: technical-guide
category: pwn
tags: [ctf, pwn, rop, ret2libc]
---

# ROP and ret2libc

## ROP model

Return-oriented programming chains short instruction sequences ending in control-transfer instructions. A chain is a program whose state is carried in registers and stack words.

## Plan from the goal backward

Example goal on Linux x86-64:

```text
call target(argument1, argument2, ...)
```

Under System V ABI, the first arguments use `rdi`, `rsi`, `rdx`, `rcx`, `r8`, and `r9`. Find gadgets that establish the required state without unacceptable side effects.

## Two-stage ret2libc

1. Use a known PLT function to leak a GOT entry.
2. Return to a stable function such as `main` for another input.
3. Calculate libc base from the leaked symbol offset.
4. Resolve the desired libc functions and strings.
5. Send a second chain.

```python
from pwn import *

context.binary = elf = ELF('./chall')
rop = ROP(elf)
rop.call(elf.plt['puts'], [elf.got['puts']])
rop.call(elf.symbols['main'])
```

Parse leaks as raw bytes, not printed hex, unless the program explicitly formats them.

## Stack alignment

Some libc functions use instructions requiring 16-byte alignment. If a chain works locally until a libc call faults, inspect `rsp` alignment and consider a single `ret` gadget.

## PIE and base calculation

For any leaked address:

```text
mapping base = leaked runtime address - known file offset
runtime symbol = mapping base + symbol offset
```

Validate the base is page-aligned and that computed addresses fall inside the expected mapping.

## Alternatives

- **ret2csu:** use compiler-provided sequences to control multiple registers.
- **SROP:** construct a signal frame when a syscall and stack control are available.
- **ret2dlresolve:** ask the dynamic linker to resolve a crafted symbol.
- **ORW:** open/read/write when spawning a shell is blocked.
- **stack pivot:** redirect `rsp` into a larger controlled region.

## Troubleshooting

- wrong libc or loader version;
- newline or null truncates payload;
- leak parser consumes too much or too little;
- chain clobbers a value in a side-effect gadget;
- stack alignment differs locally/remotely;
- PIE/libc base calculated from wrong symbol offset.

## Sources

- [pwn.college Return Oriented Programming](https://pwn.college/dojo/program-security/)
- [pwntools ROP](https://docs.pwntools.com/en/stable/rop/rop.html)
