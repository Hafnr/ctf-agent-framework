---
type: playbook
category: pwn
tags: [ctf, pwn]
---

# Pwn Playbook

## Triage

```bash
file ./chall
checksec --file=./chall
ldd ./chall
strings -a -n 5 ./chall | less
readelf -h -l -s ./chall | less
```

- [ ] Record architecture, endianness, linkage, interpreter, and supplied libc/loader.
- [ ] Record NX, PIE, RELRO, stack canary, and other mitigations.
- [ ] Run locally with simple, empty, long, and malformed input.
- [ ] Locate input functions, length checks, format strings, allocations, and frees.
- [ ] Determine whether the primitive is read, write, leak, control-flow, or logic.
- [ ] Find the exact crash offset with a cyclic pattern.
- [ ] Make local behavior reproducible before moving remote.

## Exploit ladder

1. Understand the input protocol.
2. Obtain a stable crash or logic violation.
3. Identify the controlled bytes and constraints.
4. Build the smallest useful primitive.
5. Account for mitigations and address randomization.
6. Test repeatedly, then switch to remote with the same script.

## pwntools skeleton

```python
from pwn import *

context.binary = elf = ELF("./chall", checksec=False)
context.log_level = "info"

def start():
    if args.REMOTE:
        return remote("host", 31337)
    return process(elf.path)

io = start()
# io.sendlineafter(b"> ", payload)
io.interactive()
```

## Debugging questions

- Does it fail before or after returning from the vulnerable function?
- Is the stack aligned?
- Are addresses from the correct local/remote libc?
- Is input truncated by a null byte, newline, whitespace, or parser?
- Is the remote protocol expecting another prompt or length field?

## Best references

- [pwntools stable documentation](https://docs.pwntools.com/en/stable/)
- [CTF101 binary exploitation](https://ctf101.org/binary-exploitation/overview/)
- [GDB documentation](https://sourceware.org/gdb/documentation/)
