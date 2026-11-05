---
type: technical-guide
category: web
tags: [ctf, web, server-side]
---

# Server-Side Vulnerabilities

## Path traversal and file inclusion

Map three transformations separately:

1. application decoding and validation;
2. framework/path normalization;
3. operating-system filesystem resolution.

Test absolute paths, traversal depth, alternate separators, encoding layers, and enforced suffixes only after confirming how the application constructs the path. File inclusion may also invoke a language parser, creating a different impact than file read.

## File upload analysis

Record:

- validation source: extension, MIME, signature, parser, antivirus;
- storage name and location;
- whether content is transformed;
- how the file is served;
- whether the serving origin executes or interprets it;
- overwrite and path-control behavior.

An accepted file is not automatically exploitable. The critical question is what component later consumes it.

## SSRF

### Detection channels

- returned response body;
- status/length difference;
- timing difference;
- DNS or HTTP callback;
- application-side effects.

### Map the URL parser

Check scheme, credentials section, host parsing, port, redirects, DNS resolution timing, IP normalization, and whether validation occurs before or after redirects. Cloud metadata is environment-specific; do not assume it exists.

## XXE

Determine whether XML is parsed, whether DTDs are enabled, and whether external entities are resolved. Consider file read, SSRF, error-based disclosure, and blind out-of-band resolution. Modern parsers may disable some features while leaving XInclude or alternate XML entry points.

## Deserialization

1. Identify format and library from markers, errors, or code.
2. Determine whether integrity protection exists and where the key lives.
3. Find reachable types and behavior during construction or decoding.
4. Look for a gadget chain only after confirming attacker-controlled deserialization.
5. Prefer logic or type-confusion paths before complex code-execution chains.

## Race conditions

Find a state transition with a check and a later use. Synchronize requests, minimize network jitter, and compare single-request behavior with parallel behavior. Common targets include coupon use, balance updates, invitation acceptance, file processing, and one-time tokens.

## Sources

- [Path traversal](https://portswigger.net/web-security/file-path-traversal)
- [File upload vulnerabilities](https://portswigger.net/web-security/file-upload)
- [SSRF](https://portswigger.net/web-security/ssrf)
- [XXE](https://portswigger.net/web-security/xxe)
- [Insecure deserialization](https://portswigger.net/web-security/deserialization)
- [Race conditions](https://portswigger.net/web-security/race-conditions)
