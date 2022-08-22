`define CYCLE_TIME 8

module PATTERN(
	// Output signals
	clk,
	rst_n,
	in_valid,
	in_data,
	in_mode,
	cg_en,
	// Input signals
	out_valid,
	out_data
);


output reg clk;
output reg rst_n;
output reg cg_en;
output reg in_valid;
output reg [8:0] in_data;
output reg [2:0] in_mode;

input out_valid;
input [8:0] out_data;


//================================================================
// parameters & integer
//================================================================
real	CYCLE = `CYCLE_TIME;
integer patternnum=50000;//10
integer i,j,k,l,y,lat,total_latency;
integer patcount;
integer datacount;
integer pat_delay;
integer input_file,output_file;

integer gap;
//================================================================
// wire & registers 
//================================================================
reg [31:0] gold;

//================================================================
// clock
//================================================================
always	#(CYCLE/2.0) clk = ~clk;
initial	clk = 0;
//================================================================
// initial
//================================================================

initial begin
    rst_n = 1;    
	
	in_data = 1'bx;
	in_mode = 1'bx;
	in_valid = 1'b0;
	cg_en = 1'd1;
	force clk = 0;
	
    total_latency = 0; 
	RESET;

	input_file=$fopen("../00_TESTBED/input.txt","r");
  	output_file=$fopen("../00_TESTBED/output.txt","r");
	
	for(patcount=0;patcount<patternnum;patcount=patcount+1)
	begin
		FOR_INPUT;

		COUNT_LAT;
		CALCULATE;
		
		$display("\033[0;34mPASS PATTERN NO.%4d,\033[m \033[0;32m Latency: %3d\033[m",
				patcount ,lat);
		
	end

	PASS;
	$finish;
end

task RESET; begin 
    #(0.5);   rst_n=0;
	
	#(2.0);
	if((out_valid !== 0)||(out_data !== 4'b0)) begin
		fail;
		$display ("----------------------------------------------------------------------------------------------------------");
		$display ("                                            OUTPUT NO RESET                                               ");
		$display ("----------------------------------------------------------------------------------------------------------");

		// repeat(2) @(negedge clk);
		$finish;
	end
	#(10);   rst_n=1;
	#(3);   release clk;
end endtask


task FOR_INPUT; begin
	gap = $urandom_range(2,4);
	repeat(gap)@(negedge clk);
	in_valid = 1;
	for(j=0;j<6;j=j+1) 
	begin
		if (j<1)
		begin
		k=$fscanf(input_file,"%b %d",in_mode,in_data);
		end
		
		else if (j>=1)
		begin
		k=$fscanf(input_file,"%d",in_data);

		in_mode = 'dx;
		
		end
		@(negedge clk);	
		
		
	end   
	in_valid = 0;

	in_data = 'dx;
	repeat(2)@(negedge clk);
	//$finish;
end 
endtask	

task COUNT_LAT; begin
  lat = -1;
  while(!out_valid) begin
	lat = lat + 1;
	
	if(out_data !==0)begin
		fail;
		$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
		$display ("                                                                     SPEC 4 FAIL!                                                           ");
		$display ("--------------------------------------------------------------------------------------------------------------------------------------------");

		repeat(3)@(negedge clk);
		$finish;
	
	end
	if(lat == 2000) begin
	    fail;
		$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
		$display ("                                                                     SPEC 6 FAIL!                                                           ");
		$display ("--------------------------------------------------------------------------------------------------------------------------------------------");

		repeat(3)@(negedge clk);
		$finish;
	end
	
	@(negedge clk);
  end
  total_latency = total_latency + lat;
end endtask

task CALCULATE; begin
	y=0;
	while(out_valid)
	begin
		
		l=$fscanf(output_file,"%d",gold);
		if(out_data!==gold)
				begin
					fail;
					$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
					$display ("                                                                     SPEC 9 FAIL!                                                           ");
					$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
					$display ("---------------------------------------------------------------------------------------------");
					$display ("    Fail! ANWSER IS WRONG!          ");
					$display ("             PATTERN NO.%4d ",patcount);
					$display ("             Ans:%d  ", gold);//show ans
					$display ("             Your output : %d  at %8t ",out_data, $time);//show output
					$display ("---------------------------------------------------------------------------------------------");
					repeat(10) @(negedge clk);
					$finish;
				end
		
		
		@(negedge clk);	
		y=y+1;
	end	

	
	
end endtask


task PASS;begin

$display ("----------------------------------------------------------------------------------------------------------------------");
$display ("                                                  Congratulations!                						            ");
$display ("                                           You have passed all patterns!          						            ");
$display ("                                           Your execution cycles = %5d cycles   						            ", total_latency);
$display ("                                           Your clock period = %.1f ns        					                ", CYCLE);
$display ("                                           Your total latency = %.1f ns         						            ", total_latency*CYCLE);
$display ("----------------------------------------------------------------------------------------------------------------------");



$finish;	
end endtask

task fail;begin
$display("***************************************************************");
$display("*                      SORRY BYE_BYE!!!!!!                    *");
$display("***************************************************************");
end
endtask	

endmodule



