---
type: technical-guide
category: steganography
tags: [ctf, steganography, audio, text]
---

# Audio, Text, and Container Steganography

## Audio workflow

```bash
file audio.wav
exiftool audio.wav
ffprobe audio.wav
soxi audio.wav
```

Inspect:

- left/right channels separately and their difference;
- waveform, spectrogram, and phase;
- reversed, slowed, or accelerated versions;
- sample LSBs for uncompressed PCM;
- data after the logical container end;
- DTMF, Morse, SSTV, FSK, or modem-like signals.

Spectrogram parameters matter. Try different FFT sizes, windows, and frequency ranges before concluding nothing is present.

## Text steganography

- zero-width and directional Unicode;
- whitespace width, tabs, and trailing spaces;
- homoglyphs and mixed scripts;
- capitalization, punctuation, acrostics, and nth-character patterns;
- line lengths or formatting differences;
- encoded data in comments or metadata.

```python
from collections import Counter
text = open('message.txt', 'r', encoding='utf-8').read()
print(Counter(f'U+{ord(ch):04X}' for ch in text if ch.isspace() or ord(ch) > 127))
```

## Container and polyglot hiding

Files may be concatenated, nested, or valid under multiple parsers. Inspect signatures at nonzero offsets and parse declared lengths. ZIP-based documents, PDFs, and media containers can carry attachments or unused fields.

## Password-protected layers

Before brute force, search challenge text, metadata, filenames, comments, visible content, and previous layers for a key. CTFs usually provide a clue or constrained keyspace.
