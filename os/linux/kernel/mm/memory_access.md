# Memory Access

```text
Memory Access (virtual address)
                            │
                            ▼
                      ┌──────────┐
                      │   TLB    │
                      └────┬─────┘
                           │
       ┌───────────────────┴───────────────────┐
       │                                       │
      Hit                                    Miss
       │                                       │
       │                                       ▼
       │                            ┌─────────────────────┐
       │                            │   Page table walk   │
       │                            │     (hardware)      │
       │                            └──────────┬──────────┘
       │                                       │
       │                   ┌───────────────────┴───────────────────┐
       │                   │                                       │
       │               Present=1                               Present=0
       │           (page is mapped)                        (page not mapped)
       │                   │                                       │
       │                   ▼                                       ▼
       │             Cache in TLB                             PAGE FAULT
       │                   │                               (trap to kernel)
       │                   │                                       │
       │                   │                       ┌───────────────┴───────────────┐
       │                   │                       │                               │
       │                   │                Valid access                    Invalid access
       │                   │              (demand paging)                   (bad pointer)
       │                   │                       │                               │
       │                   │                       ▼                               ▼
       │                   │             ┌───────────────────┐                 SIGSEGV
       │                   │             │ 1. Allocate frame │                 (crash)
       │                   │             │ 2. Zero the page  │
       │                   │             │ 3. Update page    │
       │                   │             │    table entry    │
       │                   │             └─────────┬─────────┘
       │                   │                       │
       │                   │                       ▼
       │                   │               Return to userspace
       │                   │                       │
       │                   │                       ▼
       │                   │                 Retry access
       │                   │                       │
       ▼                   ▼                       ▼
  ┌─────────────────────────────────────────────────────┐
  │                    Access memory                    │
  └─────────────────────────────────────────────────────┘
```
