---
type: technical-guide
category: web
tags: [ctf, web, injection]
---

# Injection Techniques

## General injection method

1. Identify the parser or interpreter likely receiving the value.
2. Establish a normal response.
3. Introduce a syntax boundary with the smallest possible change.
4. Look for errors, boolean differences, timing changes, or out-of-band effects.
5. Determine context before choosing syntax.
6. Build a minimal proof, then extract only what the challenge requires.

## SQL injection

### Recognition

- quote changes behavior;
- boolean expressions create stable response differences;
- sort/order parameters influence query structure;
- database errors disclose syntax or engine;
- time delay is repeatable and proportional.

### Decision tree

```text
Visible query result?
├─ yes → UNION/error-based after finding column count and types
└─ no  → stable true/false difference?
        ├─ yes → boolean blind
        └─ no  → repeatable timing or out-of-band channel?
```

Always identify the database family before using engine-specific functions. Parameterization prevents data from becoming query syntax; filtering quotes alone does not.

## NoSQL injection

Look for JSON operator injection, type confusion, query-selector syntax, and inconsistent parsing between URL-encoded and JSON bodies. Test whether a scalar can become an object or array.

## Command injection

Distinguish:

- argument injection into a safely executed program;
- shell metacharacter injection;
- unsafe interpolation into a script;
- environment or path manipulation.

Use a harmless observable command or controlled delay for confirmation. Account for OS, shell, quoting context, and whether output is returned.

## Server-side template injection

1. Determine whether input is rendered or merely reflected.
2. Use arithmetic probes appropriate to candidate engines.
3. Fingerprint using syntax differences, not one payload.
4. Map accessible objects and sandbox boundaries.
5. Stop at a safe proof unless further access is required by the CTF.

## XPath, LDAP, and expression languages

The same method applies: identify grammar, escape the current literal or expression, create a boolean oracle, then enumerate structure. Error messages and type coercion are often more valuable than large payload lists.

## Sources

- [PortSwigger SQL injection](https://portswigger.net/web-security/sql-injection)
- [PortSwigger NoSQL injection](https://portswigger.net/web-security/nosql-injection)
- [PortSwigger command injection](https://portswigger.net/web-security/os-command-injection)
- [PortSwigger SSTI](https://portswigger.net/web-security/server-side-template-injection)
- [PayloadsAllTheThings](https://github.com/swisskyrepo/PayloadsAllTheThings)
