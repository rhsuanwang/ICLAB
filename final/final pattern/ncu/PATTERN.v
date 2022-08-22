`ifdef RTL
	`define CYCLE_TIME 4.0 
	`define RTL_GATE
`elsif GATE
	`define CYCLE_TIME 4.0
	`define RTL_GATE
`elsif CHIP
    `define CYCLE_TIME 6.0
    `define CHIP_POST 
`elsif POST
    `define CYCLE_TIME 6.0
    `define CHIP_POST 
`endif


`ifdef FUNC
`define MAX_WAIT_READY_CYCLE 2000
`endif
`ifdef PERF
`define MAX_WAIT_READY_CYCLE 100000
`endif


`include "../00_TESTBED/MEM_MAP_define.v"
`include "../00_TESTBED/pseudo_DRAM_data.v"
`include "../00_TESTBED/pseudo_DRAM_inst.v"

module PATTERN(
    			clk,
			  rst_n,
		   IO_stall,


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

//---------------------------------------------------------------------
//   PORT DECLARATION          
//---------------------------------------------------------------------
parameter ID_WIDTH=4, DATA_WIDTH=16, ADDR_WIDTH=32, DRAM_NUMBER=2, WRIT_NUMBER=1;

output reg			clk,rst_n;
input				IO_stall;

// axi write address channel 
input wire [WRIT_NUMBER * ID_WIDTH-1:0]        awid_s_inf;
input wire [WRIT_NUMBER * ADDR_WIDTH-1:0]    awaddr_s_inf;
input wire [WRIT_NUMBER * 3 -1:0]            awsize_s_inf;
input wire [WRIT_NUMBER * 2 -1:0]           awburst_s_inf;
input wire [WRIT_NUMBER * 7 -1:0]             awlen_s_inf;
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
input wire [DRAM_NUMBER * 7 -1:0]            arlen_s_inf;
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
pseudo_DRAM_data u_DRAM_data(

  	  .clk(clk),
  	  .rst_n(rst_n),

   .   awid_s_inf(   awid_s_inf[3:0]	),
   . awaddr_s_inf( awaddr_s_inf[31:0]	),
   . awsize_s_inf( awsize_s_inf[2:0]	),
   .awburst_s_inf(awburst_s_inf[1:0]	),
   .  awlen_s_inf(  awlen_s_inf[6:0]	),
   .awvalid_s_inf(awvalid_s_inf[0]		),
   .awready_s_inf(awready_s_inf[0]		),

   .  wdata_s_inf(  wdata_s_inf[15:0]	),
   .  wlast_s_inf(  wlast_s_inf[0]		),
   . wvalid_s_inf( wvalid_s_inf[0]		),
   . wready_s_inf( wready_s_inf[0]		),

   .    bid_s_inf(    bid_s_inf[3:0]	),
   .  bresp_s_inf(  bresp_s_inf[1:0]	),
   . bvalid_s_inf( bvalid_s_inf[0]		),
   . bready_s_inf( bready_s_inf[0]		),

   .   arid_s_inf(   arid_s_inf[3:0]	),
   . araddr_s_inf( araddr_s_inf[31:0]	),
   .  arlen_s_inf(  arlen_s_inf[6:0]	),
   . arsize_s_inf( arsize_s_inf[2:0]	),
   .arburst_s_inf(arburst_s_inf[1:0]	),
   .arvalid_s_inf(arvalid_s_inf[0]		),
   .arready_s_inf(arready_s_inf[0]		), 

   .    rid_s_inf(    rid_s_inf[3:0]	),
   .  rdata_s_inf(  rdata_s_inf[15:0]	),
   .  rresp_s_inf(  rresp_s_inf[1:0]	),
   .  rlast_s_inf(  rlast_s_inf[0]		),
   . rvalid_s_inf( rvalid_s_inf[0]		),
   . rready_s_inf( rready_s_inf[0]		) 

);

pseudo_DRAM_inst u_DRAM_inst(

  	  .clk(clk),
  	  .rst_n(rst_n),

  // .   awid_s_inf(   awid_s_inf[7:4]	),
  // . awaddr_s_inf( awaddr_s_inf[63:32]	),
  // . awsize_s_inf( awsize_s_inf[5:3]	),
  // .awburst_s_inf(awburst_s_inf[3:2]	),
  // .  awlen_s_inf(  awlen_s_inf[7:4]	),
  // .awvalid_s_inf(awvalid_s_inf[1]		),
  // .awready_s_inf(awready_s_inf[1]		),
  //
  // .  wdata_s_inf(  wdata_s_inf[63:32]	),
  // .  wlast_s_inf(  wlast_s_inf[1]		),
  // . wvalid_s_inf( wvalid_s_inf[1]		),
  // . wready_s_inf( wready_s_inf[1]		),
  //
  // .    bid_s_inf(    bid_s_inf[7:4]	),
  // .  bresp_s_inf(  bresp_s_inf[3:2]	),
  // . bvalid_s_inf( bvalid_s_inf[1]		),
  // . bready_s_inf( bready_s_inf[1]		),

   .   arid_s_inf(   arid_s_inf[7:4]	),
   . araddr_s_inf( araddr_s_inf[63:32]	),
   .  arlen_s_inf(  arlen_s_inf[13:7]	),
   . arsize_s_inf( arsize_s_inf[5:3]	),
   .arburst_s_inf(arburst_s_inf[3:2]	),
   .arvalid_s_inf(arvalid_s_inf[1]		),
   .arready_s_inf(arready_s_inf[1]		), 

   .    rid_s_inf(    rid_s_inf[7:4]	),
   .  rdata_s_inf(  rdata_s_inf[31:16]	),
   .  rresp_s_inf(  rresp_s_inf[3:2]	),
   .  rlast_s_inf(  rlast_s_inf[1]		),
   . rvalid_s_inf( rvalid_s_inf[1]		),
   . rready_s_inf( rready_s_inf[1]		) 

);

integer cycles, total_cycles;
integer pat_cnt;
integer PATNUM = 489;

reg [7:0]DRAM_data_gold[0:4095];//DRAM_INIT
reg [7:0]DRAM_inst[0:4095];

reg [15:0]instruction;
wire [3:0]rs = instruction[12:9];
wire [3:0]rt = instruction[8:5];
wire [3:0]rd = instruction[4:1];
wire func = instruction[0];
wire [2:0]opcode = instruction[15:13];
wire [12:0]address = instruction[12:0];
wire signed [4:0]immediate = instruction[4:0];

reg [11:0]pc = 0;
integer i;
reg signed [15:0]golden_reg[15:0];
always	#(`CYCLE_TIME /2.0) clk= ~clk;
initial begin
    force clk = 0;
    rst_n = 1'b1;
    Reset_Signal_task;
    
    for(pat_cnt = 0; pat_cnt < PATNUM; pat_cnt = pat_cnt + 1)begin
        cal_ans;
        wait_out_valid;
        check_ans;
        @(negedge clk);
    end
    YOU_PASS_TASK;
    @(negedge clk);
	$finish;
end

task YOU_PASS_TASK; 
begin
	$display("                               `-:/+++++++/:-`                       "); 
	$display("                          ./shmNdddmmNNNMMMMMNNhs/.                  "); 
	$display("                       `:yNMMMMMdo------:/+ymMMMMMNds-               "); 
	$display("                     `+dNMMNysmMMMd/....-ymNMMMMNMMMMMd+`            "); 
	$display("                    .+NMMNy:-.-oNMMm..../MMMNho:-+dMMMMMm+`          "); 
	$display("      ``            +-oso/:::::/+so:....-:+++//////hNNm++dd-         "); 
	$display("      +/-  -`      -:.-//--.....-:+-.....-+/--....--/+-..:Nm:        "); 
	$display("  :--./-:::/.      /-.+:..-:+oso+:-+....-+:/oso+:....-+:..yMN:       "); 
	$display("  -/:-:-.+-/      `+--+.-smNMMMMMNh/....:ymNMMMMNy:...-+../MMm.      "); 
	$display(" ::/+-...--/   `--:-...-dMMMh/.-yMMd-..-mMMy::oNMMm:...-..-mMMy.`    "); 
	$display(" .-:+:.....---::-......+MMMM-  `sMMN-..oMMN.  .mMMM+.......hd+:-::`  "); 
	$display("   /+/::/:..:/-........:mMMMmddmMMMs...+NMMmddNMMMm:......-+-....-/. "); 
	$display("   ```  `/.::...........:odmNNNNmh/-..../ydmNNNmds:.......-.......-+`"); 
	$display("         -:+..............--::::--........--:::--..................::"); 
	$display("          //.......................................................-:"); 
	$display("          `+...........................................--::::-....-/`"); 
	$display("           ::.....................................-//os+/+/+oo----.` "); 
	$display("            :/-.............................-::/\033[0;31;111mosyyyyyyyyyyyh\033[m-"); 
	$display("             +s+:-...................--::/\033[0;31;111m+ssyyyyyyyyyyyyyyyyy\033[m+      "); 
	$display("            .\033[0;31;111myyyyso+:::----:/::://+osssyyyyyyyyyyyyyyyyyyyyyyyy\033[m-     "); 
	$display("             -/\033[0;31;111msyyyyyyysssssssyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy\033[m.    "); 
	$display("               `-/\033[0;31;111mssyhyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy\033[m`   "); 
	$display("                  `.\033[0;31;111mohyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyhyyyyyyyyyyss\033[m/   "); 
	$display("                   `\033[0;31;111myyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyydyyyyysso/o\033[m.`    "); 
	$display("                   :\033[0;31;111mhyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyhhhyy\033[m:-...+      "); 
	$display("                   \033[0;31;111msyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy\033[m+....o      "); 
	$display("                  `\033[0;31;111mhyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy\033[m+:..//      "); 
	$display("                  :\033[0;31;111mhyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy\033[m:+.-o`      "); 
	$display("                  -\033[0;31;111mhyyyyyyssoosyyyyyssoosyyyyyyssoo+oosy\033[m+--..o`      "); 
	$display("                  `s\033[0;33;219m/////:-.``.://::-.``.:/++/:-```````.\033[m+:--:+       "); 
	$display("                  ./\033[0;33;219m`````````````````````````````````````\033[ms.-.        "); 
	$display("                  /-\033[0;33;219m`````````````````. ``````````````````\033[mo           "); 
	$display("                  +\033[0;33;219m``````````````````. ``````````````````\033[m+`          "); 
	$display("                  +-\033[0;33;219m....-...---------: :::::::::::::/::::\033[m+`          "); 
	$display("                  `\033[0;33;219m.....+::::-:+`````   `   `/+..---o:```\033[m            "); 
	$display("                        :-..../`              o-....s``              "); 
	$display("                        ./-.--o               :+:::/o                "); 
	$display("                         /::--o               `o````o                "); 
	$display("                        -//   +                +- `-s/               "); 
	$display("                      `-/-::::o:              :+////-+/:-`           "); 
	$display("                  `///:-:///:::+             `+////:////+s+          "); 
    $display("********************************************************************");
    $display("                        \033[0;38;5;219mCongratulations!\033[m      ");
    $display("                 \033[0;38;5;219mYou have passed all patterns!\033[m");
    $display("                 \033[0;38;5;219mTotal Cycles : %d\033[m",total_cycles);
    $display("********************************************************************");
    repeat(2) @(negedge clk);
    $finish;
end
endtask


task Reset_Signal_task; begin
    for(i = 0; i < 4096; i = i + 1)begin
        DRAM_data_gold[i] = u_DRAM_data.DRAM_r[4096 + i];
        DRAM_inst[i] = u_DRAM_inst.DRAM_r[4096 + i];
    end
    total_cycles = 0;
    {golden_reg[0], golden_reg[1], golden_reg[2], golden_reg[3], golden_reg[4], golden_reg[5], golden_reg[6], golden_reg[7],
     golden_reg[8], golden_reg[9], golden_reg[10], golden_reg[11], golden_reg[12], golden_reg[13], golden_reg[14], golden_reg[15]} <= 16'b0000_0000_0000_0000;
	
	#(`CYCLE_TIME); rst_n = 0;

	#(`CYCLE_TIME *3);
	if(IO_stall !== 1) begin
		$display ("--------------------------------------------------------------------------------");
		$display ("                                   FAIL!                                        ");
		$display ("                IO_stall signal should be 1 after initial RESET                 ");
		$display ("--------------------------------------------------------------------------------");
		#(1);
		$finish;
	end
	
	if( (My_CPU.core_r0  !== 0) || (My_CPU.core_r1  !== 0) || (My_CPU.core_r2  !== 0) || (My_CPU.core_r3  !== 0) ||
		(My_CPU.core_r4  !== 0) || (My_CPU.core_r5  !== 0) || (My_CPU.core_r6  !== 0) || (My_CPU.core_r7  !== 0) ||
		(My_CPU.core_r8  !== 0) || (My_CPU.core_r9  !== 0) || (My_CPU.core_r10 !== 0) || (My_CPU.core_r11 !== 0) ||
		(My_CPU.core_r12 !== 0) || (My_CPU.core_r13 !== 0) || (My_CPU.core_r14 !== 0) || (My_CPU.core_r15 !== 0) ) begin
		
		$display ("--------------------------------------------------------------------------------");
		$display ("                                   FAIL!                                        ");
		$display ("               All the registers should be 0 after initial RESET                ");
		$display ("--------------------------------------------------------------------------------");
		#(1);
		$finish;
	end

	#(1);rst_n = 1'b1;
	#(3);release clk;
end endtask

wire signed [16:0]rs_pls = {golden_reg[rs][15], golden_reg[rs]};
wire signed [16:0]rt_pls = {golden_reg[rt][15], golden_reg[rt]};
wire signed [16:0]compare = rs_pls - rt_pls;
wire signed [15:0]r_w_address = immediate + golden_reg[rs];
wire signed [13:0]pc_sign = {2'b00, pc} + 'd1;
reg signed [13:0]pc_temp;
task cal_ans; begin
    instruction = {DRAM_inst[pc * 2 + 1], DRAM_inst[pc * 2]};
    @(negedge clk);
    case(opcode)
        3'b000:begin
            if(!func)begin//ADD
                pc = pc + 1;
                golden_reg[rd] = golden_reg[rs] + golden_reg[rt];
            end
            else begin
                pc = pc + 1;
                golden_reg[rd] = golden_reg[rs] - golden_reg[rt];
            end
        end
        3'b001:begin
            if(!func)begin//ADD
                pc = pc + 1;
                if(compare[16])begin
                    golden_reg[rd] = 1;
                end
                else begin
                    golden_reg[rd] = 0;
                end
            end
            else begin
                pc = pc + 1;
                golden_reg[rd] = golden_reg[rs] * golden_reg[rt];
            end
        end
        3'b010:begin
            pc = pc + 1;
            golden_reg[rt] = {DRAM_data_gold[r_w_address * 2 + 1], DRAM_data_gold[r_w_address * 2]};
        end
        3'b011:begin
            pc = pc + 1;
            DRAM_data_gold[r_w_address * 2 + 1] = golden_reg[rt][15:8];
            DRAM_data_gold[r_w_address * 2 ] = golden_reg[rt][7:0];
        end
        3'b100:begin
            if(golden_reg[rs] == golden_reg[rt])begin
                pc_temp = pc_sign + immediate;
                pc = pc_temp[11:0];
            end
            else begin
                pc = pc + 1;
            end
        end
        3'b101:begin
            pc <= (address - 16'h1000) / 2;
        end
    endcase
end endtask

task wait_out_valid ; begin
	cycles = 0;
	while(IO_stall === 1)begin
		cycles = cycles + 1;
		if(cycles == `MAX_WAIT_READY_CYCLE) begin
			$display( "--------------------------------------------------------------------------------------------------------------------------------------------\n");
			$display( "                                                                                                                                            \n");
			$display( "                                                     The execution latency are over %7d cycles                                              \n",`MAX_WAIT_READY_CYCLE);
			$display( "                                                                                                                                            \n");
			$display( "--------------------------------------------------------------------------------------------------------------------------------------------\n");
			repeat(2)@(negedge clk);
			$finish;
		end
	@(negedge clk);
	end
	total_cycles = total_cycles + cycles;
end endtask

integer j;
task check_ans; begin
    if(!IO_stall)begin
        if(My_CPU.core_r0  !== golden_reg[0 ] || My_CPU.core_r1  !== golden_reg[1 ] || My_CPU.core_r2  !== golden_reg[2 ] || My_CPU.core_r3  !== golden_reg[3 ] ||  
           My_CPU.core_r4  !== golden_reg[4 ] || My_CPU.core_r5  !== golden_reg[5 ] || My_CPU.core_r6  !== golden_reg[6 ] || My_CPU.core_r7  !== golden_reg[7 ] ||  
           My_CPU.core_r8  !== golden_reg[8 ] || My_CPU.core_r9  !== golden_reg[9 ] || My_CPU.core_r10 !== golden_reg[10] || My_CPU.core_r11 !== golden_reg[11] ||  
           My_CPU.core_r12 !== golden_reg[12] || My_CPU.core_r13 !== golden_reg[13] || My_CPU.core_r14 !== golden_reg[14] || My_CPU.core_r15 !== golden_reg[15])begin
           $display("***************************************************************");
           $display("                                             REG FAIL                             ");
           $display("                                       Your answer is fail !                     ");
           $display("                                              pc is %d                        ", pc);
	   $display("                                golden_r0  is %d , your core_r0  is %d                        ", golden_reg[0],My_CPU.core_r0);
           $display("                                golden_r1  is %d , your core_r1  is %d                        ", golden_reg[1],My_CPU.core_r1);
           $display("                                golden_r2  is %d , your core_r2  is %d                        ", golden_reg[2],My_CPU.core_r2);
           $display("                                golden_r3  is %d , your core_r3  is %d                        ", golden_reg[3],My_CPU.core_r3);
           $display("                                golden_r4  is %d , your core_r4  is %d                        ", golden_reg[4],My_CPU.core_r4);
           $display("                                golden_r5  is %d , your core_r5  is %d                        ", golden_reg[5],My_CPU.core_r5);
           $display("                                golden_r6  is %d , your core_r6  is %d                        ", golden_reg[6],My_CPU.core_r6);
           $display("                                golden_r7  is %d , your core_r7  is %d                        ", golden_reg[7],My_CPU.core_r7);
           $display("                                golden_r8  is %d , your core_r8  is %d                        ", golden_reg[8],My_CPU.core_r8);
           $display("                                golden_r9  is %d , your core_r9  is %d                        ", golden_reg[9],My_CPU.core_r9);
           $display("                                golden_r10 is %d , your core_r10 is %d                        ", golden_reg[10],My_CPU.core_r10);
           $display("                                golden_r11 is %d , your core_r11 is %d                        ", golden_reg[11],My_CPU.core_r11);
           $display("                                golden_r12 is %d , your core_r12 is %d                        ", golden_reg[12],My_CPU.core_r12);
           $display("                                golden_r13 is %d , your core_r13 is %d                        ", golden_reg[13],My_CPU.core_r13);
           $display("                                golden_r14 is %d , your core_r14 is %d                        ", golden_reg[14],My_CPU.core_r14);
           $display("                                golden_r15 is %d , your core_r15 is %d                        ", golden_reg[15],My_CPU.core_r15);           
	   $display("***************************************************************");
	   @(negedge clk);
           $finish;  
        end
    end
    for(j = 0; j < 4096; j = j + 1)begin
        if(DRAM_data_gold[j] !== u_DRAM_data.DRAM_r[4096 + j])begin
            $display("***************************************************************");
            $display("                                           DRAM FAIL                               ");
            $display("                                      Your answer is fail !                         ");
            $display("                                             pc is %d                        ", pc);
            $display("***************************************************************"); 
            @(negedge clk);
            $finish;
        end
    end
    $display("\033[0;38;5;111mPass pattern NO.%d ,\033[m  \033[0;32;6;121mcycles = %d\033[m ", pat_cnt,cycles); 
end endtask
endmodule
