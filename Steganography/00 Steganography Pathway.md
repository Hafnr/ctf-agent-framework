---
type: pathway
category: steganography
tags: [ctf, steganography, pathway]
---

# Steganography Pathway

## Learning order

1. [[Steganography/01 Image Steganography|Image steganography]]
2. [[Steganography/02 Audio Text and Container Steganography|Audio, text, and container steganography]]

## Layered workflow

1. Preserve and hash the original.
2. Identify the real format and parse its structure.
3. Inspect metadata, comments, thumbnails, and appended data.
4. Extract embedded or concatenated files.
5. Inspect visual/audio channels and transforms.
6. Test format-specific hiding methods.
7. Treat passwords/keys as clues that may unlock a later layer.
8. Record every extraction offset and transformation.

Avoid firing every tool at once. Each tool assumes a hiding method; use file evidence to prioritize.

## Source

- [Trail of Bits CTF Forensics](https://github.com/trailofbits/ctf/blob/master/forensics/README.md)
