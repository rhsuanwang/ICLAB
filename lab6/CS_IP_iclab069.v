`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/07 22:51:18
// Design Name: 
// Module Name: CS_IP
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


module CS_IP
#(parameter WIDTH_DATA = 384, parameter WIDTH_RESULT = 8)
(
    data,
    in_valid,
    clk,
    rst_n,
    result,
    out_valid
);
/*---------------------------------------------*/
//              INPUT AND OUT               //
/*---------------------------------------------*/
input [(WIDTH_DATA-1):0] data;
input in_valid, clk, rst_n;
output reg [(WIDTH_RESULT-1):0] result;
output reg out_valid;
/*---------------------------------------------*/
//             REG  DECLARATION          //
/*---------------------------------------------*/
reg [(WIDTH_DATA-1):0] data_in;
wire [(WIDTH_RESULT + 7):0] sum [(WIDTH_DATA/WIDTH_RESULT - 1) : 0];
reg [(WIDTH_RESULT + 2):0] check1 [7:0];
reg [(WIDTH_RESULT    ):0] check2 [2:0];
reg [(WIDTH_RESULT    ):0] check3 ;
reg [(WIDTH_RESULT - 1):0] check4 ;
reg [1:0]state,nextstate;
localparam IDLE=2'd0,IN=2'd1,CAL=2'd2,OUT=2'd3;
/*----------------------------------------------*/
//                IN ALGORATJM               //
/*---------------------------------------------*/
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        data_in <= 0;
    end
    else if(in_valid) begin
        data_in <= data;
    end
    else begin
        data_in <= data_in;
    end
end
/*----------------------------------------------*/
//               CAL ALGORATJM             //
/*---------------------------------------------*/
genvar i,j,k;
generate
    for(i = 0; i < (WIDTH_DATA/WIDTH_RESULT); i = i + 1) begin: LOOP1
        assign sum[i] = (i == 0) ? data_in[WIDTH_RESULT - 1:0]:sum[i-1] + data_in[((i+1)*WIDTH_RESULT - 1):(i*WIDTH_RESULT)];
    end
    for(j = 0; j < 8; j = j + 1) begin: LOOP2
        always @(*) begin
            if(!rst_n || (state == IDLE && in_valid == 1)) begin
                check1[j] = 0;
            end
            else begin
                if(j == 0) begin
                    if(WIDTH_RESULT < 8) begin
                        check1[j] = sum[(WIDTH_DATA/WIDTH_RESULT - 1)][WIDTH_RESULT - 1:0] + sum[(WIDTH_DATA/WIDTH_RESULT - 1)][2*WIDTH_RESULT - 1:WIDTH_RESULT];
                    end
                    else begin
                        check1[j] = sum[(WIDTH_DATA/WIDTH_RESULT - 1)][WIDTH_RESULT - 1:0] + sum[(WIDTH_DATA/WIDTH_RESULT - 1)][WIDTH_RESULT + 7:WIDTH_RESULT];
                    end
                end
                else begin
                    if(WIDTH_RESULT < 8) begin
                        if(j < (8/WIDTH_RESULT)) begin 
                            check1[j] = check1[j-1] + sum[(WIDTH_DATA/WIDTH_RESULT - 1)][((j + 2) * WIDTH_RESULT - 1):((j + 1)*WIDTH_RESULT)];
                        end
                        else begin
                            check1[j] = check1[j-1] ;
                        end
                    end
                    else begin
                        check1[j] = check1[j-1] ;
                    end
                end
            end
        end
    end
    for(k = 0; k < 3; k = k + 1) begin: LOOP3
        always @(*) begin
            if(!rst_n || (state == IDLE && in_valid == 1)) begin
                check2[k] = 0;
            end
            else begin
                if(k == 0) begin
                    if(WIDTH_RESULT < 4) begin
                        check2[k] = check1[7][(WIDTH_RESULT - 1):0] + check1[7][(2*WIDTH_RESULT - 1):WIDTH_RESULT];
                    end
                    else begin
                        check2[k] = check1[7][(WIDTH_RESULT - 1):0] + check1[7][(WIDTH_RESULT + 2):WIDTH_RESULT];
                    end
                    
                end
                else begin
                    if(WIDTH_RESULT < 4) begin
                        if(k < (4/WIDTH_RESULT)) begin
                            check2[k] = check2[k-1] + check1[7][(k + 1)* WIDTH_RESULT];
                        end
                        else begin
                            check2[k] = check2[k-1] ;
                        end
                    end
                    else begin
                        check2[k] = check2[k-1] ;
                    end
                end
            end
        end
    end
endgenerate
always @(*) begin
    if(!rst_n || (state == IDLE && in_valid == 1)) begin
        check3 = 0;
    end
    else begin
        if(WIDTH_RESULT < 4) begin
            check3 = check2[2][WIDTH_RESULT - 1:0] + check2[2][WIDTH_RESULT];
        end
        else begin
            check3 = check2[2];
        end
    end
end

always @(*) begin
    if(!rst_n || (state == IDLE && in_valid == 1)) begin
        check4 = 0;
    end
    else begin
        if(WIDTH_RESULT < 2) begin
            check4 = check3[WIDTH_RESULT - 1:0] + check3[WIDTH_RESULT];
        end
        else begin
            check4 = check3[WIDTH_RESULT - 1:0];
        end
    end
end
/*----------------------------------------------*/
//               OUT ALGORATJM             //
/*---------------------------------------------*/
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        result <= 0;
    end
    else if(state == OUT) begin
        result <= ~check4;
    end
    else begin
        result <= 0;
    end
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_valid <= 0;
    end
    else if(state == OUT) begin
        out_valid <= 1;
    end
    else begin
        out_valid <= 0;
    end
end

/*----------------------------------------------*/
//               FSM ALGORATJM             //
/*---------------------------------------------*/
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        state <= IDLE;
    end
    else begin
        state <= nextstate;
    end
end

always @(*) begin
    case(state)
        IDLE:begin
                if(in_valid)    nextstate = IN;
                else            nextstate = state;
             end
        IN:begin
                if(!in_valid)   nextstate = OUT;
                else            nextstate = state;
             end
//        CAL:begin
//                nextstate = OUT;
//             end
        OUT:begin
                nextstate = IDLE;
             end
        default:nextstate = IDLE;
    endcase
end
endmodule

