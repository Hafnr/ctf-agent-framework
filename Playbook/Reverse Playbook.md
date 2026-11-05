---
type: playbook
category: reverse
tags: [ctf, reverse]
---

# Reverse Playbook

## Static triage

```bash
file <sample>
sha256sum <sample>
strings -a -n 5 <sample> | less
objdump -d <sample> | less
```

- [ ] Identify format, architecture, language/runtime, packing, and debug symbols.
- [ ] Search imports, exports, strings, resources, and embedded files.
- [ ] Find `main`, input handling, comparisons, success text, and failure text.
- [ ] Rename functions and variables by behavior, not guesses.
- [ ] Convert the validation logic into pseudocode or a small solver.

## Dynamic workflow

1. Do not run an untrusted executable on your normal host.
2. Use an isolated VM or disposable sandbox with snapshots.
3. Break at input, comparison, transform, and success/failure branches.
4. Compare memory before and after each transformation.
5. Patch only after you understand what the patch proves.

## Common challenge patterns

- XOR/add/rotate loops and lookup tables
- Custom encodings and shuffled alphabets
- Hard-coded keys or comparison buffers
- Anti-debug checks and timing
- Packed or self-modifying code
- Native wrappers around Python, Java, .NET, or JavaScript
- Constraint systems suited to symbolic execution or an SMT solver

## Best references

- [Official Ghidra repository and documentation](https://github.com/NationalSecurityAgency/ghidra)
- [CTF101 reverse engineering](https://ctf101.org/reverse-engineering/overview/)
