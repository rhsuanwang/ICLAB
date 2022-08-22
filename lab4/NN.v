`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/25 01:11:18
// Design Name: 
// Module Name: NN
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


module NN(clk,rst_n,in_valid_d,in_valid_t,in_valid_w1,in_valid_w2,data_point,target,weight1,weight2,out_valid,out
         );
////--------------------PARAMETER--------------------------/////
// IEEE 754
parameter inst_sig_width = 23;
parameter inst_exp_width = 8;
parameter inst_ieee_compliance = 0;
parameter inst_arch = 2;
// LEARNING RATE
parameter lr = 32'h3A83126F; //lr = 0.001
// FSM PARAMETER
parameter IDLE = 3'd0,IN = 3'd1,FORWARD=3'd2,BACKWARD=3'd3,UPDATE=3'd4,OUT=3'd5;
//--------------------------------------------------------------------//
input clk,rst_n,in_valid_d,in_valid_t,in_valid_w1,in_valid_w2;
input [31:0] data_point,target,weight1,weight2;
output reg out_valid;
output reg [31:0] out;
reg [31:0] data[3:0],w1[2:0][3:0], w2[2:0],h1[2:0],y1[2:0],y_d[2:0],y2,delta1[2:0],delta2,t;
reg [31:0] out_temp;
reg [3:0] counter_f,counter_u;
reg [1:0] counter_b;
reg [2:0] state,nextstate;
reg [31:0] result0,result1,result2;
// Use for designware
reg [inst_sig_width+inst_exp_width:0] mult_a, mult_b, mult_c, mult_d, mult_e, mult_f, add_a, add_b, add_c, add_d, add_e, add_f,sub_a,sub_b, sub_c, sub_d, sub_e, sub_f;
wire [inst_sig_width+inst_exp_width:0] mult_out0,mult_out1,mult_out2, add_out0,add_out1,add_out2,sub_out0,sub_out1,sub_out2;
//------------------------DESIGN WARE-------------------------------//
DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) M0 (.a(mult_a), .b(mult_b), .rnd(3'b000), .z(mult_out0));
DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) M1 (.a(mult_c), .b(mult_d), .rnd(3'b000), .z(mult_out1));
DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) M2 (.a(mult_e), .b(mult_f), .rnd(3'b000), .z(mult_out2));
DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) A0 (.a(add_a), .b(add_b), .rnd(3'b000), .z(add_out0));
DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) A1 (.a(add_c), .b(add_d), .rnd(3'b000), .z(add_out1));
DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) A2 (.a(add_e), .b(add_f), .rnd(3'b000), .z(add_out2));
DW_fp_addsub #(inst_sig_width, inst_exp_width, inst_ieee_compliance) S0 (.a(sub_a), .b(sub_b),.op(1'b1), .rnd(3'b000), .z(sub_out0));
DW_fp_addsub #(inst_sig_width, inst_exp_width, inst_ieee_compliance) S1 (.a(sub_c), .b(sub_d),.op(1'b1), .rnd(3'b000), .z(sub_out1));
DW_fp_addsub #(inst_sig_width, inst_exp_width, inst_ieee_compliance) S2 (.a(sub_e), .b(sub_f),.op(1'b1), .rnd(3'b000), .z(sub_out2));
//////////////INPUT CATCH SYSTEM////////////////
/*-------------DATA------------------*/
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        data[0] <= 0;
        data[1] <= 0;
        data[2] <= 0;
        data[3] <= 0;
    end
    else if(in_valid_d == 1) begin
        data[0] <= data[1];
        data[1] <= data[2];
        data[2] <= data[3];
        data[3] <= data_point;
    end
end

/*-------------WEIGHT1------------------*/
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        w1[0][0] <= 0;  w1[0][1] <= 0;  w1[0][2] <= 0;  w1[0][3] <= 0;
        w1[1][0] <= 0;  w1[1][1] <= 0;  w1[1][2] <= 0;  w1[1][3] <= 0;
        w1[2][0] <= 0;  w1[2][1] <= 0;  w1[2][2] <= 0;  w1[2][3] <= 0;
    end
    else if(in_valid_w1 == 1) begin
        w1[0][0] <= w1[0][1];  w1[0][1] <= w1[0][2];  w1[0][2] <= w1[0][3];  w1[0][3] <= w1[1][0];
        w1[1][0] <= w1[1][1];  w1[1][1] <= w1[1][2];  w1[1][2] <= w1[1][3];  w1[1][3] <= w1[2][0];
        w1[2][0] <= w1[2][1];  w1[2][1] <= w1[2][2];  w1[2][2] <= w1[2][3];  w1[2][3] <= weight1;
    end
    else if(state == UPDATE && counter_u == 4'd2) begin
        w1[0][0] <= sub_out0;  
        w1[1][0] <= sub_out1;  
        w1[2][0] <= sub_out2;  
    end
    else if(state == UPDATE && counter_u == 4'd3) begin
        w1[0][1] <= sub_out0;  
        w1[1][1] <= sub_out1;  
        w1[2][1] <= sub_out2;  
    end
    else if(state == UPDATE && counter_u == 4'd4) begin
        w1[0][2] <= sub_out0;  
        w1[1][2] <= sub_out1;  
        w1[2][2] <= sub_out2;  
    end
    else if(state == UPDATE && counter_u == 4'd5) begin
        w1[0][3] <= sub_out0;  
        w1[1][3] <= sub_out1;  
        w1[2][3] <= sub_out2;  
    end
    else begin
        w1[0][0] <= w1[0][0];  w1[0][1] <= w1[0][1];  w1[0][2] <= w1[0][2];  w1[0][3] <= w1[0][3];
        w1[1][0] <= w1[1][0];  w1[1][1] <= w1[1][1];  w1[1][2] <= w1[1][2];  w1[1][3] <= w1[1][3];
        w1[2][0] <= w1[2][0];  w1[2][1] <= w1[2][1];  w1[2][2] <= w1[2][2];  w1[2][3] <= w1[2][3];
    end
end

/*-------------WEIGHT2------------------*/
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        w2[0] <= 0;
        w2[1] <= 0;
        w2[2] <= 0;
    end
    else if(in_valid_w2 == 1) begin
        w2[0] <= w2[1];
        w2[1] <= w2[2];
        w2[2] <= weight2;
    end
    else if(state == UPDATE && counter_u == 4'd6) begin
        w2[0] <= sub_out0;  
        w2[1] <= sub_out1;  
        w2[2] <= sub_out2;  
    end
    else begin
        w2[0] <= w2[0];  
        w2[1] <= w2[1];  
        w2[2] <= w2[2];  
    end
end
/*-------------TARGET------------------*/
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        t <= 0;
    end
    else if(in_valid_t == 1) begin
        t <= target;
    end
end

//////////////////////// FORWARD ALGORITHM /////////////////////////
/*-----------------------1ST LAYER------------------------*/
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        mult_a <= 0;
        mult_b <= 0;
        mult_c <= 0;
        mult_d <= 0;
        mult_e <= 0;
        mult_f <= 0;
    end
    else if(state == FORWARD && counter_f == 4'd0)begin // when counter_f = 1, mult_out = data[3] * w1[0,1,2][0]
        mult_a <= data[3];     mult_b <= w1[0][0];
        mult_c <= data[3];     mult_d <= w1[1][0];
        mult_e <= data[3];     mult_f <= w1[2][0];
    end
    else if(state == FORWARD && counter_f == 4'd1)begin // when counter_f = 2, mult_out = data[3] * w1[0,1,2][1]
        mult_a <= data[3];     mult_b <= w1[0][1];
        mult_c <= data[3];     mult_d <= w1[1][1];
        mult_e <= data[3];     mult_f <= w1[2][1];
    end
    else if(state == FORWARD && counter_f == 4'd2)begin // when counter_f = 3, mult_out = data[3] * w1[0,1,2][2]
        mult_a <= data[3];     mult_b <= w1[0][2];
        mult_c <= data[3];     mult_d <= w1[1][2];
        mult_e <= data[3];     mult_f <= w1[2][2];
    end
    else if(state == FORWARD && counter_f == 4'd3)begin // when counter_f = 4, mult_out = data[3] * w1[0,1,2][3]
        mult_a <= data[3];     mult_b <= w1[0][3];
        mult_c <= data[3];     mult_d <= w1[1][3];
        mult_e <= data[3];     mult_f <= w1[2][3];
    end
    else if(state == FORWARD && counter_f == 4'd6)begin // when counter_f = 7, mult_out = y1 [0,1,2] * w2[0,1,2]
        mult_a <= y1[0];       mult_b <= w2[0];
        mult_c <= y1[1];       mult_d <= w2[1];
        mult_e <= y1[2];       mult_f <= w2[2];
    end
    else if(state == FORWARD && counter_f == 4'd7)begin // when counter_f = 8, mult_out = y_d[0,1,2] * w2[0,1,2]
        mult_a <= y_d[0];      mult_b <= w2[0];
        mult_c <= y_d[1];      mult_d <= w2[1];
        mult_e <= y_d[2];      mult_f <= w2[2];
    end
    else if(state == FORWARD && counter_f == 4'd10)begin// when counter_b = 0, mult_out = delta1[0,1,2] =  y_d [0,1,2] * w2[0,1,2] * delta2 >> refresh delta1 >> when counter_b = 1 , get a new delta1
        mult_a <= mult_out0;      mult_b <= sub_out0;
        mult_c <= mult_out1;      mult_d <= sub_out0;
        mult_e <= mult_out2;      mult_f <= sub_out0;
    end
    else if(state == BACKWARD && counter_b == 2'd0)begin // when counter_b = 1, mult_out =lr * delta2 >> refresh delta2 >> when counter_u = 0 , get a new delta2
        mult_a <= lr;             mult_b <= delta2;
    end
    else if(state == BACKWARD && counter_b == 2'd1)begin // when counter_u = 0, mult_out = lr * delta1[0,1,2] >>refresh delta1 >> when counter_u = 1 , get a new delta1
        mult_a <= lr;             mult_b <= delta1[0];
        mult_c <= lr;             mult_d <= delta1[1];
        mult_e <= lr;             mult_f <= delta1[2];
    end
    else if(state == UPDATE && counter_u == 4'd0)begin   // when counter_u = 1, mult_out = data [0] * lr * delta1[0,1,2] 
        mult_a <= data[0];        mult_b <= mult_out0;
        mult_c <= data[0];        mult_d <= mult_out1;
        mult_e <= data[0];        mult_f <= mult_out2;
    end
    else if(state == UPDATE && counter_u == 4'd1)begin   // when counter_u = 2, mult_out = data [1] * lr * delta1[0,1,2] 
        mult_a <= data[1];        mult_b <= delta1[0];
        mult_c <= data[1];        mult_d <= delta1[1];
        mult_e <= data[1];        mult_f <= delta1[2];
    end
    else if(state == UPDATE && counter_u == 4'd2)begin    // when counter_u = 3, mult_out = data [2] * lr * delta1[0,1,2] 
        mult_a <= data[2];        mult_b <= delta1[0];
        mult_c <= data[2];        mult_d <= delta1[1];
        mult_e <= data[2];        mult_f <= delta1[2];
    end
    else if(state == UPDATE && counter_u == 4'd3)begin    // when counter_u = 4, mult_out = data [3] * lr * delta1[0,1,2] 
        mult_a <= data[3];        mult_b <= delta1[0];
        mult_c <= data[3];        mult_d <= delta1[1];
        mult_e <= data[3];        mult_f <= delta1[2];
    end
    else if(state == UPDATE && counter_u == 4'd4)begin    // when counter_u = 5, mult_out = y1[0,1,2] * lr * delta2
        mult_a <= y1[0];        mult_b <= delta2;
        mult_c <= y1[1];        mult_d <= delta2;
        mult_e <= y1[2];        mult_f <= delta2;
    end
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        add_a <= 0;
        add_b <= 0;
        add_c <= 0;
        add_d <= 0;
        add_e <= 0;
        add_f <= 0;
    end
    else if(state == FORWARD && counter_f == 4'd1)begin
        add_a <= 0;           add_b <= mult_out0;
        add_c <= 0;           add_d <= mult_out1;
        add_e <= 0;           add_f <= mult_out2;
    end
    else if(state == FORWARD && counter_f > 4'd1 && counter_f < 4'd5)begin
        add_a <= result0;     add_b <= mult_out0;
        add_c <= result1;     add_d <= mult_out1;
        add_e <= result2;     add_f <= mult_out2;
    end
    else if(state == FORWARD && counter_f == 4'd7) begin
        add_a <= mult_out0;   add_b <= mult_out1;
        add_c <= 0;           add_d <= mult_out2;
    end
    else if(state == FORWARD && counter_f == 4'd8) begin
        add_a <= result0;   add_b <= result1;
    end
end

//////////////////// BACKWARD ALGORITHM ////////////////////
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        sub_a <= 0;           sub_b <= 0;
        sub_c <= 0;           sub_d <= 0;
        sub_e <= 0;           sub_f <= 0;
    end
    else if(state == FORWARD && counter_f == 4'd9) begin    // when counter_f = 10, sub_out = delta2 >> refresh delta2 >> when counter_b = 0, get a new delta2 
        sub_a <= add_out0;           sub_b <= t;
        sub_c <= 0;                  sub_d <= 0;
        sub_e <= 0;                  sub_f <= 0;
    end
    else if(state == UPDATE && counter_u == 4'd1) begin     // when counter_u = 2, sub_out = w1_new[0,1,2][0]  >> refresh w1[0,1,2][0] >> when counter_u = 3, get a new w1[0,1,2][0]
        sub_a <= w1[0][0];           sub_b <= mult_out0;
        sub_c <= w1[1][0];           sub_d <= mult_out1;
        sub_e <= w1[2][0];           sub_f <= mult_out2;
    end
    else if(state == UPDATE && counter_u == 4'd2) begin     // when counter_u = 3, sub_out = w1_new[0,1,2][1]  >> refresh w1[0,1,2][1] >> when counter_u = 4, get a new w1[0,1,2][1]
        sub_a <= w1[0][1];           sub_b <= mult_out0;
        sub_c <= w1[1][1];           sub_d <= mult_out1;
        sub_e <= w1[2][1];           sub_f <= mult_out2;
    end
    else if(state == UPDATE && counter_u == 4'd3) begin     // when counter_u = 4, sub_out = w1_new[0,1,2][2]  >> refresh w1[0,1,2][2] >> when counter_u = 5, get a new w1[0,1,2][2]
        sub_a <= w1[0][2];           sub_b <= mult_out0;
        sub_c <= w1[1][2];           sub_d <= mult_out1;
        sub_e <= w1[2][2];           sub_f <= mult_out2;
    end
    else if(state == UPDATE && counter_u == 4'd4) begin     // when counter_u = 5, sub_out = w1_new[0,1,2][3]  >> refresh w1[0,1,2][3] >> when counter_u = 6, get a new w1[0,1,2][3]
        sub_a <= w1[0][3];           sub_b <= mult_out0;
        sub_c <= w1[1][3];           sub_d <= mult_out1;
        sub_e <= w1[2][3];           sub_f <= mult_out2;
    end
    else if(state == UPDATE && counter_u == 4'd5) begin     // when counter_u = 6, sub_out = w2_new[0,1,2]  >> refresh w2[0,1,2] >> when counter_u = 7, get a new w2[0,1,2]
        sub_a <= w2[0];              sub_b <= mult_out0;
        sub_c <= w2[1];              sub_d <= mult_out1;
        sub_e <= w2[2];              sub_f <= mult_out2;
    end
end

/*------------- add_out register -------------*/
always @(*)
begin
    if(!rst_n) begin
        result0 = 0;
        result1 = 0;
        result2 = 0;
    end
    else begin
        result0 = add_out0;
        result1 = add_out1;
        result2 = add_out2;
    end
end
/*---------------- [2:0] h1 register ------------------*/
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        h1[0] <= 0;
        h1[1] <= 0;
        h1[2] <= 0;
    end
    else if(state == FORWARD && counter_f == 4'd5) begin
        h1[0] <= add_out0;
        h1[1] <= add_out1;
        h1[2] <= add_out2;
    end
end
/* -------------lr * delta1 register---------------------*/
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        delta1[0] <= 0;
        delta1[1] <= 0;
        delta1[2] <= 0;
    end
    else if(state == BACKWARD && counter_b == 4'd0) begin
        delta1[0] <= mult_out0;
        delta1[1] <= mult_out1;
        delta1[2] <= mult_out2;
    end
    else if(state == UPDATE && counter_u == 4'd0) begin
        delta1[0] <= mult_out0;
        delta1[1] <= mult_out1;
        delta1[2] <= mult_out2;
    end
end

/* -------------delta2 register & lr * delta 2 reg ---------------------*/
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        delta2 <= 0;
    end
    else if(state == FORWARD && counter_f == 4'd10) begin
        delta2 <= sub_out0;
    end
    else if(state == BACKWARD && counter_b == 4'd1) begin
        delta2 <= mult_out0;
    end
end

/*---------------ReLu------------------*/
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        y1[0]  <= 32'b0_00000000_00000000000000000000000;
        y1[1]  <= 32'b0_00000000_00000000000000000000000;
        y1[2]  <= 32'b0_00000000_00000000000000000000000;
        y_d[0] <= 32'b0_00000000_00000000000000000000000;
        y_d[1] <= 32'b0_00000000_00000000000000000000000;
        y_d[2] <= 32'b0_00000000_00000000000000000000000;
    end
    else if(state == FORWARD && counter_f == 4'd5)begin
        y1[0] <= g(add_out0);
        y1[1] <= g(add_out1);
        y1[2] <= g(add_out2);
        y_d[0] <= g_d(add_out0);
        y_d[1] <= g_d(add_out1);
        y_d[2] <= g_d(add_out2);
    end
    else begin
        y1[0]  <= y1[0] ;
        y1[1]  <= y1[1] ;
        y1[2]  <= y1[2] ;
        y_d[0] <= y_d[0];
        y_d[1] <= y_d[1];
        y_d[2] <= y_d[2];
    end
end
/*-----------------ReLu Function-------------*/
function [31:0] g;
    input [31:0] h;
    begin
        if( h[31] == 0)
            g = h;
        else
            g = 0;
    end
endfunction

function [31:0] g_d;
    input [31:0] h;
    begin
        if(h[31] == 0)
            g_d = 32'b0_01111111_00000000000000000000000;
        else
            g_d = 32'b0_00000000_00000000000000000000000;
    end
endfunction

///////////////////////OUT//////////////////////////////////       
always @(posedge clk or negedge rst_n) begin 
    if(!rst_n) begin
        out_valid <= 0;
    end
    else if(state == OUT)begin
        out_valid <= 1;
    end
    else
        out_valid <= 0;
end

always @(posedge clk or negedge rst_n) begin 
    if(!rst_n) begin
        out_temp <= 0;
    end
    else if(state == FORWARD && counter_f == 4'd9)begin
        out_temp <= add_out0;
    end
    else
        out_temp <= out_temp;
end

always @(posedge clk or negedge rst_n) begin 
    if(!rst_n) begin
        out <= 0;
    end
    else if(state == OUT)begin
        out <= out_temp;
    end
    else
        out <= 0;
end
//////////////////// COUNTER ////////////////////////
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        counter_f <= 0;
    end
    else if(state == FORWARD) begin
        counter_f <= counter_f + 1;
    end
    else   
        counter_f <= 0;
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        counter_b <= 0;
    end
    else if(state == BACKWARD) begin
        counter_b <= counter_b + 1;
    end
    else
        counter_b <= 0;
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        counter_u <= 0;
    end
    else if(state == UPDATE) begin
        counter_u <= counter_u + 1;
    end
    else
        counter_u <= 0;
end
///////////////////////////////  FSM  //////////////////////////////////////
always @(posedge clk or negedge rst_n)
begin
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
                if(in_valid_w1 == 1)    nextstate = IN;
                else if(in_valid_d == 1)nextstate = FORWARD;
                else nextstate = state;
            end
        IN:begin
                if(in_valid_d == 1) nextstate = FORWARD;
                else nextstate = state;
            end
        FORWARD:begin
                if(counter_f == 4'd10)  nextstate = BACKWARD;
                else nextstate = state;
            end
        BACKWARD:begin
                if(counter_b == 2'd1) nextstate = UPDATE;
                else nextstate = state;
            end
        UPDATE:begin
                if(counter_u == 4'd7) nextstate = OUT;
                else nextstate = state;
            end
        OUT:begin
                nextstate = IDLE;
            end
        default:nextstate = IDLE;
    endcase
end

endmodule
