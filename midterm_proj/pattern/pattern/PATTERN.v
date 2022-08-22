`ifdef RTL
`define CYCLE_TIME 20
`endif
`ifdef GATE
`define CYCLE_TIME 20
`endif


`ifdef FUNC
`define PAT_NUM 25
`endif
`ifdef PERF
`define PAT_NUM 25
`endif

`include "../00_TESTBED/MEM_MAP_define.v"
`include "../00_TESTBED/pseudo_DRAM1.v"
`include "../00_TESTBED/pseudo_DRAM_read.v"

module PATTERN #(parameter ID_WIDTH=4, DATA_WIDTH=32, ADDR_WIDTH=32, DRAM_NUMBER=2, WRIT_NUMBER=1)(
        
    clk, 
     rst_n, 
 
     PADDR,
    PRDATA,
     PSELx, 
   PENABLE, 
    PWRITE, 
    PREADY,  
 

         awid_s_inf,
       awaddr_s_inf,
       awsize_s_inf,
      awburst_s_inf,
        awlen_s_inf,
      awvalid_s_inf,
      awready_s_inf,
                    
        wdata_s_inf,
        wlast_s_inf,
       wvalid_s_inf,
       wready_s_inf,
                    
          bid_s_inf,
        bresp_s_inf,
       bvalid_s_inf,
       bready_s_inf,
                    
         arid_s_inf,
       araddr_s_inf,
        arlen_s_inf,
       arsize_s_inf,
      arburst_s_inf,
      arvalid_s_inf,
                    
      arready_s_inf, 
          rid_s_inf,
        rdata_s_inf,
        rresp_s_inf,
        rlast_s_inf,
       rvalid_s_inf,
       rready_s_inf


             );




//Connection wires
output reg     clk,rst_n;
        

// APB channel 
output reg [ADDR_WIDTH-1:0]     PADDR;
input wire [DATA_WIDTH-1:0]     PRDATA;
output reg              PSELx;
output reg                   PENABLE;
output reg                 PWRITE;
input wire                  PREADY;




// axi write address channel 
input wire [WRIT_NUMBER * ID_WIDTH-1:0]        awid_s_inf;
input wire [WRIT_NUMBER * ADDR_WIDTH-1:0]    awaddr_s_inf;
input wire [WRIT_NUMBER * 3 -1:0]            awsize_s_inf;
input wire [WRIT_NUMBER * 2 -1:0]           awburst_s_inf;
input wire [WRIT_NUMBER * 4 -1:0]             awlen_s_inf;
input wire [WRIT_NUMBER-1:0]                awvalid_s_inf;
output wire [WRIT_NUMBER-1:0]               awready_s_inf;
// axi write data channel 
input wire [WRIT_NUMBER * DATA_WIDTH-1:0]     wdata_s_inf;
input wire [WRIT_NUMBER-1:0]                  wlast_s_inf;
input wire [WRIT_NUMBER-1:0]                 wvalid_s_inf;
output wire [WRIT_NUMBER-1:0]                wready_s_inf;
// axi write response channel
output wire [WRIT_NUMBER * ID_WIDTH-1:0]         bid_s_inf;
output wire [WRIT_NUMBER * 2 -1:0]             bresp_s_inf;
output wire [WRIT_NUMBER-1:0]                bvalid_s_inf;
input wire [WRIT_NUMBER-1:0]                  bready_s_inf;
// -----------------------------
// axi read address channel 
input wire [DRAM_NUMBER * ID_WIDTH-1:0]       arid_s_inf;
input wire [DRAM_NUMBER * ADDR_WIDTH-1:0]   araddr_s_inf;
input wire [DRAM_NUMBER * 4 -1:0]            arlen_s_inf;
input wire [DRAM_NUMBER * 3 -1:0]           arsize_s_inf;
input wire [DRAM_NUMBER * 2 -1:0]          arburst_s_inf;
input wire [DRAM_NUMBER-1:0]               arvalid_s_inf;
output wire [DRAM_NUMBER-1:0]              arready_s_inf;
// -----------------------------
// axi read data channel 
output wire [DRAM_NUMBER * ID_WIDTH-1:0]         rid_s_inf;
output wire [DRAM_NUMBER * DATA_WIDTH-1:0]     rdata_s_inf;
output wire [DRAM_NUMBER * 2 -1:0]             rresp_s_inf;
output wire [DRAM_NUMBER-1:0]                  rlast_s_inf;
output wire [DRAM_NUMBER-1:0]                 rvalid_s_inf;
input wire [DRAM_NUMBER-1:0]                  rready_s_inf;
// -----------------------------





pseudo_DRAM1 u_DRAM1(

     .clk(clk),
     .rst_n(rst_n),

   .   awid_s_inf(   awid_s_inf[3:0] ),
   . awaddr_s_inf( awaddr_s_inf[31:0] ),
   . awsize_s_inf( awsize_s_inf[2:0] ),
   .awburst_s_inf(awburst_s_inf[1:0] ),
   .  awlen_s_inf(  awlen_s_inf[3:0] ),
   .awvalid_s_inf(awvalid_s_inf[0]  ),
   .awready_s_inf(awready_s_inf[0]  ),

   .  wdata_s_inf(  wdata_s_inf[31:0] ),
   .  wlast_s_inf(  wlast_s_inf[0]  ),
   . wvalid_s_inf( wvalid_s_inf[0]  ),
   . wready_s_inf( wready_s_inf[0]  ),

   .    bid_s_inf(    bid_s_inf[3:0] ),
   .  bresp_s_inf(  bresp_s_inf[1:0] ),
   . bvalid_s_inf( bvalid_s_inf[0]  ),
   . bready_s_inf( bready_s_inf[0]  ),

   .   arid_s_inf(   arid_s_inf[3:0] ),
   . araddr_s_inf( araddr_s_inf[31:0] ),
   .  arlen_s_inf(  arlen_s_inf[3:0] ),
   . arsize_s_inf( arsize_s_inf[2:0] ),
   .arburst_s_inf(arburst_s_inf[1:0] ),
   .arvalid_s_inf(arvalid_s_inf[0]  ),
   .arready_s_inf(arready_s_inf[0]  ), 

   .    rid_s_inf(    rid_s_inf[3:0] ),
   .  rdata_s_inf(  rdata_s_inf[31:0] ),
   .  rresp_s_inf(  rresp_s_inf[1:0] ),
   .  rlast_s_inf(  rlast_s_inf[0]  ),
   . rvalid_s_inf( rvalid_s_inf[0]  ),
   . rready_s_inf( rready_s_inf[0]  )



);


pseudo_DRAM_read u_DRAM_read(

     .clk(clk),
     .rst_n(rst_n),

  // .   awid_s_inf(   awid_s_inf[7:4] ),
  // . awaddr_s_inf( awaddr_s_inf[63:32] ),
  // . awsize_s_inf( awsize_s_inf[5:3] ),
  // .awburst_s_inf(awburst_s_inf[3:2] ),
  // .  awlen_s_inf(  awlen_s_inf[7:4] ),
  // .awvalid_s_inf(awvalid_s_inf[1]  ),
  // .awready_s_inf(awready_s_inf[1]  ),
  //
  // .  wdata_s_inf(  wdata_s_inf[63:32] ),
  // .  wlast_s_inf(  wlast_s_inf[1]  ),
  // . wvalid_s_inf( wvalid_s_inf[1]  ),
  // . wready_s_inf( wready_s_inf[1]  ),
  //
  // .    bid_s_inf(    bid_s_inf[7:4] ),
  // .  bresp_s_inf(  bresp_s_inf[3:2] ),
  // . bvalid_s_inf( bvalid_s_inf[1]  ),
  // . bready_s_inf( bready_s_inf[1]  ),

   .   arid_s_inf(   arid_s_inf[7:4] ),
   . araddr_s_inf( araddr_s_inf[63:32] ),
   .  arlen_s_inf(  arlen_s_inf[7:4] ),
   . arsize_s_inf( arsize_s_inf[5:3] ),
   .arburst_s_inf(arburst_s_inf[3:2] ),
   .arvalid_s_inf(arvalid_s_inf[1]  ),
   .arready_s_inf(arready_s_inf[1]  ), 

   .    rid_s_inf(    rid_s_inf[7:4] ),
   .  rdata_s_inf(  rdata_s_inf[63:32] ),
   .  rresp_s_inf(  rresp_s_inf[3:2] ),
   .  rlast_s_inf(  rlast_s_inf[1]  ),
   . rvalid_s_inf( rvalid_s_inf[1]  ),
   . rready_s_inf( rready_s_inf[1]  ) 

);

integer wait_val_time, total_latency;
    integer pat_file_out, pat_file_data, pat_file_dram1;
    integer pat_cnt_big;
    integer gap;
    integer gold_out, gold_out_dram1;
    integer c, d, e, f, g,pat_cnt,i;
    integer m;
    integer dram1_loc,temp;
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
        pat_file_data = $fopen("../00_TESTBED/input.txt", "r");
        pat_file_out = $fopen("../00_TESTBED/output.txt", "r");


        $fscanf(pat_file_data,"%d\n",pat_cnt);
        rst_n = 1'b1;
	PENABLE= 1'b0;
            PADDR= 32'b0000_0000_0000_0000_0000_0000_0000_0000;
	PSELx= 1'b0;
	PWRITE= 1'b1;
        force clk = 0;
        total_latency = 0;
        reset_signal_task;
        repeat(4)@(negedge clk);
        for(pat_cnt_big = 0; pat_cnt_big < pat_cnt; pat_cnt_big = pat_cnt_big + 1)begin

                input_data_task;
                wait_out_valid;
                check_ans;
		       // check_ans_dram1;
	    
                
	    $display ("pattern_no: %d, passed! ,total latency: %d",pat_cnt_big,total_latency);
	    delay_task;
        end
        repeat(2)@(negedge clk);
        YOU_PASS_task;
        $finish;
    end
    
    task delay_task ; begin
        gap = $urandom_range(1, 3);
        repeat(gap)@(negedge clk);
    end endtask
    
    task APB_reset_task;
    begin
	PWRITE =1'b1;
	PENABLE = 1'd0;
	PSELx = 1'd0;
	PADDR = 32'd0;
            PADDR= 32'b0000_0000_0000_0000_0000_0000_0000_0000;
    end
    endtask
    
    task input_data_task;
    begin
            PSELx= 1'b1;
	    PWRITE= 1'b0;
	    @(negedge clk);
	    PENABLE= 1'b1;
            g = $fscanf(pat_file_data,"%h\n",PADDR);
	dram1_loc = {({u_DRAM_read.DRAM_r[PADDR+3],u_DRAM_read.DRAM_r[PADDR+2]})>>2,2'b00};
    end
    endtask
    
    task reset_signal_task; 
    begin 
      #(0.5);	rst_n=0;
      #(20/2);
      if((PREADY!== 0)||(PRDATA !== 0)) 
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
      while(PREADY!== 1) begin
        wait_val_time = wait_val_time + 1;
        if(wait_val_time == 100000)
        begin
            $display("***************************************************************");
            $display("*         The execution latency are over 100000 cycles.           *");
            $display("***************************************************************");
            repeat(2)@(negedge clk);
            $finish;
        end
        @(negedge clk);
        total_latency = total_latency + wait_val_time;
      end
    end
    endtask
    
    task check_ans;
    begin
       if(PREADY === 1) begin
	APB_reset_task;
            c = $fscanf(pat_file_out,"%h\n",gold_out);
            if(PRDATA!== gold_out) begin
                
            $display("***************************************************************");
            $display ("                        SPEC 7 IS FAIL                        ");
            $display ("                    Your answer is fail !                     ");
            $display ("       pattern_no: %d,correct_ans: %h , your ans: %h ,total latency: %d           ",pat_cnt_big,gold_out,PRDATA,total_latency);
            $display("***************************************************************"); 
            $finish;

                @(negedge clk);
                $finish;
            end
	
	for(i=0;i<256;i=i+1)begin
            m = $fscanf(pat_file_out,"%h",gold_out_dram1);
	temp={u_DRAM1.DRAM_r[dram1_loc+4*i+3],u_DRAM1.DRAM_r[dram1_loc+4*i+2],
u_DRAM1.DRAM_r[dram1_loc+4*i+1],
u_DRAM1.DRAM_r[dram1_loc+4*i+0]};

            if(temp !== gold_out_dram1) begin
                
            $display("***************************************************************");
            $display ("                        SPEC 7 IS FAIL                        ");
            $display ("                    Your answer is fail !                     ");
	$display ("       dram1_initial_location : %d           ",dram1_loc);
            $display ("       pattern_no: %d, array location: %d %d           ",pat_cnt_big,i/16,i%16);
            $display ("       correct_ans: %h , your ans: %h ,total latency: %d           ",gold_out_dram1,temp,total_latency);
            $display("***************************************************************"); 
            $finish;
	   end
                @(negedge clk);

            end
        end
    end
    endtask




    task YOU_PASS_task; 
    begin
      $display ("--------------------------------------------------------------------");
      $display ("          ~(??é´Œå??~(?—è¸±é¯å??~(??é´Œå??~(?—è¸±é¯å??~(??é´Œå??~            ");
      $display ("                         Congratulations!                           ");
      $display ("                  You have passed all patterns!                     ");
      $display ("--------------------------------------------------------------------");        
         
    #(500);
    $finish;
    end
    endtask

endmodule
