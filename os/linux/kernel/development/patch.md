# Patch

* `Message-ID`, `In-Reply-To` 等は [RFC5322 Internet Message Format](https://datatracker.ietf.org/doc/html/rfc5322) で定められている


## Headers

* `Message-ID`
  * messageの識別子

* `In-Reply-To`
  * messageの返信対象
  * `git send-email --thread` で自動付与

* `References`
  * threadを特定？ここがよくわからず
  * `git send-email --thread` で自動付与


## `git send-email`

### `--no-chain-reply-to`

2通目以降は1通目(cover)への返信になる

```text
cover
├─ patch 1
├─ patch 2
└─ patch 3

patch 1:
  In-Reply-To: <cover>
  References: <cover>

patch 2:
  In-Reply-To: <cover>
  References: <cover>

patch 3:
  In-Reply-To: <cover>
  References: <cover>
```


### `--chain-reply-to`


```text
cover
└─ patch 1
   └─ patch 2
      └─ patch 3

patch 1:
  In-Reply-To: <cover>
  References: <cover>

patch 2:
  In-Reply-To: <p1>
  References: <cover> <p1>

patch 3:
  In-Reply-To: <p2>
  References: <cover> <p1> <p2>
```
