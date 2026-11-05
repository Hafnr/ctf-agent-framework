---
type: technical-guide
category: pwn
tags: [ctf, pwn, srop, seccomp, ret2dlresolve]
---

# SROP, seccomp, and ret2dlresolve

These are constraint-driven techniques. First prove why ordinary ROP or a normal imported function cannot solve the binary.

## Signal-return-oriented programming

On Linux, signal restoration loads register state from a signal frame in memory. If an attacker controls a frame and reaches the architecture's signal-return syscall, many registers can be set at once.

Checklist:

1. Confirm architecture, kernel ABI, and frame layout.
2. Find a `syscall`/equivalent instruction and a way to set the signal-return syscall number.
3. Place a correctly aligned frame in readable memory.
4. Choose a valid stack for the next stage.
5. Verify every segment/register field required by the architecture.

Pwntools exposes `SigreturnFrame`, but the generated frame must match `context.arch` and the target ABI. Debug the transition at the syscall and inspect all registers rather than treating the helper as magic.

```python
from pwn import *
context.binary = elf = ELF('./chall', checksec=False)
context.arch = 'amd64'
frame = SigreturnFrame()
frame.rax = constants.SYS_write
frame.rdi = 1
frame.rsi = elf.bss()
frame.rdx = 0x100
frame.rip = next(elf.search(asm('syscall; ret')))
```

## Seccomp reasoning

Seccomp filters syscalls; it does not automatically prevent exploitation. Obtain the actual policy from source, `seccomp-tools dump`, or BPF disassembly. Build an allow/deny table including argument checks and architecture conditions.

```bash
seccomp-tools dump ./chall
strace -f ./chall
```

Then design around capabilities rather than syscall names. Examples: if `open` is blocked but `openat` is allowed, use the permitted ABI; if only read/write on existing descriptors are allowed, locate inherited descriptors; if execution is impossible, target data disclosure. Confirm return actions such as `KILL`, `TRAP`, or `ERRNO` from observed behavior.

## ret2dlresolve

ELF lazy binding passes relocation metadata to the dynamic resolver. If you can place forged symbol, string, and relocation records in known writable memory and invoke the resolver path, you may resolve a symbol absent from the normal PLT.

Required checks:

- dynamically linked ELF using a compatible resolver path;
- known module/writable addresses;
- correct `Elf32/64_Sym` and relocation alignment;
- symbol-name offset points into the forged string table;
- relocation target is writable;
- resolver calling sequence and argument ABI are correct.

Pwntools can construct the layout:

```python
rop = ROP(elf)
dl = Ret2dlresolvePayload(elf, symbol='system', args=['/bin/sh'])
rop.read(0, dl.data_addr, len(dl.payload))
rop.ret2dlresolve(dl)
payload = fit({offset: rop.chain()})
```

Send the first-stage chain and forged records in the order expected by the program. Inspect `dl.payload`, relocation index, and resolver breakpoint if it fails.

## Verification and pivots

- Re-run with ASLR enabled.
- Check stack alignment immediately before resolver/libc transitions.
- If seccomp blocks the intended end state, redesign the objective around allowed operations.
- If full RELRO changes writable targets, inspect the precise resolver mechanics and choose another technique when assumptions no longer hold.

## Related

- [[Pwn/03 ROP and ret2libc|ROP and ret2libc]]
- [[Pwn/06 pwntools Exploit Patterns|Pwntools exploit patterns]]
- [[Pwn/01 ELF Triage and Mitigations|ELF triage and mitigations]]

## Primary references

- [Linux seccomp userspace API](https://docs.kernel.org/userspace-api/seccomp_filter.html)
- [Linux signal ABI documentation](https://man7.org/linux/man-pages/man7/signal.7.html)
- [ELF specification and ABI resources](https://refspecs.linuxfoundation.org/elf/elf.pdf)
