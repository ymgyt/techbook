# spin lock

* `spin_lock()`: 割り込みの状態を変えずにlock
* `spin_lock_irq()`: 割り込みを無効化してlock
  * `spin_unlock_irq()`: で必ず割り込みが有効化する
* `spin_lock_irqsave(flags)`: 現在の割り込みの状態をflagsに保存して割り込みを無効化してlock
