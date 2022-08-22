`ifdef RTL
	`define CYCLE_TIME 12.0  
`endif
`ifdef GATE
	`define CYCLE_TIME 12.0
`endif

module PATTERN(
        // input signals
		clk,
		rst_n,
		in_valid,
		in_data,
		size,
		action,
        // output signals
		out_valid,
		out_data
);
//io
output	reg		clk,rst_n,in_valid;
output	reg	[30:0]	in_data;
output 	reg	[1:0]	size;
output	reg	[2:0]	action;

input			out_valid;
input		[30:0]	out_data;




//================================================================
// parameters & integer
//================================================================
real CYCLE = 12;
integer SEED = 200;
integer patcount, total_latency;
integer i, j, k, wait_val_time, out_valid_time;
integer file,outfile,file_gold;

integer size_read, num_input, act, in;
reg [30:0] golden;



//================================================================
// clock
//================================================================
initial 
begin
	clk = 0;
end
always #(CYCLE/2.0) clk = ~clk;


//================================================================
// initial
//================================================================
initial 
begin
	file = $fopen("../00_TESTBED/feed.txt", "r");
	file_gold = $fopen("../00_TESTBED/golden.txt", "r");
	rst_n = 1'b1;
	in_valid = 1'b0;
	force clk = 0;
 	total_latency = 0;

	//Spec 3.
	reset_signal_task;
	
	for(patcount=1; patcount<=21; patcount=patcount+1) begin
		write_pattern_task;
		wait_out_valid;
		check_ans;
	end
	
  	YOU_PASS_task;
end


//================================================================
// task
//================================================================
task reset_signal_task; 
begin 
  #(0.5);  rst_n=0;
  #(2.0);					
  if((out_valid !== 0)||(out_data !== 0)) 	//output
  begin
    $display("**************************************************************");
    $display("*                      SPEC 3 IS FAIL                        *");
    $display("*   Output signal should be 0 after initial RESET at %4t     *",$time);
    $display("**************************************************************");
    //$finish;
  end
  #(10);  rst_n=1;
  #(3);  release clk;
end 
endtask

//////////////////////////////////////////////////////////////////////////////////////////////////

task write_pattern_task; begin

	$fscanf(file,"%d", act);
	if(act==0)	begin
		$fscanf(file, "%d", size_read);
		case(size_read)
			0:	num_input=4;
			1:	num_input=16;
			2:	num_input=64;
			3:	num_input=256;
		endcase
	end
	else	begin
		size_read='bx;
	end

	if(act==0 ||act==1||act==2)	begin
		$fscanf(file, "%d", in);
		@(negedge clk)
			in_valid=1;
			action=act;
			size=size_read;
			in_data=in;

		for(i=1;i<num_input;i=i+1)	begin
			$fscanf(file, "%d", in);
			@(negedge clk)
				in_valid=1;
				in_data=in;
				action='bx;
				size='bx;
		end
	end
	else	begin
		@(negedge clk)
			in_valid=1;
			action=act;
			size=size_read;
			in_data='bx;	
	end
	
	
	@(negedge clk)
		action='bx;
		in_data='bx;
		in_valid=0;
end endtask



//////////////////////////////////////////////////////////////////////////////////////////////////


task wait_out_valid; begin
  wait_val_time = -1;
  while(out_valid !== 1) begin
  wait_val_time = wait_val_time + 1;
  if(wait_val_time == 25000)
  begin
    $display("***************************************************************");
    $display ("                    SPEC 6 IS FAIL                            ");
    $display("*         The execution latency are over 25000 cycles.          *");
    $display("***************************************************************");
    repeat(2)@(negedge clk);
    $finish;
  end

  @(negedge clk);
  end
  total_latency = total_latency + wait_val_time;
end endtask

task check_ans; 
begin
    out_valid_time = -1;
    while(out_valid) begin
        $fscanf(file_gold,"%d", golden);
        out_valid_time=out_valid_time+1;
        /*
        if(out_valid_time == 1)
        begin
          $display("***************************************************************");
          $display("*                         SPEC 5 IS FAIL                      *");
          $display("*              The out_valid is over 1 cycles.                *");
          $display("***************************************************************");
          repeat(2)@(negedge clk);
          $finish;
        end
        */
        if(out_data!== golden) begin
            $display("***************************************************************");
            $display ("                        SPEC 7 IS FAIL                        ");
            $display ("                    Your answer is fail !                     ");
            $display ("               correct_ans: %d , your ans: %d                 ",golden,out_data);
            $display("***************************************************************"); 
            $finish;
        end
        
        @(negedge clk);
    end
    $display("\033[0;34mPASS PATTERN NO.%4d,\033[m \033[0;32mexecution cycle : %3d\033[m",patcount ,wait_val_time);
    if(out_valid==0 && out_data!=0)begin
            $display ("********************************************************************");
            $display ("                          SPEC 4 IS FAIL                            ");
            $display ("      Output signal should be 0 after out_valid pull down           ");
            $display ("********************************************************************");  
            $finish;
   end
    repeat(4)@(negedge clk);
end 
endtask


task YOU_PASS_task; 
begin
  $display ("--------------------------------------------------------------------");
  $display ("                         Congratulations!                           ");
  $display ("                  You have passed all patterns!  latency:%d         ",total_latency);
  $display ("--------------------------------------------------------------------");        
#(500);
$finish;
end
endtask

endmodule

