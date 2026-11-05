---
type: pathway
category: web
tags: [ctf, web, pathway]
---

# Web Exploitation Pathway

## Learning order

1. [[Web/01 HTTP Recon and State|HTTP, recon, and application state]]
2. [[Web/02 Authentication and Access Control|Authentication and access control]]
3. [[Web/03 Injection Techniques|Injection techniques]]
4. [[Web/04 Server-Side Vulnerabilities|Server-side vulnerabilities]]
5. [[Web/05 Client-Side Vulnerabilities|Client-side vulnerabilities]]
6. [[Web/06 Advanced Web Protocol Attacks|Advanced protocol attacks]]
7. [[Web/07 GraphQL and WebSockets|GraphQL and WebSockets]]
8. [[Web/08 Deserialization and Race Conditions|Deserialization and race conditions]]
9. [[Web/09 Request Smuggling and Cache Poisoning|Request smuggling and cache poisoning]]
10. [[Web/10 SSRF XXE JWT OAuth and SAML|SSRF, XXE, JWT, OAuth, and SAML]]

## Core model

Treat a web application as a state machine:

```text
request + identity + server state → routing → parsing → authorization
                                → business logic → data access → response
```

A useful test changes one input while keeping the other variables constant. Compare status, headers, length, body, timing, and server-side effects.

## Competition checklist

- [ ] Map hosts, paths, methods, parameters, content types, cookies, and redirects.
- [ ] Save a normal request for every important operation.
- [ ] Identify trust boundaries: browser/server, proxy/backend, app/database, app/internal network.
- [ ] Compare anonymous, normal-user, and privileged behavior.
- [ ] Trace each input to its likely sink.
- [ ] Confirm with the smallest harmless proof before escalating.
- [ ] Preserve the final request/response and required application state.

## Primary curriculum

- [PortSwigger Web Security Academy topics](https://portswigger.net/web-security/all-topics)
- [PortSwigger detailed materials](https://portswigger.net/web-security/all-materials/detailed)
- [PayloadsAllTheThings](https://github.com/swisskyrepo/PayloadsAllTheThings)
