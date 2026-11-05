---
type: playbook
category: web
tags: [ctf, web]
---

# Web Playbook

## Map before attacking

- [ ] Browse every visible path and inspect HTML, JavaScript, comments, and source maps.
- [ ] Record methods, parameters, cookies, roles, redirects, and content types.
- [ ] Check `robots.txt`, common metadata files, and linked JavaScript bundles.
- [ ] Use the browser network panel or an intercepting proxy to establish a baseline request.
- [ ] Identify the framework, templating language, database clues, and reverse proxy.
- [ ] Test authorization with two accounts when the challenge permits it.

## Input decision tree

| Observation | Test family |
| --- | --- |
| Input appears in HTML or JavaScript | Context-aware XSS |
| Input changes a database lookup | SQL/NoSQL injection |
| Input becomes a file path | Traversal, local-file inclusion |
| Input appears in server-rendered templates | SSTI |
| Server fetches a supplied URL | SSRF |
| Structured XML is accepted | XXE |
| Object IDs select other users' data | IDOR / access control |
| Upload is parsed or served | Upload validation and parser behavior |
| Signed token controls identity | JWT validation and claim handling |

## Controlled workflow

1. Capture a normal request and response.
2. Change one variable only.
3. Compare status, length, body, headers, and timing.
4. Confirm the behavior with a harmless proof.
5. Escalate only as far as the flag requires.
6. Save the final raw request and response.

## Useful inspection commands

```bash
curl -isk https://target.example/
curl -isk -X OPTIONS https://target.example/api/
curl -isk https://target.example/robots.txt
```

## Coverage checklist

- [ ] Authentication and password-reset logic
- [ ] Session fixation, cookie flags, logout invalidation
- [ ] Horizontal and vertical access control
- [ ] SQL and NoSQL injection
- [ ] Path traversal and file inclusion
- [ ] Command injection
- [ ] Server-side request forgery
- [ ] Template injection
- [ ] File upload handling
- [ ] XSS, CSRF, CORS, and DOM sinks
- [ ] API mass assignment, hidden fields, GraphQL introspection
- [ ] Deserialization, race conditions, cache behavior

## Best references

- [PortSwigger Web Security Academy topics](https://portswigger.net/web-security/all-topics)
- [PortSwigger learning paths](https://portswigger.net/web-security/learning-paths)
- [PayloadsAllTheThings](https://github.com/swisskyrepo/PayloadsAllTheThings)
- [HackTricks web methodology](https://book.hacktricks.wiki/en/network-services-pentesting/pentesting-web/index.html)
