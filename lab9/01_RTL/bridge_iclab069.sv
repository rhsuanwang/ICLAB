`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/05 16:00:11
// Design Name: 
// Module Name: bridge
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module bridge(input clk, INF.bridge_inf inf);
import usertype::*;
state_b cs,ns;
/*----------------------------------------------------------------*/
//    REG DECLARATION                                           //
/*----------------------------------------------------------------*/
logic [7:0] address;
logic [31:0] data;
/*-------------------------------------------------------------------*/
//                   READ DRAM ALGORITHM                      //
/*-------------------------------------------------------------------*/
always @(posedge clk, negedge inf.rst_n) begin
    if(!inf.rst_n) begin
        address <= 0;
    end
    else if(cs == START && !inf.C_in_valid)begin
        address <= 0;
    end
    else if(inf.C_in_valid)
        address <= inf.C_addr;
    else begin
        address <= address;
    end
end
always @(posedge clk, negedge inf.rst_n) begin
    if(!inf.rst_n) begin
        data <= 0;
    end
    else if(cs == START && !inf.C_in_valid)begin
        data <= 0;
    end
    else if(inf.C_in_valid)
        data <= inf.C_data_w;
    else if(inf.R_VALID)
        data <= inf.R_DATA;
    else begin
        data <= data;
    end
end
/*--------------- READ ADDRESS CHANNEL----------------*/
always @(posedge clk, negedge inf.rst_n) begin
    if(!inf.rst_n) begin
        inf.AR_ADDR <= 0;
        inf.AR_VALID <= 0;
    end
    else if(cs == DRAM_R_ADD) begin        // READ INSTRUCTION FROM DRAM READ
        inf.AR_ADDR <= (address << 2) + 32'h10000;    
        inf.AR_VALID <= 1'b1;                                                      
    end
    else begin                                                                        
        inf.AR_ADDR <= 0;     
        inf.AR_VALID <= 0;  
    end
end
/*---------------- READ DATA CHANNEL-------------------*/
always @(posedge clk, negedge inf.rst_n) begin
    if(!inf.rst_n) begin
        inf.R_READY <= 0;                       
    end
    else if(inf.AR_READY)begin // DRAM GIVEN ADDRESS 
        inf.R_READY <= 1'b1;     
    end
    else if(inf.R_VALID == 1) begin  //DRAM READ END READ @ INSFETCH @ DATAFETCH FOR CONV
        inf.R_READY <= 0;
    end
    else begin
        inf.R_READY <= inf.R_READY;
    end
end

/*-------------------------------------------------------------------*/
//                  WRITE DRAM ALGORITHM                     //
/*-------------------------------------------------------------------*/
/*--------------- WRITE ADDRESS CHANNEL---------------*/
always @(posedge clk, negedge inf.rst_n) begin
    if(!inf.rst_n) begin
        inf.AW_ADDR <= 0;
        inf.AW_VALID<= 0;
    end
    else if(cs == DRAM_W_ADD)begin
        inf.AW_ADDR <= (address << 2) + 32'h10000;
        inf.AW_VALID<= 1'b1;
    end
    else begin
        inf.AW_ADDR <= 0;
        inf.AW_VALID<= 0;
    end
end
/*----------------- WRITE DATA CHANNEL----------------*/
always @(posedge clk, negedge inf.rst_n) begin
    if(!inf.rst_n) begin
         inf.W_DATA <= 0;
         inf.W_VALID<= 0;                           
    end
    else if(ns == DRAM_W_DATA) begin
         inf.W_DATA <= data;
         inf.W_VALID<= 1'b1; 
    end
    else begin
         inf.W_DATA <= 0;
         inf.W_VALID<= 0;    
    end
end

/*--------------- WRITE RESPONSE CHANNEL--------------*/
always @(posedge clk, negedge inf.rst_n) begin
    if(!inf.rst_n) begin
        inf.B_READY <= 0;
    end
    else if(ns == DRAM_W_DATA)begin
        inf.B_READY <= 1;
    end
    else begin
        inf.B_READY <= 0;
    end
end
/*----------------------------------------------------------------*/
//    OUT DECLARATION                                           //
/*----------------------------------------------------------------*/
always_ff @(posedge clk,negedge inf.rst_n)begin
    if(!inf.rst_n)begin
        inf.C_out_valid <= 0;
    end
    else if(inf.R_VALID || inf.W_READY == 1)begin
        inf.C_out_valid <= 1;
    end
    else begin
        inf.C_out_valid <= 0;
    end
end
always_ff @(posedge clk,negedge inf.rst_n)begin
    if(!inf.rst_n)begin
        inf.C_data_r <= 0;
    end
    else if(inf.R_VALID)begin
        inf.C_data_r <= inf.R_DATA;
    end
    else begin
        inf.C_data_r <= 0;
    end
end
/*----------------------------------------------------------------*/
//    FSM DECLARATION                                           //
/*----------------------------------------------------------------*/
always @(posedge clk, negedge inf.rst_n) begin
    if(!inf.rst_n) begin
        cs <= START;
    end
    else begin
        cs <= ns;
    end
end
always @(*) begin
    case(cs)
        START:begin    
                if(inf.C_in_valid)          ns = (inf.C_r_wb) ? DRAM_R_ADD:DRAM_W_ADD;
                else                        ns = cs;
            end
        DRAM_R_ADD:begin 
                if(inf.AR_READY == 1)       ns = DRAM_R_DATA;
                else                        ns = cs;
            end
        DRAM_R_DATA:begin
                if(inf.R_VALID == 1)     ns = START;
                else                        ns = cs;
            end      
        DRAM_W_ADD:begin  
                if(inf.AW_READY == 1)       ns = DRAM_W_DATA;
                else                        ns = cs;
            end
        DRAM_W_DATA:begin 
                if(inf.B_VALID == 1)        ns = START;
                else                        ns = cs;
            end
        default:                            ns = START;
    endcase
end

endmodule