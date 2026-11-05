---
type: technical-guide
category: hardware
tags: [ctf, hardware, firmware, uart, jtag, sdr]
---

# Firmware, UART/JTAG, and SDR

## Firmware triage

Hash the image, inspect entropy and strings, identify CPU/endian format, and look for headers, filesystems, compressed streams, certificates, configuration, and update metadata.

```bash
sha256sum firmware.bin
file firmware.bin
binwalk firmware.bin
binwalk -E firmware.bin
strings -a -n 6 firmware.bin | less
xxd -l 512 firmware.bin
```

Automatic extraction is a hypothesis. Validate every carved offset and magic value, then mount/extract read-only where possible. Search recovered files for init scripts, web roots, credentials, update verification, device nodes, debug flags, and architecture-specific binaries. Load raw code into Ghidra only after determining base address, CPU mode, and endianness.

## Board-interface safety

Photograph both board sides and record chip markings. With power disconnected, identify ground and likely headers. Measure target logic voltage; never assume 5 V or power the target from two sources. Use a logic analyzer or high-impedance adapter first.

### UART

UART typically needs GND, target TX, and optional target RX. Determine voltage and baud by observing idle level and bit timing. Try common frame settings only after measurement. Capture the full boot log and look for bootloader interruption, console authentication, recovery mode, and kernel command line.

```bash
picocom -b 115200 /dev/ttyUSB0
```

Do not connect adapter TX until voltage and pins are confirmed. Garbled output usually means wrong baud, inverted logic, voltage mismatch, wrong ground, or a non-UART interface.

### JTAG/SWD

JTAG commonly exposes TCK, TMS, TDI, TDO and reset; SWD uses SWCLK/SWDIO. Pin count alone is not proof. Identify the SoC, expected debug interface, reset behavior, and whether fuses/locks disable access.

```bash
openocd -f interface/<adapter>.cfg -f target/<target>.cfg
arm-none-eabi-gdb firmware.elf
(gdb) target extended-remote :3333
```

Start with identification and halt/read operations. Avoid flash erase/write commands unless the CTF explicitly requires them and a recovery image exists.

## SDR workflow

Work from a provided capture whenever possible. Record sample rate, center frequency, gain, timestamp, and data type. Plot waterfall/spectrum, identify occupied bandwidth and burst timing, estimate modulation, then recover framing, symbol timing, preamble, encoding, whitening, checksum, and payload.

```python
import numpy as np
x = np.fromfile('capture.c64', dtype=np.complex64)
print(len(x), np.mean(np.abs(x)), np.max(np.abs(x)))
```

Compare hypotheses against repeated bursts. A decoder is credible when it explains preamble, length, checksum, and multiple packets—not merely one readable substring. Do not transmit unless the event explicitly authorizes the frequency, power, and environment.

## Related

- [[Reverse/05 Anti-Analysis and Unpacking|Anti-analysis and unpacking]]
- [[Forensics/01 File Formats and Carving|File formats and carving]]
- [[Steganography/02 Audio Text and Container Steganography|Audio, text, and container steganography]]

## Primary references

- [OpenOCD user guide](https://openocd.org/doc/html/)
- [GNU Radio documentation](https://wiki.gnuradio.org/index.php/Documentation)
- [GDB remote debugging](https://sourceware.org/gdb/current/onlinedocs/gdb.html/Remote-Debugging.html)
