lab2是做比對字串<br>

在演算法中為了能夠考慮到很多情況<br>
因此我大量使用組合邏輯進行比對<br>
但是卻在實作過程發現容易有setup timing violation<br>
後來發現是因為組合邏輯critical path太長<br>
而且因為SPEC的關係沒辦法進行降頻<br>
因此我採用的方式是在邏輯中插入flipflop<br>
就解決了。
