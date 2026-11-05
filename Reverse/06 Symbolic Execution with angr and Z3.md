---
type: technical-guide
category: reverse
tags: [ctf, reverse, angr, z3, symbolic-execution]
---

# Symbolic Execution with angr and Z3

## Choose the right solver

Use direct Z3 when you can translate the validation logic into equations. Use angr when control flow, memory, library calls, or path reachability are the main difficulty. Concrete debugging is often faster for finding the relevant function and success/failure addresses first.

## Direct Z3 pattern

Specify widths and signedness deliberately. Python integers are unbounded; machine arithmetic is not.

```python
from z3 import *

x = [BitVec(f'x{i}', 8) for i in range(16)]
s = Solver()
for b in x:
    s.add(b >= 0x20, b <= 0x7e)
s.add((x[0] ^ x[1]) == 0x37)
s.add(Sum([ZeroExt(24, b) for b in x]) == 1337)

if s.check() == sat:
    m = s.model()
    print(bytes(m.eval(b).as_long() for b in x))
```

Use `BitVec` for wraparound, shifts, masks, and machine comparisons; use `Int` for true mathematical integers. Use `LShR` for logical right shift. Validate the model by feeding it to the original program.

## angr reachability template

```python
import angr, claripy

p = angr.Project('./chall', auto_load_libs=False)
N = 32
flag = claripy.BVS('flag', 8 * N)
state = p.factory.full_init_state(args=['./chall'], stdin=flag)
for i in range(N):
    b = flag.get_byte(i)
    state.solver.add(b >= 0x20, b <= 0x7e)

simgr = p.factory.simulation_manager(state)
simgr.explore(find=0x401234, avoid=[0x401180, 0x4011a0])
if simgr.found:
    print(simgr.found[0].solver.eval(flag, cast_to=bytes))
```

Use rebased addresses from the loaded object and verify whether PIE is active. Prefer addresses representing unambiguous semantic states, not merely a printed string shared by several paths.

## State-explosion control

- Constrain known format bytes early.
- Avoid failure blocks and irrelevant functions.
- Hook unsupported/expensive functions with `SimProcedure`.
- Use `auto_load_libs=False` unless library execution is essential.
- Symbolize only necessary input bytes.
- Add length/terminator constraints matching real input APIs.
- Inspect `active`, `deadended`, `errored`, `unconstrained`, and `found` stashes.

When angr diverges, compare one concrete execution with the symbolic state at the same address. Common causes are wrong initial state, missing environment/files, unsupported syscalls, unconstrained memory, or incorrect modeling of `scanf`, newline, and null termination.

## Hybrid workflow

1. Reverse enough to isolate the checker.
2. Rename variables and transcribe a small portion into Z3.
3. Use angr only for branches that are tedious to model.
4. Extract constraints or a candidate.
5. Verify against the original binary and remote protocol.

## Related

- [[Reverse/02 Static Analysis with Ghidra|Static analysis with Ghidra]]
- [[Reverse/03 Dynamic Analysis and Debugging|Dynamic analysis and debugging]]
- [[Crypto/07 Crypto Solver Patterns|Crypto solver patterns]]

## Primary references

- [angr core concepts](https://docs.angr.io/en/latest/core-concepts/toplevel.html)
- [angr simulation managers](https://docs.angr.io/en/latest/core-concepts/pathgroups.html)
- [Microsoft Z3 guide](https://microsoft.github.io/z3guide/)
