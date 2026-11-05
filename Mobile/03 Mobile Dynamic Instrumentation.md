---
type: technical-guide
category: mobile
tags: [ctf, mobile, frida, instrumentation]
---

# Mobile Dynamic Instrumentation

## Instrumentation goals

- log function arguments and return values;
- replace a validation result to test a hypothesis;
- observe cryptographic inputs/keys at runtime;
- trace file, network, and IPC behavior;
- bypass a test-only environmental check;
- reach native/JNI/Objective-C/Swift logic hidden from static analysis.

## Frida workflow

1. Match Frida client/server versions and target architecture.
2. Enumerate processes and application identifiers.
3. Spawn or attach depending on initialization timing.
4. Hook the narrowest relevant method.
5. log values safely and preserve types.
6. verify that behavior changes for the reason expected.

```javascript
Java.perform(function () {
  const Target = Java.use('com.example.Target');
  Target.check.implementation = function (value) {
    console.log('check:', value);
    const result = this.check(value);
    console.log('result:', result);
    return result;
  };
});
```

Avoid recursively calling the replacement incorrectly; overload selection and original-method invocation depend on the API/runtime.

## Native boundary

Use module exports, symbol enumeration, address offsets, and `Interceptor.attach` for native functions. Account for ASLR by calculating module-relative addresses.

## Sources

- [Frida documentation](https://frida.re/docs/home/)
- [OWASP MASTG techniques](https://mas.owasp.org/MASTG/techniques/)
