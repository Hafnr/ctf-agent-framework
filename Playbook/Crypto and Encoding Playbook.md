---
type: playbook
category: crypto
tags: [ctf, crypto, encoding]
---

# Crypto and Encoding Playbook

## Classify first

- Encoding changes representation; encryption relies on a key; hashing is one-way by design.
- Record alphabet, length, repeated blocks, padding, entropy, and whether output changes between runs.
- Preserve leading zero bytes and exact byte order.

| Signal | Likely direction |
| --- | --- |
| Hex characters and even length | Hex decode |
| Base64 alphabet with optional `=` | Base64 decode |
| Readable text after single-byte changes | XOR or substitution |
| Repeated fixed-size blocks | Block cipher mode clue |
| `n`, `e`, `c`, primes | RSA |
| Nonce/IV/key reuse | Stream or block-mode weakness |
| Many related outputs | Oracle, reused randomness, or algebraic relation |

## Workflow

1. Decode obvious outer layers.
2. Convert everything to explicit bytes or integers.
3. Write down the mathematical equation.
4. Identify the broken assumption: weak randomness, reused nonce, small exponent, shared factor, bad padding, short key, or oracle.
5. Validate on a toy value before applying it to the challenge.
6. Re-encode the recovered bytes exactly as the flag expects.

## Python byte helpers

```python
from Crypto.Util.number import bytes_to_long, long_to_bytes

x = bytes.fromhex("414243")
n = bytes_to_long(x)
print(long_to_bytes(n))
```

## Best references

- [CryptoHack courses](https://cryptohack.org/courses/)
- [CTF101 cryptography](https://ctf101.org/cryptography/overview/)
- [CyberChef](https://gchq.github.io/CyberChef/)
- [CyberChef source](https://github.com/gchq/CyberChef)
