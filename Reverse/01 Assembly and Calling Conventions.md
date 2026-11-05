---
type: technical-guide
category: reverse
tags: [ctf, reverse, assembly]
---

# Assembly and Calling Conventions

## x86-64 mental model

- registers hold integers, addresses, flags, and temporary state;
- memory is untyped bytes; types are analyst/compiler interpretations;
- instructions update registers, memory, and flags;
- conditional branches consume flags produced by comparisons/arithmetic;
- calls transfer control and preserve a return location;
- calling conventions define argument, return, and preservation rules.

## System V AMD64 essentials

| Purpose | Registers |
| --- | --- |
| Integer/pointer arguments | `rdi`, `rsi`, `rdx`, `rcx`, `r8`, `r9` |
| Return value | `rax` |
| Callee-saved | `rbx`, `rbp`, `r12`–`r15` |
| Stack pointer | `rsp` |
| Instruction pointer | `rip` |

Windows x64 instead uses `rcx`, `rdx`, `r8`, `r9` for the first four integer arguments and reserves shadow space. Identify the ABI before labeling variables.

## Recognizing constructs

- `cmp/test` followed by conditional jump: branch condition;
- backward conditional jump: probable loop;
- `lea base + index*scale`: address calculation, array, or arithmetic optimization;
- indirect `call [table + index*8]`: function pointer or virtual dispatch;
- sign/zero extension: source width and signedness clue;
- repeated shift/xor/add/rotate: encoding, hash, or cipher-like transform.

## Data structures

Infer a struct when the same base pointer is accessed at consistent offsets. Infer an array when an index is scaled by element width. Apply types only when supported by multiple uses.

## Source

- [OpenSecurityTraining2 Architecture courses](https://ost2.fyi/)
- [System V ABI](https://gitlab.com/x86-psABIs/x86-64-ABI)
