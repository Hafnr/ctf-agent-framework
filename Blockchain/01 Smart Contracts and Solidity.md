---
type: technical-guide
category: blockchain
tags: [ctf, blockchain, solidity, evm]
---

# Smart Contracts and Solidity

## Reconstruct the challenge state

Record compiler version/settings, proxy pattern, contract addresses, chain ID, funded account, ABI, constructor arguments, storage state, and the win predicate. Read setup/deployer contracts first: they define ownership, initial balances, and what “solved” means.

```bash
cast chain-id --rpc-url "$RPC_URL"
cast code "$TARGET" --rpc-url "$RPC_URL"
cast storage "$TARGET" 0 --rpc-url "$RPC_URL"
cast call "$TARGET" 'owner()(address)' --rpc-url "$RPC_URL"
```

Use a local fork or isolated challenge chain for experiments. Decode each transaction, logs, revert data, value, caller, and state difference.

## EVM execution model

- `msg.sender`, `tx.origin`, and `address(this)` are different identities.
- Calls can transfer control to untrusted code; state may be re-entered before the original call finishes.
- `call` preserves caller storage context? No: ordinary `call` uses callee storage; `delegatecall` executes callee code in caller storage.
- Storage layout is slot-based; mappings and dynamic arrays derive locations by hashing.
- Arithmetic in Solidity 0.8+ checks overflow by default, except inside `unchecked`.
- A transaction is atomic, but ordering and block-producer influence still matter.

## Audit checklist by invariant

1. **Authorization:** Who may call each state-changing function? Can initialization occur twice? Does `tx.origin` or a controllable callback influence trust?
2. **Accounting:** Do internal balances equal assets? Are shares calculated before/after deposits? Can rounding, donation, fee-on-transfer, or decimal mismatch break the invariant?
3. **External calls:** Is state finalized before control leaves? Can callbacks re-enter another function sharing state?
4. **Call semantics:** Are return values checked? Can `delegatecall` overwrite proxy storage? Is the implementation/init/admin slot correct?
5. **Signatures:** Is domain separation correct? Are nonce, chain ID, contract, deadline, and action bound? Can signatures replay or malleate?
6. **Oracle/time/order:** Can spot price, timestamp, block ordering, flash liquidity, or stale data change a decision?
7. **Creation/destruction:** Are CREATE/CREATE2 addresses or code-existence assumptions controllable?

## Test-driven exploit development

Write a local test that begins from deployment, performs only actions available to the player, and asserts the exact solve condition.

```solidity
function testSolve() public {
    vm.startPrank(player);
    // minimal sequence
    vm.stopPrank();
    assertTrue(setup.isSolved());
}
```

Log balances/storage after every call. If the exploit depends on reentrancy, implement a receiver contract and label the callback sequence. If it depends on storage collision, calculate and verify exact slots. If it depends on a signature, reconstruct the digest byte-for-byte.

## Common false conclusions

- “Private” Solidity storage is secret—it is only inaccessible through normal source syntax.
- A reverted low-level call changed state—a full revert unwinds its state changes.
- Source matches deployed code—verify bytecode, proxy implementation, and compiler metadata.
- Any profitable local sequence works remotely—confirm chain state, nonce, gas, balance, and transaction ordering.

## Related

- [[Crypto/05 Hashes MACs and PRNGs|Hashes, MACs, and PRNGs]]
- [[Web/08 Deserialization and Race Conditions|Deserialization and race conditions]]

## Primary references

- [Solidity security considerations](https://docs.soliditylang.org/en/latest/security-considerations.html)
- [Solidity storage layout](https://docs.soliditylang.org/en/latest/internals/layout_in_storage.html)
- [Ethereum smart-contract security](https://ethereum.org/en/developers/docs/smart-contracts/security/)
- [Ethereum execution environment](https://ethereum.org/en/developers/docs/evm/)
