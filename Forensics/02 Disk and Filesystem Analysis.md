---
type: technical-guide
category: forensics
tags: [ctf, forensics, disk, filesystem]
---

# Disk and Filesystem Analysis

## Preserve and identify

```bash
sha256sum disk.img
mmls disk.img
fsstat -o SECTOR_OFFSET disk.img | less
```

Partition offsets are usually expressed in sectors. Confirm sector size before converting to byte offsets.

## Sleuth Kit workflow

```bash
# List files recursively, including deleted entries where supported.
fls -r -o OFFSET disk.img

# Recover a file by metadata address/inode.
icat -o OFFSET disk.img META_ADDRESS > recovered.bin

# Generate a body file for timeline tooling.
fls -r -m / -o OFFSET disk.img > bodyfile.txt
```

## Investigation areas

- user profiles and home directories;
- shell and command history;
- browser history, downloads, cookies, and local storage;
- logs, scheduled jobs, services, and persistence;
- repositories and deleted files;
- application databases and configuration;
- unallocated space and filesystem journals;
- mounted volumes, containers, and virtual disks.

## Timeline reasoning

Different timestamps mean different things and may be modified independently. Normalize timezone, identify clock skew, and correlate filesystem times with logs/application data.

## Mounting

Prefer read-only mounting with explicit offset and filesystem type. Do not allow the host OS to repair or journal-replay an evidence image.

## Autopsy

Autopsy provides indexed browsing, keyword search, hash sets, timeline views, and artifact extraction over Sleuth Kit. Use it to accelerate review, but preserve command-level evidence for key findings.

## Sources

- [The Sleuth Kit documentation](https://sleuthkit.org/sleuthkit/docs.php)
- [Autopsy documentation](https://sleuthkit.org/autopsy/docs/user-docs/)
