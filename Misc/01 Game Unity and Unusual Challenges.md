---
type: technical-guide
category: misc
tags: [ctf, misc, game, unity, il2cpp]
---

# Game, Unity, and Unusual Challenges

## Identify engine and packaging

Preserve the whole game directory. Determine platform, engine, architecture, scripting backend, asset format, save/config locations, and network dependencies.

Unity indicators include `UnityPlayer.dll`, `<name>_Data`, `globalgamemanagers`, `resources.assets`, `Assembly-CSharp.dll`, `GameAssembly.dll`, and `il2cpp_data/Metadata/global-metadata.dat`.

## Unity decision tree

```text
Managed assemblies present?
├─ yes → Mono/.NET: inspect Assembly-CSharp.dll and dependencies
└─ no  → GameAssembly + global-metadata?
         ├─ yes → IL2CPP: recover metadata/type mappings, then analyze native code
         └─ no  → inspect WebGL, assets, scripts, or another engine
```

### Mono builds

Open managed assemblies in a .NET decompiler. Trace the win condition backward from UI text, flag comparison, scene transition, network request, or achievement. Search for `PlayerPrefs`, serialization, save encryption, debug commands, and client-authoritative state. Patch only a working copy, and prefer understanding the condition over blindly changing branches.

### IL2CPP builds

Unity converts managed IL to C++ and then native machine code. Match `GameAssembly` with the exact `global-metadata.dat`; metadata versions and stripping matter. Recover method/type mappings with a compatible analysis tool, import symbols/types into Ghidra/IDA, and verify addresses at runtime. Expect generics, wrappers, and stripped names to complicate mapping.

### Assets and saves

Inventory scenes, prefabs, text assets, scriptable objects, localization, textures/audio, and bundled files. A flag may be an unused asset, level coordinate, encoded dialogue, shader constant, or save-state reward. Validate save-file checksums, compression, serialization, and cloud/local precedence before editing.

## Dynamic game analysis

Record input-to-state changes. Use process/file/network monitoring to locate saves and requests. In a debugger, break on the final comparison, reward function, file read, or network response. Distinguish client-only checks from server-authoritative state.

Do not assume cheating the display solves the challenge: verify the actual flag output or remote state transition.

## Unusual misc workflow

1. Run `file`, hashes, strings, entropy, and hex header checks.
2. List every observable input/output and derive the state machine.
3. Separate container, encoding, compression, cryptography, and application logic.
4. Search magic values and format specifications.
5. Make a minimal parser that asserts lengths/checksums rather than ad-hoc slicing.
6. Route each layer to the relevant vault pathway.

Common misc families include esoteric languages, QR/barcodes, custom VMs, logic puzzles, network transcripts, file polyglots, printers/plotters, MIDI, chess/game notation, and optimization constraints. The transferable skill is building a precise model, not memorizing one tool per novelty.

## Related

- [[Reverse/04 Managed Code and Bytecode|Managed code and bytecode]]
- [[Reverse/06 Symbolic Execution with angr and Z3|Symbolic execution]]
- [[Forensics/06 Media and Document Analysis|Media and document analysis]]

## Primary references

- [Unity IL2CPP introduction](https://docs.unity3d.com/Manual/il2cpp-introduction.html)
- [Unity asset bundles](https://docs.unity3d.com/Manual/AssetBundlesIntro.html)
- [.NET managed assembly format](https://learn.microsoft.com/en-us/dotnet/standard/assembly/)
