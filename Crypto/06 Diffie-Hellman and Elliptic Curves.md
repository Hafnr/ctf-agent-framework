---
type: technical-guide
category: crypto
tags: [ctf, crypto, dh, ecc]
---

# Diffie–Hellman and Elliptic Curves

## Diffie–Hellman

In a group with generator `g`:

```text
A = g^a
B = g^b
shared = B^a = A^b = g^(ab)
```

DH provides a shared secret but not authentication by itself. A man-in-the-middle can establish separate secrets unless public values are authenticated.

## DH failure modes

- attacker-controlled `g` or weak group parameters;
- public value not validated;
- small subgroup confinement;
- smooth group order enabling Pohlig–Hellman;
- reused/weak private exponent;
- downgrade to weak/export parameters;
- failure to bind transcript and identities to key derivation.

## Elliptic-curve model

ECC uses points under a group law. Scalar multiplication `Q = dG` is efficient; recovering `d` from `Q` should be hard in a suitable group.

## Point validation

Validate that received points:

- lie on the intended curve;
- are not the point at infinity where forbidden;
- have appropriate subgroup order;
- are encoded canonically.

Missing validation can enable invalid-curve or small-subgroup attacks.

## ECDSA nonce reuse

ECDSA signature component `s` depends on per-signature nonce `k`. Reusing `k` for two messages can reveal `k`, then the private key. Biased or partially leaked nonces may be recoverable with lattice methods.

## Curve-parameter clues

- anomalous curves may permit Smart's attack;
- small embedding degree may permit pairing/MOV reduction;
- smooth group order weakens discrete log;
- custom curves demand much more scrutiny than standard validated parameters.

## Sources

- [CryptoHack Elliptic Curves](https://cryptohack.org/courses/elliptic/course_details/)
- [CryptoHack Public-Key course](https://cryptohack.org/courses/public-key/course_details/)
