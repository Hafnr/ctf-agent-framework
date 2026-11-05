---
type: technical-guide
category: reverse
tags: [ctf, reverse, ghidra, static-analysis]
---

# Static Analysis with Ghidra

## Triage before importing

```bash
file sample
sha256sum sample
strings -a -n 5 sample | less
readelf -h -S -s sample | less
```

Identify format, architecture, language/runtime, packing, and whether symbols remain.

## Ghidra workflow

1. Import using the correct language/compiler specification.
2. Run standard analysis; note analyzer warnings.
3. Start from entry points, imports, exports, strings, and success/failure text.
4. Follow cross-references to code using each clue.
5. Rename functions and variables by demonstrated behavior.
6. correct parameter, return, pointer, array, and struct types.
7. Compare decompiler output with disassembly at ambiguous operations.
8. Extract the validation/transformation into pseudocode or a solver.

## Decompiler discipline

Decompiler output is a hypothesis. Common errors include wrong signedness, lost casts, incorrect array sizes, merged variables, bad calling conventions, and missed indirect calls. The machine instructions are authoritative.

## High-value navigation

- function call tree and cross-references;
- imports related to input, comparison, crypto, filesystem, or network;
- strings and references;
- defined data and memory maps;
- control-flow graph around validation branches;
- function signatures and local-variable stack layout.

## Patching as an experiment

Patch a conditional branch only to test understanding. If changing one branch produces success, you have located a decision point—not necessarily recovered the required input. For CTF flags, extracting the true transformation is usually the reproducible solution.

## Source

- [Ghidra official repository](https://github.com/NationalSecurityAgency/ghidra)
- Use `Help → Contents` inside Ghidra for version-matched documentation.
