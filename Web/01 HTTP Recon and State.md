---
type: technical-guide
category: web
tags: [ctf, web, http, recon]
---

# HTTP Recon and Application State

## Establish a baseline

For every meaningful request, record:

| Layer | Questions |
| --- | --- |
| Transport | HTTP/1.1, HTTP/2, TLS, alternate ports? |
| Routing | Host header, path, method, proxy prefix, virtual host? |
| Parsing | Query, form, JSON, XML, multipart, cookies? |
| Identity | Session cookie, bearer token, CSRF token, role? |
| State | What must happen first? What changes afterward? |
| Response | Status, headers, body length, cache behavior, timing? |

```bash
curl -isk https://target.example/
curl -isk -X OPTIONS https://target.example/api/
curl -isk https://target.example/robots.txt
curl -isk https://target.example/.well-known/security.txt
```

Use `-v` when connection details matter and `--path-as-is` when testing path normalization. Never infer application behavior from one status code alone; redirects and custom error pages often hide the true result.

## Discovery workflow

1. Browse normally while recording traffic.
2. Read HTML comments and every referenced JavaScript bundle.
3. Search scripts for endpoints, parameter names, roles, GraphQL operations, source maps, and secrets.
4. Identify API documentation and schema endpoints.
5. Compare `GET`, `POST`, `HEAD`, and `OPTIONS` only where appropriate.
6. Look for alternate hosts in certificates, redirects, CSP, CORS, and JavaScript configuration.
7. Build a compact endpoint table instead of an unfiltered wordlist dump.

## State-difference testing

Create two accounts when allowed. Capture the same operation as each account and compare:

- identifiers in path, query, body, and token claims;
- cookies and anti-CSRF values;
- hidden fields and client-only restrictions;
- response fields that differ by role;
- whether object ownership is checked server-side.

## JavaScript review targets

Search for:

```text
fetch( axios graphql mutation query /api/ admin role token secret
innerHTML outerHTML document.write eval setTimeout postMessage
```

Client code is evidence of intended routes and data flow, not evidence that the server enforces the same rules.

## Troubleshooting

| Symptom | Likely cause |
| --- | --- |
| Repeater request fails but browser succeeds | Missing cookie, CSRF token, Origin/Referer, or prerequisite state |
| All unknown paths return 200 | Soft-404 or frontend router |
| Same body but different timing | Backend branch, cache, or blind operation |
| Parameter seems ignored | Wrong content type, duplicate parameter precedence, or nested parser syntax |

## Source

- [PortSwigger essential skills](https://portswigger.net/web-security/essential-skills)
- [Burp documentation](https://portswigger.net/burp/documentation)
