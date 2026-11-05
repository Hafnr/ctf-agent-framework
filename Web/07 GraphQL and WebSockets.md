---
type: technical-guide
category: web
tags: [ctf, web, graphql, websocket]
---

# GraphQL and WebSockets

## GraphQL triage

Locate endpoints in JavaScript, network history, mobile clients, error messages, and common paths such as `/graphql`. Record whether requests use GET/POST, JSON, multipart upload, persisted-query hashes, batching, or a named operation.

```http
POST /graphql HTTP/1.1
Content-Type: application/json

{"query":"query { __typename }"}
```

Test authorization on resolved objects, not only whether introspection works. If introspection is enabled in the CTF, enumerate types and arguments; if disabled, use observed client queries, validation errors, and field suggestions without flooding the service.

## GraphQL testing matrix

| Surface | Controlled test |
| --- | --- |
| Object authorization | request another object's stable ID with the same field set |
| Field authorization | add sensitive fields to an otherwise authorized object |
| Mutations | change ownership/role/price/target identifiers independently |
| Aliases/batching | determine whether limits and authorization apply per operation |
| Variables | test type coercion, null/list/object boundaries, duplicate keys |
| Depth/complexity | use a small nested query and observe limits; avoid denial of service |
| Uploads | inspect filename, MIME, storage path, and authorization |
| Subscriptions | verify authentication at connect and authorization per event |

Example introspection probe:

```graphql
query SchemaBasics {
  __schema { queryType { name } mutationType { name } }
}
```

When testing IDOR/BOLA, change one identifier at a time and preserve the original response. A `200` response containing GraphQL `errors` is not application success.

## WebSocket model

A WebSocket begins with an HTTP upgrade, then carries frames over a persistent connection. Capture the handshake, `Origin`, cookies/tokens, subprotocol, extensions, and the first client/server messages. Determine whether messages are JSON, a GraphQL subprotocol, binary, or custom framing.

```text
GET /socket HTTP/1.1
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Key: <random base64>
Sec-WebSocket-Version: 13
Origin: https://expected.example
```

Test these boundaries:

1. Connect without credentials, with expired credentials, and with a different user's credentials.
2. Modify object/channel/room identifiers inside messages.
3. Replay actions and change message ordering.
4. Test whether logout or role change invalidates an existing socket.
5. Verify server-side authorization for every message, not merely the handshake.
6. Compare browser `Origin` enforcement with non-browser clients.

For GraphQL subscriptions, identify the negotiated protocol (`graphql-transport-ws` or legacy variants) and treat connection initialization, subscription creation, and emitted event filtering as distinct authorization decisions.

## Failure diagnosis

- HTTP works but socket fails: wrong subprotocol, Origin, proxy upgrade handling, or initialization message.
- Modified message is ignored: unknown sequence ID, required prior state, or binary/compressed framing.
- GraphQL query “succeeds” with no data: inspect the `errors` array and null propagation.
- Introspection blocked: recover operations from front-end bundles and observed traffic.

## Related

- [[Web/01 HTTP Recon and State|HTTP recon and state]]
- [[Web/02 Authentication and Access Control|Authentication and access control]]
- [[Web/06 Advanced Web Protocol Attacks|Advanced web protocol attacks]]

## Primary references

- [GraphQL security guidance](https://graphql.org/learn/security/)
- [GraphQL specification](https://spec.graphql.org/)
- [RFC 6455: WebSocket protocol](https://www.rfc-editor.org/rfc/rfc6455)
