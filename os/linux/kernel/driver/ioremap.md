# ioremap

* PCI Configuration spaceのBARからdeviceのMemoryMapped I/O 用のアドレスを取得できる
* kernelも仮想アドレスで動いているので、この物理アドレスに直接アクセスできない
* MMIO領域用のmapping設定をしてくれる
  * cacheしない
  * reorderしない

```c
void __iomem *ioremap(resource_size_t phys_addr, size_t size);
```

以下のように物理アドレスを仮想アドレスに変換してからさわる
```c
void __iomem *mmio = ioremap(bar, size);

u32 cap = readl(mmio + AHCI_CAP);
writel(GHC_AE, mmio + AHCI_GHC);
```
