
set_multicycle_path 3 -setup -end -from clk_1 -to clk_2
set_multicycle_path 2 -hold  -end -from clk_1 -to clk_2

set_multicycle_path 3 -setup -end -from clk_2 -to clk_3
set_multicycle_path 2 -hold  -end -from clk_2 -to clk_3
