`define CYCLE_TIME 8

module PATTERN(
	// Output signals
	clk,
	rst_n,
	in_valid,
	in_data,
	in_mode,
	// Input signals
	out_valid,
	out_data,
	cg_en
);


output reg clk;
output reg rst_n;
output reg in_valid;
output reg [8:0] in_data;
output reg [2:0] in_mode;
output reg cg_en;

input out_valid;
input [8:0] out_data;


always	#(8.0/2.0) clk= ~clk;

integer pat_file_in, pat_file_mode, pat_file_out;
integer PATNUM;
integer pat_cnt;
integer gap;
integer a, b, c, d, e, f, g, h;
integer in_len;
integer len_cnt;
integer cycles, total_cycles;
reg [8:0] gold_out;

initial begin
    pat_file_in = $fopen("../00_TESTBED/input.txt", "r");
    pat_file_mode = $fopen("../00_TESTBED/int_mode.txt", "r");
    pat_file_out = $fopen("../00_TESTBED/output.txt", "r");
    force clk = 0;
	rst_n = 1'b1;
	in_valid = 1'b0;
        cg_en = 0;
	in_mode = 3'bx;
	in_data = 8'bx;
	$fscanf(pat_file_in,"%d\n", PATNUM);
	Reset_Signal_task;
	for(pat_cnt = 0; pat_cnt < PATNUM; pat_cnt = pat_cnt + 1)begin
	   	input_data_task;
       		wait_out_valid;
       		check_ans;
	   	delay_task;
	end
	YOU_PASS_task;
	$finish;
end

task delay_task ; begin
	gap = $urandom_range(2, 4);
	repeat(gap)@(negedge clk);
end endtask



task Reset_Signal_task; begin	
	release clk;
	@(negedge clk); rst_n = 1'b0;
	@(negedge clk); rst_n = 1'b1;
	if( (out_valid !== 1'b0) || (out_data !== 8'd0) ) begin
		$display("******************************************************************");
        	$display("      Output signal should be 0 after initial RESET   at%8t       ", $time);
        	$display("******************************************************************");
        repeat(2) #16;
        $finish;
	end
	repeat(3)@(negedge clk);
end endtask


task input_data_task;
begin
    in_valid = 1;
    for(len_cnt = 0; len_cnt < 6; len_cnt = len_cnt + 1)begin
        if(len_cnt === 0)begin
            b = $fscanf(pat_file_mode,"%d\n", in_mode);
            d = $fscanf(pat_file_in,"%d ", in_data);
        end
        else begin
            in_mode = 3'bx;
            d = $fscanf(pat_file_in,"%d ", in_data);
        end
        @(negedge clk);
    end
	in_valid = 0;
	in_data = 8'bx;
end
endtask

task wait_out_valid ; begin
	cycles = 0;
	while(out_valid === 0)begin
		cycles = cycles + 1;
		if(cycles == 2000) begin
			$display( "--------------------------------------------------------------------------------------------------------------------------------------------\n");
			$display( "                                                                                                                                            \n");
			$display( "                                                     The execution latency are over 2000 cycles                                              \n");
			$display( "                                                                                                                                            \n");
			$display( "--------------------------------------------------------------------------------------------------------------------------------------------\n");
			repeat(2)@(negedge clk);
			$finish;
		end
	@(negedge clk);
	end
	total_cycles = total_cycles + cycles;
end endtask

task check_ans ; begin
    while(out_valid === 1) begin
	//for(h=0;h<6;h=h+1)begin
		e=$fscanf(pat_file_out,"%d\n", gold_out);
		if((out_data !== gold_out)) begin
			$display ( "-------------------------------------------------------------------------\n");
			$display ( "                                 FAIL!                                       \n");
			$display ( "         Pattern NO.%d, golden ans:%d,your ans:%d            \n", pat_cnt,gold_out,out_data);
			$display ( "-------------------------------------------------------------------------\n");
			@(negedge clk);
			$finish;
		end
                @(negedge clk);

                

    
         //end
    end
/*
    else begin
	                $display ("--------------------------------------------------------------------");
    	                $display ("                         PASSED!                            ");
   	                $display ( "                     Pattern NO.%d 		            	\n", pat_cnt);
    	                $display ("--------------------------------------------------------------------");        
                end
*/
end endtask


task YOU_PASS_task; begin
    $display ("--------------------------------------------------------------------");
    $display ("                         Congratulations!                           ");
    $display ("                  You have passed all patterns!                     ");
    $display ("--------------------------------------------------------------------");        
    repeat(2)@(negedge clk);
    $finish;
end endtask

endmodule
