//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   2020 ICLAB FALL Course
//   Lab03       : Testbench and Pattern
//   Author      : 
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
output reg           clk_1;
output reg           clk_2;
output reg           clk_3;
output reg           rst_n;
output reg           in_valid;
output reg           mode;
output reg           operator;
output reg     [2:0] in;
input 		         out_valid;
input  signed [63:0] out;
 
//================================================================
// parameters & integer
//================================================================
parameter CYCLE1   = `CYCLE_TIME_clk1;
parameter CYCLE2   = `CYCLE_TIME_clk2;
parameter CYCLE3   = `CYCLE_TIME_clk3;
parameter PREFIX   =  32'd0;
parameter POSTFIX  =  32'd1;
parameter OPERAND  =  1'd1;
parameter OPERATOR =  1'd0;
parameter PATNUM   =  100;
parameter DELAY    =  1000;
parameter Digit    =  10;

//================================================================
// wire & registers 
//================================================================
integer i,j,k,l,m,n;
integer pat, lat, cnt;
integer bound;
integer notation;
integer eye0, eye1;
integer stack_ptr;
integer exprn_num, exprn_ptr;
reg signed [63:0] stack [0:19];
integer exprn [0:19][0:1];
integer operand_num, operator_num;
integer temp_v1, temp_v2;
reg signed [63:0] ans;

//================================================================
// clock
//================================================================
initial clk_1 = 0;
always #(CYCLE1/2.0) clk_1 = ~clk_1;

initial clk_2 = 0;
always #(CYCLE2/2.0) clk_2 = ~clk_2;

initial clk_3 = 0;
always #(CYCLE3/2.0) clk_3 = ~clk_3;

//================================================================
// Main
//================================================================

initial main;

//================================================================
// Task
//================================================================

task main; begin

	reset;
	for (pat=0; pat<PATNUM; pat=pat+1) begin
		generate_input;
		calculate;
		print;
		send_input;
		wait_output;
		receive_check_output;
	end
	pass;

end endtask


task reset; begin
	
	force clk_1 = 0;
	force clk_2 = 0;
	force clk_3 = 0;
	rst_n       = 1;
	in_valid    = 0;
	in          = 'dx;
	mode        = 'dx;
	operator    = 'dx;
	eye0        = 0;
	eye1        = 0;
	
	#(CYCLE1) rst_n = 0;
	#(CYCLE1) rst_n = 1;
	
	if (out!==64'd0 || out_valid !==1'b0) begin
		$display("----------------------------------------------------");
		$display("                                                    ");
		$display(" Forgot to reset output signals at %t ns", $time*1000);
		$display("                                                    ");
		$display("----------------------------------------------------");
		repeat(5) #(CYCLE1)
		$finish();
	end
	
	#(CYCLE1)
	eye0      = 1;
	release clk_1;
	release clk_2;
	release clk_3;

end endtask



task generate_input; begin

	for (i=0; i<20; i=i+1) begin
		exprn[i][0]=-1;
		exprn[i][1]=-1;
		exprn_num=-1;
	end
	
	notation     = $urandom_range(1);
	operator_num = $urandom_range(Digit,1);
	operand_num  = operator_num - 1;
	exprn_num    = operand_num+operator_num;

	if (operator_num==1) begin
		exprn_num = 1;
		exprn[0][0] = OPERATOR;
		exprn[0][1] = $urandom_range(7);
	end
	else begin
	
		exprn[0][0] = (notation==POSTFIX) ? OPERATOR : OPERAND;
		exprn[0][1] = (notation==POSTFIX) ? $urandom_range(7) : $urandom_range(2);
		
		exprn[exprn_num-1][0] = (notation==POSTFIX) ? OPERAND : OPERATOR;
		exprn[exprn_num-1][1] = (notation==POSTFIX) ? $urandom_range(2) : $urandom_range(7);
		
		operand_num  = operand_num  - 1;
		operator_num = operator_num - 1;
		
		for (i=1; i<exprn_num-1; i=i+1) begin
		
			exprn_ptr = (notation==POSTFIX) ? i : exprn_num-1-i;
		
			if ($urandom_range(1))// OPERATOR
				if (operator_num!=0) begin
					exprn[exprn_ptr][0] = OPERATOR;
					exprn[exprn_ptr][1] = $urandom_range(7);
					operator_num = operator_num - 1;
				end
				else begin
					exprn[exprn_ptr][0] = OPERAND;
					exprn[exprn_ptr][1] = $urandom_range(2);
					operand_num = operand_num - 1;
				end
			else// OPERAND
				if (operand_num!=0  && operator_num < operand_num) begin
					exprn[exprn_ptr][0] = OPERAND;
					exprn[exprn_ptr][1] = $urandom_range(2);
					operand_num = operand_num - 1;
				end
				else begin
					exprn[exprn_ptr][0] = OPERATOR;
					exprn[exprn_ptr][1] = $urandom_range(7);
					operator_num = operator_num - 1;
				end
		end
		
	end
	
end endtask


task calculate; begin
	
	for (i=0; i<20; i=i+1)
		stack[i] = -64'd1;
	
	exprn_ptr = (notation==POSTFIX) ? 0 : exprn_num-1;
	stack_ptr = -1;
	bound     = (notation==POSTFIX) ? exprn_num : -1;
	ans       = 64'd0;

	while (exprn_ptr!=bound) begin
		if (exprn[exprn_ptr][0]==OPERATOR) begin
			push(exprn[exprn_ptr][1]);
		end
		else begin // exprn[exprn_ptr][0]==OPERAND
			pop(temp_v2);
			pop(temp_v1);
			case (exprn[exprn_ptr][1])
				0: push(temp_v1+temp_v2);
				1:  if (notation==POSTFIX) push(temp_v1-temp_v2); else push(temp_v2-temp_v1);
				2: push(temp_v1*temp_v2);
			endcase
		end	
		exprn_ptr = (notation==POSTFIX) ? exprn_ptr + 1 : exprn_ptr - 1;
	end
	
	pop(ans);

end endtask


task pop;
	output signed [63:0] value;
	begin
		value = stack[stack_ptr];
		stack[stack_ptr] = -1;
		stack_ptr = stack_ptr - 1;
	end
endtask


task push;
	input signed [63:0] value; 
	begin
		stack_ptr = stack_ptr + 1;
		stack[stack_ptr] = value;
	end
endtask


task send_input; begin

	repeat($urandom_range(4,2))@(negedge clk_1);
	eye1 = 0;
	
	if (out_valid!==1)
		for (i=0; i<exprn_num; i=i+1) begin
			in_valid = 1;
			in       = exprn[i][1];
			mode     = (i==0) ? notation : 'dx;
			operator = exprn[i][0];
			@(negedge clk_1);
		end
	else begin
		$display("----------------------------------------------------");
		$display("                                                    ");
		$display(" out_valid should be low during receiving input data");
		$display("                                                    ");
		$display("----------------------------------------------------");
		repeat(5) @(negedge clk_1);
		$finish();
	end
	
	in_valid    = 0;
	in          = 'dx;
	mode        = 'dx;
	operator    = 'dx;
	
end endtask



always @(*) begin
	if (eye0)
		if (out!==64'd0 && out_valid===0) begin
			$display("----------------------------------------------------");
			$display("                                                    ");
			$display("      out should be 0 when out_valid is low         ");
			$display("                                                    ");
			$display("----------------------------------------------------");
			repeat(5) @(negedge clk_1);
			$finish();
		end
	
	if (eye1)
		if (out_valid===1) begin
			$display("----------------------------------------------------");
			$display("                                                    ");
			$display("  out_valid should be 0 before receving input data  ");
			$display("                                                    ");
			$display("----------------------------------------------------");
			repeat(5) @(negedge clk_1);
			$finish();
		end
end
	


task wait_output; begin

	lat = -1;
	while(out_valid!==1) begin
		if (lat==DELAY) begin
			$display("----------------------------------------------------");
			$display("                                                    ");
			$display("        Execution is more than 1000 cycle           ");
			$display("                                                    ");
			$display("----------------------------------------------------");
			repeat(5) @(negedge clk_1);
			$finish();
		end
		lat = lat + 1;
		@(negedge clk_3);
	end

end endtask



task receive_check_output; begin

	cnt = -1;
	while (out_valid===1) begin
		if (cnt == 0) begin
			$display("----------------------------------------------------");
			$display("                                                    ");
			$display("           Output is more than 1 cycle              ");
			$display("                                                    ");
			$display("----------------------------------------------------");
			repeat(5) @(negedge clk_1);
			$finish();
		end
		else begin
			if (out!==ans) begin
				$display("----------------------------------------------------");
				$display("                                                    ");
				$display("      Wrong output, your: %d, gold: %d              ",out, ans);
				$display("                                                    ");
				$display("----------------------------------------------------");
				print;
				repeat(5) @(negedge clk_1);
				$finish();
			end
		end
		cnt = cnt + 1;
		@(negedge clk_3);
	end
	$display("Pattern %d - PASS",pat);
	eye1 = 1;

end endtask



task pass; begin

	$display("----------------------------------------------------");
	$display("                                                    ");
	$display("                       PASS                         ");
	$display("                                                    ");
	$display("----------------------------------------------------");
	repeat(5) #(CYCLE1)
	$finish();
	
end endtask




task print; begin

	$write("\nNotation   : ");
	if (notation==PREFIX) $write("Prefix\n");
	else $write("Postfix\n");
	
	$write("Expression : ");
	for (i=0; i<exprn_num; i=i+1)
		case({exprn[i][0],exprn[i][1]})
			{32'd0,32'd0}: $write("+ ");
			{32'd0,32'd1}: $write("- ");
			{32'd0,32'd2}: $write("* ");
			default: $write("%1d ",exprn[i][1]);
		endcase

	$write("\nAnswer     : %-d",ans);
	$write("\n\n");
			

end endtask


endmodule
