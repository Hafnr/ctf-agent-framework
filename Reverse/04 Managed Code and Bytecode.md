---
type: technical-guide
category: reverse
tags: [ctf, reverse, dotnet, java, python, wasm]
---

# Managed Code and Bytecode

## Identify the runtime

| Signal | Likely target | Typical tooling |
| --- | --- | --- |
| PE with CLR metadata | .NET | ILSpy, dnSpyEx, ildasm |
| JAR/class or DEX/APK | Java/Android | JADX, apktool, javap |
| `.pyc` or Python bundle | Python bytecode | `dis`, decompilers, archive extractors |
| WASM magic/module | WebAssembly | wasm2wat, wabt, browser debugger |
| Electron/ASAR | JavaScript app | asar extraction, source maps, DevTools |

## Managed-code advantage

Metadata often preserves type names, method signatures, strings, and high-level structure. Begin with a decompiler, but inspect intermediate language or bytecode when control flow or types look wrong.

## Common CTF patterns

- hard-coded secrets or resources;
- validation split across event handlers;
- reflection and dynamically loaded assemblies/classes;
- encrypted strings decoded at startup;
- native/JNI boundary hiding key logic;
- Python marshal/bytecode version mismatch;
- WebAssembly exports called from JavaScript glue.

## Workflow

1. Extract containers and resources.
2. Identify entry points and user-controlled input.
3. Search for flag format, comparison functions, crypto APIs, and success messages.
4. Trace through wrappers to the true validation routine.
5. Reimplement the transformation independently.
6. Use runtime instrumentation if static decompilation is incomplete.

## Android crossover

For APK-specific work, continue with [[Mobile/01 Android Analysis|Android Analysis]].
