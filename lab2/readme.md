lab2是做比對字串<br>

在演算法中為了能夠考慮到很多情況<br>
因此我大量使用組合邏輯進行比對<br>
但是卻在實作過程發現容易有setup timing violation<br>
後來發現是因為組合邏輯critical path太長<br>
而且因為SPEC的關係沒辦法進行降頻<br>
因此我採用的方式是在邏輯中插入flipflop<br>
就解決了。


[筆記]<br>

![image](https://user-images.githubusercontent.com/96122960/185947084-6f33c7b9-ec07-4ec3-9b3d-8d3fe9424940.png)

T_launch：CLKM到UFF0 CK的延遲

T_ck2q：FF CLK to Q的傳輸時間

T_dp：組合邏輯延遲

T_hold：UFF1的hold時間要求

T_margin：設計餘裕

T_capture：CLKM到UFF1 CLK的延遲

T_clk: 時鐘週期

T_skew = T_capture - T_launch<br>

1. setup time violation解決方法<br>
   setup time 條件: T_ck2q + T_dp + T_setup <= T_skew + T_clk<br>
   a. 增加T_clk => 降頻(簡單暴力)<br>
   b. 減少T_dp => 在critical path加入flipflop，善用pipeline設計；在較大負載的節點插buffer、優化扇出，減少關鍵路徑上的負載；更換更大驅動的Cell，增強驅動能力;更換SVT/LVT的Cell<br>
   c. 增加T_skew => 要注意可能引入hold問題，以及前後級的margin問題<br>
   d. 減少T_ck2q => 更換更快的時序邏輯單元，如HVT->LVT<br>
   
2. hold time violation解決方法<br>
   hold time條件: T_ck2q + T_dp >= T_skew + T_hold
   a. 增加T_dp => 增加組合路徑延時，通過插buffer、插delay cell、更換驅動、更換閾值的方法（有可能增加面積、佈線資源、功耗，在慢速工藝庫條件下容易有timing violation）<br>
   b. 減少T_skew => 減小skew，甚至採用negative skew，但需做好時鍾樹的balance<br>
   c. 插入低電平有效的鎖存器(Lock-up Latch)：高電平期間，鎖存器輸出保持不變，相當於人為將數據推遲了半個時鐘週期，以保證滿足hold時間要求。
