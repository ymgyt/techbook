# future

* 一度`Poll::Ready`を返したfutureにpollしてはいけない。
  * `Ready`を返したあとにpollされたら`panic!`してよい
  * `Ready`を返したあとにもpollできるものをfused futureと呼ぶ
