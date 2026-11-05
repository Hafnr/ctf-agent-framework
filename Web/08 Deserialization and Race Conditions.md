---
type: technical-guide
category: web
tags: [ctf, web, deserialization, race-condition]
---

# Deserialization and Race Conditions

## Unsafe deserialization

Serialization turns an object graph into bytes/text; deserialization rebuilds it. The dangerous boundary is when attacker-controlled data selects types, invokes callbacks/magic methods, resolves classes, or changes security-relevant object fields.

### Recognition

- opaque base64/hex cookie or body that changes with session state;
- Java stream markers, PHP serialized syntax, Python pickle opcodes, .NET type metadata, Ruby Marshal, YAML tags;
- errors naming classes, constructors, object streams, or type binders;
- signed blobs where verification, algorithm selection, or key handling may be flawed.

Workflow:

1. Decode transport layers without modifying the original.
2. Identify the format and runtime precisely.
3. Determine integrity protection and where it is verified.
4. Map reachable classes and deserialization callbacks.
5. First prove harmless state manipulation or callback execution.
6. Build the smallest chain required by the CTF objective.

Never deserialize an unknown challenge artifact on the host. Inspect it statically or in an isolated disposable environment. For Python, `pickletools.dis` can disassemble without executing the pickle:

```bash
python -m pickletools suspicious.pkl
```

Do not assume a familiar gadget library version exists. Match runtime, dependencies, classpath, serializer configuration, and signing behavior.

## Race-condition method

A race exists when security depends on operations occurring in a particular order but concurrent requests can violate that assumption. Model the state machine rather than sending a random burst.

| Stage | Example question |
| --- | --- |
| Check | Is balance, quota, ownership, or token status read? |
| Gap | Is external I/O, database work, or queueing performed? |
| Use | When is value/privilege granted? |
| Commit | Is the update atomic and under the same lock/transaction? |

### Controlled test

1. Establish a reproducible single-request baseline.
2. Identify an endpoint with a one-time or limited invariant.
3. Prepare identical authenticated requests.
4. Synchronize their final bytes/HTTP2 streams as closely as the client permits.
5. Measure server-side results, not merely response codes.
6. Reset challenge state and repeat to distinguish a race from normal retries.

Potential patterns include limit overrun, double redemption, object creation collisions, TOCTOU file changes, and multi-endpoint state-machine races. Keep concurrency low and targeted to avoid denial of service.

## Verification

A valid race proof demonstrates an invariant violated by concurrency but preserved sequentially. Save timestamps, request IDs, response bodies, final account/object state, and the minimum number of concurrent requests.

## Related

- [[Web/02 Authentication and Access Control|Authentication and access control]]
- [[Web/04 Server-Side Vulnerabilities|Server-side vulnerabilities]]
- [[Pwn/07 Linux Kernel Exploitation|Linux kernel exploitation]]

## Primary references

- [Python pickle security warning](https://docs.python.org/3/library/pickle.html)
- [OWASP deserialization guidance](https://cheatsheetseries.owasp.org/cheatsheets/Deserialization_Cheat_Sheet.html)
- [PortSwigger race conditions](https://portswigger.net/web-security/race-conditions)
