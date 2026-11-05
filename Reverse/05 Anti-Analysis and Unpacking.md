---
type: technical-guide
category: reverse
tags: [ctf, reverse, packing, anti-debug]
---

# Anti-Analysis and Unpacking

## Recognize packing

- few imports despite complex behavior;
- one high-entropy section;
- unusual section names/permissions;
- entry point dominated by decode/copy loops;
- code becomes visible only after execution;
- strings absent statically but present in memory.

## Unpacking model

```text
stub executes → allocates/writes memory → changes permissions
              → resolves imports → transfers to original entry point
```

Break on allocation, memory-protection changes, and indirect transfer into newly written memory. Dump after unpacking and reconstruct imports if needed.

## Anti-debug categories

- debugger-presence APIs;
- timing comparisons;
- exception behavior;
- parent-process or environment checks;
- breakpoint-byte or integrity checks;
- thread/TLS callback tricks;
- VM hardware/process/artifact detection.

Instead of patching every check, identify the value or branch controlling the final decision. Instrument APIs or normalize the environment where practical.

## Control-flow flattening

Look for a dispatcher loop and state variable selecting blocks. Recover transitions, label logical states, and reconstruct the original graph. Dynamic traces can reveal real paths faster than statically analyzing every opaque branch.

## Self-modifying code

Trace writes to executable regions and invalidate/reanalyze the modified bytes. A static disassembler may show stale instructions until the memory snapshot is refreshed.

## Source

- [Malware Unicorn RE102](https://malwareunicorn.org/workshops/re102)
