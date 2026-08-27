# irq_sim

* 通常はdeviceの電気的割り込み、CPU割り込み処理、Kernel IRQ 処理、driver handler
  * kernel IRQ 処理にソフトウェア的に参加する仕組み
  * kernel IRQ core を通じたhandler 呼び出しをやりたい

## `irq_chip`

* kernelからirq 関連hardwareを制御するvtable


## IRQ のmock(trigger)

* `generic_handle_irq_safe()` を呼ぶ


## Example

```c
static int irq;

struct fake_controller {
    bool masked;
};

static struct fake_controller controller;

static void fake_mask(struct irq_data *data)
{
    controller.masked = true;
}

static void fake_unmask(struct irq_data *data)
{
    controller.masked = false;
}

static struct irq_chip fake_chip = {
    .name = "fake",
    .irq_mask = fake_mask,
    .irq_unmask = fake_unmask,
};

static int fake_controller_init(void)
{
    irq = irq_alloc_desc(NUMA_NO_NODE);
    if (irq < 0)
        return irq;

    irq_set_chip_and_handler(
        irq,
        &fake_chip,
        handle_simple_irq
    );

    return 0;
}

void fake_irq_fire(void)
{
    if (!controller.masked)
        generic_handle_irq_safe(irq);
}
```

## References

* [simulated interrutps](https://lwn.net/Articles/729430/)
