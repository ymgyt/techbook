# TCP Handshake

1. SYN

```text
Source Port:      53124
Destination Port: 443
Sequence Number:  1000
Ack Number:       0
Flags:            SYN
Window Size:      65535
Options:
  MSS=1460
  WindowScale=7
  SACK Permitted
  Timestamp=...
```

2. SYN ACK

```text
Source Port:      443
Destination Port: 53124
Sequence Number:  5000
Ack Number:       1001
Flags:            SYN, ACK
Window Size:      65535
Options:
  MSS=1448
  WindowScale=8
  SACK Permitted
  Timestamp=...
```

3. ACK

```text
Source Port:      53124
Destination Port: 443
Sequence Number:  1001
Ack Number:       5001
Flags:            ACK
Window Size:      ...
```
