# irq_chip

* kernel から見える Interrupt controller
* このvtable を通じて割り込みをmaskしたりackしたりする
* `include/linux/irq.h`
* `irq_chip` -> controller driver -> MMIO -> interrupt controller
