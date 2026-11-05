---
type: technical-guide
category: osint
tags: [ctf, osint, geolocation]
---

# Image Geolocation and Chronolocation

## Extract observable clues

- script, language, spelling, phone and domain formats;
- road markings, signs, bollards, plates, driving side;
- transit vehicles, stops, route colors, and street furniture;
- architecture, utilities, terrain, geology, vegetation, and weather;
- shadows, sun direction, season, construction state;
- storefronts, logos, landmarks, and municipal branding.

Separate observation from inference. “Yellow rear plate” is an observation; “United Kingdom” is one hypothesis.

## Reverse image search

Search the complete image, then distinctive crops. Mirror/rotate where appropriate and try multiple engines. Search results can reproduce incorrect captions, so use them to locate primary context.

## Map verification

Compare road geometry, building footprints, sight lines, terrain, sign placement, and street-level imagery. A matching landmark is insufficient if camera geometry contradicts the proposed location.

## Chronolocation

Combine shadow direction/length, weather history, vegetation, event schedules, construction changes, storefront history, satellite imagery dates, and archive captures. State ranges rather than false precision.

## Metadata

EXIF may contain coordinates and timestamps but can be stripped or forged. Check whether metadata agrees with visible evidence and file provenance.

## Source

- [Bellingcat Toolkit](https://bellingcat.gitbook.io/toolkit)
