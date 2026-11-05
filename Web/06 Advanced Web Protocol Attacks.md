---
type: technical-guide
category: web
tags: [ctf, web, http, advanced]
---

# Advanced Web Protocol Attacks

## Request smuggling model

Request smuggling exists when two HTTP components disagree about message boundaries. Model the chain:

```text
client → CDN/WAF/reverse proxy → application server
```

Compare how each hop handles `Content-Length`, `Transfer-Encoding`, HTTP/2 translation, duplicate headers, whitespace, and malformed syntax. Use timing and controlled response desynchronization before attempting cross-user impact.

## Cache poisoning and deception

### Poisoning

Find an input used by the origin but excluded from the cache key. Confirm:

1. response changes with the input;
2. the response is cacheable;
3. a clean request receives the poisoned variant;
4. cache partitioning and normalization are understood.

### Deception

Find a URL interpreted as sensitive/dynamic by the origin but static/cacheable by an intermediary. Extension and path normalization differences are common causes.

## Host header attacks

Trace Host-derived values into password-reset URLs, routing, cache keys, absolute links, and internal virtual hosts. Consider `Host`, forwarded-host headers, absolute-form requests, and proxy normalization.

## OAuth/OIDC

Map roles: resource owner, client, authorization server, resource server. Validate redirect URI matching, state/nonce binding, code reuse, PKCE, token audience/issuer, and account linking. Many flaws occur in the client application's handling rather than the provider.

## GraphQL

- enumerate schema through introspection or validation errors;
- map object-level authorization at every resolver;
- test aliases and batching against rate limits;
- inspect mutations for mass assignment;
- bound query depth and complexity assumptions.

## WebSockets

Capture the HTTP upgrade and subsequent messages. Test authentication at connection and message level, origin checks, message authorization, reconnection state, and input sinks.

## Sources

- [HTTP request smuggling](https://portswigger.net/web-security/request-smuggling)
- [Web cache poisoning](https://portswigger.net/web-security/web-cache-poisoning)
- [Web cache deception](https://portswigger.net/web-security/web-cache-deception)
- [Host header attacks](https://portswigger.net/web-security/host-header)
- [OAuth](https://portswigger.net/web-security/oauth)
- [GraphQL](https://portswigger.net/web-security/graphql)
- [WebSockets](https://portswigger.net/web-security/websockets)
