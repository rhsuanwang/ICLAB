`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/07 22:51:18
// Design Name: 
// Module Name: CS
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
//synopsys translate_off
`include "CS_IP.v"
//synopsys translate_on


module CS#(parameter WIDTH_DATA_1 = 384, parameter WIDTH_RESULT_1 = 8,
parameter WIDTH_DATA_2 = 128, parameter WIDTH_RESULT_2 = 8)
(
    data,
    in_valid,
    clk,
    rst_n,
    result,
    out_valid
);

input [(WIDTH_DATA_1 + WIDTH_DATA_2 - 1):0] data;
input in_valid, clk, rst_n;

output reg [(WIDTH_RESULT_1 + WIDTH_RESULT_2 -1):0] result;
output reg out_valid;
wire [(WIDTH_RESULT_1 + WIDTH_RESULT_2 -1):0] out_data;       
wire out_valid_data1,out_valid_data2;                                             

CS_IP #(.WIDTH_DATA(WIDTH_DATA_1), .WIDTH_RESULT(WIDTH_RESULT_1)) CS_IP1(
    .data(data[511:128]),
    .in_valid(in_valid),
    .clk(clk),
    .rst_n(rst_n),
    .result(out_data[15:8]),
    .out_valid(out_valid_data1)
);
CS_IP #(.WIDTH_DATA(WIDTH_DATA_2), .WIDTH_RESULT(WIDTH_RESULT_2)) CS_IP2(
    .data(data[127:0]),
    .in_valid(in_valid),
    .clk(clk),
    .rst_n(rst_n),
    .result(out_data[7:0]),
    .out_valid(out_valid_data2)
);
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        result <= 0;
        out_valid <= 0;
    end
    else begin
        result <= out_data;
        out_valid <= out_valid_data1 & out_valid_data2;
    end
end

endmodule