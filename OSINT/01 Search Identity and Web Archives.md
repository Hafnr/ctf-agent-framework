---
type: technical-guide
category: osint
tags: [ctf, osint, search, archives]
---

# Search, Identity, and Web Archives

## Query construction

- exact phrase: `"distinctive phrase"`
- domain restriction: `site:example.com term`
- file type: `filetype:pdf term`
- title/URL: `intitle:term`, `inurl:term`
- exclusions: `term -irrelevant`

Search engines index different content and personalize results. Record engine, query, date, and relevant result position.

## Username/email pivots

Treat matching usernames as leads, not identity proof. Compare creation dates, writing style, avatars, linked domains, timezone/activity patterns, reused repository metadata, and mutual references.

## Domain and infrastructure

Inspect DNS records, certificate transparency, WHOIS/RDAP history where lawful, archived pages, source repositories, favicon/hash reuse, and public service banners. Shared hosting and reused templates create false associations.

## Archives

Use the Wayback Machine and other archives to recover removed pages, earlier site structure, files, robots rules, and historical contact details. A missing snapshot may reflect crawl exclusions rather than absence.

## Repository history

Commits, branches, tags, issues, releases, and deleted-file history may preserve clues. Verify author identity separately; Git commit names and emails are self-asserted.

## Evidence table

| Claim | Source URL | Captured | Independent confirmation | Confidence |
| --- | --- | --- | --- | --- |
| | | | | |
