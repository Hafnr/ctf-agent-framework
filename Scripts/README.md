# Live attack-path updater

`Update-AttackPath.ps1` updates a challenge's Obsidian Canvas before and after each meaningful agent test. It writes three local files:

- `attack-path.canvas` - live visual attack tree;
- `attack-events.jsonl` - append-only event journal;
- `LIVE Attack Status.md` - Obsidian note embedding the live Canvas.

The script records activity but does not execute attacks. Open `LIVE Attack Status.md` in Obsidian while the agent works.

```powershell
& "Scripts/Update-AttackPath.ps1" `
  -ChallengeDir "Challenges/HNF/example" `
  -Id "AP-01" `
  -Hypothesis "User-controlled input reaches the return address" `
  -Test "Send a cyclic pattern and inspect the crash" `
  -Status in-progress
```

Call it again after the test:

```powershell
& "Scripts/Update-AttackPath.ps1" `
  -ChallengeDir "Challenges/HNF/example" `
  -Id "AP-01" `
  -Hypothesis "User-controlled input reaches the return address" `
  -Test "Send a cyclic pattern and inspect the crash" `
  -Result "RIP contained the cyclic-pattern offset" `
  -Evidence "evidence/gdb-crash.txt" `
  -Status confirmed
```

For a child branch, pass `-Parent AP-01`. The script calculates its depth from the parent node.
