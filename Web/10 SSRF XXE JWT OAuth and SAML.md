---
type: technical-guide
category: web
tags: [ctf, web, ssrf, xxe, jwt, oauth, saml]
---

# SSRF, XXE, JWT, OAuth, and SAML

## SSRF

Find server-side fetchers: URL previews, imports, webhooks, image/PDF conversion, proxy endpoints, feed readers, and cloud integrations. Establish whether the server performs DNS resolution, follows redirects, changes methods, preserves headers, and returns content or only timing/status.

Test a controlled URL first. Then map parser and policy boundaries: scheme, userinfo, IPv4/IPv6 representation, redirect revalidation, hostname normalization, DNS rebinding resistance, and destination checks after resolution. For blind SSRF, use a CTF-provided callback service and correlate unique tokens. Do not scan unrelated networks.

## XXE

Confirm XML parsing through content types, uploads, SVG/office formats, SOAP, or error messages. Determine whether DTDs and external entities are enabled and which parser/runtime is involved.

```xml
<?xml version="1.0"?>
<!DOCTYPE root [<!ENTITY probe "controlled">]>
<root>&probe;</root>
```

Start with an internal entity. Only use an external entity against a challenge-controlled resource after confirming scope. Distinguish classic external entities, parameter entities, XInclude, XSLT, and entity expansion; mitigations differ.

## JWT

Parse the three base64url sections without treating decoded claims as trusted. Record algorithm, key ID/header parameters, issuer, audience, subject, expiry/not-before, and where the token is accepted.

```python
import base64, json
def dec(s):
    return json.loads(base64.urlsafe_b64decode(s + '=' * (-len(s) % 4)))
h, p, sig = token.split('.')
print(dec(h), dec(p))
```

Test verifier behavior: accepted algorithms, algorithm/key-type confusion, missing-signature handling, key selection (`kid`, `jku`, `x5u`) and trust boundaries, claim validation, token replay, and key rotation. Never conclude from a locally modified token; the server must accept it.

## OAuth/OIDC

Draw actors and exact redirects: resource owner, browser, client, authorization server, token endpoint, and resource server. Capture `client_id`, registered redirect URI, response type/mode, scopes, state, nonce, PKCE challenge, code, and issuer.

Check redirect URI matching, authorization-code binding to client/redirect/PKCE, state/nonce validation, login CSRF, account-linking confusion, scope enforcement, token audience/issuer, mix-up between issuers, and leakage via URLs/referrers. OAuth delegates authorization; OIDC adds identity claims—do not interchange their tokens or validation rules.

## SAML

Preserve the raw base64/DEFLATE/XML and map identity provider, service provider, ACS URL, entity IDs, audience, recipient, `InResponseTo`, timestamps, and signed elements. Security decisions must be derived from the element actually covered by a valid signature.

Check signature location/coverage, duplicate IDs and wrapping ambiguity, canonicalization, destination/audience/recipient validation, replay, certificate trust, and whether an unsigned outer assertion can override signed data. Use a namespace-aware XML view and verify which node the application consumes.

## Related

- [[Web/02 Authentication and Access Control|Authentication and access control]]
- [[Cloud/01 Cloud Identity and Metadata|Cloud identity and metadata]]
- [[Identity/01 Active Directory and Kerberos|Active Directory and Kerberos]]

## Primary references

- [OWASP SSRF prevention](https://cheatsheetseries.owasp.org/cheatsheets/Server_Side_Request_Forgery_Prevention_Cheat_Sheet.html)
- [OWASP XXE prevention](https://cheatsheetseries.owasp.org/cheatsheets/XML_External_Entity_Prevention_Cheat_Sheet.html)
- [RFC 8725: JWT best current practices](https://www.rfc-editor.org/rfc/rfc8725)
- [RFC 9700: OAuth 2.0 security best current practice](https://www.rfc-editor.org/rfc/rfc9700)
- [OASIS SAML 2.0 technical overview](https://docs.oasis-open.org/security/saml/Post2.0/sstc-saml-tech-overview-2.0.html)
