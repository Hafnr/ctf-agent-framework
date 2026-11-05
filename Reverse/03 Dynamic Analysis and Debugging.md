---
type: technical-guide
category: reverse
tags: [ctf, reverse, debugging, dynamic-analysis]
---

# Dynamic Analysis and Debugging

## Safety

Run untrusted binaries only in an isolated, disposable VM or sandbox with snapshots. Disable shared folders, clipboard, credentials, and unnecessary networking for suspicious samples.

## Hypothesis-driven breakpoints

Set breakpoints at:

- input functions;
- comparisons and validation branches;
- decoding/decryption loops;
- allocation and free sites;
- file/network operations;
- success and failure output;
- indirect calls or suspicious APIs.

## GDB essentials

```gdb
start
break *main
run
disassemble /r main
x/16gx $rsp
x/s $rdi
watch *(int*)0xADDRESS
catch syscall openat
```

Use hardware watchpoints to discover who modifies a value. Reverse stepping requires appropriate recording support and may be expensive.

## Compare runs

Use two inputs differing in one controlled property. Record where execution diverges, buffer contents before/after transforms, comparison operands, and return values. This is often faster than tracing from program entry.

## Anti-ASLR calculations

Use module-relative offsets in notes:

```text
runtime address = module base + static offset
```

Avoid recording one run's randomized absolute address as though it were stable.

## Dynamic instrumentation

Frida, debugger scripting, and API tracing can log arguments or replace functions without manually stepping every instruction. Instrument the narrowest behavior needed to answer the current question.

## Sources

- [GDB documentation](https://sourceware.org/gdb/documentation/)
- [Frida documentation](https://frida.re/docs/home/)
- [Malware Unicorn RE101](https://malwareunicorn.org/workshops/re101)
