---
type: playbook
category: forensics
tags: [ctf, forensics]
---

# Forensics Playbook

## Preserve and identify

```bash
sha256sum <artifact>
file <artifact>
exiftool <artifact>
binwalk <artifact>
strings -a -n 6 <artifact> | less
```

- [ ] Work from a copy and record its hash.
- [ ] Trust file signatures and structure more than extensions.
- [ ] Check metadata, timestamps, comments, thumbnails, alternate streams, and appended data.
- [ ] Establish a timeline before chasing isolated indicators.

## By artifact

### PCAP

- Start with protocol hierarchy, endpoints, conversations, DNS, HTTP, and exported objects.
- Follow suspicious streams and compare timestamps across protocols.
- Use display filters to narrow; preserve the original capture.

### Disk or filesystem

- Mount read-only when possible.
- Inspect deleted files, browser history, shell history, logs, scheduled tasks, and archives.
- Normalize timestamps and note the timezone.

### Memory

- Use Volatility 3 for current work.
- Begin with OS identification, processes, parent/child relationships, command lines, network state, loaded modules, and suspicious memory regions.
- Dump a process or file only after recording why it is suspicious.

### Images and documents

- Check metadata, embedded objects, layers, macros, relationships, fonts, and trailing bytes.
- Unzip container formats such as OOXML rather than treating them as opaque files.

## Best references

- [Volatility 3 documentation](https://volatility3.readthedocs.io/en/latest/)
- [Wireshark User's Guide](https://www.wireshark.org/docs/wsug_html_chunked/)
- [CTF101 forensics](https://ctf101.org/forensics/overview/)
