---
type: technical-guide
category: crypto
tags: [ctf, crypto, aes, block-cipher]
---

# Symmetric Cryptography

## Separate primitive from mode

AES transforms one 16-byte block under a key. Modes define how blocks, IVs/nonces, padding, and authentication are composed.

| Mode | Critical property | Common failure |
| --- | --- | --- |
| ECB | Each block independent | Repeated plaintext blocks reveal patterns |
| CBC | XOR with previous ciphertext/IV | Bit flipping, padding oracle, predictable IV |
| CTR | Encrypt counter to keystream | Nonce reuse exposes XOR of plaintexts |
| GCM | CTR plus authentication | Nonce reuse damages confidentiality and authentication |

## ECB detection

Split ciphertext into block-size chunks and count duplicates. Repetition is evidence, not proof; structured plaintext makes it more visible.

## CBC bit flipping

For CBC decryption:

```text
P_i = D_K(C_i) ⊕ C_{i-1}
```

Changing a bit in `C_{i-1}` changes the corresponding bit in `P_i`, while corrupting the previous plaintext block. This enables controlled modification when integrity is absent.

## Padding oracle

If the system reveals whether decrypted padding is valid, chosen modifications to the previous block can recover plaintext byte-by-byte. Distinguish the oracle signal from unrelated failures and handle accidental valid padding.

## CTR/stream nonce reuse

```text
c1 = p1 ⊕ stream
c2 = p2 ⊕ stream
c1 ⊕ c2 = p1 ⊕ p2
```

Nonce uniqueness is mandatory for a fixed key. Predictable nonces may be acceptable in some schemes; repeated nonces are not.

## GCM

GCM authenticates using a polynomial hash. Repeated nonces reuse the counter stream and create algebraic relationships between authentication tags. Exploitation depends on the available messages and chosen-data capabilities.

## Block-size and padding triage

- change input length and observe ciphertext-length steps;
- test whether identical blocks repeat;
- identify IV/nonce location and whether it changes;
- separate encoding from ciphertext;
- determine whether authentication failure differs from padding/decryption failure.

## Sources

- [CryptoHack Symmetric Cryptography](https://cryptohack.org/courses/symmetric/course_details/)
- [Cryptopals Sets 2–4](https://cryptopals.com/)
