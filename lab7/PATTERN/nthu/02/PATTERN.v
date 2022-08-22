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
input signed [63:0] out;
 
//================================================================
// parameters & integer
//================================================================
real CYCLE_clk1 = `CYCLE_TIME_clk1;
real CYCLE_clk2 = `CYCLE_TIME_clk2;
real CYCLE_clk3 = `CYCLE_TIME_clk3;
parameter PATNUM = 18000;  
integer patcount, total_latency, wait_val_time;
integer i, x, num, temp1, temp2;
integer in_read, in_hold, out_read, out_hold;
//================================================================
// wire & registers 
//================================================================
reg signed[63:0] ans;

//================================================================
// clock
//================================================================
always	#(CYCLE_clk1/2.0) clk_1 = ~clk_1;
initial	clk_1 = 0;
always	#(CYCLE_clk2/2.0) clk_2 = ~clk_2;
initial	clk_2 = 0;
always	#(CYCLE_clk3/2.0) clk_3 = ~clk_3;
initial	clk_3 = 0;
//================================================================
// initial
//================================================================
initial 
begin
	//+++++++++++++++++++++++++++++++++++++++++++++++++++
	in_read=$fopen("../00_TESTBED/input.txt","r");
  	out_read=$fopen("../00_TESTBED/output.txt","r");
	//+++++++++++++++++++++++++++++++++++++++++++++++++++

	rst_n = 1'b1;
	in_valid = 1'b0;
	in = 'bx;
	mode = 'bx;
	operator = 'bx;
	force clk_1 = 0;
	force clk_2 = 0;
	force clk_3 = 0;
 	total_latency = 0;

	reset_signal_task;

	for(patcount=1; patcount<=PATNUM; patcount=patcount+1) 
	begin

		input_task;
		wait_out_valid;
		check_ans;
	end	
  	YOU_PASS_task;
end 

always begin	
	if(out_valid===0&&out!=='b0)begin
        $display ("---------------------------------------------------------------------------------------------");
        $display ("    Fail! The out_data should be reset when your out_valid is pulled down                   ");
        $display ("---------------------------------------------------------------------------------------------");
        repeat(2) #CYCLE_clk3;
        $finish;
    end
	else @(negedge clk_3);
end
//================================================================
// task
//================================================================
task reset_signal_task; 
begin 

    #(10);  rst_n=0;
    #(5);

    if((out_valid !== 0)||(out !== 'b0)) 
    begin
        $display ("---------------------------------------------------------------------------------------------");
        $display ("    Fail! Output signals should be 0 after reset at %4t", $time);
        $display ("---------------------------------------------------------------------------------------------");
        $finish;
    end

    #(50);  rst_n=1;
    #(10);  
	release clk_1;
	release clk_2;
	release clk_3;
end 
endtask

task input_task; 
begin
	// Inputs start from second negtive edge after the begining of clock
    if(patcount=='d1) begin repeat(2)@(posedge clk_1); #12.05; end
	// set in_valid and out_valid
    in_valid = 1'b1;
	in_hold=$fscanf(in_read,"%d",num);
	in_hold=$fscanf(in_read,"%d",mode);
    for(i=0; i<num*2+1; i=i+1)
    begin
		if(i===1) mode = 'bx;
        in_hold=$fscanf(in_read,"%d",in);
        in_hold=$fscanf(in_read,"%d",operator);
        @(posedge clk_1); #12.05;
    end


	// Disable input
    in_valid = 'b0;
    in = 'bx; 
	mode = 'bx;
	operator = 'bx;       
end
endtask

task wait_out_valid; begin
  wait_val_time = -1;
  while(out_valid !== 1) begin
	wait_val_time = wait_val_time + 1;
	if(wait_val_time > 1000)
	begin
		$display ("---------------------------------------------------------------------------------------------");
		$display ("    Fail! The execution latency is over 1000 cycles.");
		$display ("---------------------------------------------------------------------------------------------");
		repeat(2)@(negedge clk_3);
		$finish;
	end
	@(negedge clk_3);
  end
  total_latency = total_latency + wait_val_time+num*2+1;
end endtask

task check_ans; 
begin
    // Check the answer here
    x=0;
    while(out_valid)
	begin
		if(x>=1)//x>max-1
		begin
            $display ("---------------------------------------------------------------------------------------------");
            $display ("    Fail! OUT_VALID is over 1 cycles");
            $display ("---------------------------------------------------------------------------------------------");
            repeat(9) @(negedge clk_3);
            $finish;
		end	
        out_hold=$fscanf(out_read, "%d", ans);        
		if(out!==ans)
		begin     
            $display ("---------------------------------------------------------------------------------------------");
            $display ("    Fail! ANWSER IS WRONG!          ");
            $display ("             PATTERN NO.%4d ",patcount);
            $display ("             Ans:%d  ", ans);//show ans
            $display ("             Your output : %d  at %8t ",out, $time);//show output
            $display ("---------------------------------------------------------------------------------------------");
            repeat(9) @(negedge clk_3);
            $finish;
		end
		@(negedge clk_3);	
		x=x+1;
	end	
    $display("\033[0;34mPASS PATTERN NO.%4d,\033[m \033[0;32mexecution cycle : %3d\033[m", patcount, wait_val_time);
	temp1 = $urandom_range(2, 4);
    repeat(temp1)@(posedge clk_1); #12.05; 
end 
endtask

task YOU_PASS_task; 
begin
	
    $display ("--------------------------------------------------------------------");        
    $display ("                         Congratulations!                           ");
    $display ("                  You have passed all patterns!                     ");
    $display ("                  Total lentency : %d cycles                     ", total_latency);
    $display ("--------------------------------------------------------------------"); 
	          
         
    #(500);
    $finish;
end
endtask
endmodule

