`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/03 19:00:24
// Design Name: 
// Module Name: SMC
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


module SMC(
  // Input signals
    mode,
    W_0, V_GS_0, V_DS_0,
    W_1, V_GS_1, V_DS_1,
    W_2, V_GS_2, V_DS_2,
    W_3, V_GS_3, V_DS_3,
    W_4, V_GS_4, V_DS_4,
    W_5, V_GS_5, V_DS_5,   
  // Output signals
    out_n
   );
//================================================================
//   INPUT AND OUTPUT DECLARATION                         
//================================================================
input [2:0] W_0, V_GS_0, V_DS_0;
input [2:0] W_1, V_GS_1, V_DS_1;
input [2:0] W_2, V_GS_2, V_DS_2;
input [2:0] W_3, V_GS_3, V_DS_3;
input [2:0] W_4, V_GS_4, V_DS_4;
input [2:0] W_5, V_GS_5, V_DS_5;
input [1:0] mode;
output wire [9:0] out_n;         							// use this if using continuous assignment for out_n  // Ex: assign out_n = XXX;

wire [7:0] ID0,ID1,ID2,ID3,ID4,ID5,gm0,gm1,gm2,gm3,gm4,gm5;
reg [7:0] array [0:5];     //[9:0] array [1:6]
wire [7:0] A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,U,V,W,X,Y,Z;

//ID/gm Calculation
Calculator C0(.vgs(V_GS_0), .vds(V_DS_0), .w(W_0), .id(ID0), .gm(gm0));
Calculator C1(.vgs(V_GS_1), .vds(V_DS_1), .w(W_1), .id(ID1), .gm(gm1));
Calculator C2(.vgs(V_GS_2), .vds(V_DS_2), .w(W_2), .id(ID2), .gm(gm2));
Calculator C3(.vgs(V_GS_3), .vds(V_DS_3), .w(W_3), .id(ID3), .gm(gm3));
Calculator C4(.vgs(V_GS_4), .vds(V_DS_4), .w(W_4), .id(ID4), .gm(gm4));
Calculator C5(.vgs(V_GS_5), .vds(V_DS_5), .w(W_5), .id(ID5), .gm(gm5));

always @(*)
begin
    if(mode == 2'b01 || mode == 2'b11)
    begin
        {array[5],array[4],array[3],array[2],array[1],array[0]} = 
        {ID0, ID1, ID2, ID3, ID4, ID5};
    end
    else
    begin
        {array[5],array[4],array[3],array[2],array[1],array[0]} = 
        {gm0, gm1, gm2, gm3, gm4, gm5};
    end
end


//大到小= U,V,W,X,Y,Z
Comparator D1(.in0(array[0]),.in1(array[1]),.out0(A),.out1(B));
Comparator D2(.in0(array[2]),.in1(array[3]),.out0(C),.out1(D));
Comparator D3(.in0(array[4]),.in1(array[5]),.out0(E),.out1(F));
Comparator D4(.in0(A),.in1(C),.out0(G),.out1(H));
Comparator D5(.in0(G),.in1(E),.out0(U),.out1(I));   //BIGGEST U , (I,H)?
Comparator D6(.in0(B),.in1(D),.out0(J),.out1(K)); 
Comparator D7(.in0(K),.in1(F),.out0(L),.out1(Z));   //SMALLEST Z , (J,L)?
Comparator D8(.in0(I),.in1(H),.out0(M),.out1(N));
Comparator D9(.in0(J),.in1(L),.out0(O),.out1(P)); 
Comparator D10(.in0(M),.in1(O),.out0(V),.out1(Q));
Comparator D11(.in0(N),.in1(P),.out0(R),.out1(Y)); 
Comparator D12(.in0(Q),.in1(R),.out0(W),.out1(X));

Maxmin M1(.mode(mode),.out_n(out_n),.n0(U),.n1(V),.n2(W),.n3(X),.n4(Y),.n5(Z));

endmodule

module Calculator(vgs, vds, w, id, gm);

input   [2:0] vgs, vds, w;
output  [7:0] id, gm;
parameter vt = 3'b001,k = 3'b011;
wire    [2:0] vgs, vds, w;
reg     [7:0] id, gm;
wire result;
assign result = ((vgs-vt) > vds)? 1:0;
always @(*) 
begin
    if(result)    //Triode
    begin
        id = w *( (3'b010 * (vgs-vt) * vds) - (vds*vds) )/k;
        gm = w * vds * 3'b010/k;
    end
    else //Saturation
    begin
        id = w * (vgs-vt) * (vgs-vt)/k;
        gm = w * (vgs-vt) * 3'b010  /k;
    end
end
endmodule


module Comparator (in0,in1,out0,out1);
input wire [7:0] in0,in1;
output reg [7:0] out0,out1;
            
always @(*)
begin
    if(in0 > in1)       // 若位子大的比較大，則往前放
    begin
        out0 = in0;
        out1 = in1;
    end
    else begin
        out0 = in1;
        out1 = in0;
    end
end
endmodule

module Maxmin(mode,out_n,n0,n1,n2,n3,n4,n5);
input [1:0] mode;
output reg [9:0] out_n;
input wire  [7:0] n0,n1,n2,n3,n4,n5;

always @(*)
begin
    case(mode)
        2'b00: //smaller gm
            out_n = n3 + n4 + n5;
        2'b01: //smaller current
            out_n = 3'b011 * n3 + 3'b100 * n4 + 3'b101* n5;
        2'b10: //larger gm
            out_n = n0 + n1+ n2;
        2'b11: //larger current
            out_n = 3'b011 * n0 + 3'b100 * n1 + 3'b101* n2;
    endcase
end

endmodule