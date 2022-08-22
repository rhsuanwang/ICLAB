`ifdef RTL
`define CYCLE_TIME 20
`endif
`ifdef GATE
`define CYCLE_TIME 20
`endif


`ifdef FUNC
`define PAT_NUM 10
`endif
`ifdef PERF
`define PAT_NUM 10
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
output reg			  clk,rst_n;
        

// APB channel 
output reg [ADDR_WIDTH-1:0] 	PADDR;
input wire [DATA_WIDTH-1:0]  	PRDATA;
output reg			    	  	PSELx;
output reg		                PENABLE;
output reg 		                PWRITE;
input wire 			            PREADY;




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
output wire [WRIT_NUMBER-1:0]             	  bvalid_s_inf;
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

    .   awid_s_inf(   awid_s_inf[3:0]	),
    . awaddr_s_inf( awaddr_s_inf[31:0]	),
    . awsize_s_inf( awsize_s_inf[2:0]	),
    .awburst_s_inf(awburst_s_inf[1:0]	),
    .  awlen_s_inf(  awlen_s_inf[3:0]	),
    .awvalid_s_inf(awvalid_s_inf[0]		),
    .awready_s_inf(awready_s_inf[0]		),
    
    .  wdata_s_inf(  wdata_s_inf[31:0]	),
    .  wlast_s_inf(  wlast_s_inf[0]		),
    . wvalid_s_inf( wvalid_s_inf[0]		),
    . wready_s_inf( wready_s_inf[0]		),
    
    .    bid_s_inf(    bid_s_inf[3:0]	),
    .  bresp_s_inf(  bresp_s_inf[1:0]	),
    . bvalid_s_inf( bvalid_s_inf[0]		),
    . bready_s_inf( bready_s_inf[0]		),
    
    .   arid_s_inf(   arid_s_inf[3:0]	),
    . araddr_s_inf( araddr_s_inf[31:0]	),
    .  arlen_s_inf(  arlen_s_inf[3:0]	),
    . arsize_s_inf( arsize_s_inf[2:0]	),
    .arburst_s_inf(arburst_s_inf[1:0]	),
    .arvalid_s_inf(arvalid_s_inf[0]		),
    .arready_s_inf(arready_s_inf[0]		), 
    
    .    rid_s_inf(    rid_s_inf[3:0]	),
    .  rdata_s_inf(  rdata_s_inf[31:0]	),
    .  rresp_s_inf(  rresp_s_inf[1:0]	),
    .  rlast_s_inf(  rlast_s_inf[0]		),
    . rvalid_s_inf( rvalid_s_inf[0]		),
    . rready_s_inf( rready_s_inf[0]		) 

);


pseudo_DRAM_read u_DRAM_read(

  	.clk(clk),
  	.rst_n(rst_n),

    .   arid_s_inf(   arid_s_inf[7:4]	),
    . araddr_s_inf( araddr_s_inf[63:32]	),
    .  arlen_s_inf(  arlen_s_inf[7:4]	),
    . arsize_s_inf( arsize_s_inf[5:3]	),
    .arburst_s_inf(arburst_s_inf[3:2]	),
    .arvalid_s_inf(arvalid_s_inf[1]		),
    .arready_s_inf(arready_s_inf[1]		), 

    .    rid_s_inf(    rid_s_inf[7:4]	),
    .  rdata_s_inf(  rdata_s_inf[63:32]	),
    .  rresp_s_inf(  rresp_s_inf[3:2]	),
    .  rlast_s_inf(  rlast_s_inf[1]		),
    . rvalid_s_inf( rvalid_s_inf[1]		),
    . rready_s_inf( rready_s_inf[1]		) 

);



//================================================================
// parameters & integer
//================================================================
real	CYCLE   =   `CYCLE_TIME;
integer PATNUM;//  =   10;
integer i,j,k,l,lat,latency,total_latency;
integer gap,patcount;
integer file;


//================================================================
// wire & registers 
//================================================================
reg check_done ;
reg [ADDR_WIDTH-1:0] instru_loc;
reg [DATA_WIDTH-1:0] instru;
reg [DATA_WIDTH-1:0] gold_ans ;  
reg [DATA_WIDTH-1:0] temp ;  
reg [ADDR_WIDTH-1:0] dram1_loc;
reg [ADDR_WIDTH-1:0] addr_tmp;
//---------------------------------------------------------------------
//   CLOCK GENERATION
//---------------------------------------------------------------------
always	#(CYCLE/2.0) clk = ~clk;
initial	clk = 0;

//---------------------------------------------------------------------
//   initial
//---------------------------------------------------------------------

initial begin
    rst_n = 1'b1;	 
       
	force clk = 0;
	
	APB_reset_task;
    total_latency = 0; 
	reset_task;

	file=$fopen("../00_TESTBED/pattern.txt","r");
    k = $fscanf(file, "%d", PATNUM);
	for(patcount=0;patcount<PATNUM;patcount=patcount+1) begin
        latency = 0;
		input_task;
		wait_busy;
		check_ans;
		$display("\033[0;34mPASS PATTERN NO.%4d,\033[m \033[0;32m Latency: %3d \033[m \033[0;31m \033[m",
				patcount ,latency);
		total_latency = total_latency + latency;
        
    end

	YOU_PASS_task;
	$finish;
end


task reset_task; begin 
    #(0.5);	rst_n = 0;
	#(2.0);
	if ( (PREADY !== 1'b0) || (PRDATA !== 32'b0) ) begin//|| awid_s_inf !== 0 || awaddr_s_inf !== 0 || awsize_s_inf !== 0 || awburst_s_inf !== 0 || awlen_s_inf !== 0 || awvalid_s_inf !== 0 || wdata_s_inf !== 0 || wlast_s_inf !== 0 || wvalid_s_inf !== 0 || bready_s_inf !== 0 ||  arid_s_inf !== 0 ||araddr_s_inf !==0 ||  arsize_s_inf!== 0 ||  arburst_s_inf !== 0 ||  awlen_s_inf !== 0 ||  arvalid_s_inf !== 0 ||  rready_s_inf !== 0 ) begin
		$display ("------------------------------------------------------------------------");
		$display ("                              FAIL!                                     ");
		$display ("        Output signal should be 0 after initial RESET at %8t       ",$time);
		$display ("------------------------------------------------------------------------");
		$finish;
	end
	#(10);	rst_n=1;
	#(3);	release clk;    
end endtask



task input_task; begin
	gap = $urandom_range(1,3);
	repeat(gap)@(negedge clk);
    PWRITE = 0;
    PSELx  = 1;
    @(negedge clk);
	k = $fscanf(file, "%h", instru_loc);
    PADDR   = instru_loc;
    PENABLE = 1;
    
    k = $fscanf(file, "%h", instru);
	dram1_loc = ({16'b0, instru[31:18]})<<2;

end endtask


task wait_busy; begin
	lat = -1;
	@(negedge clk);
    while( PREADY!==1 ) begin
		lat = lat + 1;
		if(lat == 100000) begin
			$display ("------------------------------------------------------------");
			$display ("      The execution latency is over 100000 cycles          ");
			$display ("------------------------------------------------------------");
			repeat(2)@(negedge clk);
			$finish;
		end
		@(negedge clk);	
	end
	latency = latency + lat;
end endtask


task check_ans; begin
	while( PREADY===1 ) begin
        APB_reset_task;
        if ( instru !== PRDATA ) begin
            $display ("-------------------------------------------");
			$display ("     PATTERN NO.%4d place:%3d TIME %4t     ",patcount,i,$time);
			$display ("         ANSWER INSTRU. is %h.             ",instru);
			$display ("         OUTPUT INSTRU. is %h.             ",PRDATA);
			$display ("-------------------------------------------");
			repeat(9) @(negedge clk);
			$finish;   
        end
        
		for(i=0;i<256;i=i+1) begin
			k = $fscanf(file, "%h", gold_ans);
            
			temp = { u_DRAM1.DRAM_r[dram1_loc+4*i+3], 
                     u_DRAM1.DRAM_r[dram1_loc+4*i+2], 
                     u_DRAM1.DRAM_r[dram1_loc+4*i+1], 
                     u_DRAM1.DRAM_r[dram1_loc+4*i+0] }; 
                     
			if(temp !== gold_ans) begin
				$display ("--------------------------------------");
				$display ("     PATTERN NO.%4d   TIME %4t        ",patcount,$time);
                $display ("           Location is %h.            ",dram1_loc+4*i);
                $display ("             number is %h.            ",4*i);
				$display ("             Answer is %h.            ",gold_ans);
				$display ("             Output is %h.            ",temp);
				$display ("--------------------------------------");
				repeat(5) @(negedge clk);
				$finish;
			end
        end
		#(100);
		@(negedge clk);
	end
end endtask

task YOU_PASS_task; begin
    $display ("--------------------------------------------------------------------");
    $display ("                         Congratulations!                           ");
    $display ("                  You have passed all patterns!                     ");
    $display ("--------------------------------------------------------------------");        
    repeat(2)@(negedge clk);
    $finish;
end endtask


task APB_reset_task; begin
    PWRITE  =   1'b0;
    PENABLE =   1'b0;
    PSELx   =   1'd0;
    PADDR   =   32'd0;
end endtask

endmodule



