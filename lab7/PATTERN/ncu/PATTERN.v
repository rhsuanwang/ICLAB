//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   2020 ICLAB FALL Course
//   Lab03       : Testbench and Pattern
//   Author      : Yi-Ting Wang
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : PATTERN.v
//   Module Name : PATTERN  
//   Release version : v1.0
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################
`ifdef RTL
	`timescale 1ns/1ps
	`include "PN.v"
	`define CYCLE_TIME_clk1 19
	`define CYCLE_TIME_clk2 6
	`define CYCLE_TIME_clk3 11
`endif
`ifdef GATE
	`timescale 1ns/1ps
	`include "PN_SYN.v"
	`define CYCLE_TIME_clk1 19
	`define CYCLE_TIME_clk2 6
	`define CYCLE_TIME_clk3 11
`endif


module PATTERN(
    // Output signals
	clk_1,
	clk_2,
	clk_3,
    rst_n,
	in_valid,
	in,
	mode,
	operator,

    // Input signals
    out_valid,
    out
);

//================================================================ 
//   INPUT AND OUTPUT DECLARATION
//================================================================
output reg clk_1, clk_2, clk_3, rst_n, in_valid, mode, operator;
output reg [2:0] in;
input out_valid;
input [63:0] out;
 
real CYCLE_clk1 = 19;
real CYCLE_clk2 = 6;
real CYCLE_clk3 = 11;
always	#(CYCLE_clk1/2.0) clk_1 = ~clk_1;
always	#(CYCLE_clk2/2.0) clk_2 = ~clk_2;
always	#(CYCLE_clk3/2.0) clk_3 = ~clk_3;

integer pat_file_in, pat_file_operator, pat_file_mode, pat_file_total_num, pat_file_result;
integer PATNUM = 1000;
integer pat_cnt;
integer gap;
integer gold_out;
integer a, b, c, d, e, f, g;
integer in_len;
integer len_cnt;
integer cycles, total_cycles;
reg signed[63:0]gold_out_0;
initial begin
    pat_file_in = $fopen("../00_TESTBED/in.txt", "r");
    pat_file_operator = $fopen("../00_TESTBED/operator.txt", "r");
    pat_file_mode = $fopen("../00_TESTBED/mode.txt", "r");
    pat_file_total_num = $fopen("../00_TESTBED/total_num.txt", "r");
    pat_file_result = $fopen("../00_TESTBED/result.txt", "r");
    force clk_1 = 0;
	force clk_2 = 0;
	force clk_3 = 0;
	rst_n = 1'b1;
	in_valid = 1'b0;
	mode = 1'bx;
	in = 3'bx;
	operator = 1'bx;
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
	repeat(gap)@(negedge clk_1);
end endtask



task Reset_Signal_task; begin	
	release clk_1;
	release clk_2;
	release clk_3;
	@(negedge clk_1); rst_n = 1'b0;
	@(negedge clk_1); rst_n = 1'b1;
	if( (out_valid !== 1'b0) || (out !== 64'd0) ) begin
		$display("******************************************************************");
        $display("      Output signal should be 0 after initial RESET   at%8t       ", $time);
        $display("******************************************************************");
        repeat(2) #CYCLE_clk1;
        $finish;
	end
	repeat(3)@(negedge clk_1);
end endtask


task input_data_task;
begin
    a = $fscanf(pat_file_total_num,"%d\n", in_len);
    in_valid = 1;
    for(len_cnt = 0; len_cnt < in_len; len_cnt = len_cnt + 1)begin
        if(len_cnt === 0)begin
            b = $fscanf(pat_file_mode,"%d\n", mode);
            c = $fscanf(pat_file_operator,"%d\n", operator);
            d = $fscanf(pat_file_in,"%d\n", in);
        end
        else begin
            mode = 1'bx;
            c = $fscanf(pat_file_operator,"%d\n", operator);
            d = $fscanf(pat_file_in,"%d\n", in);
        end
        @(negedge clk_1);
    end
    in = 3'bx;
    operator = 1'bx;
    in_valid = 0;
end
endtask

task wait_out_valid ; begin
	cycles = 0;
	while(out_valid === 0)begin
		cycles = cycles + 1;
		if(cycles == 1000) begin
			$display( "--------------------------------------------------------------------------------------------------------------------------------------------\n");
			$display( "                                                                                                                                            \n");
			$display( "                                                     The execution latency are over 1000 cycles                                              \n");
			$display( "                                                                                                                                            \n");
			$display( "--------------------------------------------------------------------------------------------------------------------------------------------\n");
			repeat(2)@(negedge clk_3);
			$finish;
		end
	@(negedge clk_3);
	end
	total_cycles = total_cycles + cycles;
end endtask

task check_ans ; begin
    if(out_valid === 1) begin
		e = $fscanf(pat_file_result,"%d\n", gold_out);
		gold_out_0 = gold_out;
		if(	(out !== gold_out_0)) begin
			$display ( "--------------------------------------------------------------------------------------------------------------------------------------------\n");
			$display ( "                                                                        FAIL!                                                               \n");
			$display ( "                                                                Pattern NO.%03d                                                        \n", pat_cnt);
			$display ( "--------------------------------------------------------------------------------------------------------------------------------------------\n");
			@(negedge clk_3);
			$finish;
		end
    end
end endtask


task YOU_PASS_task; begin
    $display ("--------------------------------------------------------------------");
    $display ("                         Congratulations!                           ");
    $display ("                  You have passed all patterns!                     ");
    $display ("--------------------------------------------------------------------");        
    repeat(2)@(negedge clk_3);
    $finish;
end endtask

endmodule

