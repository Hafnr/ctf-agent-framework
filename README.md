# CTF Obsidian Agent Framework

An Obsidian-compatible CTF knowledge vault and operating framework for human solvers, Codex, Claude Code, and other local terminal agents.

The public repository contains reusable playbooks, technical pathways, challenge templates, agent instructions, and an optional Kali-over-SSH workflow. Real challenge files, flags, credentials, writeups, captures, binaries, and local logs are excluded by default.

## Start here

- Open `START HERE.md` for the complete handbook index.
- Open `00 CTF Dashboard.canvas` for the visual pathway map.
- Open `Playbook/00 Master Playbook.md` for competition triage and routing.
- Read `AGENTS.md` for the end-to-end agent workflow.
- Claude Code automatically imports the same workflow through `CLAUDE.md`.

## Workflow

1. Create `Challenges/<event>/<challenge>/`.
2. Copy `Templates/Challenge.md` to `Challenges/<event>/<challenge>/Challenge.md`.
3. Preserve supplied files under an `original/` directory and work from copies.
4. Record facts, hypotheses, commands, failures, and evidence while solving.
5. Save final scripts inside the challenge directory.
6. Create the final writeup from `Writeups/Writeup Template.md`.
7. Promote only verified, reusable learnings into the technical pathways.

## Agent use

Open the repository as the local workspace and give the agent the authorized target, flag format, challenge path, and event rules. Agents that recognize `AGENTS.md` load it directly. Claude Code loads `CLAUDE.md`, which imports `AGENTS.md`.

Example:

```text
Solve this authorized CTF challenge end to end according to AGENTS.md.

Event: <event>
Challenge: <name>
Category: <category>
Files: Challenges/<event>/<name>/original/
Target: <official target or none>
Flag format: <format>
Scope/rules: <event rules>

Maintain Challenge.md, preserve original evidence, create the final solver or
exploit, verify the flag without submitting it, and produce the final writeup.
```

## Optional Kali environment

The workflow supports an SSH alias named `ctf-kali`. Configure it locally in `~/.ssh/config`; never commit the host address, password, private key, or event credentials. Agents must verify the alias before use and fall back to approved local tools when it is unavailable.

## VS Code extension

The companion Obsidian Vault Panel is maintained separately:

- [Hafnr/obsidian-vault-panel](https://github.com/Hafnr/obsidian-vault-panel)

It provides Markdown previews, wikilink navigation, Canvas preview, and a draggable force-directed graph inside VS Code.

## Privacy model

The root `.gitignore` excludes event workspaces, solved writeups, attachments, global command logs, common binary/capture formats, credentials, agent state, and editor state. Always run `git status --short --ignored` and inspect the staged diff before publishing.

## Status tags

- `#todo` — not started
- `#investigating` — active lead
- `#blocked` — missing information or access
- `#solved` — flag captured

## Authorized use

Use offensive techniques only on CTF infrastructure, deliberately vulnerable labs, or systems you have explicit permission to test.

## License

MIT. See `LICENSE`.
