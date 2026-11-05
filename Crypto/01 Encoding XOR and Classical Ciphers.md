---
type: technical-guide
category: crypto
tags: [ctf, crypto, encoding, xor]
---

# Encoding, XOR, and Classical Ciphers

## Preserve bytes

Always distinguish text from bytes and bytes from integers:

```python
data = bytes.fromhex('414243')
print(data)
print(data.hex())
print(int.from_bytes(data, 'big'))
```

Encoding layers often reveal themselves through restricted alphabets, padding, and length. Decode one layer at a time and inspect after each transformation.

## XOR identities

```text
x ⊕ 0 = x
x ⊕ x = 0
x ⊕ y ⊕ y = x
```

If `c = p ⊕ k`, then knowing any two recovers the third.

```python
def xor_bytes(left, right):
    return bytes(a ^ b for a, b in zip(left, right))
```

## Single-byte XOR

Try all 256 keys and score candidates for expected language, flag prefix, or printable structure. A printable-only score is weak; use letter/space frequency and common n-grams where possible.

## Repeating-key XOR

1. Estimate key length using normalized Hamming distance or periodic statistics.
2. Transpose bytes by key position.
3. Solve each column as single-byte XOR.
4. Reassemble and score the complete plaintext.

## Reused stream/one-time pad

If two ciphertexts use the same keystream:

```text
c1 ⊕ c2 = p1 ⊕ p2
```

Use known/guessed plaintext fragments to recover corresponding keystream bytes, then propagate across all ciphertexts. Track uncertainty rather than treating guesses as facts.

## Classical-cipher recognition

| Pattern | Candidate |
| --- | --- |
| Alphabet preserved, frequencies shifted | Caesar/substitution |
| Periodic frequency behavior | Vigenère/repeating key |
| Characters rearranged, frequencies unchanged | Transposition |
| Digraph rules and 5×5 square | Playfair |
| Linear transformation of letter blocks | Hill cipher |

Classical ciphers are usually solved through structural/frequency analysis, not modern brute-force tooling.

## Sources

- [CryptoHack Introduction](https://cryptohack.org/courses/intro/)
- [Cryptopals Set 1](https://cryptopals.com/sets/1)
