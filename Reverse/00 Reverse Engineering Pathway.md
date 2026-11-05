---
type: pathway
category: reverse
tags: [ctf, reverse, pathway]
---

# Reverse Engineering Pathway

## Learning order

1. [[Reverse/01 Assembly and Calling Conventions|Assembly and calling conventions]]
2. [[Reverse/02 Static Analysis with Ghidra|Static analysis with Ghidra]]
3. [[Reverse/03 Dynamic Analysis and Debugging|Dynamic analysis and debugging]]
4. [[Reverse/04 Managed Code and Bytecode|Managed code and bytecode]]
5. [[Reverse/05 Anti-Analysis and Unpacking|Anti-analysis and unpacking]]
6. [[Reverse/06 Symbolic Execution with angr and Z3|Symbolic execution with angr and Z3]]

## Analysis loop

```text
classify → locate inputs/outputs → form hypothesis → inspect evidence
         → rename/type/comment → test dynamically → extract algorithm
```

The goal is not to read every instruction. The goal is to answer a specific question about the program.

## Primary curriculum

- [OpenSecurityTraining2](https://ost2.fyi/)
- [Ghidra official repository](https://github.com/NationalSecurityAgency/ghidra)
- [Malware Unicorn workshops](https://malwareunicorn.org/workshops/re101)
