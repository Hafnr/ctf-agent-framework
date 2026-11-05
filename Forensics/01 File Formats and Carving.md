---
type: technical-guide
category: forensics
tags: [ctf, forensics, file-format, carving]
---

# File Formats and Carving

## Initial triage

```bash
sha256sum artifact
file artifact
xxd -l 256 artifact
strings -a -n 6 artifact | less
exiftool artifact
binwalk artifact
```

Trust signatures and internal structure more than the extension.

## Structure questions

- Does the header match the claimed format?
- Are declared lengths and offsets valid?
- Is there data before the header or after the logical end marker?
- Are multiple file signatures embedded?
- Is the file truncated, concatenated, or polyglot?
- Are unused fields carrying data?

## Carving

Carving recovers content by signatures and structure rather than filesystem metadata. Validate carved outputs; false positives are common in compressed or random-looking data.

```bash
foremost -i image.bin -o carved
binwalk -eM firmware.bin
```

Do not repeatedly run recursive extraction without tracking provenance. Record the parent offset of every useful child artifact.

## Archives

```bash
7z l archive
unzip -l archive.zip
zipinfo archive.zip
zipdetails -v archive.zip | less
```

Check nested archives, comments, filenames, timestamps, encryption method, CRC errors, and path traversal names. Repair tools may alter evidence; work on a copy.

## Container formats

OOXML (`docx`, `xlsx`, `pptx`), APK/JAR, EPUB, and many firmware formats are containers. Extract them and inspect relationships, manifests, resources, macros, and embedded objects.

## Source

- [Trail of Bits CTF Forensics](https://github.com/trailofbits/ctf/blob/master/forensics/README.md)
