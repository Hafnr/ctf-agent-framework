---
type: technical-guide
category: identity
tags: [ctf, active-directory, kerberos, ldap, windows]
---

# Active Directory and Kerberos

> [!warning] Domain scope
> Run enumeration and authentication only against the event's domain controllers and hosts. Domain protocols generate shared logs and lockouts.

## Build the domain map

Record your current user/computer, domain DNS name, domain SID, DCs, time source, forest/trusts, reachable ports, and whether you have a password, NT hash, Kerberos key, ticket, certificate, or token.

```powershell
whoami /all
whoami /fqdn
set USERDNSDOMAIN
nltest /dsgetdc:example.local
klist
Get-ADDomain
Get-ADForest
```

Kerberos is time-sensitive and SPN-driven. Fix DNS and clock problems before interpreting authentication failures.

## Kerberos mental model

1. AS exchange: client obtains a ticket-granting ticket (TGT) from the KDC.
2. TGS exchange: the TGT requests a service ticket for an SPN.
3. AP exchange: the client presents that ticket to the service.

The ticket contains authorization data including a Windows PAC. The service account's key protects the service ticket; the `krbtgt` key protects TGTs. Distinguish a ticket from its session key and cache format.

## Enumeration by question

| Question | Objects/edges to inspect |
| --- | --- |
| Who controls this user/group/computer? | ACL owner, GenericAll/Write, membership, delegated rights |
| Which accounts expose crackable material? | SPNs, pre-auth settings, managed/service accounts—within CTF rules |
| Where can this identity log on/administer? | sessions, local groups, remote-management rights |
| Can authentication be relayed/delegated? | protocol signing/channel binding, delegation settings, SPNs |
| Can certificates authenticate identities? | templates, enrollment rights, EKUs, mappings, CA trust |
| Can one domain reach another? | trust direction/type, SID filtering, selective authentication |

Use LDAP queries and native tools first; graph collectors help visualize but their edges must be verified against actual ACLs and configuration.

## Credential and ticket discipline

- Label secrets by type: plaintext, NT hash, AES key, TGT, service ticket, certificate/private key.
- Record principal, domain, source, acquisition time, expiration, and validation result.
- Avoid password spraying unless explicitly designed by the challenge; lockouts waste shared state.
- Use a new logon session or isolated cache when testing tickets so ambient credentials do not mask failure.
- After each pivot, rerun `whoami /all`, `klist`, and an authorization check on the intended resource.

## Common failure meanings

- `KRB_AP_ERR_SKEW`: clock difference.
- `KDC_ERR_S_PRINCIPAL_UNKNOWN`: incorrect/missing SPN or wrong realm.
- Ticket exists but access denied: authentication succeeded; authorization did not.
- Works by IP but not hostname—or reverse: SPN/DNS/protocol fallback differs.
- LDAP bind succeeds but query fails: base DN, signing/channel binding, or permissions.

## Evidence-driven path

Represent every proposed path as `principal --verified right--> object --effect--> new capability`. Do not accept a graph edge as exploitable until you can name the protocol action, prerequisites, and resulting security context. Prefer reversible changes and record anything modified in the directory.

## Primary references

- [Microsoft Active Directory protocols overview](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-adod)
- [Microsoft Kerberos authentication overview](https://learn.microsoft.com/en-us/windows-server/security/kerberos/kerberos-authentication-overview)
- [RFC 4120: Kerberos V5](https://www.rfc-editor.org/rfc/rfc4120)
- [Microsoft LDAP protocol specification](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-adts/)
