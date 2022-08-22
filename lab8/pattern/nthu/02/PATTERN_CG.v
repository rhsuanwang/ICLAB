`define CYCLE_TIME 8



module PATTERN(
	// Output signals
	clk,
	rst_n,
	cg_en,
	in_valid,
	in_data,
	in_mode,
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
parameter PATNUM = 10; 
integer patcount, total_latency, wait_val_time;
integer i, x, num, temp1, temp2;
integer mode_read, mode_hold, in_read, in_hold, out_read, out_hold;

//================================================================
// wire & registers 
//================================================================
reg [8:0] ans;

//================================================================
// clock
//================================================================
always	#(`CYCLE_TIME/2.0) clk = ~clk;
initial	clk = 0;
//================================================================
// initial
//================================================================
initial 
begin
	//+++++++++++++++++++++++++++++++++++++++++++++++++++
	mode_read=$fopen("../00_TESTBED/mode.txt","r");
	in_read=$fopen("../00_TESTBED/input.txt","r");
  	out_read=$fopen("../00_TESTBED/output.txt","r");
	//+++++++++++++++++++++++++++++++++++++++++++++++++++

	rst_n = 1'b1;
	in_valid = 1'b0;
	in_data = 9'bx;
	in_mode = 3'bx;
	cg_en = 1 ;
	force clk = 0;
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
	if(out_valid===0&&out_data!=='b0)begin
        $display ("---------------------------------------------------------------------------------------------");
        $display ("    Fail! The out_data should be reset when your out_valid is pulled down                   ");
        $display ("---------------------------------------------------------------------------------------------");
        repeat(2) #`CYCLE_TIME;
        $finish;
    end
	else @(negedge clk);
end
//================================================================
// task
//================================================================
task reset_signal_task; 
begin 

    #(10);  rst_n=0;
    #(5);

    if((out_valid !== 0)||(out_data !== 'b0)) 
    begin
        $display ("---------------------------------------------------------------------------------------------");
        $display ("    Fail! Output signals should be 0 after reset at %4t", $time);
        $display ("---------------------------------------------------------------------------------------------");
        $finish;
    end

    #(50);  rst_n=1;
    #(10);  
	release clk;
end 
endtask

task input_task; 
begin
	// Inputs start from second negtive edge after the begining of clock
    if(patcount=='d1) begin repeat(2)@(posedge clk); #(`CYCLE_TIME/2); end
	// set in_valid and out_valid
    	in_valid = 1'b1;
	mode_hold=$fscanf(mode_read,"%d",in_mode);


    for(i=0; i<6; i=i+1)
    begin
	if(i>0) in_mode = 'bx;
        in_hold=$fscanf(in_read,"%d",in_data);
    	@(negedge clk);
    end
	// Disable input
	in_valid = 'b0;
	in_data = 'bx; 
	in_mode = 'bx;      
end
endtask

task wait_out_valid; begin
  wait_val_time = -1;
  while(out_valid !== 1) begin
	wait_val_time = wait_val_time + 1;
	if(wait_val_time > 2000)
	begin
		$display ("---------------------------------------------------------------------------------------------");
		$display ("    Fail! The execution latency is over 2000 cycles.");
		$display ("---------------------------------------------------------------------------------------------");
		repeat(2)@(negedge clk);
		$finish;
	end
	@(negedge clk);
  end
  total_latency = total_latency + wait_val_time + 6;
end endtask

task check_ans; 
begin
    // Check the answer here
    x=0;
    while(out_valid)
	begin
	if(x>=6)//x>max-1
	begin
            $display ("---------------------------------------------------------------------------------------------");
            $display ("    Fail! OUT_VALID is over 6 cycles");
            $display ("---------------------------------------------------------------------------------------------");
            repeat(9) @(negedge clk);
            $finish;
	end	
        out_hold=$fscanf(out_read, "%d", ans);        
	if(out_data!==ans)
	begin     
            $display ("---------------------------------------------------------------------------------------------");
            $display ("    Fail! ANWSER IS WRONG!          ");
            $display ("             PATTERN NO.%4d ",patcount);
            $display ("             Ans:%d  ", ans);//show ans
            $display ("             Your output : %d  at %8t ",out_data, $time);//show output
            $display ("---------------------------------------------------------------------------------------------");
            repeat(9) @(negedge clk);
            $finish;
	end
		@(negedge clk);	
		x=x+1;
	end	
    $display("\033[0;34mPASS PATTERN NO.%4d,\033[m \033[0;32mexecution cycle : %3d\033[m", patcount, wait_val_time);
	temp1 = $urandom_range(2, 4);
    repeat(temp1)@(negedge clk);
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