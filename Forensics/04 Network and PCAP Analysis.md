---
type: technical-guide
category: forensics
tags: [ctf, forensics, pcap, wireshark]
---

# Network and PCAP Analysis

## Triage order

1. Capture properties and duration.
2. Protocol hierarchy.
3. Endpoints and conversations.
4. DNS queries and resolutions.
5. HTTP/TLS and transferred objects.
6. Authentication, remote access, and unusual protocols.
7. Timeline correlated with other evidence.

## Useful display filters

```text
dns
http
http.request
tcp.stream eq 0
ip.addr == 10.0.0.5
tcp.flags.syn == 1 && tcp.flags.ack == 0
tcp.analysis.retransmission
tls.handshake
```

Display filters do not change the capture; capture filters determine what was collected.

## tshark patterns

```bash
tshark -r capture.pcapng -q -z io,phs
tshark -r capture.pcapng -q -z endpoints,ip
tshark -r capture.pcapng -q -z conv,tcp
tshark -r capture.pcapng -Y dns -T fields -e frame.time -e ip.src -e dns.qry.name
```

## Stream analysis

Follow TCP/UDP streams, but remember that one application transaction may span connections and one connection may contain many transactions. Reassembly, retransmission, and out-of-order delivery can affect raw packet interpretation.

## Object extraction

Wireshark can export objects for supported protocols. Record the stream and request that produced each object, then hash extracted files.

## Encrypted traffic

Possible routes include supplied TLS key logs, server private keys for compatible legacy exchanges, session secrets from memory, application-layer keys, or endpoint artifacts. Encryption does not hide metadata such as timing, sizes, endpoints, and many handshake fields.

## Sources

- [Wireshark User's Guide](https://www.wireshark.org/docs/wsug_html_chunked/)
- [Wireshark display filters](https://www.wireshark.org/docs/dfref/)
