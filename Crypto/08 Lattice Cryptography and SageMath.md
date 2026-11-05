---
type: technical-guide
category: crypto
tags: [ctf, crypto, lattice, sage, lll]
---

# Lattice Cryptography and SageMath

## Recognize a lattice problem

Typical signals are approximate integer relations, hidden small values, modular equations with bounded errors, biased/partially known nonces, truncated outputs, polynomial congruences, knapsack-style sums, or an RSA root known to be small.

Do not begin with LLL. First write the exact relation, modulus, unknowns, and bounds. A lattice attack succeeds only if a short vector representing the desired relation is unusually short compared with alternatives.

## Core objects

A lattice basis is a matrix whose integer row combinations form the lattice. `LLL` produces a shorter, more orthogonal basis; it does not directly “decrypt.” Scaling encodes the relative importance of equations and bounds.

```sage
B = Matrix(ZZ, [
    [q, 0, 0],
    [a, 1, 0],
    [b, 0, 1],
])
R = B.LLL()
for row in R.rows():
    print(row)
```

Always inspect row/column orientation and verify candidate vectors in the original equations.

## CTF workflow

1. Derive an integer equation; remove modular ambiguity with explicit multiples of `q`.
2. Bound every unknown and estimate bit sizes.
3. Construct a basis where the desired solution maps to a short vector.
4. Scale columns so different coordinates have comparable expected magnitude.
5. Apply `LLL()`; use stronger reduction only if justified.
6. Interpret several short rows, not only the first.
7. Verify candidates in the original cryptosystem.

### Approximate relation pattern

For values resembling `a_i*x + e_i = b_i (mod q)` with small `e_i`, the unknown and error bounds guide the embedding. If the unknown is not substantially smaller than the modulus or there are too few samples, the chosen lattice may not separate the target vector.

### Small-root pattern

For a polynomial `f(x) = 0 mod N` with a bounded root, use Sage's small-root support only after making the polynomial monic where required and checking the theoretical size bound.

```sage
P.<x> = PolynomialRing(Zmod(N))
f = (known + x)^e - c
roots = f.small_roots(X=2^unknown_bits, beta=1.0)
```

### Partial nonce/signature pattern

Convert each signature equation into a modular relation involving the private key and a small nonce error. Keep sign conventions and modular inverses explicit. Test recovered keys by regenerating the public key or verifying signatures.

## SageMath precision traps

- Use `ZZ`, `Zmod(q)`, `GF(p)`, and polynomial rings intentionally.
- Convert modular elements to centered integer representatives when building integer lattices.
- Avoid silent real-number approximations in an exact derivation.
- Record Sage version, basis, scaling factor, and expected bounds.
- A reduced vector is a hypothesis until it satisfies the original equations.

## Related

- [[Crypto/02 Number Theory Toolkit|Number theory toolkit]]
- [[Crypto/03 RSA Attacks|RSA attacks]]
- [[Crypto/06 Diffie-Hellman and Elliptic Curves|Diffie-Hellman and elliptic curves]]

## Primary references

- [SageMath lattice cryptography module](https://doc.sagemath.org/html/en/reference/cryptography/sage/crypto/lattice.html)
- [SageMath matrix reduction](https://doc.sagemath.org/html/en/reference/matrices/sage/matrix/matrix_integer_dense.html)
- [SageMath polynomial small roots](https://doc.sagemath.org/html/en/reference/polynomial_rings/sage/rings/polynomial/polynomial_modn_dense_ntl.html)
