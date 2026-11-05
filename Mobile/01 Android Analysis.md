---
type: technical-guide
category: mobile
tags: [ctf, mobile, android]
---

# Android Analysis

## Static triage

```bash
sha256sum app.apk
apkanalyzer manifest print app.apk
apktool d app.apk -o decoded
jadx -d jadx-out app.apk
```

Inspect:

- manifest components, permissions, intent filters, exported state;
- network security configuration and cleartext policy;
- deep links and custom URL schemes;
- WebViews and JavaScript bridges;
- hard-coded endpoints, tokens, keys, and feature flags;
- local databases, shared preferences, files, and backup rules;
- native libraries and JNI boundaries;
- signing information and debuggable/test flags.

## Component exposure

Activities, services, receivers, and providers may be reachable externally depending on exported state and intent filters. Test the component's authorization and input validation, not merely whether it launches.

## Dynamic workflow

```bash
adb install app.apk
adb shell pm list packages
adb shell dumpsys package PACKAGE
adb logcat
adb shell run-as PACKAGE ls -la
```

`run-as` requires a debuggable application. Use an emulator or authorized test device and match architecture/API level.

## Network

Proxy traffic through an intercepting proxy. Determine whether failure is caused by trust-store configuration, certificate pinning, client certificates, protocol mismatch, or application logic before attempting instrumentation.

## Source

- [OWASP Android Security Testing](https://mas.owasp.org/MASTG/0x05b-Android-Security-Testing/)
- [OWASP MASTG tools](https://mas.owasp.org/MASTG/tools/)
