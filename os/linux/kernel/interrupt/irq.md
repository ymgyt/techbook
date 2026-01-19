# IRQ

* 割込み発生源の識別子


## Interrupt Flow

--- 初期化 ---
1. I/O APICの各pin(hwirq)とIRQ Num(N)の対応関係をirq_domainで管理
  * PIC busからdeviceをみつけた際に割込み使うかの情報を取得して、hwirq -> IRQ Nの対応を作る
2. IRQ Nに対応するIDT vectorを割り当てる
  * IDT vector <-> IRQ Nは対応関係にある
3. I/O APICに対してpin(hwirq)とIDT vectorの対応関係を設定する
4. Device driverはprobe時にIRQ Nを受け取る  * `request_irq(IRQ_N, handler,...)`でIRQに対応するhandlerを登録する

--- 割り込み発生 ---
1. Deviceが割り込みを発生
2. I/O APIC pinに電気的に到達
3. I/O APICが設定に従いpin(hwirq) をIDT vectorに変換してCPUに割り込みを発生させる(ex. 0x31)
4. CPUは`IDT[0x31]`を参照して、`0x31_stub`を実行する
  * stubは0x31をstackにpushして共通処理を呼ぶ
5. 共通処理はvector(0x31)をIRQ Nに変換する
6. IRQ Nのhandlerを実行する
