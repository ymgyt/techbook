# tokio runtime

## Multi threaded runtime

* A multi thread runtime has a fixed number of worker threads, which are all created on startup(固定のworker threadを起動時に作成する)

* The multi thread runtime maintains one global queue, and a local queue for each worker thread. (global queueとworker threadごとにlocal queueがある)

  * The local queue of a worker thread can fit at most 256 tasks. If more than 256 tasks are added to the local queue, then half of them are moved to the global queue to make space.(256 taskのcapasityをもち、それ以上あるとglobal queueに半分が移される)

  * The runtime will prefer to choose the next task to schedule from the local queue, and will only pick a task from the global queue if the local queue is empty,or if it has picked a task from the local queue global_queue_interval times in a row. If the value of(local queueを優先するが、local queueが空か、閾値回数、連続してlocal queueから取得した場合にglobal queueから取得する)
    * If both the local queue and global queue is empty, then the worker thread will attempt to steal tasks from the local queue of another worker thread. Stealing is done by moving half of the tasks in one local queue to another local queue.(local queueとglobal queueが空の場合、他のworker threadのlocal queueの半分をstealする)

* LIFO slo optimizationという特別枠があるらしいがよくわかっていない

### fairness gurantee

以下の条件を満たす場合

* runtimeのいかなる時でも、taskの合計が超過しない`MAX_TASKS`がある
* いかなる`poll`でも必ずそれ以内に終了する`MAX_SCHEDULE` time unitがある

taskがwokenされてから再びsheduleされるまでの時間が`MAX_DELEAY`以内であることが保証される


* 参考
  * [tokio docs](https://docs.rs/tokio/latest/tokio/runtime/index.html)
  * [tokio blog Making the Tokio scheduler 10x faster](https://tokio.rs/blog/2019-10-scheduler)
