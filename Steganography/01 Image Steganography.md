---
type: technical-guide
category: steganography
tags: [ctf, steganography, image]
---

# Image Steganography

## PNG

PNG is chunk-based. Check chunk order, declared lengths, CRCs, ancillary chunks, data after `IEND`, unusual dimensions, palette/transparency, and decompressed scanline data.

```bash
pngcheck -v image.png
exiftool image.png
binwalk image.png
zsteg -a image.png
```

`zsteg` enumerates many bit/channel orders; validate any output against structure or expected flag format because false positives are common.

## Bit planes and LSB

For each color/alpha channel, inspect individual bit planes. A hidden payload may use:

- one or more least significant bits;
- selected channels only;
- row/column or reversed traversal;
- pixel-coordinate permutations;
- a key-derived order;
- payload length/header preceding data.

```python
from PIL import Image

image = Image.open('image.png').convert('RGB')
bits = []
for red, green, blue in image.getdata():
    bits.append(red & 1)

data = bytes(
    sum(bits[index + bit] << (7 - bit) for bit in range(8))
    for index in range(0, len(bits) - 7, 8)
)
print(data[:100])
```

## JPEG

JPEG is lossy and organized around markers and DCT coefficients. Check EXIF/comments, thumbnails, appended data after EOI (`FF D9`), coefficient-domain hiding, and known steganography tools. Pixel LSB assumptions appropriate for PNG do not transfer directly to JPEG.

```bash
jpeginfo -c image.jpg
exiftool image.jpg
steghide info image.jpg
```

## Visual transforms

- separate RGBA channels;
- compare channel differences;
- inspect alpha independently;
- invert, threshold, rotate, mirror, and examine borders;
- inspect animated frames and frame differences;
- look for QR/barcodes at alternate contrast or scale.

Transformations should be driven by visible/statistical clues and preserved in your notes.
