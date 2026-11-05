---
type: technical-guide
category: crypto
tags: [ctf, crypto, hash, mac, prng]
---

# Hashes, MACs, and PRNGs

## Hash properties

- preimage resistance: given `h`, finding `m` with `H(m)=h` is hard;
- second-preimage resistance: given `m`, finding a different collision is hard;
- collision resistance: finding any pair with the same hash is hard.

Password hashing additionally needs salt and deliberate cost. Fast general-purpose hashes are inappropriate for password storage.

## Length extension

Merkle–Damgård hashes such as MD5, SHA-1, and SHA-256 expose a final state that can continue hashing when used naively as:

```text
MAC = H(secret || message)
```

An attacker who guesses secret length may compute a valid hash for `secret || message || glue_padding || extension`. HMAC is designed to avoid this construction flaw.

## MAC distinction

Encryption does not imply integrity. A MAC authenticates a message under a secret key; a digital signature provides public verification. Verify what bytes are covered and whether parsing is canonical.

## PRNG state attacks

Questions:

1. Is the generator cryptographically secure?
2. How much output reveals internal state?
3. Is the seed low entropy or derived from time/PID?
4. Are truncated outputs still sufficient to recover state?
5. Can state transitions be inverted or predicted?

For Mersenne Twister, enough full outputs allow state cloning because the tempering operation is invertible. It is not a cryptographic generator.

## Hash-cracking workflow

- identify likely algorithm from context and length, not length alone;
- determine whether salt, encoding, iteration count, or pepper exists;
- build a challenge-relevant candidate set before broad brute force;
- use masks/rules based on observed password construction;
- validate recovered input through the target application.

## Sources

- [Cryptopals Set 4](https://cryptopals.com/sets/4)
- [CryptoHack hash challenges](https://cryptohack.org/challenges/hashes/)
