# kthreadd

* kthread 作成担当 kthread
* task_structは親をcopyする方式なので、作りたい側が直接作らず、専用threadに移譲している
