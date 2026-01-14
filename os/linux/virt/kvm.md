# KVM

Kernel-based Virtual Machine

CPU仮想化命令を使って、実行主体の切り替え(VM-Entry/Vm-Exit)をuserspaceから制御できるようにした仕組み

```c
int kvm_fd = open("/dev/kvm", O_RDWR);
// VMの作成
int vm_fd = ioctl(kvm_fd, KVM_CREATE_VM, 0);

// Guest memory
// GPA -> HPAの変換
struct kvm_userspace_memory_region region = {
    .slot = 0,
    .guest_phys_addr = 0x0,
    .memory_size = 512 * 1024 * 1024,
    .userspace_addr = (uint64_t)mem,
};

ioctl(vm_fd, KVM_SET_USER_MEMORY_REGION, &region);

// vCPUを作る
int vcpu_fd = ioctl(vm_fd, KVM_CREATE_VCPU,0);

// Register
// CPUの初期状態を作る
struct kvm_regs regs = {
    .rip = entry_point,
    .rsp = stack,
};

ioctl(vcpu_fd, KVM_SET_REGS, &regs);

// 実行開始
ioctl(vcp_fd, KVM_RUN, 0);

// 制御がもどった理由に応じて処理をemulate
struct kvm_run *run = mmap(...);

switch (run->exit_reason) {
    case KVM_EXIT_MMIO:
    case KVM_EXIT_IO:
    case KVM_EXIT_HLT:
}

```

* `KVM_CREATE_VM`
  * Guest物理アドレス空間の管理単位を作る

## KVM Sample Code

```c
// minimal_kvm_hlt.c
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <linux/kvm.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <unistd.h>

static void die(const char *msg) {
    perror(msg);
    exit(1);
}

int main(void) {
    int kvm_fd = open("/dev/kvm", O_RDWR | O_CLOEXEC);
    if (kvm_fd < 0) die("open /dev/kvm");

    int api = ioctl(kvm_fd, KVM_GET_API_VERSION, 0);
    if (api < 0) die("KVM_GET_API_VERSION");
    if (api != KVM_API_VERSION) {
        fprintf(stderr, "KVM API version mismatch: got %d expected %d\n", api, KVM_API_VERSION);
        return 1;
    }

    int vm_fd = ioctl(kvm_fd, KVM_CREATE_VM, (unsigned long)0);
    if (vm_fd < 0) die("KVM_CREATE_VM");

    // 1 page of guest RAM
    const size_t mem_size = 0x1000;
    uint8_t *mem = mmap(NULL, mem_size, PROT_READ | PROT_WRITE,
                        MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (mem == MAP_FAILED) die("mmap guest mem");

    // Put guest code at GPA 0x0000: just HLT (0xF4)
    mem[0x0000] = 0xF4;

    // Register guest memory: GPA[0..0x1000) -> this userspace address
    struct kvm_userspace_memory_region region = {
        .slot = 0,
        .flags = 0,
        .guest_phys_addr = 0x0000,
        .memory_size = mem_size,
        .userspace_addr = (uint64_t)mem,
    };
    if (ioctl(vm_fd, KVM_SET_USER_MEMORY_REGION, &region) < 0)
        die("KVM_SET_USER_MEMORY_REGION");

    int vcpu_fd = ioctl(vm_fd, KVM_CREATE_VCPU, (unsigned long)0);
    if (vcpu_fd < 0) die("KVM_CREATE_VCPU");

    int run_size = ioctl(kvm_fd, KVM_GET_VCPU_MMAP_SIZE, 0);
    if (run_size < 0) die("KVM_GET_VCPU_MMAP_SIZE");
    struct kvm_run *run = mmap(NULL, run_size, PROT_READ | PROT_WRITE,
                               MAP_SHARED, vcpu_fd, 0);
    if (run == MAP_FAILED) die("mmap kvm_run");

    // Initialize CPU state (real-mode-like defaults are acceptable for this minimal case)
    struct kvm_sregs sregs;
    if (ioctl(vcpu_fd, KVM_GET_SREGS, &sregs) < 0) die("KVM_GET_SREGS");

    // Ensure CS base=0, selector=0 so RIP=0 points to GPA 0.
    sregs.cs.base = 0;
    sregs.cs.selector = 0;

    if (ioctl(vcpu_fd, KVM_SET_SREGS, &sregs) < 0) die("KVM_SET_SREGS");

    struct kvm_regs regs = {
        .rip = 0x0000,
        .rflags = 0x2, // reserved bit must be 1
    };
    if (ioctl(vcpu_fd, KVM_SET_REGS, &regs) < 0) die("KVM_SET_REGS");

    // Run until HLT
    while (1) {
        if (ioctl(vcpu_fd, KVM_RUN, 0) < 0) {
            if (errno == EINTR) continue;
            die("KVM_RUN");
        }

        switch (run->exit_reason) {
            case KVM_EXIT_HLT:
                printf("Guest halted (KVM_EXIT_HLT)\n");
                return 0;

            case KVM_EXIT_FAIL_ENTRY:
                fprintf(stderr, "KVM_EXIT_FAIL_ENTRY: hardware_entry_failure_reason=0x%llx\n",
                        (unsigned long long)run->fail_entry.hardware_entry_failure_reason);
                return 1;

            case KVM_EXIT_INTERNAL_ERROR:
                fprintf(stderr, "KVM_EXIT_INTERNAL_ERROR: suberror=0x%x\n",
                        run->internal.suberror);
                return 1;

            default:
                fprintf(stderr, "Unhandled exit_reason=%d\n", run->exit_reason);
                return 1;
        }
    }
}
```
