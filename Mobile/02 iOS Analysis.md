---
type: technical-guide
category: mobile
tags: [ctf, mobile, ios]
---

# iOS Analysis

## Package triage

An IPA is a ZIP container. Inspect `Payload/*.app`, `Info.plist`, entitlements, embedded frameworks, provisioning profile, resources, URL schemes, associated domains, and the Mach-O binary.

```bash
unzip -l app.ipa
plutil -p Payload/App.app/Info.plist
codesign -d --entitlements :- Payload/App.app
otool -L Payload/App.app/App
strings -a Payload/App.app/App | less
```

Some commands require macOS. Cross-platform static tooling can still parse many Mach-O and plist artifacts.

## Storage targets

- `UserDefaults` preferences;
- application Documents/Library/tmp;
- SQLite/Core Data databases;
- Keychain items and access-control attributes;
- caches, logs, pasteboard, screenshots, and backups.

## Platform surfaces

- custom URL schemes and universal links;
- inter-process communication and extensions;
- WebViews and script bridges;
- biometric gates and Keychain access control;
- ATS/network configuration and pinning;
- jailbreak/debugger detection and integrity checks.

## Objective-C and Swift

Objective-C metadata often exposes class and selector names. Swift binaries retain mangled symbols and rich runtime metadata but may be larger and more complex. Use demangling and type-aware decompilation.

## Source

- [OWASP MASTG iOS knowledge and tests](https://mas.owasp.org/MASTG/)
