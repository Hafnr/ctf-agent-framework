---
type: technical-guide
category: forensics
tags: [ctf, forensics, image, audio, document]
---

# Media and Document Analysis

## Images

- inspect metadata, dimensions, color model, channels, palette, alpha, and thumbnails;
- examine trailing bytes and chunk structure;
- separate frames/layers/pages;
- compare histograms/channels and bit planes;
- inspect visually at extreme brightness/contrast only as a clue, not proof.

## Audio

- metadata and container/codec;
- waveform and channel differences;
- spectrogram at multiple FFT sizes;
- reversed or speed-shifted playback;
- DTMF, Morse, SSTV, FSK, and other signal encodings;
- data appended to or embedded within PCM samples.

## PDFs

Inspect objects, streams, xref structure, attachments, JavaScript, forms, metadata, incremental updates, and hidden/overlaid content. Rendering is only one interpretation of the object graph.

## Office documents

For OOXML, extract the ZIP container and inspect relationships, document XML, comments, tracked changes, embedded objects, external links, macros, and custom XML. Legacy OLE documents require OLE-aware tooling.

## Common commands

```bash
exiftool artifact
pdfid.py document.pdf
pdf-parser.py document.pdf
unzip -l document.docx
olevba suspicious.doc
ffprobe media
```

## Next pathway

If the artifact appears to intentionally conceal data, continue with [[Steganography/00 Steganography Pathway]].
