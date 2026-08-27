# irq_domain

* systemには複数の Interrupt Controller がいる
* Controller 内でのsource 識別子をhwirq という
* 複数 controller でのhwirq をすべてmergeして一意の識別子にしたものが irq number
* この対応表instance が `irq_domain`
* `irq_chip` の実装として、IRQ -> hwirq の変換も必要になる。このmapping 処理を提供するのが `irq_domain` layer

```text
 Controller A               Linux
 hwirq 0  ────────────────→ IRQ 37
 hwirq 1  ────────────────→ IRQ 42

 Controller B
 hwirq 0  ────────────────→ IRQ 51
 hwirq 1  ────────────────→ IRQ 53
```

## References

* [The irq_domain Interrupt Number Mapping Library](https://docs.kernel.org/core-api/irq/irq-domain.html)
