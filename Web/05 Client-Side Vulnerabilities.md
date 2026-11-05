---
type: technical-guide
category: web
tags: [ctf, web, client-side, xss]
---

# Client-Side Vulnerabilities

## XSS is a context problem

Trace input to the exact browser parser:

| Context | Important boundary |
| --- | --- |
| HTML text | Element creation and entity encoding |
| HTML attribute | Quote state, attribute type, URL behavior |
| JavaScript string | String delimiter and script parsing |
| Template literal | Backticks and expression interpolation |
| URL | Scheme and downstream decoding |
| CSS | Property grammar and browser support |
| DOM sink | Runtime transformation before insertion |

Do not judge by seeing characters reflected. Inspect the resulting DOM and execution context.

## DOM source-to-sink workflow

1. Identify controllable sources: URL, fragment, referrer, `postMessage`, storage.
2. Trace transformations and sanitizers.
3. Identify sinks such as `innerHTML`, `outerHTML`, `document.write`, dynamic script creation, or string-to-code functions.
4. Determine whether the value reaches the sink in a usable form.
5. Confirm with a minimal visible effect.

## CSRF

CSRF requires a state-changing request that the browser can issue with ambient credentials. Evaluate token binding, SameSite behavior, method/content type, Origin/Referer validation, and whether the action needs secrets unavailable cross-origin.

## CORS

Test the server's response to controlled `Origin` values. Important failures include reflection of arbitrary origins, trusting `null`, weak suffix matching, and credentialed access. A permissive header matters only if sensitive data or actions become readable cross-origin.

## postMessage

Review both sender and receiver:

- Does the receiver validate `event.origin` exactly?
- Does it validate message structure and types?
- Does message data reach a dangerous DOM sink?
- Does the sender use a restrictive target origin?

## Prototype pollution

Find recursive merge or path-assignment behavior that accepts attacker-controlled property names. Then find a gadget: application behavior that reads the polluted inherited property in a security-sensitive sink.

## Sources

- [Cross-site scripting](https://portswigger.net/web-security/cross-site-scripting)
- [DOM-based vulnerabilities](https://portswigger.net/web-security/dom-based)
- [CSRF](https://portswigger.net/web-security/csrf)
- [CORS](https://portswigger.net/web-security/cors)
- [Prototype pollution](https://portswigger.net/web-security/prototype-pollution)
