---
type: technical-guide
category: web
tags: [ctf, web, authentication, access-control]
---

# Authentication and Access Control

## Separate the questions

- **Authentication:** who are you?
- **Session management:** how is that identity maintained?
- **Authorization:** may this identity perform this action on this object?
- **Business logic:** should this sequence of valid actions be allowed?

## Authentication test matrix

| Area | Controlled tests |
| --- | --- |
| Username discovery | Compare status, message, length, and timing for known/unknown users |
| Password policy | Check truncation, normalization, Unicode, and inconsistent endpoints |
| Rate limiting | Determine scope: IP, account, session, endpoint, or global |
| MFA | Test alternate flows, recovery, state reuse, and direct navigation |
| Password reset | Token entropy, expiry, single use, host handling, account binding |
| Remember-me | Token construction, revocation, rotation, and device binding |

Do not brute-force unless the CTF explicitly expects it. First look for logic flaws that reduce the search space or bypass the control.

## Session analysis

- Decode structured tokens without assuming the signature is invalid.
- Check cookie scope: `Domain`, `Path`, `Secure`, `HttpOnly`, `SameSite`.
- Test whether login, logout, password change, or role change rotates the session.
- Verify server-side invalidation rather than relying on browser deletion.
- Compare claims with actual server authorization.

### JWT reasoning

1. Parse header and claims.
2. Identify the expected algorithm and key source.
3. Test validation assumptions: algorithm confusion, missing signature, weak secret, key selection, claim enforcement.
4. Confirm `exp`, `nbf`, `aud`, `iss`, and subject binding.

Changing a claim is not a finding unless the server accepts the modified token.

## Access-control matrix

Build a matrix rather than testing randomly:

| Endpoint/action | Anonymous | User A own object | User A other object | Admin |
| --- | --- | --- | --- | --- |
| Read | | | | |
| Update | | | | |
| Delete | | | | |

Test identifiers in paths, query strings, JSON keys, GraphQL variables, headers, and nested objects. Try method and content-type variations only after a baseline is understood.

## Business-logic sequence

Model the intended states, then attempt:

- skipping a required step;
- repeating a one-time action;
- changing values after validation;
- submitting steps out of order;
- racing two valid operations;
- mixing state from two users or sessions.

## Sources

- [PortSwigger authentication](https://portswigger.net/web-security/authentication)
- [PortSwigger access control](https://portswigger.net/web-security/access-control)
- [PortSwigger business logic](https://portswigger.net/web-security/logic-flaws)
- [PortSwigger JWT attacks](https://portswigger.net/web-security/jwt)
