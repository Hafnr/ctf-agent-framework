---
type: technical-guide
category: crypto
tags: [ctf, crypto, mathematics]
---

# Number Theory Toolkit

## Euclidean and extended Euclidean algorithms

`gcd(a,b)` determines shared factors. Extended GCD finds `x,y` such that:

```text
ax + by = gcd(a,b)
```

When `gcd(a,n)=1`, `x mod n` is the modular inverse of `a`.

```python
from math import gcd
inverse = pow(a, -1, n)
```

## Modular exponentiation

Use `pow(base, exponent, modulus)`, which avoids constructing the enormous unmodded power.

## Chinese Remainder Theorem

CRT combines congruences with pairwise coprime moduli into one solution modulo their product. In CTFs it appears in broadcast attacks, residue reconstruction, and multi-prime systems.

```python
def crt(remainders, moduli):
    total = 0
    product = 1
    for modulus in moduli:
        product *= modulus
    for remainder, modulus in zip(remainders, moduli):
        partial = product // modulus
        total += remainder * partial * pow(partial, -1, modulus)
    return total % product
```

## Integer roots

Floating-point roots are unsafe for large integers. Use exact integer-root functions and verify by exponentiation.

## Quadratic residues

The Legendre symbol tests whether a nonzero value has a square root modulo an odd prime. Tonelli–Shanks computes roots for general odd primes. Remember that modular square roots usually come in pairs.

## Factoring clues

- primes too close together → Fermat factorization;
- shared factor across moduli → pairwise GCD;
- smooth `p-1` or `p+1` → specialized methods;
- leaked bits/structure → lattice or Coppersmith-style small-root methods;
- very small modulus → conventional factorization.

## Source

- [CryptoHack Modular Arithmetic](https://cryptohack.org/courses/modular/course_details/)
