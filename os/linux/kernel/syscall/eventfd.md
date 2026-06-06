# eventfd

* fdを返す
* `write(fd, u64)`でcounterを加算
* `read(fd, &mut u64)`でcounterを読んで、0にできる
* このfdを通じてプロセス間でeventの通知ができる
