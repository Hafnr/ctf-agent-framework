---
type: technical-guide
category: web
tags: [ctf, web, request-smuggling, cache-poisoning]
---

# Request Smuggling and Cache Poisoning

> [!danger] Shared-state risk
> Desynchronization and poisoning can affect other users. Use only the isolated CTF target and cache-busted resources specified by the challenge.

## Build the proxy-chain model

Record client protocol, edge/CDN, reverse proxy, application server, connection reuse, HTTP/2 downgrading, and cache layers. Request smuggling requires an interpretation disagreement; cache poisoning requires harmful response variance from an input absent from the cache key.

## Request-boundary analysis

For HTTP/1.1, compare how each hop treats `Content-Length`, `Transfer-Encoding`, duplicated headers, whitespace/obfuscation, malformed chunks, and connection reuse. Classic labels describe which hop honors which length:

- **CL.TE**: front end uses `Content-Length`; back end uses chunked framing.
- **TE.CL**: front end uses chunked framing; back end uses `Content-Length`.
- **TE.TE**: both claim TE support but one fails to recognize an obfuscated header.

HTTP/2 does not use chunked transfer coding, but downgrade to HTTP/1.1 can introduce ambiguous reconstructed requests. Distinguish response queue poisoning, request tunneling, client-side desync, and ordinary pipelining.

## Safe confirmation workflow

1. Send a normal baseline through the exact same connection path.
2. Use a timing or self-contained differential probe designed for the suspected variant.
3. Repeat with fresh connections and cache-busting identifiers.
4. Confirm a second request is affected, ideally one you control.
5. Only then test a minimal challenge-specific impact.

A delay alone is not proof. False positives arise from backend latency, keep-alive, pipelining, rate limiting, and proxy retries. Verify boundary shift across paired requests.

## Cache-key analysis

Map which request components select the stored response:

```text
method + scheme? + host? + path + query? + selected headers/cookies?
```

Observe `Age`, `Via`, `X-Cache`, `Cache-Control`, `Vary`, stable response markers, and whether errors/redirects are cached. Use a unique cache buster for every experiment.

Test candidate unkeyed inputs one at a time: forwarded host/scheme headers, alternate host headers, path normalization, query parsing, method override, and headers reflected into HTML, redirects, imports, or script URLs. Prove:

1. the input changes the origin response;
2. the response is cached;
3. a clean request with the same cache key receives it;
4. the effect is scoped to the CTF objective.

Cache deception is different: it tricks a cache into storing a victim's private response under an apparently cacheable path. Write down whether you are poisoning shared content or exposing private content.

## Related

- [[Web/01 HTTP Recon and State|HTTP recon and state]]
- [[Web/06 Advanced Web Protocol Attacks|Advanced web protocol attacks]]
- [[Web/07 GraphQL and WebSockets|GraphQL and WebSockets]]

## Primary references

- [PortSwigger request-smuggling research](https://portswigger.net/research/request-smuggling)
- [RFC 9112: HTTP/1.1 message parsing](https://www.rfc-editor.org/rfc/rfc9112)
- [RFC 9111: HTTP caching](https://www.rfc-editor.org/rfc/rfc9111)
- [PortSwigger web cache poisoning](https://portswigger.net/web-security/web-cache-poisoning)
