# Audio

## 音がなるまで

1. ApplicationがOSのAPIに音声データを投げる
  * PCM: Pulse Code Modulation

2. Kernelのミキサーが複数アプリの音を合成
3. Audio Driver
4. Sound Card
  * デジタル->アナログ変換
  * 加工
  * 電気信号化
5. Speaker
6. 空気振動として聞こえる
