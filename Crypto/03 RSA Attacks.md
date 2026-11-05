---
type: technical-guide
category: crypto
tags: [ctf, crypto, rsa]
---

# RSA Attacks

## Correct RSA model

```text
n = p q
φ(n) = (p-1)(q-1)
d = e⁻¹ mod φ(n)
c = mᵉ mod n
m = cᵈ mod n
```

Secure RSA also requires correct padding and parameter generation. Textbook RSA is deterministic and algebraically malleable.

## Fast triage

- factor `n` if small or structurally weak;
- compute `gcd` between every supplied modulus;
- inspect `e`, number of ciphertexts, and whether messages/moduli repeat;
- test exact integer roots when `m^e < n` may hold;
- look for leaked `p`, `q`, `φ(n)`, `d`, CRT values, or partial bits;
- determine padding/signature scheme and oracle behavior.

## Common attacks

### Shared prime

```python
from math import gcd
p = gcd(n1, n2)
if 1 < p < n1:
    q1 = n1 // p
```

### Small public exponent without wraparound

If `c = m^e` as an integer because it never wrapped modulo `n`, take the exact integer `e`-th root.

### Hastad broadcast

The same unpadded message encrypted under the same small `e` to enough pairwise-coprime moduli can be reconstructed with CRT, then exact-rooted.

### Common modulus

If the same `n` and message use coprime exponents `e1,e2`, Bézout coefficients can combine ciphertexts to recover the message. Handle negative coefficients with modular inverses.

### Wiener

An unusually small private exponent can be recovered from continued fractions of `e/n`. Verify candidates by reconstructing valid factors.

### Oracle attacks

Parity, padding, or error/timing oracles may reveal plaintext iteratively. Model exactly what one oracle query reveals and update the candidate interval or search state accordingly.

### Signature mistakes

Check whether verification parses padding strictly, validates the complete encoded message, binds the correct hash algorithm, and rejects malformed structure.

## Solver checks

- `pow(m,e,n) == c` after recovery;
- recovered factors multiply to `n`;
- decoded bytes preserve leading zeros where format requires;
- padding removal follows the actual scheme, not ad hoc stripping.

## Sources

- [CryptoHack Public-Key Cryptography](https://cryptohack.org/courses/public-key/course_details/)
- [Cryptopals Set 6](https://cryptopals.com/sets/6)
