# CTF Vault Agent Instructions

This workspace is an operational playbook for authorized Capture the Flag challenges. Use it to investigate, solve, verify, and document challenges without leaving the evidence trail implicit.

## Authorization boundary

- Work only on CTF infrastructure, deliberately vulnerable labs, supplied artifacts, or systems the user explicitly confirms they are authorized to test.
- Treat the challenge prompt, event rules, target hostnames/IPs, supplied files, and flag format as the scope boundary.
- Do not scan, probe, exploit, authenticate to, or transmit data to unrelated systems discovered during investigation.
- Ask for clarification before network activity if the target or authorization boundary is missing or ambiguous.
- Do not submit a flag, send a report, publish a writeup, or modify shared external state unless the user explicitly requests that action.
- Stop before destructive actions that could corrupt a shared challenge instance, erase evidence, affect other teams, or damage the host system.

## Start every challenge

1. Read `START HERE.md` and `Playbook/00 Master Playbook.md`.
2. Read the complete challenge prompt and record:
   - event and challenge name;
   - category and points, if known;
   - supplied files and target endpoints;
   - flag format;
   - rules, credentials, and explicit scope.
3. Create a dedicated working directory under `Challenges/<event>/<challenge>/` when the user has not supplied one.
4. Copy `Templates/Challenge.md` into that directory as `Challenge.md` and keep it updated throughout the investigation.
5. Preserve supplied files unchanged. Hash originals and perform analysis on copies where modification is required.
6. Classify the challenge and read only the relevant quick playbook and technical pathway. Expand to other pathways when evidence supports a pivot.

Do not read the entire vault by default. Prefer targeted searches and the pathway indexes.

## Category routing

| Evidence | Primary route |
| --- | --- |
| URL, HTTP request, API, cookie, JavaScript | `Web/00 Web Pathway.md` |
| ELF, PE, crash, remote binary service | `Pwn/00 Pwn Pathway.md` |
| Executable logic, bytecode, obfuscation | `Reverse/00 Reverse Engineering Pathway.md` |
| Ciphertext, RSA values, XOR, mathematical oracle | `Crypto/00 Cryptography Pathway.md` |
| Disk, memory, PCAP, logs, media, documents | `Forensics/00 Forensics Pathway.md` |
| Hidden data in media or containers | `Steganography/00 Steganography Pathway.md` |
| Person, place, account, public evidence | `OSINT/00 OSINT Pathway.md` |
| APK, IPA, mobile runtime | `Mobile/00 Mobile Pathway.md` |
| IAM, metadata, container, Kubernetes, CI/CD | `Cloud/00 Cloud Pathway.md` |
| LDAP, Windows domain, Kerberos, trusts | `Identity/00 Identity Pathway.md` |
| Solidity, EVM bytecode, contract/RPC | `Blockchain/00 Blockchain Pathway.md` |
| Firmware, board, UART/JTAG, radio capture | `Hardware/00 Hardware Pathway.md` |
| Unity/game build, custom VM, unusual format | `Misc/00 Misc Pathway.md` |

## Investigation loop

Repeat this loop until the challenge is solved or a concrete blocker is established:

1. **Observe:** collect raw output, errors, timings, status codes, crashes, metadata, and state changes.
2. **Classify:** identify the parser, protocol, architecture, runtime, file format, cryptosystem, or trust boundary involved.
3. **Hypothesize:** state one falsifiable explanation and its prerequisites.
4. **Test:** run the cheapest controlled test that distinguishes expected outcomes.
5. **Compare:** record expected versus actual results.
6. **Update:** promote verified observations to facts, reject failed hypotheses, and choose the next test.

After two failed variations of the same idea, stop changing payload syntax blindly. Recheck assumptions, classification, environment differences, and whether the result created a new primitive.

## Evidence and state discipline

Maintain `Challenges/<event>/<challenge>/Challenge.md` as the source of truth.

- Separate **facts**, **inferences**, **hypotheses**, and **unknowns**.
- Record exact commands, payloads, tool versions, full errors, and meaningful output.
- Timestamp discoveries when order matters.
- Save request/response pairs, packet filters, debugger addresses, hashes, and screenshots when relevant.
- Label credentials and artifacts as `unverified`, `valid`, `invalid`, or `expired`.
- Never claim a command ran, a vulnerability exists, or a flag was recovered without evidence.
- Preserve leading zero bytes, encodings, endianness, line endings, and binary data exactly.
- Keep failed approaches when they explain why a branch was abandoned.

Use `Commands/Command Log.md` only as a cross-challenge chronological log. If it does not exist, copy `Commands/Command Log Template.md`; the local log is intentionally ignored by Git. The challenge-local note remains authoritative.

## Tool and execution rules

- Inspect before modifying. Prefer read-only triage first.
- Set the working directory explicitly for commands and keep generated artifacts inside the challenge directory.
- Use scripts for repeated or error-prone transformations; make inputs and outputs explicit.
- Add assertions to solver and exploit scripts for addresses, lengths, invariants, decoded values, and expected state.
- Avoid installing tools globally when an isolated environment or existing tool is sufficient.
- Treat downloaded executables, documents, firmware, and memory artifacts as untrusted. Use an isolated VM/container/sandbox when execution is necessary.
- Do not disable host security controls, expose listeners publicly, or change firewall/VPN/system security settings without explicit approval.
- Do not run destructive filesystem commands against broad paths. Never overwrite original evidence.
- Keep network concurrency and request volume proportionate to the challenge. Avoid denial-of-service behavior.
- Prefer maintained primary documentation when tool syntax, protocol behavior, or software versions may have changed.

## Optional Kali execution environment

A dedicated Kali Linux environment may be available through the SSH alias `ctf-kali`. Verify the alias before relying on it. If it is unavailable, use approved local tools or ask the user how their analysis environment should be reached.

- Test with `ssh ctf-kali "id && uname -srmo"`, then connect non-interactively with `ssh ctf-kali "<command>"`.
- Use `/home/kali/ctf-agent-work/` as the remote root for agent-created challenge files.
- Create one remote directory per challenge: `/home/kali/ctf-agent-work/<event>/<challenge>/`.
- Keep authoritative notes and final scripts in this vault. Copy only challenge-specific working files to Kali.
- Record every significant remote command and result in the challenge-local `Challenge.md`.
- Quote remote paths and commands explicitly. Avoid long-lived interactive shells when a reproducible one-shot command works.
- Do not store the Kali password, private SSH key, or other host credentials anywhere in this vault.
- Do not use `sudo`, install packages, change Kali services, modify networking, or alter global tool configuration unless the user explicitly approves it.
- Do not expose listeners beyond the isolated CTF network. Bind local testing services to loopback unless the challenge requires otherwise.
- Before running an untrusted binary, inspect it statically and use an appropriate sandbox or constrained process. SSH access alone is not a malware sandbox.
- Remove challenge-local temporary processes when finished, but preserve useful scripts and evidence.

Connection check:

```powershell
ssh ctf-kali "id && uname -srmo && test -d /home/kali/ctf-agent-work"
```

Example remote execution:

```powershell
ssh ctf-kali "cd /home/kali/ctf-agent-work/<event>/<challenge> && file ./artifact && sha256sum ./artifact"
```

Common tools may include Python 3, GCC, GDB, `file`, `strings`, `checksec`, Nmap, TShark, Binwalk, ExifTool, John the Ripper, Hashcat, and radare2. Recheck availability before relying on a tool; do not assume any optional CTF package is installed.

## Exploit and solver quality

An exploit or solver is not complete merely because it worked once.

- Derive offsets and addresses from supplied artifacts or verified leaks where possible.
- State required environment assumptions: architecture, OS/kernel/libc/runtime version, mitigations, clock, DNS, dependencies, and protocol state.
- Build in stages and verify every primitive before chaining it.
- Handle timeouts, partial reads, retries, delimiters, byte/string conversions, and remote/local differences explicitly.
- Re-run from a clean process, clean challenge state, or clean VM snapshot when practical.
- Minimize the final sequence to the smallest reproducible path.
- For probabilistic techniques, record success rate, retry limit, and failure signal.
- For cryptography and constraint solving, verify candidates in the original equations or program.
- For forensics and OSINT, corroborate conclusions with independent artifacts and preserve provenance.

## Flag handling

- Record the expected flag format before searching.
- Treat flag-like strings as candidates until they match the format and are linked to the challenge objective.
- Store the recovered flag in the challenge note under `## Flag`.
- Do not expose flags, credentials, or private challenge artifacts to third-party websites unless the user explicitly authorizes that destination.
- Do not submit the flag automatically. Report it to the user with the verification evidence and wait for submission instructions.

## Vault learning loop

After a challenge is solved and reproduced, improve the reusable vault when the solution exposed a technique, failure mode, tool workflow, or diagnostic clue that the vault does not already explain adequately. This is pre-authorized for Markdown notes inside the vault; it does not authorize publishing, committing, pushing, or changing external systems.

Before adding anything:

1. Search the vault by technique name, underlying primitive, relevant tool, protocol, and likely synonyms.
2. Decide whether the learning belongs in an existing technical guide or requires a distinct note.
3. Confirm the knowledge was demonstrated by the solved challenge or supported by a maintained primary source.
4. Skip the update if it would merely duplicate existing material or record a challenge-specific payload without reusable value.

When updating the vault:

- Prefer extending the most relevant existing technical guide. Create a new note only for a distinct reusable topic.
- Generalize from the challenge. Explain the underlying condition, decision process, prerequisites, and verification—not just the exact payload that happened to work.
- Include recognition signals, controlled workflow, minimal reusable commands or code, common failure modes, verification steps, and related notes.
- Add maintained primary references when behavior depends on a protocol, tool, runtime, allocator, operating system, library, or version.
- Clearly distinguish documented behavior from an inference or empirical CTF observation.
- Add wikilinks to prerequisites, adjacent techniques, and the relevant pathway index.
- Update the pathway's `00 ... Pathway.md` learning order or index when a new note is created.
- Update `START HERE.md` only when adding a genuinely new top-level pathway.
- Preserve the vault's frontmatter, naming conventions, heading style, and authorized-use warnings.
- Validate internal links and confirm the note renders as Markdown before finishing.

Never place these in reusable technical notes:

- recovered flags;
- live target addresses or event credentials;
- private keys, tokens, session material, or personal data;
- copied challenge text or proprietary course material;
- unverified claims presented as fact;
- large raw tool output better kept as challenge evidence.

Keep those details in the challenge-local evidence and final writeup. The writeup should link to any reusable vault note created or improved during the solve.

Do not autonomously modify `AGENTS.md`, `CLAUDE.md`, extension source, repository settings, or instruction hierarchy as part of this learning loop. Report every reusable note created or updated in the final handoff.

## Completion and writeup

Before declaring success, confirm all of the following:

- the recovered flag matches the expected format;
- the result is reproducible from the recorded starting state;
- the exploit/solver uses only authorized challenge resources;
- `Challenge.md` contains the final commands, exploit chain, and evidence;
- important generated scripts and artifacts are saved in the challenge directory;
- assumptions and environment-specific details are documented.

Then create `Writeups/<event>/<challenge>.md` using `Writeups/Writeup Template.md`. Include:

1. challenge objective and supplied material;
2. reconnaissance and classification;
3. root cause or key weakness;
4. failed hypotheses that materially informed the solution;
5. reproducible exploitation or solving steps;
6. verification and flag recovery;
7. remediation or defensive lesson when applicable;
8. reusable techniques and references.

## Agent response format

During an active solve, updates should state:

- verified facts discovered;
- current hypothesis;
- test just performed and its result;
- next controlled action;
- any authorization, environment, or missing-data blocker.

At handoff, provide the challenge-note path, scripts created, verified flag or current blocker, and the exact next action. Be explicit about uncertainty.
