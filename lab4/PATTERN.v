`ifdef RTL
	`timescale 1ns/10ps
	`include "NN.v"  
	`define CYCLE_TIME 20.0
`endif
`ifdef GATE
	`timescale 1ns/10ps
	`include "NN_SYN.v"
	`define CYCLE_TIME 20.0
`endif

//synopsys translate_off
`include "/usr/synthesis/dw/sim_ver/DW_fp_mult.v"
`include "/usr/synthesis/dw/sim_ver/DW_fp_add.v"
`include "/usr/synthesis/dw/sim_ver/DW_fp_addsub.v"
//synopsys translate_on

module PATTERN(
	// Output signals
	clk,
	rst_n,
	in_valid_d,
	in_valid_t,
	in_valid_w1,
	in_valid_w2,
	data_point,
	target,
	weight1,
	weight2,
	// Input signals
	out_valid,
	out
);
//---------------------------------------------------------------------
//   PARAMETER
//---------------------------------------------------------------------
parameter inst_sig_width = 23;
parameter inst_exp_width = 8;
parameter inst_ieee_compliance = 0;
parameter inst_arch = 0;

//================================================================
//   INPUT AND OUTPUT DECLARATION                         
//================================================================
output reg clk, rst_n, in_valid_d, in_valid_t, in_valid_w1, in_valid_w2;
output reg [inst_sig_width+inst_exp_width:0] data_point, target;
output reg [inst_sig_width+inst_exp_width:0] weight1, weight2;
input	out_valid;
input	[inst_sig_width+inst_exp_width:0] out;

integer wait_val_time, total_latency;
//================================================================
// clock
//================================================================
initial 
begin
	clk = 0;
end
always #(20/2.0) clk = ~clk;

initial 
begin
	
	rst_n = 1'b1;
	in_valid_d = 1'b0;
	in_valid_t = 1'b0;
	in_valid_w1 = 1'b0;
	in_valid_w2 = 1'b0;
	data_point = 32'bx;
	target = 32'bx;
	weight1 = 32'bx;
	weight2 = 32'bx;
	force clk = 0;
	reset_signal_task;
	
    input_data_task;
	wait_out_valid;
	check_ans;
    repeat(2)@(negedge clk);
	YOU_PASS_task;
end


task input_data_task;
begin
	repeat(2)@(negedge clk);
    in_valid_w1 = 1'b1;
	in_valid_w2 = 1'b1;
	weight1 = 32'b0_01111011_01011010100001000100010;// 0.0845988
	weight2 = 32'b1_10000000_00100101001010011101110;// -2.29034
	@(negedge clk);
	weight1 = 32'b0_01111111_01001011001010001011011;// 1.29359
	weight2 = 32'b0_01111111_01010101011101001001001;// 1.33381
	@(negedge clk);
	weight1 = 32'b1_01111110_01011101100010011010110;// -0.682691
	weight2 = 32'b0_01111110_10000001100110010001001;// 0.753121
	@(negedge clk);
	in_valid_w2 = 1'b0;
	weight1 = 32'b1_01111101_00000110000011101101100;// -0.255916
	weight2 = 32'bx;// x
	@(negedge clk);
	weight1 = 32'b1_01111111_00101011010011000001101;// -1.16913
	@(negedge clk);
	weight1 = 32'b0_01111101_11000110100101001100110;// 0.443927
	@(negedge clk);
	weight1 = 32'b0_01111111_01010111100100011110011;// 1.34207
	@(negedge clk);
	weight1 = 32'b0_01111111_11111001000010100001001;// 1.97281
	@(negedge clk);
	weight1 = 32'b1_01111110_01011101000111000011101;// -0.681856
	@(negedge clk);
	weight1 = 32'b0_10000000_01101000001010001111010;// 2.81375
	@(negedge clk);
	weight1 = 32'b1_01111101_00001000100001010000100;// -0.25832
	@(negedge clk);
	weight1 = 32'b1_01111111_00110011010110111101010;// -1.20062
	@(negedge clk);
	in_valid_w1 = 1'b0;
	weight1 = 32'bx;
	repeat(2)@(negedge clk);
	in_valid_d = 1;
    in_valid_t = 1;
    data_point = 32'b0_01111011_01100101010000001001011;// 0.0872198
    target = 32'b0_10000011_00100000000000000000000;// 18
    @(negedge clk);
    in_valid_t = 0;
    target = 32'bx;
    data_point = 32'b0_01111010_00101110100011101111010;// 0.0369334
    @(negedge clk);
    data_point = 32'b0_01111110_11111101101100011110100;// 0.995498
    @(negedge clk);
    data_point = 32'b0_01110110_10111110110110110001110;// 0.00340924
    @(negedge clk);
    in_valid_d = 0;
    data_point = 32'bx;
    
end
endtask

task reset_signal_task; 
begin 
  #(0.5);	rst_n=0;
  #(20/2);
  if((out_valid !== 0)||(out !== 0)) 
  begin
    $display("**************************************************************");
    $display("*   Output signal should be 0 after initial RESET at %4t     *",$time);
    $display("**************************************************************");
    $finish;
  end
  #(10);	rst_n=1;
  #(3);		release clk;
end 
endtask


task wait_out_valid;
begin
  wait_val_time = -1;
  while(out_valid !== 1) begin
	wait_val_time = wait_val_time + 1;
	if(wait_val_time == 30)
	begin
		$display("***************************************************************");
		$display("*         The execution latency are over 30 cycles.           *");
		$display("***************************************************************");
		repeat(2)@(negedge clk);
		$finish;
	end
	@(negedge clk);
  end
  total_latency = total_latency + wait_val_time;
end
endtask

task check_ans;
begin
    if(out_valid === 1)begin
	   if(out[31:8] !== 32'b0_01111111_101011010100010)
	   begin
		  $display ("--------------------------------------------------------------------");
		  $display ("                     PATTERN FAILED!!!                         ");
		  $display ("--------------------------------------------------------------------");
		  repeat(2) @(negedge clk);		
		  $finish;
        end
    end
end
endtask



task YOU_PASS_task; 
begin
  $display ("--------------------------------------------------------------------");
  $display ("          ~(ï¿?–½ï¿?~(ï¼¿â–³ï¼?~(ï¿?–½ï¿?~(ï¼¿â–³ï¼?~(ï¿?–½ï¿?~            ");
  $display ("                         Congratulations!                           ");
  $display ("                  You have passed all patterns!                     ");
  $display ("--------------------------------------------------------------------");        
     
#(500);
$finish;
end
endtask

endmodule
