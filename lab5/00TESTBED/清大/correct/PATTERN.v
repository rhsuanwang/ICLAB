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
// parameters & integer & wire & registers 
//================================================================
integer input_file;
integer output_file;
integer PATNUM;
integer a, c, i, j, p;
integer MATRIX_SIZE, MATRIX_LEN;
integer mismatch;
integer cycles;
integer total_cycles;
integer gap;
reg [2:0] mode;
reg [30:0] golden_out;

reg [30:0] golden_matrix [0:255];
reg [30:0] your_matrix [0:255];
//================================================================
// clock
//================================================================
always begin
	#(`CYCLE_TIME/2.0) clk = ~clk;
end	
initial	clk = 0;
//================================================================
// initial
//================================================================
initial begin
	input_file = $fopen("../00_TESTBED/input_pat0.txt", "r");
	output_file = $fopen("../00_TESTBED/output_pat0.txt", "r");
	a = $fscanf(input_file,"%d\n",PATNUM);

	rst_n = 1;
	in_valid = 0;
	in_data = 31'bx;
	size = 2'bx;
	action = 3'bx;

	force clk = 0;
	reset_task;
	total_cycles = 0;

	@(negedge clk);

	for(p=0; p<PATNUM; p=p+1) begin
		feed_task;
		wait_task;
		check_task;
		delay_task;
	end
	#(1);
	pass_task;
	#(1);
	$finish;
end

//================================================================
// task
//================================================================
task reset_task ; begin
	#(`CYCLE_TIME); rst_n = 0;

	#(1.0);
	if((out_valid !== 0) || (out_data !== 0)) begin
		$display ("--------------------------------------------------------------------------------");
		$display ("                                   FAIL!                                        ");
		$display ("                Output signal should be 0 after initial RESET                   ");
		$display ("--------------------------------------------------------------------------------");
		#(1);
		$finish;
	end	
	#(`CYCLE_TIME-1); rst_n = 1 ;
	#(`CYCLE_TIME); release clk;
end endtask

task delay_task ; begin
	gap = $urandom_range(3, 5);
	repeat(gap)@(negedge clk);
end endtask

task feed_task ; begin
    in_valid = 1;
    a = $fscanf(input_file,"%d\n",action);
    mode = action;
    case(action)
    	0, 1, 2: begin
    		if(action===0) begin
    			a = $fscanf(input_file,"%d\n",size);
	    		case(size)
	    			2'd0: begin
	    				MATRIX_SIZE = 4;
	    				MATRIX_LEN = 2;
	    			end
	    			2'd1: begin
	    				MATRIX_SIZE = 16;
	    				MATRIX_LEN = 4;
	    			end
	    			2'd2: begin
	    				MATRIX_SIZE = 64;
	    				MATRIX_LEN = 8;
	    			end
	    			2'd3: begin
	    				MATRIX_SIZE = 256;
	    				MATRIX_LEN = 16;
	    			end
	    		endcase
	    	end
    		a = $fscanf(input_file,"%d\n",in_data);
    		@(negedge clk);
    		action = 3'bx;
    		size = 2'bx;
    		for(i=0; i<MATRIX_SIZE-1; i=i+1)begin
				a = $fscanf(input_file,"%d\n",in_data);
				if(out_valid !== 0) begin
					$display ("--------------------------------------------------------------------------------");
					$display ("                                   FAIL!                                        ");
					$display ("                      out_valid overlap with in_valid                           ");                     
					$display ("--------------------------------------------------------------------------------");
					#(1);
					$finish ;
				end
				@(negedge clk);
			end
		end
    	default: begin
    		@(negedge clk);
    		action = 3'bx;
    	end
    endcase
	in_valid = 0;
	in_data = 31'bx;
end endtask

task wait_task ; begin
	cycles = 0;
	while(out_valid !== 1)begin
		cycles = cycles + 1;
		if(cycles == 25000) begin
			$display ("--------------------------------------------------------------------------------");
			$display ("                                   FAIL!                                        ");
			$display ("               The execution latency are over 25000 cycles                      ");
			$display ("--------------------------------------------------------------------------------");
			#(1);
			$finish;
		end
		@(negedge clk);
	end
	total_cycles = total_cycles + cycles - 1;
end endtask

task check_task ; begin
    if(out_valid === 1) begin
    	mismatch=0;
    	case(mode)
    		0, 1, 2: begin
    			for(i=0; i<MATRIX_SIZE; i=i+1) begin
    				a = $fscanf(output_file, "%d\n", golden_out);
    				golden_matrix[i] = golden_out;
    				your_matrix[i] = out_data;
    				if(out_data !== golden_out) mismatch = 1;
    				@(negedge clk);
    			end
    			if(mismatch===1) begin
					$display ("\033[0;31mPattern NO.%1d FAIL!\033[m", p);
					$display ("Your Matrix:");
					for(i=0; i<MATRIX_SIZE; i=i+1) begin
						$write ("%2d", your_matrix[i]);
						if(((i+1)%MATRIX_LEN) == 0) $write ("\n");
					end
					$display ("Golden Matrix:");
					for(i=0; i<MATRIX_SIZE; i=i+1) begin
						$write ("%2d", golden_matrix[i]);
						if(((i+1)%MATRIX_LEN) == 0) $write ("\n");
					end
					#(1);
					$finish;
    			end
    		end
    		default: begin
    			if(out_data !== 0) begin	
	    			$display ("--------------------------------------------------------------------------------");
					$display ("                                   FAIL!                                        ");
					$display ("                        output_data should be ZERO                              ");
					$display ("--------------------------------------------------------------------------------");
					#(1);
					$finish;
				end
    		end
    	endcase
    	$display ("\033[0;32mPattern NO.%1d PASS! \033[m", p);
    end
end endtask

task pass_task;begin
	$display ("----------------------------------------------------------------------------");
	$display ("                              Congratulations!                              ");
	$display ("                       You have passed all patterns!                        ");
	$display ("                                                                            ");
	$display ("                    Your execution cycles   = %2d cycles                    ", total_cycles);
	$display ("                    Your clock period       = %.1f ns                       ", `CYCLE_TIME);
	$display ("                    Computation Time        = %.1f ns                       ", (total_cycles + PATNUM)*`CYCLE_TIME);
	$display ("----------------------------------------------------------------------------");
end endtask 

endmodule

