---
type: technical-guide
category: pwn
tags: [ctf, pwn, elf, mitigations]
---

# ELF Triage and Mitigations

## Static triage

```bash
file ./chall
sha256sum ./chall
checksec --file=./chall
readelf -h -l -S -s -r ./chall | less
objdump -d -M intel ./chall | less
strings -a -n 5 ./chall | less
ldd ./chall
```

Record architecture, endianness, PIE status, interpreter, linked libraries, symbols, relocations, and supplied loader/libc.

## Mitigation table

| Mitigation | What it changes | Typical consequence |
| --- | --- | --- |
| NX/DEP | Writable memory is not executable | Reuse code or change permissions rather than execute stack bytes |
| Stack canary | Detects overwrite before function return | Leak/preserve canary or avoid protected return path |
| PIE | Randomizes executable base | Leak a code pointer or exploit partial overwrite/relative behavior |
| ASLR | Randomizes mappings | Leak bases or use non-randomized/relative targets |
| RELRO | Protects relocation data | Full RELRO prevents GOT overwrite after relocation |
| CET/Shadow Stack | Protects returns/indirect branches | Classic ROP may require alternate control primitive |

Mitigations do not remove the bug; they constrain which exploit primitives remain useful.

## ELF concepts

- **Sections** organize link-time data such as `.text`, `.rodata`, `.got`, and symbol tables.
- **Segments** describe runtime mappings loaded into memory.
- **PLT** provides call stubs for dynamically linked functions.
- **GOT** holds resolved addresses or relocation data.
- **Relocations** tell the loader what must be adjusted at runtime.

## Dynamic baseline

```bash
strace -f -o strace.log ./chall
ltrace -o ltrace.log ./chall
gdb -q ./chall
```

In GDB:

```gdb
set disassembly-flavor intel
start
info files
info proc mappings
info registers
disassemble main
```

## Questions before exploitation

1. How does input enter and terminate?
2. Which bytes and lengths are attacker-controlled?
3. Where is the first memory-safety violation?
4. What can be read, written, or redirected?
5. Which addresses are known, leaked, or stable?
6. Which mitigation blocks the simplest path?

## Sources

- [pwn.college binary defenses](https://pwn.college/intro-re-pwn~5933fc84/defenses/)
- [ELF specification references](https://refspecs.linuxfoundation.org/elf/elf.pdf)
