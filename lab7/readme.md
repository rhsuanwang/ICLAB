lab7實現具備CDC設計的Polish notation(PN)電路<BR>
在連結兩個不同頻率的Module時使用到的是double flop synchronizer
  
[筆記]<br>
static time analysis(STA)會根據constraints檢查所有design裡的timing paths是否有timing violation/ glitch/ clock skew等等<br>
從SDC可以設定這些timing constraint<br>
  
clock uncertainty (clock skew)用來模擬影響clock的因素，進而限縮timing的constraint。<br>
就可以在前端的時候提早發現是否有violation，也就是在APR前預留一些timing margin，避免APR時很難修timing issue<br>
  
在面對CDC(clock domain crossing)時，為了避免發生metastability(由於非理想的data傳輸導致的不穩定狀態)<br>
會用synchronizer處理<br>
  1. 2-FF
      優點:簡單
      缺點:Latency長，throughput低
  2. handshake
      優點:throughput高
      缺點:latency長
  3. dual clock FIFO 
      優點:throughput高
      缺點:難做
