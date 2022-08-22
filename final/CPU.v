//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   ICLAB 2021 Final Project: Customized ISA Processor 
//   Author              : Hsi-Hao Huang
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : CPU.v
//   Module Name : CPU.v
//   Release version : V1.0 (Release Date: 2021-May)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

module CPU(

				clk,
			  rst_n,
  
		   IO_stall,

         awid_m_inf,
       awaddr_m_inf,
       awsize_m_inf,
      awburst_m_inf,
        awlen_m_inf,
      awvalid_m_inf,
      awready_m_inf,
                    
        wdata_m_inf,
        wlast_m_inf,
       wvalid_m_inf,
       wready_m_inf,
                    
          bid_m_inf,
        bresp_m_inf,
       bvalid_m_inf,
       bready_m_inf,
                    
         arid_m_inf,
       araddr_m_inf,
        arlen_m_inf,
       arsize_m_inf,
      arburst_m_inf,
      arvalid_m_inf,
                    
      arready_m_inf, 
          rid_m_inf,
        rdata_m_inf,
        rresp_m_inf,
        rlast_m_inf,
       rvalid_m_inf,
       rready_m_inf 

);
// Input port
input  wire clk, rst_n;
// Output port
output reg  IO_stall;

parameter ID_WIDTH = 4 , ADDR_WIDTH = 32, DATA_WIDTH = 16, DRAM_NUMBER=2, WRIT_NUMBER=1;

// AXI Interface wire connecttion for pseudo DRAM read/write
/* Hint:
  your AXI-4 interface could be designed as convertor in submodule(which used reg for output signal),
  therefore I declared output of AXI as wire in CPU
*/



// axi write address channel 
output  reg [WRIT_NUMBER * ID_WIDTH-1:0]        awid_m_inf;
output  reg [WRIT_NUMBER * ADDR_WIDTH-1:0]    awaddr_m_inf;
output  reg [WRIT_NUMBER * 3 -1:0]            awsize_m_inf;
output  reg [WRIT_NUMBER * 2 -1:0]           awburst_m_inf;
output  reg [WRIT_NUMBER * 7 -1:0]             awlen_m_inf;
output  reg [WRIT_NUMBER-1:0]                awvalid_m_inf;
input   wire [WRIT_NUMBER-1:0]                awready_m_inf;
// axi write data channel 
output  reg [WRIT_NUMBER * DATA_WIDTH-1:0]     wdata_m_inf;
output  reg [WRIT_NUMBER-1:0]                  wlast_m_inf;
output  reg [WRIT_NUMBER-1:0]                 wvalid_m_inf;
input   wire [WRIT_NUMBER-1:0]                 wready_m_inf;
// axi write response channel
input   wire [WRIT_NUMBER * ID_WIDTH-1:0]         bid_m_inf;
input   wire [WRIT_NUMBER * 2 -1:0]             bresp_m_inf;
input   wire [WRIT_NUMBER-1:0]             	   bvalid_m_inf;
output  reg [WRIT_NUMBER-1:0]                 bready_m_inf;
// -----------------------------
// axi read address channel 
output  reg [DRAM_NUMBER * ID_WIDTH-1:0]       arid_m_inf;
output  reg [DRAM_NUMBER * ADDR_WIDTH-1:0]   araddr_m_inf;
output  reg [DRAM_NUMBER * 7 -1:0]            arlen_m_inf;
output  reg [DRAM_NUMBER * 3 -1:0]           arsize_m_inf;
output  reg [DRAM_NUMBER * 2 -1:0]          arburst_m_inf;
output  reg [DRAM_NUMBER-1:0]               arvalid_m_inf;
input   wire [DRAM_NUMBER-1:0]               arready_m_inf;
// -----------------------------
// axi read data channel 
input   wire [DRAM_NUMBER * ID_WIDTH-1:0]         rid_m_inf;
input   wire [DRAM_NUMBER * DATA_WIDTH-1:0]     rdata_m_inf;
input   wire [DRAM_NUMBER * 2 -1:0]             rresp_m_inf;
input   wire [DRAM_NUMBER-1:0]                  rlast_m_inf;
input   wire [DRAM_NUMBER-1:0]                 rvalid_m_inf;
output  reg [DRAM_NUMBER-1:0]                 rready_m_inf;
// -----------------------------

//
//
// 
/* Register in each core:
  There are sixteen registers in your CPU. You should not change the name of those registers.
  TA will check the value in each register when your core is not busy.
  If you change the name of registers below, you must get the fail in this lab.
*/

reg signed [15:0] core_r0 , core_r1 , core_r2 , core_r3 ;
reg signed [15:0] core_r4 , core_r5 , core_r6 , core_r7 ;
reg signed [15:0] core_r8 , core_r9 , core_r10, core_r11;
reg signed [15:0] core_r12, core_r13, core_r14, core_r15;
/*------------------------------------------------------------*/
//                    SRAM PARAMETER                      //
/*-----------------------------------------------------------*/
reg wen;
reg [15:0] sram_in; 
reg [7:0] index;  
wire [15:0] sram_out;
reg wen_d;
reg [15:0] sram_in_d; 
reg [7:0] index_d;  
wire [15:0] sram_out_d;

RA1SH C1(.Q(sram_out),.CLK(clk),.CEN(1'b0),.WEN(wen),.A(index),.D(sram_in),.OEN(1'b0));
RA1SH C2(.Q(sram_out_d),.CLK(clk),.CEN(1'b0),.WEN(wen_d),.A(index_d),.D(sram_in_d),.OEN(1'b0));
//////////////////////////////////////////////////////////////////////
//               REG & WIRE                         
//////////////////////////////////////////////////////////////////////
reg [15:0] pc;
reg [2:0] instr_tag[255:0];
reg [2:0] data_tag[255:0];
reg [15:0] instruction;
reg [2:0] func;
reg signed [15:0] rs,rt;
reg signed [4:0] imm;
reg [15:0] address;
reg [3:0] state,nextstate;
reg [1:0] cs,ns;
reg [1:0] counter;
reg [15:0] count_addr;
reg [1:0] counter_d;
reg [15:0] count_addr_d;
reg [15:0] lw_sw_address;
reg first;
reg [15:0] last_address;
reg [15:0] last_address_d;
parameter START=4'd0,DRAM_IF_ADD=4'd1,DRAM_IF_DATA=4'd2,OUT_STAGE=4'd3;
parameter IDLE=4'd0,WAIT=4'd1,SRAM_IF=4'd2,ID=4'd3,EXE=4'd4,MEM1=4'd5,MEM2=4'd6,DRAM_MEM_ADD=4'd7,DRAM_MEM_DATA=4'd8,SRAM_MEM=4'd9,OUT=4'd10;
parameter ADD=3'd0,SUB=3'd1,SLT=3'd2,MUL=3'd3,LW=3'd4,SW=3'd5,BEQ=3'd6,JUMP=3'd7;
//////////////////////////////////////////////////////////////////////
//               INSTRUCTION FETCH                         
//////////////////////////////////////////////////////////////////////
//-------------------------------------------------------//
//               LAST READ ADDRESS                         
//-------------------------------------------------------//
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        last_address <= 0;
    end
    else if(cs == OUT_STAGE && ns == START && pc[11:9] != instr_tag[pc[8:1]])begin
        last_address <= {pc[15:8],8'b0000_0000} - 2;
    end
    else if(cs == DRAM_IF_DATA && rlast_m_inf[1])begin
        last_address <= count_addr + 2;
    end
    else begin
        last_address <= last_address;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        last_address_d <= 0;
    end
    else if(state == MEM1 && lw_sw_address[11:9] != data_tag[lw_sw_address[8:1]])begin
        last_address_d <= {lw_sw_address[15:8],8'b0000_0000} - 2;
    end
    else if(state == DRAM_MEM_DATA && rlast_m_inf[0])begin
        last_address_d <= count_addr_d + 2;
    end
    else begin
        last_address_d <= last_address_d;
    end
end
//-------------------------------------------------------//
//               AXI4 READ ADDRESS                         
//-------------------------------------------------------//
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        arid_m_inf <= 0;
        araddr_m_inf <= 0;
        arlen_m_inf <= 0;
        arsize_m_inf <= 0;
        arburst_m_inf <= 0;
        arvalid_m_inf <= 0;
    end
    else if(ns == DRAM_IF_ADD)begin
        if(pc[11:0] <= 12'h07c)begin
            arid_m_inf <= 0;                                                      
            araddr_m_inf <= {16'b0000_0000_0000_0000,16'h1000 + (counter << 8),32'b0000_0000_0000_0000_0000_0000_0000_0000};  
            arlen_m_inf <= {7'd127,7'b000_0000};                                                
            arsize_m_inf <= {3'b001,3'b000};                                                 
            arburst_m_inf <= {2'b01,2'b00};                                                  
            arvalid_m_inf <= {1'b1,1'b0}; 
        end
        else if(pc[11:0] >= 12'hf7e)begin
            arid_m_inf <= 0;                                                      
            araddr_m_inf <= {16'b0000_0000_0000_0000,16'h1f00,32'b0000_0000_0000_0000_0000_0000_0000_0000};  
            arlen_m_inf <= {7'd127,7'b000_0000};                                                
            arsize_m_inf <= {3'b001,3'b000};                                                 
            arburst_m_inf <= {2'b01,2'b00};                                                  
            arvalid_m_inf <= {1'b1,1'b0}; 
        end
        else begin
            arid_m_inf <= 0;                                                      
            //araddr_m_inf <= {16'b0000_0000_0000_0000,pc-8'd124,32'b0000_0000_0000_0000_0000_0000_0000_0000}; 
            araddr_m_inf <= {16'b0000_0000_0000_0000,last_address + 2,32'b0000_0000_0000_0000_0000_0000_0000_0000};  
            arlen_m_inf <= {7'd127,7'b000_0000};                                                
            arsize_m_inf <= {3'b001,3'b000};                                                 
            arburst_m_inf <= {2'b01,2'b00};                                                  
            arvalid_m_inf <= {1'b1,1'b0}; 
        end                                                   
    end
    else if(nextstate == DRAM_MEM_ADD && func == LW)begin
        if(lw_sw_address[11:0] <= 12'h07c)begin
            arid_m_inf <= 0;                                                      
            araddr_m_inf <= {32'b0000_0000_0000_0000_0000_0000_0000_0000,16'b0000_0000_0000_0000,16'h1000 + (counter_d << 8)};  
            arlen_m_inf <= {7'b000_0000,7'd127};                                                
            arsize_m_inf <= {3'b000,3'b001};                                                 
            arburst_m_inf <= {2'b00,2'b01};                                                  
            arvalid_m_inf <= {1'b0,1'b1}; 
        end
        else if(lw_sw_address[11:0] >= 12'hf7e)begin
            arid_m_inf <= 0;                                                      
            araddr_m_inf <= {32'b0000_0000_0000_0000_0000_0000_0000_0000,16'b0000_0000_0000_0000,16'h1f00};  
            arlen_m_inf <= {7'b000_0000,7'd127};                                                
            arsize_m_inf <= {3'b000,3'b001};                                                 
            arburst_m_inf <= {2'b00,2'b01};                                                  
            arvalid_m_inf <= {1'b0,1'b1}; 
        end
        else begin
            arid_m_inf <= 0;                                                      
            //araddr_m_inf <= {16'b0000_0000_0000_0000,pc-8'd124,32'b0000_0000_0000_0000_0000_0000_0000_0000}; 
            araddr_m_inf <= {32'b0000_0000_0000_0000_0000_0000_0000_0000,16'b0000_0000_0000_0000,last_address_d + 2};  
            arlen_m_inf <= {7'b000_0000,7'd127};                                                
            arsize_m_inf <= {3'b000,3'b001};                                                 
            arburst_m_inf <= {2'b00,2'b01};                                                  
            arvalid_m_inf <= {1'b0,1'b1}; 
        end                                                               
    end
    else begin
        arid_m_inf <= 0;
        araddr_m_inf <= 0;
        arlen_m_inf <= 0;
        arsize_m_inf <= 0;
        arburst_m_inf <= 0;
        arvalid_m_inf <= 0;
    end
end
//-------------------------------------------------------//
//               AXI4 READ DATA                      
//-------------------------------------------------------//
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        rready_m_inf <= 2'b00; 
    end
    else if(arready_m_inf == 2'b10)begin 
        rready_m_inf <= {1'b1,rready_m_inf[0]};     
    end
    else if(rlast_m_inf == 2'b10) begin  
        rready_m_inf <= {1'b0,rready_m_inf[0]};
    end
    else if(arready_m_inf == 2'b01)begin 
        rready_m_inf <= {rready_m_inf[1],1'b1};     
    end
    else if(rlast_m_inf == 2'b01) begin  
        rready_m_inf <= {rready_m_inf[1],1'b0};
    end
    else if(arready_m_inf == 2'b11)begin
        rready_m_inf <= {1'b1,1'b1};      
    end
    else if(rlast_m_inf == 2'b11) begin  
        rready_m_inf <= {1'b0,1'b0};
    end
    else begin
        rready_m_inf <= rready_m_inf;
    end
end
//-------------------------------------------------------//
//               SRAM INSTRUCTION WRITE                         
//-------------------------------------------------------//
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        wen <= 1;
    end
    else if(rvalid_m_inf[1])begin
        wen <= 0;
    end
    else begin
        wen <= 1;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        index <= 0;
    end
    else if(cs == DRAM_IF_ADD && ns == DRAM_IF_DATA)begin
        if(pc[11:0] <= 12'h07c)begin
            index <= counter << 7;
        end
        else if(pc[11:0] >= 12'hf7e)begin
            index <= 12'hf80;
        end
        else begin
            index <=  araddr_m_inf[40:33];
        end
        
    end
    else if(cs == DRAM_IF_DATA && wen == 0)begin   // write instruction
        index <= (index == 8'd255) ? 0:index + 1;
    end
    else if(cs == DRAM_IF_DATA && wen == 1)begin   // write instruction
        index <= index;
    end
    else if(nextstate == SRAM_IF)begin  // read instruction
        index <= pc[8:1];
    end
    else begin
        index <= 0;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        sram_in <= 0;
    end
    else if(rvalid_m_inf[1])begin   //write instruction
        sram_in <= rdata_m_inf[31:16];
    end
    else begin
        sram_in <= sram_in;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        instr_tag[0]   <= 0;instr_tag[10]   <= 0;instr_tag[20] <= 0;instr_tag[30]  <= 0;instr_tag[40]  <= 0;instr_tag[50]  <= 0;instr_tag[60]  <= 0;instr_tag[70]  <= 0;instr_tag[80]  <= 0;instr_tag[90]  <= 0;
        instr_tag[1]   <= 0;instr_tag[11]   <= 0;instr_tag[21] <= 0;instr_tag[31]  <= 0;instr_tag[41]  <= 0;instr_tag[51]  <= 0;instr_tag[61]  <= 0;instr_tag[71]  <= 0;instr_tag[81]  <= 0;instr_tag[91]  <= 0;
        instr_tag[2]   <= 0;instr_tag[12]   <= 0;instr_tag[22] <= 0;instr_tag[32]  <= 0;instr_tag[42]  <= 0;instr_tag[52]  <= 0;instr_tag[62]  <= 0;instr_tag[72]  <= 0;instr_tag[82]  <= 0;instr_tag[92]  <= 0;
        instr_tag[3]   <= 0;instr_tag[13]   <= 0;instr_tag[23] <= 0;instr_tag[33]  <= 0;instr_tag[43]  <= 0;instr_tag[53]  <= 0;instr_tag[63]  <= 0;instr_tag[73]  <= 0;instr_tag[83]  <= 0;instr_tag[93]  <= 0;
        instr_tag[4]   <= 0;instr_tag[14]   <= 0;instr_tag[24] <= 0;instr_tag[34]  <= 0;instr_tag[44]  <= 0;instr_tag[54]  <= 0;instr_tag[64]  <= 0;instr_tag[74]  <= 0;instr_tag[84]  <= 0;instr_tag[94]  <= 0;
        instr_tag[5]   <= 0;instr_tag[15]   <= 0;instr_tag[25] <= 0;instr_tag[35]  <= 0;instr_tag[45]  <= 0;instr_tag[55]  <= 0;instr_tag[65]  <= 0;instr_tag[75]  <= 0;instr_tag[85]  <= 0;instr_tag[95]  <= 0;
        instr_tag[6]   <= 0;instr_tag[16]   <= 0;instr_tag[26] <= 0;instr_tag[36]  <= 0;instr_tag[46]  <= 0;instr_tag[56]  <= 0;instr_tag[66]  <= 0;instr_tag[76]  <= 0;instr_tag[86]  <= 0;instr_tag[96]  <= 0;
        instr_tag[7]   <= 0;instr_tag[17]   <= 0;instr_tag[27] <= 0;instr_tag[37]  <= 0;instr_tag[47]  <= 0;instr_tag[57]  <= 0;instr_tag[67]  <= 0;instr_tag[77]  <= 0;instr_tag[87]  <= 0;instr_tag[97]  <= 0;
        instr_tag[8]   <= 0;instr_tag[18]   <= 0;instr_tag[28] <= 0;instr_tag[38]  <= 0;instr_tag[48]  <= 0;instr_tag[58]  <= 0;instr_tag[68]  <= 0;instr_tag[78]  <= 0;instr_tag[88]  <= 0;instr_tag[98]  <= 0;
        instr_tag[9]   <= 0;instr_tag[19]   <= 0;instr_tag[29] <= 0;instr_tag[39]  <= 0;instr_tag[49]  <= 0;instr_tag[59]  <= 0;instr_tag[69]  <= 0;instr_tag[79]  <= 0;instr_tag[89]  <= 0;instr_tag[99]  <= 0;
        instr_tag[100] <= 0;instr_tag[110] <= 0;instr_tag[120] <= 0;instr_tag[130] <= 0;instr_tag[140] <= 0;instr_tag[150] <= 0;instr_tag[160] <= 0;instr_tag[170] <= 0;instr_tag[180] <= 0;instr_tag[190] <= 0;
        instr_tag[101] <= 0;instr_tag[111] <= 0;instr_tag[121] <= 0;instr_tag[131] <= 0;instr_tag[141] <= 0;instr_tag[151] <= 0;instr_tag[161] <= 0;instr_tag[171] <= 0;instr_tag[181] <= 0;instr_tag[191] <= 0;
        instr_tag[102] <= 0;instr_tag[112] <= 0;instr_tag[122] <= 0;instr_tag[132] <= 0;instr_tag[142] <= 0;instr_tag[152] <= 0;instr_tag[162] <= 0;instr_tag[172] <= 0;instr_tag[182] <= 0;instr_tag[192] <= 0;
        instr_tag[103] <= 0;instr_tag[113] <= 0;instr_tag[123] <= 0;instr_tag[133] <= 0;instr_tag[143] <= 0;instr_tag[153] <= 0;instr_tag[163] <= 0;instr_tag[173] <= 0;instr_tag[183] <= 0;instr_tag[193] <= 0;
        instr_tag[104] <= 0;instr_tag[114] <= 0;instr_tag[124] <= 0;instr_tag[134] <= 0;instr_tag[144] <= 0;instr_tag[154] <= 0;instr_tag[164] <= 0;instr_tag[174] <= 0;instr_tag[184] <= 0;instr_tag[194] <= 0;
        instr_tag[105] <= 0;instr_tag[115] <= 0;instr_tag[125] <= 0;instr_tag[135] <= 0;instr_tag[145] <= 0;instr_tag[155] <= 0;instr_tag[165] <= 0;instr_tag[175] <= 0;instr_tag[185] <= 0;instr_tag[195] <= 0;
        instr_tag[106] <= 0;instr_tag[116] <= 0;instr_tag[126] <= 0;instr_tag[136] <= 0;instr_tag[146] <= 0;instr_tag[156] <= 0;instr_tag[166] <= 0;instr_tag[176] <= 0;instr_tag[186] <= 0;instr_tag[196] <= 0;
        instr_tag[107] <= 0;instr_tag[117] <= 0;instr_tag[127] <= 0;instr_tag[137] <= 0;instr_tag[147] <= 0;instr_tag[157] <= 0;instr_tag[167] <= 0;instr_tag[177] <= 0;instr_tag[187] <= 0;instr_tag[197] <= 0;
        instr_tag[108] <= 0;instr_tag[118] <= 0;instr_tag[128] <= 0;instr_tag[138] <= 0;instr_tag[148] <= 0;instr_tag[158] <= 0;instr_tag[168] <= 0;instr_tag[178] <= 0;instr_tag[188] <= 0;instr_tag[198] <= 0;
        instr_tag[109] <= 0;instr_tag[119] <= 0;instr_tag[129] <= 0;instr_tag[139] <= 0;instr_tag[149] <= 0;instr_tag[159] <= 0;instr_tag[169] <= 0;instr_tag[179] <= 0;instr_tag[189] <= 0;instr_tag[199] <= 0;
        instr_tag[200] <= 0;instr_tag[210] <= 0;instr_tag[220] <= 0;instr_tag[230] <= 0;instr_tag[240] <= 0;instr_tag[250] <= 0;
        instr_tag[201] <= 0;instr_tag[211] <= 0;instr_tag[221] <= 0;instr_tag[231] <= 0;instr_tag[241] <= 0;instr_tag[251] <= 0;
        instr_tag[202] <= 0;instr_tag[212] <= 0;instr_tag[222] <= 0;instr_tag[232] <= 0;instr_tag[242] <= 0;instr_tag[252] <= 0;
        instr_tag[203] <= 0;instr_tag[213] <= 0;instr_tag[223] <= 0;instr_tag[233] <= 0;instr_tag[243] <= 0;instr_tag[253] <= 0;
        instr_tag[204] <= 0;instr_tag[214] <= 0;instr_tag[224] <= 0;instr_tag[234] <= 0;instr_tag[244] <= 0;instr_tag[254] <= 0;
        instr_tag[205] <= 0;instr_tag[215] <= 0;instr_tag[225] <= 0;instr_tag[235] <= 0;instr_tag[245] <= 0;instr_tag[255] <= 0;
        instr_tag[206] <= 0;instr_tag[216] <= 0;instr_tag[226] <= 0;instr_tag[236] <= 0;instr_tag[246] <= 0;
        instr_tag[207] <= 0;instr_tag[217] <= 0;instr_tag[227] <= 0;instr_tag[237] <= 0;instr_tag[247] <= 0;
        instr_tag[208] <= 0;instr_tag[218] <= 0;instr_tag[228] <= 0;instr_tag[238] <= 0;instr_tag[248] <= 0;
        instr_tag[209] <= 0;instr_tag[219] <= 0;instr_tag[229] <= 0;instr_tag[239] <= 0;instr_tag[249] <= 0;
    end
    else if(cs == DRAM_IF_DATA && wen == 0)begin
        instr_tag[index] <= count_addr[11:9];
    end
    else begin
        instr_tag[0]   <= instr_tag[0]  ;instr_tag[10]  <= instr_tag[10] ;instr_tag[20]  <= instr_tag[20] ;instr_tag[30]  <= instr_tag[30] ;instr_tag[40]  <= instr_tag[40] ;instr_tag[50]  <= instr_tag[50] ;instr_tag[60]  <= instr_tag[60] ;instr_tag[70]  <= instr_tag[70] ;instr_tag[80]  <= instr_tag[80] ;instr_tag[90]  <= instr_tag[90] ;
        instr_tag[1]   <= instr_tag[1]  ;instr_tag[11]  <= instr_tag[11] ;instr_tag[21]  <= instr_tag[21] ;instr_tag[31]  <= instr_tag[31] ;instr_tag[41]  <= instr_tag[41] ;instr_tag[51]  <= instr_tag[51] ;instr_tag[61]  <= instr_tag[61] ;instr_tag[71]  <= instr_tag[71] ;instr_tag[81]  <= instr_tag[81] ;instr_tag[91]  <= instr_tag[91] ;
        instr_tag[2]   <= instr_tag[2]  ;instr_tag[12]  <= instr_tag[12] ;instr_tag[22]  <= instr_tag[22] ;instr_tag[32]  <= instr_tag[32] ;instr_tag[42]  <= instr_tag[42] ;instr_tag[52]  <= instr_tag[52] ;instr_tag[62]  <= instr_tag[62] ;instr_tag[72]  <= instr_tag[72] ;instr_tag[82]  <= instr_tag[82] ;instr_tag[92]  <= instr_tag[92] ;
        instr_tag[3]   <= instr_tag[3]  ;instr_tag[13]  <= instr_tag[13] ;instr_tag[23]  <= instr_tag[23] ;instr_tag[33]  <= instr_tag[33] ;instr_tag[43]  <= instr_tag[43] ;instr_tag[53]  <= instr_tag[53] ;instr_tag[63]  <= instr_tag[63] ;instr_tag[73]  <= instr_tag[73] ;instr_tag[83]  <= instr_tag[83] ;instr_tag[93]  <= instr_tag[93] ;
        instr_tag[4]   <= instr_tag[4]  ;instr_tag[14]  <= instr_tag[14] ;instr_tag[24]  <= instr_tag[24] ;instr_tag[34]  <= instr_tag[34] ;instr_tag[44]  <= instr_tag[44] ;instr_tag[54]  <= instr_tag[54] ;instr_tag[64]  <= instr_tag[64] ;instr_tag[74]  <= instr_tag[74] ;instr_tag[84]  <= instr_tag[84] ;instr_tag[94]  <= instr_tag[94] ;
        instr_tag[5]   <= instr_tag[5]  ;instr_tag[15]  <= instr_tag[15] ;instr_tag[25]  <= instr_tag[25] ;instr_tag[35]  <= instr_tag[35] ;instr_tag[45]  <= instr_tag[45] ;instr_tag[55]  <= instr_tag[55] ;instr_tag[65]  <= instr_tag[65] ;instr_tag[75]  <= instr_tag[75] ;instr_tag[85]  <= instr_tag[85] ;instr_tag[95]  <= instr_tag[95] ;
        instr_tag[6]   <= instr_tag[6]  ;instr_tag[16]  <= instr_tag[16] ;instr_tag[26]  <= instr_tag[26] ;instr_tag[36]  <= instr_tag[36] ;instr_tag[46]  <= instr_tag[46] ;instr_tag[56]  <= instr_tag[56] ;instr_tag[66]  <= instr_tag[66] ;instr_tag[76]  <= instr_tag[76] ;instr_tag[86]  <= instr_tag[86] ;instr_tag[96]  <= instr_tag[96] ;
        instr_tag[7]   <= instr_tag[7]  ;instr_tag[17]  <= instr_tag[17] ;instr_tag[27]  <= instr_tag[27] ;instr_tag[37]  <= instr_tag[37] ;instr_tag[47]  <= instr_tag[47] ;instr_tag[57]  <= instr_tag[57] ;instr_tag[67]  <= instr_tag[67] ;instr_tag[77]  <= instr_tag[77] ;instr_tag[87]  <= instr_tag[87] ;instr_tag[97]  <= instr_tag[97] ;
        instr_tag[8]   <= instr_tag[8]  ;instr_tag[18]  <= instr_tag[18] ;instr_tag[28]  <= instr_tag[28] ;instr_tag[38]  <= instr_tag[38] ;instr_tag[48]  <= instr_tag[48] ;instr_tag[58]  <= instr_tag[58] ;instr_tag[68]  <= instr_tag[68] ;instr_tag[78]  <= instr_tag[78] ;instr_tag[88]  <= instr_tag[88] ;instr_tag[98]  <= instr_tag[98] ;
        instr_tag[9]   <= instr_tag[9]  ;instr_tag[19]  <= instr_tag[19] ;instr_tag[29]  <= instr_tag[29] ;instr_tag[39]  <= instr_tag[39] ;instr_tag[49]  <= instr_tag[49] ;instr_tag[59]  <= instr_tag[59] ;instr_tag[69]  <= instr_tag[69] ;instr_tag[79]  <= instr_tag[79] ;instr_tag[89]  <= instr_tag[89] ;instr_tag[99]  <= instr_tag[99] ;
        instr_tag[100] <= instr_tag[100];instr_tag[110] <= instr_tag[110];instr_tag[120] <= instr_tag[120];instr_tag[130] <= instr_tag[130];instr_tag[140] <= instr_tag[140];instr_tag[150] <= instr_tag[150];instr_tag[160] <= instr_tag[160];instr_tag[170] <= instr_tag[170];instr_tag[180] <= instr_tag[180];instr_tag[190] <= instr_tag[190];
        instr_tag[101] <= instr_tag[101];instr_tag[111] <= instr_tag[111];instr_tag[121] <= instr_tag[121];instr_tag[131] <= instr_tag[131];instr_tag[141] <= instr_tag[141];instr_tag[151] <= instr_tag[151];instr_tag[161] <= instr_tag[161];instr_tag[171] <= instr_tag[171];instr_tag[181] <= instr_tag[181];instr_tag[191] <= instr_tag[191];
        instr_tag[102] <= instr_tag[102];instr_tag[112] <= instr_tag[112];instr_tag[122] <= instr_tag[122];instr_tag[132] <= instr_tag[132];instr_tag[142] <= instr_tag[142];instr_tag[152] <= instr_tag[152];instr_tag[162] <= instr_tag[162];instr_tag[172] <= instr_tag[172];instr_tag[182] <= instr_tag[182];instr_tag[192] <= instr_tag[192];
        instr_tag[103] <= instr_tag[103];instr_tag[113] <= instr_tag[113];instr_tag[123] <= instr_tag[123];instr_tag[133] <= instr_tag[133];instr_tag[143] <= instr_tag[143];instr_tag[153] <= instr_tag[153];instr_tag[163] <= instr_tag[163];instr_tag[173] <= instr_tag[173];instr_tag[183] <= instr_tag[183];instr_tag[193] <= instr_tag[193];
        instr_tag[104] <= instr_tag[104];instr_tag[114] <= instr_tag[114];instr_tag[124] <= instr_tag[124];instr_tag[134] <= instr_tag[134];instr_tag[144] <= instr_tag[144];instr_tag[154] <= instr_tag[154];instr_tag[164] <= instr_tag[164];instr_tag[174] <= instr_tag[174];instr_tag[184] <= instr_tag[184];instr_tag[194] <= instr_tag[194];
        instr_tag[105] <= instr_tag[105];instr_tag[115] <= instr_tag[115];instr_tag[125] <= instr_tag[125];instr_tag[135] <= instr_tag[135];instr_tag[145] <= instr_tag[145];instr_tag[155] <= instr_tag[155];instr_tag[165] <= instr_tag[165];instr_tag[175] <= instr_tag[175];instr_tag[185] <= instr_tag[185];instr_tag[195] <= instr_tag[195];
        instr_tag[106] <= instr_tag[106];instr_tag[116] <= instr_tag[116];instr_tag[126] <= instr_tag[126];instr_tag[136] <= instr_tag[136];instr_tag[146] <= instr_tag[146];instr_tag[156] <= instr_tag[156];instr_tag[166] <= instr_tag[166];instr_tag[176] <= instr_tag[176];instr_tag[186] <= instr_tag[186];instr_tag[196] <= instr_tag[196];
        instr_tag[107] <= instr_tag[107];instr_tag[117] <= instr_tag[117];instr_tag[127] <= instr_tag[127];instr_tag[137] <= instr_tag[137];instr_tag[147] <= instr_tag[147];instr_tag[157] <= instr_tag[157];instr_tag[167] <= instr_tag[167];instr_tag[177] <= instr_tag[177];instr_tag[187] <= instr_tag[187];instr_tag[197] <= instr_tag[197];
        instr_tag[108] <= instr_tag[108];instr_tag[118] <= instr_tag[118];instr_tag[128] <= instr_tag[128];instr_tag[138] <= instr_tag[138];instr_tag[148] <= instr_tag[148];instr_tag[158] <= instr_tag[158];instr_tag[168] <= instr_tag[168];instr_tag[178] <= instr_tag[178];instr_tag[188] <= instr_tag[188];instr_tag[198] <= instr_tag[198];
        instr_tag[109] <= instr_tag[109];instr_tag[119] <= instr_tag[119];instr_tag[129] <= instr_tag[129];instr_tag[139] <= instr_tag[139];instr_tag[149] <= instr_tag[149];instr_tag[159] <= instr_tag[159];instr_tag[169] <= instr_tag[169];instr_tag[179] <= instr_tag[179];instr_tag[189] <= instr_tag[189];instr_tag[199] <= instr_tag[199];
        instr_tag[200] <= instr_tag[200];instr_tag[210] <= instr_tag[210];instr_tag[220] <= instr_tag[220];instr_tag[230] <= instr_tag[230];instr_tag[240] <= instr_tag[240];instr_tag[250] <= instr_tag[250];
        instr_tag[201] <= instr_tag[201];instr_tag[211] <= instr_tag[211];instr_tag[221] <= instr_tag[221];instr_tag[231] <= instr_tag[231];instr_tag[241] <= instr_tag[241];instr_tag[251] <= instr_tag[251];
        instr_tag[202] <= instr_tag[202];instr_tag[212] <= instr_tag[212];instr_tag[222] <= instr_tag[222];instr_tag[232] <= instr_tag[232];instr_tag[242] <= instr_tag[242];instr_tag[252] <= instr_tag[252];
        instr_tag[203] <= instr_tag[203];instr_tag[213] <= instr_tag[213];instr_tag[223] <= instr_tag[223];instr_tag[233] <= instr_tag[233];instr_tag[243] <= instr_tag[243];instr_tag[253] <= instr_tag[253];
        instr_tag[204] <= instr_tag[204];instr_tag[214] <= instr_tag[214];instr_tag[224] <= instr_tag[224];instr_tag[234] <= instr_tag[234];instr_tag[244] <= instr_tag[244];instr_tag[254] <= instr_tag[254];
        instr_tag[205] <= instr_tag[205];instr_tag[215] <= instr_tag[215];instr_tag[225] <= instr_tag[225];instr_tag[235] <= instr_tag[235];instr_tag[245] <= instr_tag[245];instr_tag[255] <= instr_tag[255];
        instr_tag[206] <= instr_tag[206];instr_tag[216] <= instr_tag[216];instr_tag[226] <= instr_tag[226];instr_tag[236] <= instr_tag[236];instr_tag[246] <= instr_tag[246];
        instr_tag[207] <= instr_tag[207];instr_tag[217] <= instr_tag[217];instr_tag[227] <= instr_tag[227];instr_tag[237] <= instr_tag[237];instr_tag[247] <= instr_tag[247];
        instr_tag[208] <= instr_tag[208];instr_tag[218] <= instr_tag[218];instr_tag[228] <= instr_tag[228];instr_tag[238] <= instr_tag[238];instr_tag[248] <= instr_tag[248];
        instr_tag[209] <= instr_tag[209];instr_tag[219] <= instr_tag[219];instr_tag[229] <= instr_tag[229];instr_tag[239] <= instr_tag[239];instr_tag[249] <= instr_tag[249];
    end
end
//-------------------------------------------------------//
//               INSTRUCTION                          
//-------------------------------------------------------//
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        instruction <= 0;
    end
    else if(cs == DRAM_IF_DATA && index == pc[8:1] && !wen)begin
        instruction <= sram_in;
    end
    else if(state == SRAM_IF && counter == 1)begin
        instruction <= sram_out;
    end
    else begin
        instruction <= instruction;
    end
end
//////////////////////////////////////////////////////////////////////
//               INSTRUCTION DECODE                        
//////////////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        func <= 0;
    end
    else if(state == ID)begin
        case(instruction[15:13])
            3'b000:   func <= (instruction[0] == 0) ? ADD:SUB;
            3'b001:   func <= (instruction[0] == 0) ? SLT:MUL;
            3'b010:   func <= LW;
            3'b011:   func <= SW;
            3'b100:   func <= BEQ;
            3'b101:   func <= JUMP;
        endcase
    end
    else begin
        func <= func;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        rs <= 0;
    end
    else if(state == ID)begin
        case(instruction[12:9])
            4'b0000:    rs <= core_r0;
            4'b0001:    rs <= core_r1;
            4'b0010:    rs <= core_r2;
            4'b0011:    rs <= core_r3;
            4'b0100:    rs <= core_r4;
            4'b0101:    rs <= core_r5;
            4'b0110:    rs <= core_r6;
            4'b0111:    rs <= core_r7;
            4'b1000:    rs <= core_r8;
            4'b1001:    rs <= core_r9;
            4'b1010:    rs <= core_r10;
            4'b1011:    rs <= core_r11;
            4'b1100:    rs <= core_r12;
            4'b1101:    rs <= core_r13;
            4'b1110:    rs <= core_r14;
            4'b1111:    rs <= core_r15;
        endcase
    end
    else begin
        rs <= rs;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        rt <= 0;
    end
    else if(state == ID)begin
        case(instruction[8:5])
            4'b0000:    rt <= core_r0;
            4'b0001:    rt <= core_r1;
            4'b0010:    rt <= core_r2;
            4'b0011:    rt <= core_r3;
            4'b0100:    rt <= core_r4;
            4'b0101:    rt <= core_r5;
            4'b0110:    rt <= core_r6;
            4'b0111:    rt <= core_r7;
            4'b1000:    rt <= core_r8;
            4'b1001:    rt <= core_r9;
            4'b1010:    rt <= core_r10;
            4'b1011:    rt <= core_r11;
            4'b1100:    rt <= core_r12;
            4'b1101:    rt <= core_r13;
            4'b1110:    rt <= core_r14;
            4'b1111:    rt <= core_r15;
        endcase
    end
    else begin
        rt <= rt;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        imm <= 0;
    end
    else if(state == ID && (instruction[15:13] == 3'b010 || instruction[15:13] == 3'b011 || instruction[15:13] == 3'b100))begin
        imm <= instruction[4:0];
    end
    else begin
        imm <= imm;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        address <= 0;
    end
    else if(state == ID && instruction[15:13] == 3'b101)begin
        address <= {3'b000,instruction[12:0]};
    end
    else begin
        address <= address;
    end
end
//////////////////////////////////////////////////////////////////////
//               EXECUTION                        
//////////////////////////////////////////////////////////////////////
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        pc <= 16'h1000;
    end
    else if(state == EXE)begin
        if(func == JUMP)begin
            pc <= address;
        end
        else if(func == BEQ && rs == rt)begin
            pc <= pc + ((16'b0000_0000_0000_0001+{{11{imm[4]}},imm}) << 1);
        end
        else begin
            pc <= pc + 2;
        end
    end
    else begin
        pc <= pc;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        core_r0 <= 16'b0000_0000_0000_0000;
    end
    else if(state == EXE && instruction[4:1] == 4'b0000)begin
        case(func)
            ADD:    core_r0 <= rs + rt;
            SUB:    core_r0 <= rs - rt;
            SLT:    core_r0 <= (((rs < rt) && rs[15] == rt[15]) || (rs[15] == 1 && rt[15] == 0)) ? 16'b0000_0000_0000_0001:16'b0000_0000_0000_0000;
            MUL:    core_r0 <= rs * rt;
            default:core_r0 <= core_r0;
        endcase
    end
    else if(state == DRAM_MEM_DATA && func == LW && instruction[8:5] == 4'b0000 && !wen_d && index_d == lw_sw_address[8:1])begin
        core_r0 <= sram_in_d;
    end
    else if(state == SRAM_MEM && counter_d == 1 && instruction[8:5] == 4'b0000)begin
        core_r0 <= sram_out_d;
    end
    else begin
        core_r0 <= core_r0;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        core_r1 <= 0;
    end
    else if(state == EXE && instruction[4:1] == 4'b0001)begin
        case(func)
            ADD:    core_r1 <= rs + rt;
            SUB:    core_r1 <= rs - rt;
            SLT:    core_r1 <= (((rs < rt) && rs[15] == rt[15]) || (rs[15] == 1 && rt[15] == 0)) ? 16'b0000_0000_0000_0001:16'b0000_0000_0000_0000;
            MUL:    core_r1 <= rs * rt;
            default:core_r1 <= core_r1;
        endcase
    end
    else if(state == DRAM_MEM_DATA && func == LW && instruction[8:5] == 4'b0001 && !wen_d && index_d == lw_sw_address[8:1])begin
        core_r1 <= sram_in_d;
    end
    else if(state == SRAM_MEM && counter_d == 1 && instruction[8:5] == 4'b0001)begin
        core_r1 <= sram_out_d;
    end
    else begin
        core_r1 <= core_r1;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        core_r2 <= 16'b0000_0000_0000_0000;
    end
    else if(state == EXE && instruction[4:1] == 4'b0010)begin
        case(func)
            ADD:    core_r2 <= rs + rt;
            SUB:    core_r2 <= rs - rt;
            SLT:    core_r2 <= (((rs < rt) && rs[15] == rt[15]) || (rs[15] == 1 && rt[15] == 0)) ? 16'b0000_0000_0000_0001:16'b0000_0000_0000_0000;
            MUL:    core_r2 <= rs * rt;
            default:core_r2 <= core_r2;
        endcase
    end
    else if(state == DRAM_MEM_DATA && func == LW && instruction[8:5] == 4'b0010 && !wen_d && index_d == lw_sw_address[8:1])begin
        core_r2 <= sram_in_d;
    end
    else if(state == SRAM_MEM && counter_d == 1 && instruction[8:5] == 4'b0010)begin
        core_r2 <= sram_out_d;
    end
    else begin
        core_r2 <= core_r2;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        core_r3 <= 16'b0000_0000_0000_0000;
    end
    else if(state == EXE && instruction[4:1] == 4'b0011)begin
        case(func)
            ADD:    core_r3 <= rs + rt;
            SUB:    core_r3 <= rs - rt;
            SLT:    core_r3 <= (((rs < rt) && rs[15] == rt[15]) || (rs[15] == 1 && rt[15] == 0)) ? 16'b0000_0000_0000_0001:16'b0000_0000_0000_0000;
            MUL:    core_r3 <= rs * rt;
            default:core_r3 <= core_r3;
        endcase
    end
    else if(state == DRAM_MEM_DATA && func == LW && instruction[8:5] == 4'b0011 && !wen_d && index_d == lw_sw_address[8:1])begin
        core_r3 <= sram_in_d;
    end
    else if(state == SRAM_MEM && counter_d == 1 && instruction[8:5] == 4'b0011)begin
        core_r3 <= sram_out_d;
    end
    else begin
        core_r3 <= core_r3;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        core_r4 <= 16'b0000_0000_0000_0000;
    end
    else if(state == EXE && instruction[4:1] == 4'b0100)begin
        case(func)
            ADD:    core_r4 <= rs + rt;
            SUB:    core_r4 <= rs - rt;
            SLT:    core_r4 <= (((rs < rt) && rs[15] == rt[15]) || (rs[15] == 1 && rt[15] == 0)) ? 16'b0000_0000_0000_0001:16'b0000_0000_0000_0000;
            MUL:    core_r4 <= rs * rt;
            default:core_r4 <= core_r4;
        endcase
    end
    else if(state == DRAM_MEM_DATA && func == LW && instruction[8:5] == 4'b0100 && !wen_d && index_d == lw_sw_address[8:1])begin
        core_r4 <= sram_in_d;
    end
    else if(state == SRAM_MEM && counter_d == 1 && instruction[8:5] == 4'b0100)begin
        core_r4 <= sram_out_d;
    end
    else begin
        core_r4 <= core_r4;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        core_r5 <= 16'b0000_0000_0000_0000;
    end
    else if(state == EXE && instruction[4:1] == 4'b0101)begin
        case(func)
            ADD:    core_r5 <= rs + rt;
            SUB:    core_r5 <= rs - rt;
            SLT:    core_r5 <= (((rs < rt) && rs[15] == rt[15]) || (rs[15] == 1 && rt[15] == 0)) ? 16'b0000_0000_0000_0001:16'b0000_0000_0000_0000;
            MUL:    core_r5 <= rs * rt;
            default:core_r5 <= core_r5;
        endcase
    end
    else if(state == DRAM_MEM_DATA && func == LW && instruction[8:5] == 4'b0101 && !wen_d && index_d == lw_sw_address[8:1])begin
        core_r5 <= sram_in_d;
    end
    else if(state == SRAM_MEM && counter_d == 1 && instruction[8:5] == 4'b0101)begin
        core_r5 <= sram_out_d;
    end
    else begin
        core_r5 <= core_r5;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        core_r6 <= 16'b0000_0000_0000_0000;
    end
    else if(state == EXE && instruction[4:1] == 4'b0110)begin
        case(func)
            ADD:    core_r6 <= rs + rt;
            SUB:    core_r6 <= rs - rt;
            SLT:    core_r6 <= (((rs < rt) && rs[15] == rt[15]) || (rs[15] == 1 && rt[15] == 0)) ? 16'b0000_0000_0000_0001:16'b0000_0000_0000_0000;
            MUL:    core_r6 <= rs * rt;
            default:core_r6 <= core_r6;
        endcase
    end
    else if(state == DRAM_MEM_DATA && func == LW && instruction[8:5] == 4'b0110 && !wen_d && index_d == lw_sw_address[8:1])begin
        core_r6 <= sram_in_d;
    end
    else if(state == SRAM_MEM && counter_d == 1 && instruction[8:5] == 4'b0110)begin
        core_r6 <= sram_out_d;
    end
    else begin
        core_r6 <= core_r6;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        core_r7 <= 16'b0000_0000_0000_0000;
    end
    else if(state == EXE && instruction[4:1] == 4'b0111)begin
        case(func)
            ADD:    core_r7 <= rs + rt;
            SUB:    core_r7 <= rs - rt;
            SLT:    core_r7 <= (((rs < rt) && rs[15] == rt[15]) || (rs[15] == 1 && rt[15] == 0)) ? 16'b0000_0000_0000_0001:16'b0000_0000_0000_0000;
            MUL:    core_r7 <= rs * rt;
            default:core_r7 <= core_r7;
        endcase
    end
    else if(state == DRAM_MEM_DATA && func == LW && instruction[8:5] == 4'b0111 && !wen_d && index_d == lw_sw_address[8:1])begin
        core_r7 <= sram_in_d;
    end
    else if(state == SRAM_MEM && counter_d == 1 && instruction[8:5] == 4'b0111)begin
        core_r7 <= sram_out_d;
    end
    else begin
        core_r7 <= core_r7;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        core_r8 <= 16'b0000_0000_0000_0000;
    end
    else if(state == EXE && instruction[4:1] == 4'b1000)begin
        case(func)
            ADD:    core_r8 <= rs + rt;
            SUB:    core_r8 <= rs - rt;
            SLT:    core_r8 <= (((rs < rt) && rs[15] == rt[15]) || (rs[15] == 1 && rt[15] == 0)) ? 16'b0000_0000_0000_0001:16'b0000_0000_0000_0000;
            MUL:    core_r8 <= rs * rt;
            default:core_r8 <= core_r8;
        endcase
    end
    else if(state == DRAM_MEM_DATA && func == LW && instruction[8:5] == 4'b1000 && !wen_d && index_d == lw_sw_address[8:1])begin
        core_r8 <= sram_in_d;
    end
    else if(state == SRAM_MEM && counter_d == 1 && instruction[8:5] == 4'b1000)begin
        core_r8 <= sram_out_d;
    end
    else begin
        core_r8 <= core_r8;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        core_r9 <= 16'b0000_0000_0000_0000;
    end
    else if(state == EXE && instruction[4:1] == 4'b1001)begin
        case(func)
            ADD:    core_r9 <= rs + rt;
            SUB:    core_r9 <= rs - rt;
            SLT:    core_r9 <= (((rs < rt) && rs[15] == rt[15]) || (rs[15] == 1 && rt[15] == 0)) ? 16'b0000_0000_0000_0001:16'b0000_0000_0000_0000;
            MUL:    core_r9 <= rs * rt;
            default:core_r9 <= core_r9;
        endcase
    end
    else if(state == DRAM_MEM_DATA && func == LW && instruction[8:5] == 4'b1001 && !wen_d && index_d == lw_sw_address[8:1])begin
        core_r9 <= sram_in_d;
    end
    else if(state == SRAM_MEM && counter_d == 1 && instruction[8:5] == 4'b1001)begin
        core_r9 <= sram_out_d;
    end
    else begin
        core_r9 <= core_r9;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        core_r10 <= 16'b0000_0000_0000_0000;
    end
    else if(state == EXE && instruction[4:1] == 4'b1010)begin
        case(func)
            ADD:    core_r10 <= rs + rt;
            SUB:    core_r10 <= rs - rt;
            SLT:    core_r10 <= (((rs < rt) && rs[15] == rt[15]) || (rs[15] == 1 && rt[15] == 0)) ? 16'b0000_0000_0000_0001:16'b0000_0000_0000_0000;
            MUL:    core_r10 <= rs * rt;
            default:core_r10 <= core_r10;
        endcase
    end
    else if(state == DRAM_MEM_DATA && func == LW && instruction[8:5] == 4'b1010 && !wen_d && index_d == lw_sw_address[8:1])begin
        core_r10 <= sram_in_d;
    end
    else if(state == SRAM_MEM && counter_d == 1 && instruction[8:5] == 4'b1010)begin
        core_r10 <= sram_out_d;
    end
    else begin
        core_r10 <= core_r10;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        core_r11 <= 16'b0000_0000_0000_0000;
    end
    else if(state == EXE && instruction[4:1] == 4'b1011)begin
        case(func)
            ADD:    core_r11 <= rs + rt;
            SUB:    core_r11 <= rs - rt;
            SLT:    core_r11 <= (((rs < rt) && rs[15] == rt[15]) || (rs[15] == 1 && rt[15] == 0)) ? 16'b0000_0000_0000_0001:16'b0000_0000_0000_0000;
            MUL:    core_r11 <= rs * rt;
            default:core_r11 <= core_r11;
        endcase
    end
    else if(state == DRAM_MEM_DATA && func == LW && instruction[8:5] == 4'b1011 && !wen_d && index_d == lw_sw_address[8:1])begin
        core_r11 <= sram_in_d;
    end
    else if(state == SRAM_MEM && counter_d == 1 && instruction[8:5] == 4'b1011)begin
        core_r11 <= sram_out_d;
    end
    else begin
        core_r11 <= core_r11;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        core_r12 <= 16'b0000_0000_0000_0000;
    end
    else if(state == EXE && instruction[4:1] == 4'b1100)begin
        case(func)
            ADD:    core_r12 <= rs + rt;
            SUB:    core_r12 <= rs - rt;
            SLT:    core_r12 <= (((rs < rt) && rs[15] == rt[15]) || (rs[15] == 1 && rt[15] == 0)) ? 16'b0000_0000_0000_0001:16'b0000_0000_0000_0000;
            MUL:    core_r12 <= rs * rt;
            default:core_r12 <= core_r12;
        endcase
    end
    else if(state == DRAM_MEM_DATA && func == LW && instruction[8:5] == 4'b1100 && !wen_d && index_d == lw_sw_address[8:1])begin
        core_r12 <= sram_in_d;
    end
    else if(state == SRAM_MEM && counter_d == 1 && instruction[8:5] == 4'b1100)begin
        core_r12 <= sram_out_d;
    end
    else begin
        core_r12 <= core_r12;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        core_r13 <= 16'b0000_0000_0000_0000;
    end
    else if(state == EXE && instruction[4:1] == 4'b1101)begin
        case(func)
            ADD:    core_r13 <= rs + rt;
            SUB:    core_r13 <= rs - rt;
            SLT:    core_r13 <= (((rs < rt) && rs[15] == rt[15]) || (rs[15] == 1 && rt[15] == 0)) ? 16'b0000_0000_0000_0001:16'b0000_0000_0000_0000;
            MUL:    core_r13 <= rs * rt;
            default:core_r13 <= core_r13;
        endcase
    end
    else if(state == DRAM_MEM_DATA && func == LW && instruction[8:5] == 4'b1101 && !wen_d && index_d == lw_sw_address[8:1])begin
        core_r13 <= sram_in_d;
    end
    else if(state == SRAM_MEM && counter_d == 1 && instruction[8:5] == 4'b1101)begin
        core_r13 <= sram_out_d;
    end
    else begin
        core_r13 <= core_r13;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        core_r14 <= 16'b0000_0000_0000_0000;
    end
    else if(state == EXE && instruction[4:1] == 4'b1110)begin
        case(func)
            ADD:    core_r14 <= rs + rt;
            SUB:    core_r14 <= rs - rt;
            SLT:    core_r14 <= (((rs < rt) && rs[15] == rt[15]) || (rs[15] == 1 && rt[15] == 0)) ? 16'b0000_0000_0000_0001:16'b0000_0000_0000_0000;
            MUL:    core_r14 <= rs * rt;
            default:core_r14 <= core_r14;
        endcase
    end
    else if(state == DRAM_MEM_DATA && func == LW && instruction[8:5] == 4'b1110 && !wen_d && index_d == lw_sw_address[8:1])begin
        core_r14 <= sram_in_d;
    end
    else if(state == SRAM_MEM && counter_d == 1 && instruction[8:5] == 4'b1110)begin
        core_r14 <= sram_out_d;
    end
    else begin
        core_r14 <= core_r14;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        core_r15 <= 16'b0000_0000_0000_0000;
    end
    else if(state == EXE && instruction[4:1] == 4'b1111)begin
        case(func)
            ADD:    core_r15 <= rs + rt;
            SUB:    core_r15 <= rs - rt;
            SLT:    core_r15 <= (((rs < rt) && rs[15] == rt[15]) || (rs[15] == 1 && rt[15] == 0)) ? 16'b0000_0000_0000_0001:16'b0000_0000_0000_0000;
            MUL:    core_r15 <= rs * rt;
            default:core_r15 <= core_r15;
        endcase
    end
    else if(state == DRAM_MEM_DATA && func == LW && instruction[8:5] == 4'b1111 && !wen_d && index_d == lw_sw_address[8:1])begin
        core_r15 <= sram_in_d;
    end
    else if(state == SRAM_MEM && counter_d == 1 && instruction[8:5] == 4'b1111)begin
        core_r15 <= sram_out_d;
    end
    else begin
        core_r15 <= core_r15;
    end
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        lw_sw_address <= 0;
    end
    else if(state == EXE && (func == LW || func == SW))begin
        lw_sw_address <= ((rs + {{11{imm[4]}},imm}) << 1) + 16'h1000;
    end
    else begin
        lw_sw_address <= lw_sw_address;
    end
end
//////////////////////////////////////////////////////////////////////
//               MEMORY                         
//////////////////////////////////////////////////////////////////////
/*--------------- WRITE ADDRESS CHANNEL---------------*/
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        awid_m_inf   <= 0;
        awaddr_m_inf <= 0;
        awsize_m_inf <= 0;
        awburst_m_inf<= 0;
        awlen_m_inf  <= 0;
        awvalid_m_inf<= 0;
    end
    else if(nextstate == DRAM_MEM_ADD && func == SW)begin
        awid_m_inf   <= 4'b0000;
        awaddr_m_inf <= {16'b0000_0000_0000_0000,((rs + {{11{imm[4]}},imm}) << 1) + 16'h1000};
        awlen_m_inf  <= 7'd0;
        awsize_m_inf <= 3'b001;
        awburst_m_inf<= 2'b01;
        awvalid_m_inf<= 1'b1;
    end
    else begin
        awid_m_inf   <= 0;
        awaddr_m_inf <= 0;
        awsize_m_inf <= 0;
        awburst_m_inf<= 0;
        awlen_m_inf  <= 0;
        awvalid_m_inf<= 0;
    end
end
/*----------------- WRITE DATA CHANNEL----------------*/
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
         wdata_m_inf <= 0;
         wlast_m_inf <= 0;
         wvalid_m_inf<= 0;                           
    end
    else if(state == DRAM_MEM_DATA && func == SW) begin
         wdata_m_inf <= rt;
         wlast_m_inf <= 1'b1;
         wvalid_m_inf<= 1'b1; 
    end
    else begin
         wdata_m_inf <= 0;
         wlast_m_inf <= 0;
         wvalid_m_inf<= 0;    
    end
end

/*--------------- WRITE RESPONSE CHANNEL--------------*/
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        bready_m_inf <= 0;
    end
    else if(state == DRAM_MEM_DATA && func == SW)begin
        bready_m_inf <= 1'b1;
    end
    else begin
        bready_m_inf <= 0;
    end
end
//-------------------------------------------------------//
//               SRAM INSTRUCTION WRITE                         
//-------------------------------------------------------//
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        wen_d <= 1;
    end
    else if(rvalid_m_inf[0] || (wready_m_inf && lw_sw_address[11:9] == data_tag[lw_sw_address[8:1]]))begin
        wen_d <= 0;
    end
    else begin
        wen_d <= 1;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        index_d <= 0;
    end
    else if(state == DRAM_MEM_ADD && nextstate == DRAM_MEM_DATA && func == SW)begin
        index_d <=  awaddr_m_inf[8:1];
    end
    else if(state == DRAM_MEM_ADD && nextstate == DRAM_MEM_DATA && func == LW)begin
        if(lw_sw_address[11:0] <= 12'h07c)begin
            index_d <= counter_d << 7;
        end
        else if(lw_sw_address[11:0] >= 12'hf7e)begin
            index_d <= 12'hf80;
        end
        else begin
            index_d <=  araddr_m_inf[8:1];
        end
    end
    else if(state == DRAM_MEM_DATA && wen_d == 0)begin   // read data to sram
        index_d <= (index_d == 8'd255) ? 0:index_d + 1;
    end
    else if(state == DRAM_MEM_DATA && wen_d == 1)begin   // read data to sram
        index_d <= index_d;
    end
    else if(nextstate == SRAM_MEM)begin  // read data
        index_d <= lw_sw_address[8:1];
    end
    else begin
        index_d <= 0;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        sram_in_d <= 0;
    end
    else if(rvalid_m_inf[0])begin   //write data in lw
        sram_in_d <= rdata_m_inf[15:0];
    end
    else if(wready_m_inf)begin   //write data in sw
        sram_in_d <= wdata_m_inf[15:0];
    end
    else begin
        sram_in_d <= sram_in_d;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        data_tag[0]   <= 0;data_tag[10]   <= 0;data_tag[20] <= 0;data_tag[30]  <= 0;data_tag[40]  <= 0;data_tag[50]  <= 0;data_tag[60]  <= 0;data_tag[70]  <= 0;data_tag[80]  <= 0;data_tag[90]  <= 0;
        data_tag[1]   <= 0;data_tag[11]   <= 0;data_tag[21] <= 0;data_tag[31]  <= 0;data_tag[41]  <= 0;data_tag[51]  <= 0;data_tag[61]  <= 0;data_tag[71]  <= 0;data_tag[81]  <= 0;data_tag[91]  <= 0;
        data_tag[2]   <= 0;data_tag[12]   <= 0;data_tag[22] <= 0;data_tag[32]  <= 0;data_tag[42]  <= 0;data_tag[52]  <= 0;data_tag[62]  <= 0;data_tag[72]  <= 0;data_tag[82]  <= 0;data_tag[92]  <= 0;
        data_tag[3]   <= 0;data_tag[13]   <= 0;data_tag[23] <= 0;data_tag[33]  <= 0;data_tag[43]  <= 0;data_tag[53]  <= 0;data_tag[63]  <= 0;data_tag[73]  <= 0;data_tag[83]  <= 0;data_tag[93]  <= 0;
        data_tag[4]   <= 0;data_tag[14]   <= 0;data_tag[24] <= 0;data_tag[34]  <= 0;data_tag[44]  <= 0;data_tag[54]  <= 0;data_tag[64]  <= 0;data_tag[74]  <= 0;data_tag[84]  <= 0;data_tag[94]  <= 0;
        data_tag[5]   <= 0;data_tag[15]   <= 0;data_tag[25] <= 0;data_tag[35]  <= 0;data_tag[45]  <= 0;data_tag[55]  <= 0;data_tag[65]  <= 0;data_tag[75]  <= 0;data_tag[85]  <= 0;data_tag[95]  <= 0;
        data_tag[6]   <= 0;data_tag[16]   <= 0;data_tag[26] <= 0;data_tag[36]  <= 0;data_tag[46]  <= 0;data_tag[56]  <= 0;data_tag[66]  <= 0;data_tag[76]  <= 0;data_tag[86]  <= 0;data_tag[96]  <= 0;
        data_tag[7]   <= 0;data_tag[17]   <= 0;data_tag[27] <= 0;data_tag[37]  <= 0;data_tag[47]  <= 0;data_tag[57]  <= 0;data_tag[67]  <= 0;data_tag[77]  <= 0;data_tag[87]  <= 0;data_tag[97]  <= 0;
        data_tag[8]   <= 0;data_tag[18]   <= 0;data_tag[28] <= 0;data_tag[38]  <= 0;data_tag[48]  <= 0;data_tag[58]  <= 0;data_tag[68]  <= 0;data_tag[78]  <= 0;data_tag[88]  <= 0;data_tag[98]  <= 0;
        data_tag[9]   <= 0;data_tag[19]   <= 0;data_tag[29] <= 0;data_tag[39]  <= 0;data_tag[49]  <= 0;data_tag[59]  <= 0;data_tag[69]  <= 0;data_tag[79]  <= 0;data_tag[89]  <= 0;data_tag[99]  <= 0;
        data_tag[100] <= 0;data_tag[110] <= 0;data_tag[120] <= 0;data_tag[130] <= 0;data_tag[140] <= 0;data_tag[150] <= 0;data_tag[160] <= 0;data_tag[170] <= 0;data_tag[180] <= 0;data_tag[190] <= 0;
        data_tag[101] <= 0;data_tag[111] <= 0;data_tag[121] <= 0;data_tag[131] <= 0;data_tag[141] <= 0;data_tag[151] <= 0;data_tag[161] <= 0;data_tag[171] <= 0;data_tag[181] <= 0;data_tag[191] <= 0;
        data_tag[102] <= 0;data_tag[112] <= 0;data_tag[122] <= 0;data_tag[132] <= 0;data_tag[142] <= 0;data_tag[152] <= 0;data_tag[162] <= 0;data_tag[172] <= 0;data_tag[182] <= 0;data_tag[192] <= 0;
        data_tag[103] <= 0;data_tag[113] <= 0;data_tag[123] <= 0;data_tag[133] <= 0;data_tag[143] <= 0;data_tag[153] <= 0;data_tag[163] <= 0;data_tag[173] <= 0;data_tag[183] <= 0;data_tag[193] <= 0;
        data_tag[104] <= 0;data_tag[114] <= 0;data_tag[124] <= 0;data_tag[134] <= 0;data_tag[144] <= 0;data_tag[154] <= 0;data_tag[164] <= 0;data_tag[174] <= 0;data_tag[184] <= 0;data_tag[194] <= 0;
        data_tag[105] <= 0;data_tag[115] <= 0;data_tag[125] <= 0;data_tag[135] <= 0;data_tag[145] <= 0;data_tag[155] <= 0;data_tag[165] <= 0;data_tag[175] <= 0;data_tag[185] <= 0;data_tag[195] <= 0;
        data_tag[106] <= 0;data_tag[116] <= 0;data_tag[126] <= 0;data_tag[136] <= 0;data_tag[146] <= 0;data_tag[156] <= 0;data_tag[166] <= 0;data_tag[176] <= 0;data_tag[186] <= 0;data_tag[196] <= 0;
        data_tag[107] <= 0;data_tag[117] <= 0;data_tag[127] <= 0;data_tag[137] <= 0;data_tag[147] <= 0;data_tag[157] <= 0;data_tag[167] <= 0;data_tag[177] <= 0;data_tag[187] <= 0;data_tag[197] <= 0;
        data_tag[108] <= 0;data_tag[118] <= 0;data_tag[128] <= 0;data_tag[138] <= 0;data_tag[148] <= 0;data_tag[158] <= 0;data_tag[168] <= 0;data_tag[178] <= 0;data_tag[188] <= 0;data_tag[198] <= 0;
        data_tag[109] <= 0;data_tag[119] <= 0;data_tag[129] <= 0;data_tag[139] <= 0;data_tag[149] <= 0;data_tag[159] <= 0;data_tag[169] <= 0;data_tag[179] <= 0;data_tag[189] <= 0;data_tag[199] <= 0;
        data_tag[200] <= 0;data_tag[210] <= 0;data_tag[220] <= 0;data_tag[230] <= 0;data_tag[240] <= 0;data_tag[250] <= 0;
        data_tag[201] <= 0;data_tag[211] <= 0;data_tag[221] <= 0;data_tag[231] <= 0;data_tag[241] <= 0;data_tag[251] <= 0;
        data_tag[202] <= 0;data_tag[212] <= 0;data_tag[222] <= 0;data_tag[232] <= 0;data_tag[242] <= 0;data_tag[252] <= 0;
        data_tag[203] <= 0;data_tag[213] <= 0;data_tag[223] <= 0;data_tag[233] <= 0;data_tag[243] <= 0;data_tag[253] <= 0;
        data_tag[204] <= 0;data_tag[214] <= 0;data_tag[224] <= 0;data_tag[234] <= 0;data_tag[244] <= 0;data_tag[254] <= 0;
        data_tag[205] <= 0;data_tag[215] <= 0;data_tag[225] <= 0;data_tag[235] <= 0;data_tag[245] <= 0;data_tag[255] <= 0;
        data_tag[206] <= 0;data_tag[216] <= 0;data_tag[226] <= 0;data_tag[236] <= 0;data_tag[246] <= 0;
        data_tag[207] <= 0;data_tag[217] <= 0;data_tag[227] <= 0;data_tag[237] <= 0;data_tag[247] <= 0;
        data_tag[208] <= 0;data_tag[218] <= 0;data_tag[228] <= 0;data_tag[238] <= 0;data_tag[248] <= 0;
        data_tag[209] <= 0;data_tag[219] <= 0;data_tag[229] <= 0;data_tag[239] <= 0;data_tag[249] <= 0;
    end
    else if(state == DRAM_MEM_DATA && wen_d == 0)begin
        data_tag[index_d] <= count_addr_d[11:9];
    end
    else begin
        data_tag[0]   <= data_tag[0]  ;data_tag[10]  <= data_tag[10] ;data_tag[20]  <= data_tag[20] ;data_tag[30]  <= data_tag[30] ;data_tag[40]  <= data_tag[40] ;data_tag[50]  <= data_tag[50] ;data_tag[60]  <= data_tag[60] ;data_tag[70]  <= data_tag[70] ;data_tag[80]  <= data_tag[80] ;data_tag[90]  <= data_tag[90] ;
        data_tag[1]   <= data_tag[1]  ;data_tag[11]  <= data_tag[11] ;data_tag[21]  <= data_tag[21] ;data_tag[31]  <= data_tag[31] ;data_tag[41]  <= data_tag[41] ;data_tag[51]  <= data_tag[51] ;data_tag[61]  <= data_tag[61] ;data_tag[71]  <= data_tag[71] ;data_tag[81]  <= data_tag[81] ;data_tag[91]  <= data_tag[91] ;
        data_tag[2]   <= data_tag[2]  ;data_tag[12]  <= data_tag[12] ;data_tag[22]  <= data_tag[22] ;data_tag[32]  <= data_tag[32] ;data_tag[42]  <= data_tag[42] ;data_tag[52]  <= data_tag[52] ;data_tag[62]  <= data_tag[62] ;data_tag[72]  <= data_tag[72] ;data_tag[82]  <= data_tag[82] ;data_tag[92]  <= data_tag[92] ;
        data_tag[3]   <= data_tag[3]  ;data_tag[13]  <= data_tag[13] ;data_tag[23]  <= data_tag[23] ;data_tag[33]  <= data_tag[33] ;data_tag[43]  <= data_tag[43] ;data_tag[53]  <= data_tag[53] ;data_tag[63]  <= data_tag[63] ;data_tag[73]  <= data_tag[73] ;data_tag[83]  <= data_tag[83] ;data_tag[93]  <= data_tag[93] ;
        data_tag[4]   <= data_tag[4]  ;data_tag[14]  <= data_tag[14] ;data_tag[24]  <= data_tag[24] ;data_tag[34]  <= data_tag[34] ;data_tag[44]  <= data_tag[44] ;data_tag[54]  <= data_tag[54] ;data_tag[64]  <= data_tag[64] ;data_tag[74]  <= data_tag[74] ;data_tag[84]  <= data_tag[84] ;data_tag[94]  <= data_tag[94] ;
        data_tag[5]   <= data_tag[5]  ;data_tag[15]  <= data_tag[15] ;data_tag[25]  <= data_tag[25] ;data_tag[35]  <= data_tag[35] ;data_tag[45]  <= data_tag[45] ;data_tag[55]  <= data_tag[55] ;data_tag[65]  <= data_tag[65] ;data_tag[75]  <= data_tag[75] ;data_tag[85]  <= data_tag[85] ;data_tag[95]  <= data_tag[95] ;
        data_tag[6]   <= data_tag[6]  ;data_tag[16]  <= data_tag[16] ;data_tag[26]  <= data_tag[26] ;data_tag[36]  <= data_tag[36] ;data_tag[46]  <= data_tag[46] ;data_tag[56]  <= data_tag[56] ;data_tag[66]  <= data_tag[66] ;data_tag[76]  <= data_tag[76] ;data_tag[86]  <= data_tag[86] ;data_tag[96]  <= data_tag[96] ;
        data_tag[7]   <= data_tag[7]  ;data_tag[17]  <= data_tag[17] ;data_tag[27]  <= data_tag[27] ;data_tag[37]  <= data_tag[37] ;data_tag[47]  <= data_tag[47] ;data_tag[57]  <= data_tag[57] ;data_tag[67]  <= data_tag[67] ;data_tag[77]  <= data_tag[77] ;data_tag[87]  <= data_tag[87] ;data_tag[97]  <= data_tag[97] ;
        data_tag[8]   <= data_tag[8]  ;data_tag[18]  <= data_tag[18] ;data_tag[28]  <= data_tag[28] ;data_tag[38]  <= data_tag[38] ;data_tag[48]  <= data_tag[48] ;data_tag[58]  <= data_tag[58] ;data_tag[68]  <= data_tag[68] ;data_tag[78]  <= data_tag[78] ;data_tag[88]  <= data_tag[88] ;data_tag[98]  <= data_tag[98] ;
        data_tag[9]   <= data_tag[9]  ;data_tag[19]  <= data_tag[19] ;data_tag[29]  <= data_tag[29] ;data_tag[39]  <= data_tag[39] ;data_tag[49]  <= data_tag[49] ;data_tag[59]  <= data_tag[59] ;data_tag[69]  <= data_tag[69] ;data_tag[79]  <= data_tag[79] ;data_tag[89]  <= data_tag[89] ;data_tag[99]  <= data_tag[99] ;
        data_tag[100] <= data_tag[100];data_tag[110] <= data_tag[110];data_tag[120] <= data_tag[120];data_tag[130] <= data_tag[130];data_tag[140] <= data_tag[140];data_tag[150] <= data_tag[150];data_tag[160] <= data_tag[160];data_tag[170] <= data_tag[170];data_tag[180] <= data_tag[180];data_tag[190] <= data_tag[190];
        data_tag[101] <= data_tag[101];data_tag[111] <= data_tag[111];data_tag[121] <= data_tag[121];data_tag[131] <= data_tag[131];data_tag[141] <= data_tag[141];data_tag[151] <= data_tag[151];data_tag[161] <= data_tag[161];data_tag[171] <= data_tag[171];data_tag[181] <= data_tag[181];data_tag[191] <= data_tag[191];
        data_tag[102] <= data_tag[102];data_tag[112] <= data_tag[112];data_tag[122] <= data_tag[122];data_tag[132] <= data_tag[132];data_tag[142] <= data_tag[142];data_tag[152] <= data_tag[152];data_tag[162] <= data_tag[162];data_tag[172] <= data_tag[172];data_tag[182] <= data_tag[182];data_tag[192] <= data_tag[192];
        data_tag[103] <= data_tag[103];data_tag[113] <= data_tag[113];data_tag[123] <= data_tag[123];data_tag[133] <= data_tag[133];data_tag[143] <= data_tag[143];data_tag[153] <= data_tag[153];data_tag[163] <= data_tag[163];data_tag[173] <= data_tag[173];data_tag[183] <= data_tag[183];data_tag[193] <= data_tag[193];
        data_tag[104] <= data_tag[104];data_tag[114] <= data_tag[114];data_tag[124] <= data_tag[124];data_tag[134] <= data_tag[134];data_tag[144] <= data_tag[144];data_tag[154] <= data_tag[154];data_tag[164] <= data_tag[164];data_tag[174] <= data_tag[174];data_tag[184] <= data_tag[184];data_tag[194] <= data_tag[194];
        data_tag[105] <= data_tag[105];data_tag[115] <= data_tag[115];data_tag[125] <= data_tag[125];data_tag[135] <= data_tag[135];data_tag[145] <= data_tag[145];data_tag[155] <= data_tag[155];data_tag[165] <= data_tag[165];data_tag[175] <= data_tag[175];data_tag[185] <= data_tag[185];data_tag[195] <= data_tag[195];
        data_tag[106] <= data_tag[106];data_tag[116] <= data_tag[116];data_tag[126] <= data_tag[126];data_tag[136] <= data_tag[136];data_tag[146] <= data_tag[146];data_tag[156] <= data_tag[156];data_tag[166] <= data_tag[166];data_tag[176] <= data_tag[176];data_tag[186] <= data_tag[186];data_tag[196] <= data_tag[196];
        data_tag[107] <= data_tag[107];data_tag[117] <= data_tag[117];data_tag[127] <= data_tag[127];data_tag[137] <= data_tag[137];data_tag[147] <= data_tag[147];data_tag[157] <= data_tag[157];data_tag[167] <= data_tag[167];data_tag[177] <= data_tag[177];data_tag[187] <= data_tag[187];data_tag[197] <= data_tag[197];
        data_tag[108] <= data_tag[108];data_tag[118] <= data_tag[118];data_tag[128] <= data_tag[128];data_tag[138] <= data_tag[138];data_tag[148] <= data_tag[148];data_tag[158] <= data_tag[158];data_tag[168] <= data_tag[168];data_tag[178] <= data_tag[178];data_tag[188] <= data_tag[188];data_tag[198] <= data_tag[198];
        data_tag[109] <= data_tag[109];data_tag[119] <= data_tag[119];data_tag[129] <= data_tag[129];data_tag[139] <= data_tag[139];data_tag[149] <= data_tag[149];data_tag[159] <= data_tag[159];data_tag[169] <= data_tag[169];data_tag[179] <= data_tag[179];data_tag[189] <= data_tag[189];data_tag[199] <= data_tag[199];
        data_tag[200] <= data_tag[200];data_tag[210] <= data_tag[210];data_tag[220] <= data_tag[220];data_tag[230] <= data_tag[230];data_tag[240] <= data_tag[240];data_tag[250] <= data_tag[250];
        data_tag[201] <= data_tag[201];data_tag[211] <= data_tag[211];data_tag[221] <= data_tag[221];data_tag[231] <= data_tag[231];data_tag[241] <= data_tag[241];data_tag[251] <= data_tag[251];
        data_tag[202] <= data_tag[202];data_tag[212] <= data_tag[212];data_tag[222] <= data_tag[222];data_tag[232] <= data_tag[232];data_tag[242] <= data_tag[242];data_tag[252] <= data_tag[252];
        data_tag[203] <= data_tag[203];data_tag[213] <= data_tag[213];data_tag[223] <= data_tag[223];data_tag[233] <= data_tag[233];data_tag[243] <= data_tag[243];data_tag[253] <= data_tag[253];
        data_tag[204] <= data_tag[204];data_tag[214] <= data_tag[214];data_tag[224] <= data_tag[224];data_tag[234] <= data_tag[234];data_tag[244] <= data_tag[244];data_tag[254] <= data_tag[254];
        data_tag[205] <= data_tag[205];data_tag[215] <= data_tag[215];data_tag[225] <= data_tag[225];data_tag[235] <= data_tag[235];data_tag[245] <= data_tag[245];data_tag[255] <= data_tag[255];
        data_tag[206] <= data_tag[206];data_tag[216] <= data_tag[216];data_tag[226] <= data_tag[226];data_tag[236] <= data_tag[236];data_tag[246] <= data_tag[246];
        data_tag[207] <= data_tag[207];data_tag[217] <= data_tag[217];data_tag[227] <= data_tag[227];data_tag[237] <= data_tag[237];data_tag[247] <= data_tag[247];
        data_tag[208] <= data_tag[208];data_tag[218] <= data_tag[218];data_tag[228] <= data_tag[228];data_tag[238] <= data_tag[238];data_tag[248] <= data_tag[248];
        data_tag[209] <= data_tag[209];data_tag[219] <= data_tag[219];data_tag[229] <= data_tag[229];data_tag[239] <= data_tag[239];data_tag[249] <= data_tag[249];
    end
end
//////////////////////////////////////////////////////////////////////
//               OUT                        
//////////////////////////////////////////////////////////////////////
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        IO_stall <= 1;
    end
    else if(nextstate == OUT && ns == OUT_STAGE) begin
        IO_stall <= 0;
    end
    else begin
        IO_stall <= 1;
    end
end
//////////////////////////////////////////////////////////////////////
//               COUNTER                         
//////////////////////////////////////////////////////////////////////
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        counter <= 0;
    end
    else if((cs == DRAM_IF_ADD && ns == DRAM_IF_ADD) || cs == DRAM_IF_DATA)begin
        counter <= counter;
    end
    else if(cs == DRAM_IF_ADD && ns == DRAM_IF_DATA)begin
        counter <= counter + 1;
    end
    else if(state == SRAM_IF)begin
        counter <= counter + 1;
    end
    else begin
        counter <= 0;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        count_addr <= 0;
    end
    else if(cs == DRAM_IF_ADD && ns == DRAM_IF_DATA)begin
        count_addr <= araddr_m_inf[47:32];
    end
    else if(cs == DRAM_IF_DATA)begin
        count_addr <= (!wen) ? count_addr + 2 : count_addr;
    end
    else begin
        count_addr <= 0;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        counter_d <= 0;
    end
    else if((state == DRAM_MEM_ADD && nextstate == DRAM_MEM_ADD) || state == DRAM_MEM_DATA)begin
        counter_d <= counter_d;
    end
    else if(state == DRAM_MEM_ADD && nextstate == DRAM_MEM_DATA)begin
        counter_d <= counter_d + 1;
    end
    else if(state == SRAM_MEM)begin
        counter_d <= counter_d + 1;
    end
    else begin
        counter_d <= 0;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        count_addr_d <= 0;
    end
    else if(state == DRAM_MEM_ADD && nextstate == DRAM_MEM_DATA)begin
        count_addr_d <= araddr_m_inf[15:0];
    end
    else if(state == DRAM_MEM_DATA)begin
        count_addr_d <= (!wen_d) ? count_addr_d + 2 : count_addr_d;
    end
    else begin
        count_addr_d <= 0;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        first <= 1;
    end
    else if(state == OUT && cs == OUT_STAGE)begin
        first <= 0;
    end
    else begin
        first <= first;
    end
end
//////////////////////////////////////////////////////////////////////
//               FSM DECLARATION                        
//////////////////////////////////////////////////////////////////////
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        state <= IDLE;
    end
    else begin
        state <= nextstate;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cs <= START;
    end
    else begin
        cs <= ns;
    end
end

always @(*)begin
    case(cs)
        START:begin
            if(pc[11:9] == instr_tag[pc[8:1]] && first == 0)    ns = OUT_STAGE;
            else                                                ns = DRAM_IF_ADD;
        end
        DRAM_IF_ADD:begin
            if(arready_m_inf[1])                ns = DRAM_IF_DATA;
            else                                ns = cs;
        end
        DRAM_IF_DATA:begin
            if(count_addr[7:0] == 8'hfe && ((first && counter != 3'd2)))                     ns = DRAM_IF_ADD;
            else if(count_addr[7:0] == 8'hfe && ((!first) || (first && counter == 3'd2)))    ns = OUT_STAGE;
            else                                                                             ns = cs;
        end
        OUT_STAGE:begin
            if(state == OUT)    ns = START;
            else                ns = cs;
        end
        default:begin
            ns = START;
        end
    endcase
end
always @(*)begin
    case(state)
        IDLE:begin
            if(pc[11:9] == instr_tag[pc[8:1]] && first == 0)    nextstate = SRAM_IF;
            else                                                 nextstate = WAIT;
        end
        WAIT:begin
            if(index == pc[8:1] && !wen)        nextstate = ID;
            else                                nextstate = state;
        end
        SRAM_IF:begin
            if(counter == 1)                    nextstate = ID;
            else                                nextstate = state;
        end
        ID:begin
            nextstate = EXE;
        end
        EXE:begin
            if(func == SW)          nextstate = DRAM_MEM_ADD;
            else if(func == LW)     nextstate = MEM1;
            else                    nextstate = OUT;
        end
        MEM1:begin
            nextstate = MEM2;
        end
        MEM2:begin
            if(lw_sw_address[11:9] == data_tag[lw_sw_address[8:1]] && first == 0)   nextstate = SRAM_MEM;
            else                                                                    nextstate = DRAM_MEM_ADD;
        end
        DRAM_MEM_ADD:begin
            if((func == SW && awready_m_inf) || (func == LW && arready_m_inf[0]))   nextstate = DRAM_MEM_DATA;
            else                                                                    nextstate = state;
        end
        DRAM_MEM_DATA:begin
            if(count_addr_d[7:0] == 8'hfe && ((first && counter_d != 3'd2)))                                   nextstate = DRAM_MEM_ADD;
            else if(func == LW && count_addr_d[7:0] == 8'hfe && ((!first) || (first && counter_d == 3'd2)))    nextstate = OUT;
            else if(func == SW && bvalid_m_inf)                                                                nextstate = OUT;
            else                                                                                               nextstate = state;
        end
        SRAM_MEM:begin
            if(counter_d == 1)                    nextstate = OUT;
            else                                  nextstate = state;
        end
        OUT:begin
            if(cs == OUT_STAGE) nextstate = IDLE;
            else                nextstate = state;
        end
        default:nextstate = IDLE;
    endcase
end


endmodule



















