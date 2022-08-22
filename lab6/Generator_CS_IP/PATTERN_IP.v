`ifdef RTL
	`timescale 1ns/10ps
	`include "CS_IP_Demo.v"  
	`define CYCLE_TIME 20.0
`endif
`ifdef GATE
	`timescale 1ns/10ps
	`include "CS_IP_Demo_SYN.v"
	`define CYCLE_TIME 20.0
`endif

//synopsys translate_off
//`include "CS_IP.v"
//synopsys translate_on

module PATTERN_IP
#(parameter WIDTH_DATA = 64, parameter WIDTH_RESULT = 64)
(
    //  Output signals
    data,
    in_valid, clk, rst_n,
    //  Input signals
    result,
    out_valid
);
//---------------------------------------------------------------------
//   PARAMETER
//---------------------------------------------------------------------


//================================================================
//   INPUT AND OUTPUT DECLARATION                         
//================================================================
output reg[(WIDTH_DATA - 1):0] data;
output reg in_valid, clk, rst_n;
input [(WIDTH_RESULT - 1):0] result;
input out_valid;

integer wait_val_time, total_latency;
    integer pat_file_out, pat_file_data;
    integer pat_cnt_big;
    integer gap;
    integer gold_out;
    integer c, d, e, f, g,pat_cnt;
    //================================================================
    // clock
    //================================================================
    initial 
    begin
        clk = 0;
    end
    always #(10/2.0) clk = ~clk;
    
    initial 
    begin
        pat_file_data = $fopen("../00_TESTBED/input.txt", "r");
        pat_file_out = $fopen("../00_TESTBED/output.txt", "r");
        $fscanf(pat_file_data,"%d\n",pat_cnt);
        rst_n = 1'b1;
        in_valid= 1'b0;
        data= 64'bx;
        force clk = 0;
        reset_signal_task;
        @(negedge clk);
        for(pat_cnt_big = 0; pat_cnt_big < pat_cnt; pat_cnt_big = pat_cnt_big + 1)begin

                input_data_task;
                wait_out_valid;
                check_ans;
                delay_task;

        end
        repeat(2)@(negedge clk);
        YOU_PASS_task;
        $finish;
    end
    
    task delay_task ; begin
        gap = $urandom_range(1, 2);
        repeat(gap)@(negedge clk);
    end endtask
    
    
    task input_data_task;
    begin
            in_valid= 1;
            g = $fscanf(pat_file_data,"%b\n",data);
            @(negedge clk);
            data= 64'bx;
            in_valid = 0;
    end
    endtask
    
    task reset_signal_task; 
    begin 
      #(0.5);	rst_n=0;
      #(20/2);
      if((out_valid !== 0)||(result !== 0)) 
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
        if(wait_val_time == 100)
        begin
            $display("***************************************************************");
            $display("*         The execution latency are over 100 cycles.           *");
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
       if(out_valid === 1) begin
            c = $fscanf(pat_file_out,"%b\n",gold_out);
            if(result!== gold_out) begin
                
            $display("***************************************************************");
            $display ("                        SPEC 7 IS FAIL                        ");
            $display ("                    Your answer is fail !                     ");
            $display ("       pattern_no: %d,correct_ans: %b , your ans: %b            ",pat_cnt_big,gold_out,result);
            $display("***************************************************************"); 
            $finish;

                @(negedge clk);
                $finish;
            end

	else begin
            $display ("pattern_no: %d, passed!",pat_cnt_big);
            end

        end
    end
    endtask
    
    
    
    task YOU_PASS_task; 
    begin
      $display ("--------------------------------------------------------------------");
      $display ("          ~(嚙?嚙?~(嚗踱嚗?~(嚙?嚙?~(嚗踱嚗?~(嚙?嚙?~            ");
      $display ("                         Congratulations!                           ");
      $display ("                  You have passed all patterns!                     ");
      $display ("--------------------------------------------------------------------");        
         
    #(500);
    $finish;
    end
    endtask
    
    endmodule


