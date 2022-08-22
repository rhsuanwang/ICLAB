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

output reg			  clk,rst_n;
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
// DRAM
// -----------------------------

pseudo_DRAM_data u_DRAM_data(

  	  .clk(clk),
  	  .rst_n(rst_n),

   .   awid_s_inf(   awid_s_inf),
   . awaddr_s_inf( awaddr_s_inf),
   . awsize_s_inf( awsize_s_inf),
   .awburst_s_inf(awburst_s_inf),
   .  awlen_s_inf(  awlen_s_inf),
   .awvalid_s_inf(awvalid_s_inf),
   .awready_s_inf(awready_s_inf),
							   
   .  wdata_s_inf(  wdata_s_inf),
   .  wlast_s_inf(  wlast_s_inf),
   . wvalid_s_inf( wvalid_s_inf),
   . wready_s_inf( wready_s_inf),

   .    bid_s_inf(    bid_s_inf),
   .  bresp_s_inf(  bresp_s_inf),
   . bvalid_s_inf( bvalid_s_inf),
   . bready_s_inf( bready_s_inf),

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
//================================================================
// wires & registers
//================================================================
reg [15:0] DATA_RAM[0:2047], INST_RAM[0:2047]; //pseudo_ram
reg signed[7:0] DATA_RAM_in[4096*2-1:4096];
reg signed[7:0] INST_RAM_in[4096*2-1:4096];
reg signed [15:0] golden_reg[0:15]; 
reg signed [11:0] pc; 
reg signed [11:0] save_pc;
reg signed [13:0]Dload_pre_addr;
reg signed [13:0]Dstore_pre_addr;
reg signed [13:0]I_pre_addr;

//================================================================
// parameters & integer
//================================================================
`define PATNUM 1364
`define INT_MAX 32767
`define INT_MIN -32768
integer data_DRAM_file, inst_DRAM_file;
reg [9999:0] str,str1;
integer i, j, k, l;
integer a, b, c;
integer total_cycles, cycles;
integer patcount;
integer check_DRAM_cnt;
//================================================================
// clock
//================================================================
always	#(`CYCLE_TIME/2.0) clk = ~clk;
initial	clk = 0;
//================================================================
// initial
//================================================================
initial begin
/*
	data_DRAM_file = $fopen("../00_TESTBED/DRAM/DRAM_data.dat", "r");
	inst_DRAM_file = $fopen("../00_TESTBED/DRAM/DRAM_inst.dat", "r");

	for(i=0;i<2048;i=i+1)begin
		a = $fgets(str, data_DRAM_file);
		a = $fscanf(data_DRAM_file,"%h"  ,DATA_RAM[i][7:0]);
		a = $fscanf(data_DRAM_file,"%h\n",DATA_RAM[i][15:8]);
	//	a = $fgets(str, data_DRAM_file); //change line
	end
	
	for(j=0;j<2048;j=j+1)begin
		b = $fgets(str1, inst_DRAM_file);
		b = $fscanf(inst_DRAM_file,"%h"  ,INST_RAM[j][7:0]);
		b = $fscanf(inst_DRAM_file,"%h\n",INST_RAM[j][15:8]);
		b = $fgets(str1, inst_DRAM_file); //change line
	end
*/
	//initial set
	$readmemh("../00_TESTBED/DRAM/DRAM_data.dat",DATA_RAM_in);
	$readmemh("../00_TESTBED/DRAM/DRAM_inst.dat",INST_RAM_in);
	for(i=0;i<2048;i=i+1)begin
		DATA_RAM[i] = {DATA_RAM_in[i*2+'h1000+1],DATA_RAM_in[i*2+'h1000]};
	end
	for(j=0;j<2048;j=j+1)begin
		INST_RAM[j] = {INST_RAM_in[j*2+'h1000+1],INST_RAM_in[j*2+'h1000]};
	end
	

	
	for(k=0;k<16;k=k+1)begin
		golden_reg[k] = 0;
	end

	pc = 0;
	rst_n = 1;
	force clk = 0;
	reset_task;
	total_cycles = 0;
	Dload_pre_addr = 8191;
	Dstore_pre_addr = 8191;
	I_pre_addr = 0;
	check_DRAM_cnt = 0;

    @(negedge clk);
	for (patcount=0;patcount<`PATNUM;patcount=patcount+1)begin
		check_DRAM_cnt = check_DRAM_cnt + 1;
		calculate_golden_task;
		wait_task;
		check_reg_task;
		if(check_DRAM_cnt==10)begin
			check_DRAM_task;
			check_DRAM_cnt = 0;
		end
		@(negedge clk);
	end
	#(2);
	pass_task;
	$finish;
end
//================================================================
// reset task
//================================================================
task reset_task ; begin
	#(`CYCLE_TIME); rst_n = 0;

	#(`CYCLE_TIME*3);
	if(IO_stall !== 1) begin
		$display ("--------------------------------------------------------------------------------");
		$display ("                                   FAIL!                                        ");
		$display ("                IO_stall signal should be 1 after initial RESET                 ");
		$display ("--------------------------------------------------------------------------------");
		#(1);
		$finish;
	end
	
	if( (My_CHIP.core_r0  !== 0) || (My_CHIP.core_r1  !== 0) || (My_CHIP.core_r2  !== 0) || (My_CHIP.core_r3  !== 0) ||
		(My_CHIP.core_r4  !== 0) || (My_CHIP.core_r5  !== 0) || (My_CHIP.core_r6  !== 0) || (My_CHIP.core_r7  !== 0) ||
		(My_CHIP.core_r8  !== 0) || (My_CHIP.core_r9  !== 0) || (My_CHIP.core_r10 !== 0) || (My_CHIP.core_r11 !== 0) ||
		(My_CHIP.core_r12 !== 0) || (My_CHIP.core_r13 !== 0) || (My_CHIP.core_r14 !== 0) || (My_CHIP.core_r15 !== 0) ) begin
		
		$display ("--------------------------------------------------------------------------------");
		$display ("                                   FAIL!                                        ");
		$display ("               All the registers should be 0 after initial RESET                ");
		$display ("--------------------------------------------------------------------------------");
		#(1);
		$finish;
	end
	
	#(1.0); rst_n = 1 ;
	#(3.0); release clk;
end endtask
//================================================================
// wait task
//================================================================
task wait_task ; begin 
	cycles = 0;
	while(IO_stall !== 0)begin
		cycles = cycles + 1;
		if(cycles == `MAX_WAIT_READY_CYCLE) begin
			$display ("------------------------------------------------------------------------------------------------");
			$display ("                                                                                                ");
			$display ("         	The execution latency are over %7d cycles                                  ", `MAX_WAIT_READY_CYCLE);
			$display ("                                                                                                ");
			$display ("------------------------------------------------------------------------------------------------");
			repeat(2)@(negedge clk);
			$finish;
		end
	@(negedge clk);
	end
	total_cycles = total_cycles + cycles;
end endtask
//================================================================
// calculate golden task
//================================================================
localparam RTYPE1 = 3'b000, RTYPE2 = 3'b001, LOAD = 3'b010, STORE = 3'b011, BRANCH = 3'b100, JUMP = 3'b101;
reg[2:0] opcode;
reg[3:0] rs, rt, rd;
reg func;
reg signed[4:0] imm;
reg[12:0] Address;
reg signed[13:0]load_addr;
reg signed[13:0]store_addr;


task calculate_golden_task ; begin
	save_pc = pc;
	opcode = INST_RAM[pc][15:13];
    {rs, rt, rd} = INST_RAM[pc][12:1];
    func = INST_RAM[pc][0];	
    imm = INST_RAM[pc][4:0];
    Address = INST_RAM[pc][12:0];
	//===========test=========================================
//		golden_reg[rs] = 32767; 
//		golden_reg[rt] = -32766; 
//		golden_reg[rd] = golden_reg[rs] - golden_reg[rt]; 
//		$display ("------------------------------------------------------------------------------------------------\n");
//		$display ("		golden_reg[rs] : %d \n",golden_reg[rs]);
//		$display ("		golden_reg[rt] : %d \n",golden_reg[rt]);
//		$display ("		golden_reg[rd] : %d \n",golden_reg[rd]);
//		$display ("------------------------------------------------------------------------------------------------\n");
//	opcode = RTYPE1;
//    func = 1;	
//==========================================================================	
  case(opcode)
    RTYPE1: begin
		if(func)begin			
			if((golden_reg[rs] - golden_reg[rt]) > `INT_MAX || (golden_reg[rs] - golden_reg[rt])< `INT_MIN)
				$display ("*****Warning : the data(SUB) is overflow in instr_addr=%4h*****\n",pc*2+'h1000);				
			golden_reg[rd] = golden_reg[rs] - golden_reg[rt]; //SUB
		end else begin
			if((golden_reg[rs] + golden_reg[rt]) > `INT_MAX || (golden_reg[rs] + golden_reg[rt])< `INT_MIN)
				$display ("*****Warning : the data(ADD) is overflow in instr_addr=%4h*****\n",pc*2+'h1000);				
			golden_reg[rd] = golden_reg[rs] + golden_reg[rt]; //ADD
		end
	pc = pc + 1;
    end
    RTYPE2: begin
		if(func)begin
			if((golden_reg[rs] * golden_reg[rt]) > `INT_MAX || (golden_reg[rs] * golden_reg[rt])< `INT_MIN)
				$display ("*****Warning : the data(MUL) is overflow in instr_addr=%4h*****\n",pc*2+'h1000);	
			golden_reg[rd] = golden_reg[rs] * golden_reg[rt]; //MUL
		end else begin
			if(golden_reg[rs] < golden_reg[rt])
				golden_reg[rd] = 1; //SLT
			else
				golden_reg[rd] = 0; //SLT
		end
	pc = pc + 1;
	end
    LOAD: begin
	  load_addr = (golden_reg[rs] + imm) ; 
	  if(golden_reg[rs] + imm > 2047 || golden_reg[rs] + imm < 0)
		$display ("*****Warning : the Load address is out of range in instr_addr=%4h*****\n",pc*2+'h1000);	
	  if((load_addr > (Dload_pre_addr + 32) || load_addr < (Dload_pre_addr - 32 + 1)) && (Dload_pre_addr != 8191))begin
	    $display ("*****patnum =%6d  *******************************************************************",patcount);
		$display ("*****Warning : the Load address violates the data dependence in instr_addr = %4h*****\n",pc*2+'h1000);	
	  end
	golden_reg[rt] = DATA_RAM[load_addr];	 
	Dload_pre_addr = load_addr;	
	pc = pc + 1;
    end
	STORE: begin
	  store_addr = (golden_reg[rs] + imm) ;  	  
	  if(golden_reg[rs] + imm > 2047 || golden_reg[rs] + imm < 0)
		$display ("*****Warning : the Store address is out of range in instr_addr=%4h*****\n",pc*2+'h1000);	
	  if(store_addr > (Dstore_pre_addr + 32) || store_addr < (Dstore_pre_addr - 32 + 1) && (Dstore_pre_addr != 8191))begin
	    $display ("*****patnum =%6d  *******************************************************************",patcount);
		$display ("*****Warning : the Store address violates the data dependence in instr_addr=%4h*****\n",pc*2+'h1000);	
	  end
	DATA_RAM[store_addr] = golden_reg[rt];
	Dstore_pre_addr = store_addr;
	pc = pc + 1;
    end
	BRANCH: begin
      if(golden_reg[rs] === golden_reg[rt])
		pc = pc + 1 + imm;
	  else
		pc = pc + 1;
    end
	JUMP: begin
	  if(Address > 13'h1fff || Address < 13'h1000 )
		$display ("*****Warning : the Jump address is out of range in instr_addr=%4h*****\n",pc*2+'h1000);	
	  if(Address[0]==1)
		$display ("*****Warning : the Jump address is odd in instr_addr=%4h*****\n",pc*2+'h1000);	
		
	   pc = (Address - 'h1000)/2;
    end
	
	default:begin
		$display ("------------------------------------------------------------------------------------------------\n");
		$display ("		Warning : DRAM_inst has wrong opcode in instr_addr=%4h*****\n",pc*2+'h1000);	
		$display ("------------------------------------------------------------------------------------------------\n");
    end
  endcase
  
	if(pc > 2047 || pc < 0)
		$display ("*****Warning : pc is out of range in instr_addr=%4h*****\n",save_pc*2+'h1000);	
	if(pc > (I_pre_addr + 32) || pc < (I_pre_addr - 32 + 1))begin
		$display ("*****patnum =%6d  **********************************************************************************************",patcount);
		$display ("*****Warning : the current address violates the data dependence in instr_addr = %4h ,  next_instr_addr = %4h*****\n",save_pc*2+'h1000, pc*2+'h1000);		
	end	
		
	I_pre_addr = pc;	

end endtask
//================================================================
// check task
//================================================================
task check_reg_task ; begin 
    if(IO_stall === 0) begin
    	if( (My_CHIP.core_r0  !== golden_reg[0 ]) || (My_CHIP.core_r1  !== golden_reg[1 ]) || (My_CHIP.core_r2  !== golden_reg[2 ]) || (My_CHIP.core_r3  !== golden_reg[3 ]) ||
			(My_CHIP.core_r4  !== golden_reg[4 ]) || (My_CHIP.core_r5  !== golden_reg[5 ]) || (My_CHIP.core_r6  !== golden_reg[6 ]) || (My_CHIP.core_r7  !== golden_reg[7 ]) ||
			(My_CHIP.core_r8  !== golden_reg[8 ]) || (My_CHIP.core_r9  !== golden_reg[9 ]) || (My_CHIP.core_r10 !== golden_reg[10]) || (My_CHIP.core_r11 !== golden_reg[11]) ||
			(My_CHIP.core_r12 !== golden_reg[12]) || (My_CHIP.core_r13 !== golden_reg[13]) || (My_CHIP.core_r14 !== golden_reg[14]) || (My_CHIP.core_r15 !== golden_reg[15]) ) begin
			  $display ("\033[0;31mInstruction NO.%1d FAIL!\033[m", patcount);
			  $display ("------------------------------------------------------------------");
			  $display ("     Instruction Address : %4h                                     ",(save_pc)*2+'h1000);
			    case(opcode)
					RTYPE1: begin
						$display ("     Instruction : %b_%b_%b_%b_%b                                 ",opcode,rs,rt,rd,func);
						if(func)
							$display ("     sub (rd=rs-rt) rs=%d, rt=%d, rd=%d                                ",rs,rt,rd);
						else
							$display ("     add (rd=rs+rt) rs=%d, rt=%d, rd=%d                                ",rs,rt,rd);
					end
					RTYPE2: begin
						$display ("     Instruction : %b_%b_%b_%b_%b                                 ",opcode,rs,rt,rd,func);
						if(func)
							$display ("     mult (rd=rs*rt) rs=%d, rt=%d, rd=%d                                ",rs,rt,rd);
						else
							$display ("     slt (rd=(rs<rt)?1:0) rs=%d, rt=%d, rd=%d                                ",rs,rt,rd);
					end
					LOAD: begin
						$display ("     Instruction : %b_%b_%b_%b                                 ",opcode,rs,rt,imm);
						$display ("     load (rt=DM[(rs+imm)*2+offset]) rs=%d, rt=%d, imm=%d                         ",rs,rt,imm);
					end
					STORE: begin
						$display ("     Instruction : %b_%b_%b_%b                                 ",opcode,rs,rt,imm);
						$display ("     store (DM[(rs+imm)*2+offset]=rt) rs=%d, rt=%d, imm=%d                         ",rs,rt,imm);
					end
					BRANCH: begin
						$display ("     Instruction : %b_%b_%b_%b                                 ",opcode,rs,rt,imm);
						$display ("     branch (pc=(rs==rt)?pc+1+imm:pc+1) rs=%d, rt=%d, imm=%d            ",rs,rt,imm);
					end
					JUMP: begin
						$display ("     Instruction : %b_%b                                 ",opcode,Address);
						$display ("     jump (address) Address=%h(hex)                         ",Address);
					end
				endcase
			  $display ("------------------------------------------------------------------");
			  $display ("core_r0  -->  Your Answer : %d      Golden Answer : %d           ",My_CHIP.core_r0 ,golden_reg[0 ]);
			  $display ("core_r1  -->  Your Answer : %d      Golden Answer : %d           ",My_CHIP.core_r1 ,golden_reg[1 ]);
			  $display ("core_r2  -->  Your Answer : %d      Golden Answer : %d           ",My_CHIP.core_r2 ,golden_reg[2 ]);
			  $display ("core_r3  -->  Your Answer : %d      Golden Answer : %d           ",My_CHIP.core_r3 ,golden_reg[3 ]);
			  $display ("core_r4  -->  Your Answer : %d      Golden Answer : %d           ",My_CHIP.core_r4 ,golden_reg[4 ]);
			  $display ("core_r5  -->  Your Answer : %d      Golden Answer : %d           ",My_CHIP.core_r5 ,golden_reg[5 ]);
			  $display ("core_r6  -->  Your Answer : %d      Golden Answer : %d           ",My_CHIP.core_r6 ,golden_reg[6 ]);
			  $display ("core_r7  -->  Your Answer : %d      Golden Answer : %d           ",My_CHIP.core_r7 ,golden_reg[7 ]);
			  $display ("core_r8  -->  Your Answer : %d      Golden Answer : %d           ",My_CHIP.core_r8 ,golden_reg[8 ]);
			  $display ("core_r9  -->  Your Answer : %d      Golden Answer : %d           ",My_CHIP.core_r9 ,golden_reg[9 ]);
			  $display ("core_r10 -->  Your Answer : %d      Golden Answer : %d           ",My_CHIP.core_r10,golden_reg[10]);
			  $display ("core_r11 -->  Your Answer : %d      Golden Answer : %d           ",My_CHIP.core_r11,golden_reg[11]);
			  $display ("core_r12 -->  Your Answer : %d      Golden Answer : %d           ",My_CHIP.core_r12,golden_reg[12]);
			  $display ("core_r13 -->  Your Answer : %d      Golden Answer : %d           ",My_CHIP.core_r13,golden_reg[13]);
			  $display ("core_r14 -->  Your Answer : %d      Golden Answer : %d           ",My_CHIP.core_r14,golden_reg[14]);
			  $display ("core_r15 -->  Your Answer : %d      Golden Answer : %d           ",My_CHIP.core_r15,golden_reg[15]);
			  repeat(2)@(negedge clk);
			  $finish;
		end
		else begin
			$display ("\033[0;32mInstruction NO.%1d PASS! \033[m", patcount);
			    case(opcode)
					RTYPE1: begin
						if(func)
							$display (" sub (rd=rs-rt) rs=%d, rt=%d, rd=%d                                ",rs,rt,rd);
						else            
							$display (" add (rd=rs+rt) rs=%d, rt=%d, rd=%d                                ",rs,rt,rd);
					end                 
					RTYPE2: begin       
						if(func)        
							$display (" mult (rd=rs*rt) rs=%d, rt=%d, rd=%d                                ",rs,rt,rd);
						else            
							$display (" slt (rd=(rs<rt)?1:0) rs=%d, rt=%d, rd=%d                                ",rs,rt,rd);
					end
					LOAD: begin
						$display (" load (rt=DM[(rs+imm)*2+offset]) rs=%d, rt=%d, imm=%d                         ",rs,rt,imm);
					end             
					STORE: begin    
						$display (" store (DM[(rs+imm)*2+offset]=rt) rs=%d, rt=%d, imm=%d                         ",rs,rt,imm);
					end             
					BRANCH: begin   
						$display (" branch (pc=(rs==rt)?pc+1+imm:pc+1) rs=%d, rt=%d, imm=%d            ",rs,rt,imm);
					end             
					JUMP: begin     
						$display (" jump (address) Address=%h(hex)                         ",Address);
					end
				endcase
		end
    end
end endtask
reg dram_wrong;
task check_DRAM_task ; begin 
	dram_wrong = 0;
    if(IO_stall === 0) begin
		for(l=0;l<2048;l=l+1)begin
			if({u_DRAM_data.DRAM_r[l*2+1+'h1000],u_DRAM_data.DRAM_r[l*2+'h1000]} !== DATA_RAM[l]) begin
			  if(dram_wrong == 0)begin
				$display ("\033[0;31mInstruction NO.%1d *DRAM* FAIL!\033[m", patcount);
				$display ("-------------------------------------------------------------------------------");
			  end
				
			  dram_wrong = 1;
			  $display ("DATA_DRAM Address = %4h -->  Your Answer : %d    Golden Answer : %d", (l*2+'h1000),{u_DRAM_data.DRAM_r[l*2+1+'h1000],u_DRAM_data.DRAM_r[l*2+'h1000]},DATA_RAM[l]);

			end
		end
		
		if(dram_wrong)begin
			repeat(2)@(negedge clk);
			$finish;
		end else
			$display ("\033[0;32mInstruction NO.%1d *DRAM* PASS! \033[m", patcount);
    end
end endtask

task pass_task;begin
	$display ("----------------------------------------------------------------------------");
	$display ("                              Congratulations!                              ");
	$display ("                       You have passed all patterns!                        ");
	$display ("                                                                            ");
	$display ("                    Your execution cycles   = %2d cycles                    ", total_cycles);
	$display ("                    Your clock period       = %.1f ns                       ", `CYCLE_TIME);
	$display ("                    Computation Time        = %.1f ns                       ", (total_cycles*`CYCLE_TIME));
	$display ("----------------------------------------------------------------------------");
end endtask
endmodule

