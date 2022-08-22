`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/18 20:18:47
// Design Name: 
// Module Name: SD
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


module SD(clk,rst_n,in,in_valid,out,out_valid
//          ,out_count,
//          out0,out1,out2,out3,out4,out5,out6,out7,out8,out9,out10,out11,out12,out13,out14,
//          disobey0 ,disobey1 ,disobey2 ,disobey3 ,disobey4 ,disobey5 ,disobey6 ,disobey7 ,disobey8 ,disobey9,
//          disobey10,disobey11,disobey12,disobey13,disobey14,disobey15,disobey16,disobey17,disobey18,disobey19,
//          disobey20,disobey21,disobey22,disobey23,disobey24,disobey25,disobey26,disobey,
//          state,next_state,
//          cs,
//          ns,
//          correct0,correct1,correct2,correct3,correct4,correct5,correct6,correct7,correct8,correct9,correct10,correct11,correct12,correct13,correct14,
//          fake0,fake1,fake2,fake3,fake4,fake5,fake6,fake7,fake8,fake9,fake10,fake11,fake12,fake13,fake14, fail, done,                                                 
//          counter,flag,count,
//          testdata,testmask,
//          row0,row1,row2,row3,row4,row5,row6,row7,row8,
//          col0,col1,col2,col3,col4,col5,col6,col7,col8,
//          blc0,blc1,blc2,blc3,blc4,blc5,blc6,blc7,blc8,
//          array0 ,array1 ,array2 ,array3 ,array4 ,array5 ,array6 ,array7 ,array8 ,array9,
//          array10,array11,array12,array13,array14,array15,array16,array17,array18,array19,
//          array20,array21,array22,array23,array24,array25,array26,array27,array28,array29,
//          array30,array31,array32,array33,array34,array35,array36,array37,array38,array39,
//          array40,array41,array42,array43,array44,array45,array46,array47,array48,array49,
//          array50,array51,array52,array53,array54,array55,array56,array57,array58,array59,
//          array60,array61,array62,array63,array64,array65,array66,array67,array68,array69,
//          array70,array71,array72,array73,array74,array75,array76,array77,array78,array79,
//          array80,
//          place0,place1,place2,place3,place4,place5,place6,place7,place8,place9,place10,place11,place12,place13,place14,
//          mask0,mask1,mask2,mask3,mask4,mask5,mask6,mask7,mask8,mask9,mask10,mask11,mask12,mask13,mask14,
//          mask0_change,mask1_change,mask2_change,mask3_change,mask4_change,mask5_change,mask6_change,mask7_change,mask8_change,mask9_change,mask10_change,mask11_change,mask12_change,mask13_change,mask14_change,     
//          life0,life1,life2,life3,life4,life5,life6,life7,life8,life9,life10,life11,life12,life13,life14
          );
input clk,rst_n;
input [3:0] in;
input in_valid;
output reg out_valid;
output reg [3:0] out;
/*output*/ reg [3:0] out_count;
/*output*/ reg [3:0] out0,out1,out2,out3,out4,out5,out6,out7,out8,out9,out10,out11,out12,out13,out14;
/*output*/ reg [4:0] state,next_state; //18 state
/*output*/ reg [1:0] cs,ns;
parameter START=2'd0,FIRST=2'd1,REFRESH=2'd2,CORRECT=2'd3;
parameter IDLE=5'd0,IN=5'd1,RCB=5'd2,MASK=5'd3,ST1=5'd4,ST2=5'd5,ST3=5'd6,ST4=5'd7,ST5=5'd8,ST6=5'd9,ST7=5'd10,ST8=5'd11,ST9=5'd12,ST10=5'd13,ST11=5'd14,ST12=5'd15,ST13=5'd16,ST14=5'd17,ST15=5'd18,SUCCESS=5'd19,FAIL=5'd20,WAIT=5'd21,FAIL2 = 5'd22,SUCCESS2=5'd23;
reg work;
reg go;
/*output*/ reg [3:0] testdata;
/*output*/ reg [9:0] testmask;
/*output*/ reg correct0,correct1,correct2,correct3,correct4,correct5,correct6,correct7,correct8,correct9,correct10,correct11,correct12,correct13,correct14;
/*output*/ reg fake0,fake1,fake2,fake3,fake4,fake5,fake6,fake7,fake8,fake9,fake10,fake11,fake12,fake13,fake14;
/*output*/ reg fail;
/*output*/ wire disobey0 ,disobey1 ,disobey2 ,disobey3 ,disobey4 ,disobey5 ,disobey6 ,disobey7 ,disobey8 ,disobey9,
            disobey10,disobey11,disobey12,disobey13,disobey14,disobey15,disobey16,disobey17,disobey18,disobey19,
            disobey20,disobey21,disobey22,disobey23,disobey24,disobey25,disobey26;
/*output */reg disobey;
/*output*/ reg [3:0] array0,array1,array2,array3,array4,array5,array6,array7,array8,array9,
          array10,array11,array12,array13,array14,array15,array16,array17,array18,array19,
          array20,array21,array22,array23,array24,array25,array26,array27,array28,array29,
          array30,array31,array32,array33,array34,array35,array36,array37,array38,array39,
          array40,array41,array42,array43,array44,array45,array46,array47,array48,array49,
          array50,array51,array52,array53,array54,array55,array56,array57,array58,array59,
          array60,array61,array62,array63,array64,array65,array66,array67,array68,array69,
          array70,array71,array72,array73,array74,array75,array76,array77,array78,array79,
          array80;
reg [3:0] array_in [80:0];
/*output*/ reg [6:0] counter;
/*output*/ reg flag,done ;
/*output*/ reg [3:0] count;
reg [6:0] place [14:0];
reg [6:0] place_t;
/*output*/ reg [6:0] place0,place1,place2,place3,place4,place5,place6,place7,place8,place9,place10,place11,place12,place13,place14;
wire [8:0] row [8:0],col[8:0],blc[8:0];
reg [9:0] mask[14:0];
wire [3:0] life [14:0];
wire [3:0] rownum0,rownum1,rownum2,rownum3,rownum4,rownum5,rownum6,rownum7,rownum8,rownum9,rownum10,rownum11,rownum12,rownum13,rownum14;
wire [3:0] colnum0,colnum1,colnum2,colnum3,colnum4,colnum5,colnum6,colnum7,colnum8,colnum9,colnum10,colnum11,colnum12,colnum13,colnum14;
wire [3:0] blcnum0,blcnum1,blcnum2,blcnum3,blcnum4,blcnum5,blcnum6,blcnum7,blcnum8,blcnum9,blcnum10,blcnum11,blcnum12,blcnum13,blcnum14;
reg use0,use1,use2,use3,use4,use5,use6,use7,use8,use9,use10,use11,use12,use13,use14; 
reg goco ;
/*output*/ reg [8:0] row0,row1,row2,row3,row4,row5,row6,row7,row8;
/*output*/ reg [8:0] col0,col1,col2,col3,col4,col5,col6,col7,col8;
/*output*/ reg [8:0] blc0,blc1,blc2,blc3,blc4,blc5,blc6,blc7,blc8;
/*output*/ wire [9:0] mask0,mask1,mask2,mask3,mask4,mask5,mask6,mask7,mask8,mask9,mask10,mask11,mask12,mask13,mask14; 
/*output*/ reg [9:0] mask0_change,mask1_change,mask2_change,mask3_change,mask4_change,mask5_change,mask6_change,mask7_change,mask8_change,mask9_change,mask10_change,mask11_change,mask12_change,mask13_change,mask14_change;    
/*output*/ wire [3:0] life0,life1,life2,life3,life4,life5,life6,life7,life8,life9,life10,life11,life12,life13,life14; 
///////////////////////////////////////////FSM////////////////////////////////////////////////////////////////
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        state <= IDLE;
    else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        IDLE:
            begin
                if(in_valid)    next_state = IN;
                else            next_state = state;
            end
        IN: 
            begin
                if(done && counter == 7'd0)        next_state = WAIT;
                else            next_state = state;
            end
        WAIT:begin
                                next_state = RCB;
            end
        RCB:begin
                if(disobey)     next_state = FAIL;
                else            next_state = MASK;
            end
        MASK:
            begin
                if(disobey)     next_state = FAIL;
                else if(work)   next_state = ST1;
                else            next_state = state;
            end
        ST1:
            begin
                if(correct0)       next_state = ST2;
                else if(fake0)   next_state = FAIL;
                else            next_state = state;
            end
        ST2: 
            begin
                if(correct1)       next_state = ST3;
                else if(fake1)   next_state = ST1;
                else            next_state = state;
            end
        ST3:
            begin
                if(correct2)       next_state = ST4;
                else if(fake2)   next_state = ST2;
                else            next_state = state;
            end
        ST4:
            begin
                if(correct3)       next_state = ST5;
                else if(fake3)   next_state = ST3;
                else            next_state = state;
            end
        ST5: 
            begin
                if(correct4)       next_state = ST6;
                else if(fake4)   next_state = ST4;
                else            next_state = state;
            end
        ST6:
            begin
                if(correct5)       next_state = ST7;
                else if(fake5)   next_state = ST5;
                else            next_state = state;
            end
        ST7:
            begin
                if(correct6)       next_state = ST8;
                else if(fake6)   next_state = ST6;
                else            next_state = state;
            end
        ST8: 
            begin
                if(correct7)       next_state = ST9;
                else if(fake7)   next_state = ST7;
                else            next_state = state;
            end
        ST9:
            begin
                if(correct8)       next_state = ST10;
                else if(fake8)   next_state = ST8;
                else            next_state = state;
            end
        ST10:
            begin
                if(correct9)       next_state = ST11;
                else if(fake9)   next_state = ST9;
                else            next_state = state;
            end
        ST11: 
            begin
                if(correct10)       next_state = ST12;
                else if(fake10)   next_state = ST10;
                else            next_state = state;
            end
        ST12:
            begin
                if(correct11)       next_state = ST13;
                else if(fake11)   next_state = ST11;
                else            next_state = state;
            end
        ST13:
            begin
                if(correct12)       next_state = ST14;
                else if(fake12)   next_state = ST12;
                else            next_state = state;
            end
        ST14: 
            begin
                if(correct13)       next_state = ST15;
                else if(fake13)   next_state = ST13;
                else            next_state = state;
            end
        ST15:
            begin
                if(correct14)       next_state = SUCCESS;
                else if(fake14)   next_state = ST14;
                else            next_state = state;
            end
        SUCCESS:
            begin
                                next_state = SUCCESS2;
            end
        SUCCESS2:
            begin
                if(out_valid == 0) 
                                next_state = IDLE;
                else            next_state = state;
            end
        FAIL: 
            begin
                                next_state = FAIL2;
            end
        FAIL2: 
            begin
                if(out_valid == 0)
                                next_state = IDLE;
                else            next_state = state;
            end
        default:next_state = state;
    endcase
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        array0 <= 0;  array10 <= 0;  array20 <= 0;  array30 <= 0;  array40 <= 0;    place0  <= 0;   mask[0 ] <= 0;     mask0_change  <= 0;    use0  <= 0;       out0  <= 0; 
        array1 <= 0;  array11 <= 0;  array21 <= 0;  array31 <= 0;  array41 <= 0;    place1  <= 0;   mask[1 ] <= 0;     mask1_change  <= 0;    use1  <= 0;       out1  <= 0;             
        array2 <= 0;  array12 <= 0;  array22 <= 0;  array32 <= 0;  array42 <= 0;    place2  <= 0;   mask[2 ] <= 0;     mask2_change  <= 0;    use2  <= 0;       out2  <= 0;             
        array3 <= 0;  array13 <= 0;  array23 <= 0;  array33 <= 0;  array43 <= 0;    place3  <= 0;   mask[3 ] <= 0;     mask3_change  <= 0;    use3  <= 0;       out3  <= 0;             
        array4 <= 0;  array14 <= 0;  array24 <= 0;  array34 <= 0;  array44 <= 0;    place4  <= 0;   mask[4 ] <= 0;     mask4_change  <= 0;    use4  <= 0;       out4  <= 0;             
        array5 <= 0;  array15 <= 0;  array25 <= 0;  array35 <= 0;  array45 <= 0;    place5  <= 0;   mask[5 ] <= 0;     mask5_change  <= 0;    use5  <= 0;       out5  <= 0;             
        array6 <= 0;  array16 <= 0;  array26 <= 0;  array36 <= 0;  array46 <= 0;    place6  <= 0;   mask[6 ] <= 0;     mask6_change  <= 0;    use6  <= 0;       out6  <= 0;                                                                  
        array7 <= 0;  array17 <= 0;  array27 <= 0;  array37 <= 0;  array47 <= 0;    place7  <= 0;   mask[7 ] <= 0;     mask7_change  <= 0;    use7  <= 0;       out7  <= 0;                                                                  
        array8 <= 0;  array18 <= 0;  array28 <= 0;  array38 <= 0;  array48 <= 0;    place8  <= 0;   mask[8 ] <= 0;     mask8_change  <= 0;    use8  <= 0;       out8  <= 0;                                                                  
        array9 <= 0;  array19 <= 0;  array29 <= 0;  array39 <= 0;  array49 <= 0;    place9  <= 0;   mask[9 ] <= 0;     mask9_change  <= 0;    use9  <= 0;       out9  <= 0;                                                                                             
                                                                                    place10 <= 0;   mask[10] <= 0;     mask10_change <= 0;    use10 <= 0;       out10 <= 0;  
        array50 <= 0;  array60 <= 0;  array70 <= 0;  array80 <= 0;                  place11 <= 0;   mask[11] <= 0;     mask11_change <= 0;    use11 <= 0;       out11 <= 0;  
        array51 <= 0;  array61 <= 0;  array71 <= 0;  work <= 0;                     place12 <= 0;   mask[12] <= 0;     mask12_change <= 0;    use12 <= 0;       out12 <= 0;  
        array52 <= 0;  array62 <= 0;  array72 <= 0;  out_valid <= 0;                place13 <= 0;   mask[13] <= 0;     mask13_change <= 0;    use13 <= 0;       out13 <= 0;  
        array53 <= 0;  array63 <= 0;  array73 <= 0;                                 place14 <= 0;   mask[14] <= 0;     mask14_change <= 0;    use14 <= 0;       out14 <= 0;  
        array54 <= 0;  array64 <= 0;  array74 <= 0;  goco  <= 0;                    testdata <= 0;  
        array55 <= 0;  array65 <= 0;  array75 <= 0;  fail <= 0;                     testmask <= 0;  fake0  <= 0;       correct0  <= 0;        
        array56 <= 0;  array66 <= 0;  array76 <= 0;  disobey <= 0;                                  fake1  <= 0;       correct1  <= 0;        
        array57 <= 0;  array67 <= 0;  array77 <= 0;  go <= 0;                                       fake2  <= 0;       correct2  <= 0;        
        array58 <= 0;  array68 <= 0;  array78 <= 0;  done <= 0;                                     fake3  <= 0;       correct3  <= 0;        
        array59 <= 0;  array69 <= 0;  array79 <= 0;                                                 fake4  <= 0;       correct4  <= 0;        
                                                                                                    fake5  <= 0;       correct5  <= 0;        
        row0 <= 10'd1023;  col0 <= 10'd1023;    blc0 <= 10'd1023;                                   fake6  <= 0;       correct6  <= 0;        
        row1 <= 10'd1023;  col1 <= 10'd1023;    blc1 <= 10'd1023;                                   fake7  <= 0;       correct7  <= 0;        
        row2 <= 10'd1023;  col2 <= 10'd1023;    blc2 <= 10'd1023;                                   fake8  <= 0;       correct8  <= 0;        
        row3 <= 10'd1023;  col3 <= 10'd1023;    blc3 <= 10'd1023;                                   fake9  <= 0;       correct9  <= 0;        
        row4 <= 10'd1023;  col4 <= 10'd1023;    blc4 <= 10'd1023;                                   fake10 <= 0;       correct10 <= 0;        
        row5 <= 10'd1023;  col5 <= 10'd1023;    blc5 <= 10'd1023;                                   fake11 <= 0;       correct11 <= 0;        
        row6 <= 10'd1023;  col6 <= 10'd1023;    blc6 <= 10'd1023;                                   fake12 <= 0;       correct12 <= 0;        
        row7 <= 10'd1023;  col7 <= 10'd1023;    blc7 <= 10'd1023;                                   fake13 <= 0;       correct13 <= 0;        
        row8 <= 10'd1023;  col8 <= 10'd1023;    blc8 <= 10'd1023;                                   fake14 <= 0;       correct14 <= 0;        
        
    end
    else begin
        case(state)
            IDLE:begin
                    array0 <= 0;  array10 <= 0;  array20 <= 0;  array30 <= 0;  array40 <= 0;    place0  <= 0;   mask[0 ] <= 0;     mask0_change  <= 0;    use0  <= 0;       out0  <= 0;                        
                    array1 <= 0;  array11 <= 0;  array21 <= 0;  array31 <= 0;  array41 <= 0;    place1  <= 0;   mask[1 ] <= 0;     mask1_change  <= 0;    use1  <= 0;       out1  <= 0;                        
                    array2 <= 0;  array12 <= 0;  array22 <= 0;  array32 <= 0;  array42 <= 0;    place2  <= 0;   mask[2 ] <= 0;     mask2_change  <= 0;    use2  <= 0;       out2  <= 0;                        
                    array3 <= 0;  array13 <= 0;  array23 <= 0;  array33 <= 0;  array43 <= 0;    place3  <= 0;   mask[3 ] <= 0;     mask3_change  <= 0;    use3  <= 0;       out3  <= 0;                        
                    array4 <= 0;  array14 <= 0;  array24 <= 0;  array34 <= 0;  array44 <= 0;    place4  <= 0;   mask[4 ] <= 0;     mask4_change  <= 0;    use4  <= 0;       out4  <= 0;                        
                    array5 <= 0;  array15 <= 0;  array25 <= 0;  array35 <= 0;  array45 <= 0;    place5  <= 0;   mask[5 ] <= 0;     mask5_change  <= 0;    use5  <= 0;       out5  <= 0;                        
                    array6 <= 0;  array16 <= 0;  array26 <= 0;  array36 <= 0;  array46 <= 0;    place6  <= 0;   mask[6 ] <= 0;     mask6_change  <= 0;    use6  <= 0;       out6  <= 0;                        
                    array7 <= 0;  array17 <= 0;  array27 <= 0;  array37 <= 0;  array47 <= 0;    place7  <= 0;   mask[7 ] <= 0;     mask7_change  <= 0;    use7  <= 0;       out7  <= 0;                        
                    array8 <= 0;  array18 <= 0;  array28 <= 0;  array38 <= 0;  array48 <= 0;    place8  <= 0;   mask[8 ] <= 0;     mask8_change  <= 0;    use8  <= 0;       out8  <= 0;                        
                    array9 <= 0;  array19 <= 0;  array29 <= 0;  array39 <= 0;  array49 <= 0;    place9  <= 0;   mask[9 ] <= 0;     mask9_change  <= 0;    use9  <= 0;       out9  <= 0;                        
                                                                                                place10 <= 0;   mask[10] <= 0;     mask10_change <= 0;    use10 <= 0;       out10 <= 0;                        
                    array50 <= 0;  array60 <= 0;  array70 <= 0;  array80 <= 0;                  place11 <= 0;   mask[11] <= 0;     mask11_change <= 0;    use11 <= 0;       out11 <= 0;                        
                    array51 <= 0;  array61 <= 0;  array71 <= 0;  work <= 0;                     place12 <= 0;   mask[12] <= 0;     mask12_change <= 0;    use12 <= 0;       out12 <= 0;                        
                    array52 <= 0;  array62 <= 0;  array72 <= 0;  out_valid <= 0;                place13 <= 0;   mask[13] <= 0;     mask13_change <= 0;    use13 <= 0;       out13 <= 0;                        
                    array53 <= 0;  array63 <= 0;  array73 <= 0;                                 place14 <= 0;   mask[14] <= 0;     mask14_change <= 0;    use14 <= 0;       out14 <= 0;                        
                    array54 <= 0;  array64 <= 0;  array74 <= 0;                                 testdata <= 0;                                                                                    
                    array55 <= 0;  array65 <= 0;  array75 <= 0;  fail <= 0;                     testmask <= 0;  fake0  <= 0;       correct0  <= 0;                                                            
                    array56 <= 0;  array66 <= 0;  array76 <= 0;  disobey <= 0;                                  fake1  <= 0;       correct1  <= 0;                                                            
                    array57 <= 0;  array67 <= 0;  array77 <= 0;  go <= 0;                                       fake2  <= 0;       correct2  <= 0;                                                            
                    array58 <= 0;  array68 <= 0;  array78 <= 0;  done <= 0;                                     fake3  <= 0;       correct3  <= 0;                                                            
                    array59 <= 0;  array69 <= 0;  array79 <= 0;  goco  <= 0;                                    fake4  <= 0;       correct4  <= 0;                                                            
                                                                                                                fake5  <= 0;       correct5  <= 0;                                                            
                    row0 <= 10'd1023;  col0 <= 10'd1023;    blc0 <= 10'd1023;                                   fake6  <= 0;       correct6  <= 0;                                                            
                    row1 <= 10'd1023;  col1 <= 10'd1023;    blc1 <= 10'd1023;                                   fake7  <= 0;       correct7  <= 0;                                                            
                    row2 <= 10'd1023;  col2 <= 10'd1023;    blc2 <= 10'd1023;                                   fake8  <= 0;       correct8  <= 0;                                                            
                    row3 <= 10'd1023;  col3 <= 10'd1023;    blc3 <= 10'd1023;                                   fake9  <= 0;       correct9  <= 0;                                                            
                    row4 <= 10'd1023;  col4 <= 10'd1023;    blc4 <= 10'd1023;                                   fake10 <= 0;       correct10 <= 0;                                                            
                    row5 <= 10'd1023;  col5 <= 10'd1023;    blc5 <= 10'd1023;                                   fake11 <= 0;       correct11 <= 0;                                                            
                    row6 <= 10'd1023;  col6 <= 10'd1023;    blc6 <= 10'd1023;                                   fake12 <= 0;       correct12 <= 0;                                                            
                    row7 <= 10'd1023;  col7 <= 10'd1023;    blc7 <= 10'd1023;                                   fake13 <= 0;       correct13 <= 0;                                                            
                    row8 <= 10'd1023;  col8 <= 10'd1023;    blc8 <= 10'd1023;                                   fake14 <= 0;       correct14 <= 0;                                                            
                                                                                                                                                                                           
                end
            IN: begin
                    if(count > 4'd14)  done <= 1;
                    else 
                    array0 <= array_in[0];  array10 <= array_in[10];  array20 <= array_in[20];  array30 <= array_in[30];  array40 <= array_in[40];
                    array1 <= array_in[1];  array11 <= array_in[11];  array21 <= array_in[21];  array31 <= array_in[31];  array41 <= array_in[41];
                    array2 <= array_in[2];  array12 <= array_in[12];  array22 <= array_in[22];  array32 <= array_in[32];  array42 <= array_in[42];
                    array3 <= array_in[3];  array13 <= array_in[13];  array23 <= array_in[23];  array33 <= array_in[33];  array43 <= array_in[43];
                    array4 <= array_in[4];  array14 <= array_in[14];  array24 <= array_in[24];  array34 <= array_in[34];  array44 <= array_in[44];
                    array5 <= array_in[5];  array15 <= array_in[15];  array25 <= array_in[25];  array35 <= array_in[35];  array45 <= array_in[45];
                    array6 <= array_in[6];  array16 <= array_in[16];  array26 <= array_in[26];  array36 <= array_in[36];  array46 <= array_in[46];
                    array7 <= array_in[7];  array17 <= array_in[17];  array27 <= array_in[27];  array37 <= array_in[37];  array47 <= array_in[47];
                    array8 <= array_in[8];  array18 <= array_in[18];  array28 <= array_in[28];  array38 <= array_in[38];  array48 <= array_in[48];
                    array9 <= array_in[9];  array19 <= array_in[19];  array29 <= array_in[29];  array39 <= array_in[39];  array49 <= array_in[49];
                    
                    array50 <= array_in[50];  array60 <= array_in[60];  array70 <= array_in[70];  array80 <= array_in[80]; 
                    array51 <= array_in[51];  array61 <= array_in[61];  array71 <= array_in[71];  
                    array52 <= array_in[52];  array62 <= array_in[62];  array72 <= array_in[72];  
                    array53 <= array_in[53];  array63 <= array_in[63];  array73 <= array_in[73];  
                    array54 <= array_in[54];  array64 <= array_in[64];  array74 <= array_in[74];  
                    array55 <= array_in[55];  array65 <= array_in[65];  array75 <= array_in[75];  
                    array56 <= array_in[56];  array66 <= array_in[66];  array76 <= array_in[76];  
                    array57 <= array_in[57];  array67 <= array_in[67];  array77 <= array_in[77];  
                    array58 <= array_in[58];  array68 <= array_in[68];  array78 <= array_in[78];  
                    array59 <= array_in[59];  array69 <= array_in[69];  array79 <= array_in[79];  
                    
                    place0  <= place[0 ];   place7  <= place[7 ]; 
                    place1  <= place[1 ];   place8  <= place[8 ]; 
                    place2  <= place[2 ];   place9  <= place[9 ]; 
                    place3  <= place[3 ];   place10 <= place[10]; 
                    place4  <= place[4 ];   place11 <= place[11]; 
                    place5  <= place[5 ];   place12 <= place[12]; 
                    place6  <= place[6 ];   place13 <= place[13]; 
                                            place14 <= place[14]; 
                end
            RCB:begin
                    done <= 0;
                    row0 <= row[0];  col0 <= col[0];   blc0  <= blc[0];      
                    row1 <= row[1];  col1 <= col[1];   blc1  <= blc[1];      
                    row2 <= row[2];  col2 <= col[2];   blc2  <= blc[2];      
                    row3 <= row[3];  col3 <= col[3];   blc3  <= blc[3];      
                    row4 <= row[4];  col4 <= col[4];   blc4  <= blc[4];      
                    row5 <= row[5];  col5 <= col[5];   blc5  <= blc[5];      
                    row6 <= row[6];  col6 <= col[6];   blc6  <= blc[6];      
                    row7 <= row[7];  col7 <= col[7];   blc7  <= blc[7];      
                    row8 <= row[8];  col8 <= col[8];   blc8  <= blc[8];  
                    if(disobey0 ==1 ||disobey1==1 || disobey2==1 || disobey3==1 || disobey4==1 || disobey5==1 ||  disobey6==1 ||  disobey7==1 ||  disobey8==1 ||  
                       disobey9==1 ||   disobey10==1 ||   disobey11==1 ||   disobey12==1 ||   disobey13==1 ||   disobey14==1 ||   disobey15==1 ||   disobey16==1 ||   disobey17==1 ||   
                       disobey18==1 ||   disobey19==1 ||   disobey20==1 ||   disobey21==1 ||   disobey22==1 ||   disobey23==1 ||   disobey24==1 ||   disobey25==1 ||   disobey26==1)  
                       disobey <= 1;
                end
            MASK:
                begin
                    if(life0 == 0 || life1 == 0 || life2 == 0 || life3 == 0 || life4 == 0 || life5 == 0 || life6 == 0 || life7 == 0 || life8 == 0 || life9 == 0 || life10 == 0 || life11 == 0 || life12 == 0 || life13 == 0 || life14 == 0)        
                        disobey <= 1;
                    else begin    
                        mask[0 ]  <= mask0;   mask[9 ] <= mask9 ;   mask0_change  <= mask0 ;   mask9_change  <= mask9 ; 
                        mask[1 ]  <= mask1;   mask[10] <= mask10;   mask1_change  <= mask1 ;   mask10_change <= mask10; 
                        mask[2 ]  <= mask2;   mask[11] <= mask11;   mask2_change  <= mask2 ;   mask11_change <= mask11; 
                        mask[3 ]  <= mask3;   mask[12] <= mask12;   mask3_change  <= mask3 ;   mask12_change <= mask12; 
                        mask[4 ]  <= mask4;   mask[13] <= mask13;   mask4_change  <= mask4 ;   mask13_change <= mask13; 
                        mask[5 ]  <= mask5;   mask[14] <= mask14;   mask5_change  <= mask5 ;   mask14_change <= mask14; 
                        mask[6 ]  <= mask6;                         mask6_change  <= mask6 ;                       
                        mask[7 ]  <= mask7;                         mask7_change  <= mask7 ;                       
                        mask[8 ]  <= mask8;                         mask8_change  <= mask8 ;                       
                        work <= 1;
                    end             
                end                                                         
            ST1:begin
                go <= 1;   work <= 0;
                    case(cs)
                    START:begin
                                fail <= 0; correct0 <= 0; fake0 <= 0; fake1 <= 0;   use1 <= 0;
                                if(use0) begin  //找更改過的
                                    testdata <= out0;
                                    testmask <= mask0_change;
                                end
                                else begin          //沒更動過的
                                    testdata <= first(mask[0]);
                                    testmask <= mask[0];
                                end
                          end
                    FIRST:begin
                                correct0 <= 0;
                                fail <= 0;
                                testdata <= first(testmask);
                                testmask <= newmask(testdata,testmask);
                                use0 <= 1;
                                row0 <= backrcb(rownum0,0,testdata,row0);    col0 <= backrcb(colnum0,0,testdata,col0);    blc0 <= backrcb(blcnum0,0,testdata,blc0);
                                row1 <= backrcb(rownum0,1,testdata,row1);    col1 <= backrcb(colnum0,1,testdata,col1);    blc1 <= backrcb(blcnum0,1,testdata,blc1);
                                row2 <= backrcb(rownum0,2,testdata,row2);    col2 <= backrcb(colnum0,2,testdata,col2);    blc2 <= backrcb(blcnum0,2,testdata,blc2);
                                row3 <= backrcb(rownum0,3,testdata,row3);    col3 <= backrcb(colnum0,3,testdata,col3);    blc3 <= backrcb(blcnum0,3,testdata,blc3);
                                row4 <= backrcb(rownum0,4,testdata,row4);    col4 <= backrcb(colnum0,4,testdata,col4);    blc4 <= backrcb(blcnum0,4,testdata,blc4);
                                row5 <= backrcb(rownum0,5,testdata,row5);    col5 <= backrcb(colnum0,5,testdata,col5);    blc5 <= backrcb(blcnum0,5,testdata,blc5);
                                row6 <= backrcb(rownum0,6,testdata,row6);    col6 <= backrcb(colnum0,6,testdata,col6);    blc6 <= backrcb(blcnum0,6,testdata,blc6);
                                row7 <= backrcb(rownum0,7,testdata,row7);    col7 <= backrcb(colnum0,7,testdata,col7);    blc7 <= backrcb(blcnum0,7,testdata,blc7);
                                row8 <= backrcb(rownum0,8,testdata,row8);    col8 <= backrcb(colnum0,8,testdata,col8);    blc8 <= backrcb(blcnum0,8,testdata,blc8);
                          end
                    REFRESH:begin
                                if(testdata == 4'd10)   //FSM1返回上一個STATE
                                begin   
                                    fake0 <= 1; use0 <= 0; 
                                end
                                else begin
                                    fake0 <= 0; goco <= 1;
                                    row0 <= newrcb(rownum0,0,testdata,row0);    col0 <= newrcb(colnum0,0,testdata,col0);    blc0 <= newrcb(blcnum0,0,testdata,blc0);
                                    row1 <= newrcb(rownum0,1,testdata,row1);    col1 <= newrcb(colnum0,1,testdata,col1);    blc1 <= newrcb(blcnum0,1,testdata,blc1);
                                    row2 <= newrcb(rownum0,2,testdata,row2);    col2 <= newrcb(colnum0,2,testdata,col2);    blc2 <= newrcb(blcnum0,2,testdata,blc2);
                                    row3 <= newrcb(rownum0,3,testdata,row3);    col3 <= newrcb(colnum0,3,testdata,col3);    blc3 <= newrcb(blcnum0,3,testdata,blc3);
                                    row4 <= newrcb(rownum0,4,testdata,row4);    col4 <= newrcb(colnum0,4,testdata,col4);    blc4 <= newrcb(blcnum0,4,testdata,blc4);
                                    row5 <= newrcb(rownum0,5,testdata,row5);    col5 <= newrcb(colnum0,5,testdata,col5);    blc5 <= newrcb(blcnum0,5,testdata,blc5);
                                    row6 <= newrcb(rownum0,6,testdata,row6);    col6 <= newrcb(colnum0,6,testdata,col6);    blc6 <= newrcb(blcnum0,6,testdata,blc6);
                                    row7 <= newrcb(rownum0,7,testdata,row7);    col7 <= newrcb(colnum0,7,testdata,col7);    blc7 <= newrcb(blcnum0,7,testdata,blc7);
                                    row8 <= newrcb(rownum0,8,testdata,row8);    col8 <= newrcb(colnum0,8,testdata,col8);    blc8 <= newrcb(blcnum0,8,testdata,blc8);
                                end
                          end
                    CORRECT:begin
                                goco <= 0;
                                if(life1 == 0 || life2 == 0 || life3 == 0 || life4 == 0 || life5 == 0 || life6 == 0 || life7 == 0 || life8 == 0 || life9 == 0 || life10 == 0 || life11 == 0 || life12 == 0 || life13 == 0 || life14 == 0)
                                begin    
                                    fail <= 1;
                                    correct0 <= 0;
                                    mask0_change <= testmask;
                                    
                                end
                                else begin
                                    fail <= 0;
                                    correct0 <= 1;
                                    mask0_change <= testmask;
                                    out0 <= testdata;
                                    mask[1] <= mask1;
                                end
                            end
                endcase
                end
            ST2:begin
                case(cs)
                    START:begin
                                fail <= 0; correct1 <= 0; fake1 <= 0;   correct0 <= 0; fake2 <= 0;  use2 <= 0;
                                if(use1) begin  //找更改過的(後面的往前找下一個可能性的時候會需要用到)
                                    testdata <= out1;
                                    testmask <= mask1_change;
                                end
                                else begin          //沒更動過的
                                    testdata <= first(mask[1]);
                                    testmask <= mask[1];
                                end
                          end
                    FIRST:begin
                                correct1 <= 0;
                                fail <= 0;
                                testdata <= first(testmask);
                                testmask <= newmask(testdata,testmask);
                                use1 <= 1;
                                row0 <= backrcb(rownum1,0,testdata,row0);    col0 <= backrcb(colnum1,0,testdata,col0);    blc0 <= backrcb(blcnum1,0,testdata,blc0);
                                row1 <= backrcb(rownum1,1,testdata,row1);    col1 <= backrcb(colnum1,1,testdata,col1);    blc1 <= backrcb(blcnum1,1,testdata,blc1);
                                row2 <= backrcb(rownum1,2,testdata,row2);    col2 <= backrcb(colnum1,2,testdata,col2);    blc2 <= backrcb(blcnum1,2,testdata,blc2);
                                row3 <= backrcb(rownum1,3,testdata,row3);    col3 <= backrcb(colnum1,3,testdata,col3);    blc3 <= backrcb(blcnum1,3,testdata,blc3);
                                row4 <= backrcb(rownum1,4,testdata,row4);    col4 <= backrcb(colnum1,4,testdata,col4);    blc4 <= backrcb(blcnum1,4,testdata,blc4);
                                row5 <= backrcb(rownum1,5,testdata,row5);    col5 <= backrcb(colnum1,5,testdata,col5);    blc5 <= backrcb(blcnum1,5,testdata,blc5);
                                row6 <= backrcb(rownum1,6,testdata,row6);    col6 <= backrcb(colnum1,6,testdata,col6);    blc6 <= backrcb(blcnum1,6,testdata,blc6);
                                row7 <= backrcb(rownum1,7,testdata,row7);    col7 <= backrcb(colnum1,7,testdata,col7);    blc7 <= backrcb(blcnum1,7,testdata,blc7);
                                row8 <= backrcb(rownum1,8,testdata,row8);    col8 <= backrcb(colnum1,8,testdata,col8);    blc8 <= backrcb(blcnum1,8,testdata,blc8);
                          end
                    REFRESH:begin
                                if(testdata == 4'd10)   //FSM1返回上一個STATE
                                begin   
                                    fake1 <= 1; use1 <= 0; 
                                end
                                else begin
                                    fake1 <= 0; goco <= 1;
                                    row0 <= newrcb(rownum1,0,testdata,row0);    col0 <= newrcb(colnum1,0,testdata,col0);    blc0 <= newrcb(blcnum1,0,testdata,blc0);
                                    row1 <= newrcb(rownum1,1,testdata,row1);    col1 <= newrcb(colnum1,1,testdata,col1);    blc1 <= newrcb(blcnum1,1,testdata,blc1);
                                    row2 <= newrcb(rownum1,2,testdata,row2);    col2 <= newrcb(colnum1,2,testdata,col2);    blc2 <= newrcb(blcnum1,2,testdata,blc2);
                                    row3 <= newrcb(rownum1,3,testdata,row3);    col3 <= newrcb(colnum1,3,testdata,col3);    blc3 <= newrcb(blcnum1,3,testdata,blc3);
                                    row4 <= newrcb(rownum1,4,testdata,row4);    col4 <= newrcb(colnum1,4,testdata,col4);    blc4 <= newrcb(blcnum1,4,testdata,blc4);
                                    row5 <= newrcb(rownum1,5,testdata,row5);    col5 <= newrcb(colnum1,5,testdata,col5);    blc5 <= newrcb(blcnum1,5,testdata,blc5);
                                    row6 <= newrcb(rownum1,6,testdata,row6);    col6 <= newrcb(colnum1,6,testdata,col6);    blc6 <= newrcb(blcnum1,6,testdata,blc6);
                                    row7 <= newrcb(rownum1,7,testdata,row7);    col7 <= newrcb(colnum1,7,testdata,col7);    blc7 <= newrcb(blcnum1,7,testdata,blc7);
                                    row8 <= newrcb(rownum1,8,testdata,row8);    col8 <= newrcb(colnum1,8,testdata,col8);    blc8 <= newrcb(blcnum1,8,testdata,blc8);
                                end
                          end
                    CORRECT:begin
                                goco <= 0;
                                if(life2 == 0 || life3 == 0 || life4 == 0 || life5 == 0 || life6 == 0 || life7 == 0 || life8 == 0 || life9 == 0 || life10 == 0 || life11 == 0 || life12 == 0 || life13 == 0 || life14 == 0)
                                begin    
                                    fail <= 1;
                                    correct1 <= 0;
                                    mask1_change <= testmask;
                                    
                                end
                                else begin
                                    fail <= 0;
                                    correct1 <= 1;
                                    mask1_change <= testmask;
                                    out1 <= testdata;
                                    mask[2] <= mask2;
                                end
                            end
                endcase
                end
            ST3:begin
                case(cs)
                    START:begin
                                fail <= 0; correct2 <= 0; fake2 <= 0; correct1 <= 0;    fake3 <= 0; use3 <= 0;
                                if(use2) begin  //找更改過的
                                    testdata <= out2;
                                    testmask <= mask2_change;
                                end
                                else begin          //沒更動過的
                                    testdata <= first(mask[2]);
                                    testmask <= mask[2];
                                end
                          end
                    FIRST:begin
                                correct2 <= 0;
                                fail <= 0;
                                testdata <= first(testmask);
                                testmask <= newmask(testdata,testmask);
                                use2 <= 1;
                                row0 <= backrcb(rownum2,0,testdata,row0);    col0 <= backrcb(colnum2,0,testdata,col0);    blc0 <= backrcb(blcnum2,0,testdata,blc0);
                                    row1 <= backrcb(rownum2,1,testdata,row1);    col1 <= backrcb(colnum2,1,testdata,col1);    blc1 <= backrcb(blcnum2,1,testdata,blc1);
                                    row2 <= backrcb(rownum2,2,testdata,row2);    col2 <= backrcb(colnum2,2,testdata,col2);    blc2 <= backrcb(blcnum2,2,testdata,blc2);
                                    row3 <= backrcb(rownum2,3,testdata,row3);    col3 <= backrcb(colnum2,3,testdata,col3);    blc3 <= backrcb(blcnum2,3,testdata,blc3);
                                    row4 <= backrcb(rownum2,4,testdata,row4);    col4 <= backrcb(colnum2,4,testdata,col4);    blc4 <= backrcb(blcnum2,4,testdata,blc4);
                                    row5 <= backrcb(rownum2,5,testdata,row5);    col5 <= backrcb(colnum2,5,testdata,col5);    blc5 <= backrcb(blcnum2,5,testdata,blc5);
                                    row6 <= backrcb(rownum2,6,testdata,row6);    col6 <= backrcb(colnum2,6,testdata,col6);    blc6 <= backrcb(blcnum2,6,testdata,blc6);
                                    row7 <= backrcb(rownum2,7,testdata,row7);    col7 <= backrcb(colnum2,7,testdata,col7);    blc7 <= backrcb(blcnum2,7,testdata,blc7);
                                    row8 <= backrcb(rownum2,8,testdata,row8);    col8 <= backrcb(colnum2,8,testdata,col8);    blc8 <= backrcb(blcnum2,8,testdata,blc8);
                          end
                    REFRESH:begin
                                if(testdata == 4'd10)   //FSM1返回上一個STATE
                                begin   
                                    fake2 <= 1; use2 <= 0; 
                                end
                                else begin
                                    fake2 <= 0; goco <= 1;
                                    row0 <= newrcb(rownum2,0,testdata,row0);    col0 <= newrcb(colnum2,0,testdata,col0);    blc0 <= newrcb(blcnum2,0,testdata,blc0);
                                    row1 <= newrcb(rownum2,1,testdata,row1);    col1 <= newrcb(colnum2,1,testdata,col1);    blc1 <= newrcb(blcnum2,1,testdata,blc1);
                                    row2 <= newrcb(rownum2,2,testdata,row2);    col2 <= newrcb(colnum2,2,testdata,col2);    blc2 <= newrcb(blcnum2,2,testdata,blc2);
                                    row3 <= newrcb(rownum2,3,testdata,row3);    col3 <= newrcb(colnum2,3,testdata,col3);    blc3 <= newrcb(blcnum2,3,testdata,blc3);
                                    row4 <= newrcb(rownum2,4,testdata,row4);    col4 <= newrcb(colnum2,4,testdata,col4);    blc4 <= newrcb(blcnum2,4,testdata,blc4);
                                    row5 <= newrcb(rownum2,5,testdata,row5);    col5 <= newrcb(colnum2,5,testdata,col5);    blc5 <= newrcb(blcnum2,5,testdata,blc5);
                                    row6 <= newrcb(rownum2,6,testdata,row6);    col6 <= newrcb(colnum2,6,testdata,col6);    blc6 <= newrcb(blcnum2,6,testdata,blc6);
                                    row7 <= newrcb(rownum2,7,testdata,row7);    col7 <= newrcb(colnum2,7,testdata,col7);    blc7 <= newrcb(blcnum2,7,testdata,blc7);
                                    row8 <= newrcb(rownum2,8,testdata,row8);    col8 <= newrcb(colnum2,8,testdata,col8);    blc8 <= newrcb(blcnum2,8,testdata,blc8);
                                end
                          end
                    CORRECT:begin
                                goco <= 0;
                                if(life3 == 0 || life4 == 0 || life5 == 0 || life6 == 0 || life7 == 0 || life8 == 0 || life9 == 0 || life10 == 0 || life11 == 0 || life12 == 0 || life13 == 0 || life14 == 0)
                                begin    
                                    fail <= 1;
                                    correct2 <= 0;
                                    mask2_change <= testmask;
                                    
                                end
                                else begin
                                    fail <= 0;
                                    correct2 <= 1;
                                    mask2_change <= testmask;
                                    out2 <= testdata;
                                    mask[3] <= mask3;
                                end
                            end
                endcase
                end
            ST4:begin
                case(cs)
                    START:begin
                                fail <= 0; correct3 <= 0; fake3 <= 0; correct2 <= 0; fake4 <= 0;    use4 <= 0;
                                if(use3) begin  //找更改過的
                                    testdata <= out3;
                                    testmask <= mask3_change;
                                end
                                else begin          //沒更動過的
                                    testdata <= first(mask[3]);
                                    testmask <= mask[3];
                                end
                          end
                    FIRST:begin
                                correct3 <= 0;
                                fail <= 0;
                                testdata <= first(testmask);
                                testmask <= newmask(testdata,testmask);
                                use3 <= 1;
                                row0 <= backrcb(rownum3,0,testdata,row0);    col0 <= backrcb(colnum3,0,testdata,col0);    blc0 <= backrcb(blcnum3,0,testdata,blc0);
                                    row1 <= backrcb(rownum3,1,testdata,row1);    col1 <= backrcb(colnum3,1,testdata,col1);    blc1 <= backrcb(blcnum3,1,testdata,blc1);
                                    row2 <= backrcb(rownum3,2,testdata,row2);    col2 <= backrcb(colnum3,2,testdata,col2);    blc2 <= backrcb(blcnum3,2,testdata,blc2);
                                    row3 <= backrcb(rownum3,3,testdata,row3);    col3 <= backrcb(colnum3,3,testdata,col3);    blc3 <= backrcb(blcnum3,3,testdata,blc3);
                                    row4 <= backrcb(rownum3,4,testdata,row4);    col4 <= backrcb(colnum3,4,testdata,col4);    blc4 <= backrcb(blcnum3,4,testdata,blc4);
                                    row5 <= backrcb(rownum3,5,testdata,row5);    col5 <= backrcb(colnum3,5,testdata,col5);    blc5 <= backrcb(blcnum3,5,testdata,blc5);
                                    row6 <= backrcb(rownum3,6,testdata,row6);    col6 <= backrcb(colnum3,6,testdata,col6);    blc6 <= backrcb(blcnum3,6,testdata,blc6);
                                    row7 <= backrcb(rownum3,7,testdata,row7);    col7 <= backrcb(colnum3,7,testdata,col7);    blc7 <= backrcb(blcnum3,7,testdata,blc7);
                                    row8 <= backrcb(rownum3,8,testdata,row8);    col8 <= backrcb(colnum3,8,testdata,col8);    blc8 <= backrcb(blcnum3,8,testdata,blc8);
                          end
                    REFRESH:begin
                                if(testdata == 4'd10)   //FSM1返回上一個STATE
                                begin   
                                    fake3 <= 1; use3 <= 0; 
                                end
                                else begin
                                    fake3 <= 0; goco <= 1;
                                    row0 <= newrcb(rownum3,0,testdata,row0);    col0 <= newrcb(colnum3,0,testdata,col0);    blc0 <= newrcb(blcnum3,0,testdata,blc0);
                                    row1 <= newrcb(rownum3,1,testdata,row1);    col1 <= newrcb(colnum3,1,testdata,col1);    blc1 <= newrcb(blcnum3,1,testdata,blc1);
                                    row2 <= newrcb(rownum3,2,testdata,row2);    col2 <= newrcb(colnum3,2,testdata,col2);    blc2 <= newrcb(blcnum3,2,testdata,blc2);
                                    row3 <= newrcb(rownum3,3,testdata,row3);    col3 <= newrcb(colnum3,3,testdata,col3);    blc3 <= newrcb(blcnum3,3,testdata,blc3);
                                    row4 <= newrcb(rownum3,4,testdata,row4);    col4 <= newrcb(colnum3,4,testdata,col4);    blc4 <= newrcb(blcnum3,4,testdata,blc4);
                                    row5 <= newrcb(rownum3,5,testdata,row5);    col5 <= newrcb(colnum3,5,testdata,col5);    blc5 <= newrcb(blcnum3,5,testdata,blc5);
                                    row6 <= newrcb(rownum3,6,testdata,row6);    col6 <= newrcb(colnum3,6,testdata,col6);    blc6 <= newrcb(blcnum3,6,testdata,blc6);
                                    row7 <= newrcb(rownum3,7,testdata,row7);    col7 <= newrcb(colnum3,7,testdata,col7);    blc7 <= newrcb(blcnum3,7,testdata,blc7);
                                    row8 <= newrcb(rownum3,8,testdata,row8);    col8 <= newrcb(colnum3,8,testdata,col8);    blc8 <= newrcb(blcnum3,8,testdata,blc8);
                                end
                          end
                    CORRECT:begin
                                goco <= 0;
                                if(life4 == 0 || life5 == 0 || life6 == 0 || life7 == 0 || life8 == 0 || life9 == 0 || life10 == 0 || life11 == 0 || life12 == 0 || life13 == 0 || life14 == 0)
                                begin    
                                    fail <= 1;
                                    correct3 <= 0;
                                    mask3_change <= testmask;
                                    
                                end
                                else begin
                                    fail <= 0;
                                    correct3 <= 1;
                                    mask3_change <= testmask;
                                    out3 <= testdata;
                                    mask[4] <= mask4;
                                end
                            end
                endcase
                end
            ST5:begin
                case(cs)
                    START:begin
                                fail <= 0; correct4 <= 0; fake4 <= 0; correct3 <= 0;    fake5 <= 0; use5 <= 0;
                                if(use4) begin  //找更改過的
                                    testdata <= out4;
                                    testmask <= mask4_change;
                                end
                                else begin          //沒更動過的
                                    testdata <= first(mask[4]);
                                    testmask <= mask4;
                                end
                          end
                    FIRST:begin
                                correct4 <= 0;
                                fail <= 0;
                                testdata <= first(testmask);
                                testmask <= newmask(testdata,testmask);
                                use4 <= 1;
                                
                                    row0 <= backrcb(rownum4,0,testdata,row0);    col0 <= backrcb(colnum4,0,testdata,col0);    blc0 <= backrcb(blcnum4,0,testdata,blc0);
                                    row1 <= backrcb(rownum4,1,testdata,row1);    col1 <= backrcb(colnum4,1,testdata,col1);    blc1 <= backrcb(blcnum4,1,testdata,blc1);
                                    row2 <= backrcb(rownum4,2,testdata,row2);    col2 <= backrcb(colnum4,2,testdata,col2);    blc2 <= backrcb(blcnum4,2,testdata,blc2);
                                    row3 <= backrcb(rownum4,3,testdata,row3);    col3 <= backrcb(colnum4,3,testdata,col3);    blc3 <= backrcb(blcnum4,3,testdata,blc3);
                                    row4 <= backrcb(rownum4,4,testdata,row4);    col4 <= backrcb(colnum4,4,testdata,col4);    blc4 <= backrcb(blcnum4,4,testdata,blc4);
                                    row5 <= backrcb(rownum4,5,testdata,row5);    col5 <= backrcb(colnum4,5,testdata,col5);    blc5 <= backrcb(blcnum4,5,testdata,blc5);
                                    row6 <= backrcb(rownum4,6,testdata,row6);    col6 <= backrcb(colnum4,6,testdata,col6);    blc6 <= backrcb(blcnum4,6,testdata,blc6);
                                    row7 <= backrcb(rownum4,7,testdata,row7);    col7 <= backrcb(colnum4,7,testdata,col7);    blc7 <= backrcb(blcnum4,7,testdata,blc7);
                                    row8 <= backrcb(rownum4,8,testdata,row8);    col8 <= backrcb(colnum4,8,testdata,col8);    blc8 <= backrcb(blcnum4,8,testdata,blc8);
                          end
                    REFRESH:begin
                                if(testdata == 4'd10)   //FSM1返回上一個STATE
                                begin   
                                    fake4 <= 1; use4 <= 0; 
                                end
                                else begin
                                    fake4 <= 0; goco <= 1;
                                    row0 <= newrcb(rownum4,0,testdata,row0);    col0 <= newrcb(colnum4,0,testdata,col0);    blc0 <= newrcb(blcnum4,0,testdata,blc0);
                                    row1 <= newrcb(rownum4,1,testdata,row1);    col1 <= newrcb(colnum4,1,testdata,col1);    blc1 <= newrcb(blcnum4,1,testdata,blc1);
                                    row2 <= newrcb(rownum4,2,testdata,row2);    col2 <= newrcb(colnum4,2,testdata,col2);    blc2 <= newrcb(blcnum4,2,testdata,blc2);
                                    row3 <= newrcb(rownum4,3,testdata,row3);    col3 <= newrcb(colnum4,3,testdata,col3);    blc3 <= newrcb(blcnum4,3,testdata,blc3);
                                    row4 <= newrcb(rownum4,4,testdata,row4);    col4 <= newrcb(colnum4,4,testdata,col4);    blc4 <= newrcb(blcnum4,4,testdata,blc4);
                                    row5 <= newrcb(rownum4,5,testdata,row5);    col5 <= newrcb(colnum4,5,testdata,col5);    blc5 <= newrcb(blcnum4,5,testdata,blc5);
                                    row6 <= newrcb(rownum4,6,testdata,row6);    col6 <= newrcb(colnum4,6,testdata,col6);    blc6 <= newrcb(blcnum4,6,testdata,blc6);
                                    row7 <= newrcb(rownum4,7,testdata,row7);    col7 <= newrcb(colnum4,7,testdata,col7);    blc7 <= newrcb(blcnum4,7,testdata,blc7);
                                    row8 <= newrcb(rownum4,8,testdata,row8);    col8 <= newrcb(colnum4,8,testdata,col8);    blc8 <= newrcb(blcnum4,8,testdata,blc8);
                                end
                          end
                    CORRECT:begin
                                goco <= 0;
                                if(life5 == 0 || life6 == 0 || life7 == 0 || life8 == 0 || life9 == 0 || life10 == 0 || life11 == 0 || life12 == 0 || life13 == 0 || life14 == 0)
                                begin    
                                    fail <= 1;
                                    correct4 <= 0;
                                    mask4_change <= testmask;
                                end
                                else begin
                                    fail <= 0;
                                    correct4 <= 1;
                                    mask4_change <= testmask;
                                    out4 <= testdata;
                                    mask[5] <= mask5;
                                end
                            end
                endcase
                end
            ST6:begin
                case(cs)
                    START:begin
                                fail <= 0; correct5 <= 0; fake5 <= 0;  correct4 <= 0;   fake6 <= 0; use6 <= 0;
                                if(use5) begin  //找更改過的
                                    testdata <= out5;
                                    testmask <= mask5_change;
                                end
                                else begin          //沒更動過的
                                    testdata <= first(mask[5]);
                                    testmask <= mask[5];
                                end
                          end
                    FIRST:begin
                                correct5 <= 0;
                                fail <= 0;
                                testdata <= first(testmask);
                                testmask <= newmask(testdata,testmask);
                                use5 <= 1;
                                row0 <= backrcb(rownum5,0,testdata,row0);    col0 <= backrcb(colnum5,0,testdata,col0);    blc0 <= backrcb(blcnum5,0,testdata,blc0);
                                    row1 <= backrcb(rownum5,1,testdata,row1);    col1 <= backrcb(colnum5,1,testdata,col1);    blc1 <= backrcb(blcnum5,1,testdata,blc1);
                                    row2 <= backrcb(rownum5,2,testdata,row2);    col2 <= backrcb(colnum5,2,testdata,col2);    blc2 <= backrcb(blcnum5,2,testdata,blc2);
                                    row3 <= backrcb(rownum5,3,testdata,row3);    col3 <= backrcb(colnum5,3,testdata,col3);    blc3 <= backrcb(blcnum5,3,testdata,blc3);
                                    row4 <= backrcb(rownum5,4,testdata,row4);    col4 <= backrcb(colnum5,4,testdata,col4);    blc4 <= backrcb(blcnum5,4,testdata,blc4);
                                    row5 <= backrcb(rownum5,5,testdata,row5);    col5 <= backrcb(colnum5,5,testdata,col5);    blc5 <= backrcb(blcnum5,5,testdata,blc5);
                                    row6 <= backrcb(rownum5,6,testdata,row6);    col6 <= backrcb(colnum5,6,testdata,col6);    blc6 <= backrcb(blcnum5,6,testdata,blc6);
                                    row7 <= backrcb(rownum5,7,testdata,row7);    col7 <= backrcb(colnum5,7,testdata,col7);    blc7 <= backrcb(blcnum5,7,testdata,blc7);
                                    row8 <= backrcb(rownum5,8,testdata,row8);    col8 <= backrcb(colnum5,8,testdata,col8);    blc8 <= backrcb(blcnum5,8,testdata,blc8);
                          end
                    REFRESH:begin
                                if(testdata == 4'd10)   //FSM1返回上一個STATE
                                begin   
                                    fake5 <= 1; use5 <= 0; 
                                end
                                else begin
                                    fake5 <= 0; goco <= 1;
                                    row0 <= newrcb(rownum5,0,testdata,row0);    col0 <= newrcb(colnum5,0,testdata,col0);    blc0 <= newrcb(blcnum5,0,testdata,blc0);
                                    row1 <= newrcb(rownum5,1,testdata,row1);    col1 <= newrcb(colnum5,1,testdata,col1);    blc1 <= newrcb(blcnum5,1,testdata,blc1);
                                    row2 <= newrcb(rownum5,2,testdata,row2);    col2 <= newrcb(colnum5,2,testdata,col2);    blc2 <= newrcb(blcnum5,2,testdata,blc2);
                                    row3 <= newrcb(rownum5,3,testdata,row3);    col3 <= newrcb(colnum5,3,testdata,col3);    blc3 <= newrcb(blcnum5,3,testdata,blc3);
                                    row4 <= newrcb(rownum5,4,testdata,row4);    col4 <= newrcb(colnum5,4,testdata,col4);    blc4 <= newrcb(blcnum5,4,testdata,blc4);
                                    row5 <= newrcb(rownum5,5,testdata,row5);    col5 <= newrcb(colnum5,5,testdata,col5);    blc5 <= newrcb(blcnum5,5,testdata,blc5);
                                    row6 <= newrcb(rownum5,6,testdata,row6);    col6 <= newrcb(colnum5,6,testdata,col6);    blc6 <= newrcb(blcnum5,6,testdata,blc6);
                                    row7 <= newrcb(rownum5,7,testdata,row7);    col7 <= newrcb(colnum5,7,testdata,col7);    blc7 <= newrcb(blcnum5,7,testdata,blc7);
                                    row8 <= newrcb(rownum5,8,testdata,row8);    col8 <= newrcb(colnum5,8,testdata,col8);    blc8 <= newrcb(blcnum5,8,testdata,blc8);
                                end
                          end
                    CORRECT:begin
                                goco <= 0;
                                if(life6 == 0 || life7 == 0 || life8 == 0 || life9 == 0 || life10 == 0 || life11 == 0 || life12 == 0 || life13 == 0 || life14 == 0)
                                begin    
                                    fail <= 1;
                                    correct5 <= 0;
                                    mask5_change <= testmask;
                                    
                                end
                                else begin
                                    fail <= 0;
                                    correct5 <= 1;
                                    mask5_change <= testmask;
                                    out5 <= testdata;
                                    mask[6] <= mask6;
                                end
                            end
                endcase
                end
            ST7:begin
                case(cs)
                    START:begin
                                fail <= 0; correct6 <= 0; fake6 <= 0; correct5 <= 0;    fake7 <= 0; use7 <= 0;
                                if(use6) begin  //找更改過的
                                    testdata <= out6;
                                    testmask <= mask6_change;
                                end
                                else begin          //沒更動過的
                                    testdata <= first(mask[6]);
                                    testmask <= mask[6];
                                end
                          end
                    FIRST:begin
                                correct6 <= 0;
                                fail <= 0;
                                testdata <= first(testmask);
                                testmask <= newmask(testdata,testmask);
                                use6 <= 1;
                                row0 <= backrcb(rownum6,0,testdata,row0);    col0 <= backrcb(colnum6,0,testdata,col0);    blc0 <= backrcb(blcnum6,0,testdata,blc0);
                                    row1 <= backrcb(rownum6,1,testdata,row1);    col1 <= backrcb(colnum6,1,testdata,col1);    blc1 <= backrcb(blcnum6,1,testdata,blc1);
                                    row2 <= backrcb(rownum6,2,testdata,row2);    col2 <= backrcb(colnum6,2,testdata,col2);    blc2 <= backrcb(blcnum6,2,testdata,blc2);
                                    row3 <= backrcb(rownum6,3,testdata,row3);    col3 <= backrcb(colnum6,3,testdata,col3);    blc3 <= backrcb(blcnum6,3,testdata,blc3);
                                    row4 <= backrcb(rownum6,4,testdata,row4);    col4 <= backrcb(colnum6,4,testdata,col4);    blc4 <= backrcb(blcnum6,4,testdata,blc4);
                                    row5 <= backrcb(rownum6,5,testdata,row5);    col5 <= backrcb(colnum6,5,testdata,col5);    blc5 <= backrcb(blcnum6,5,testdata,blc5);
                                    row6 <= backrcb(rownum6,6,testdata,row6);    col6 <= backrcb(colnum6,6,testdata,col6);    blc6 <= backrcb(blcnum6,6,testdata,blc6);
                                    row7 <= backrcb(rownum6,7,testdata,row7);    col7 <= backrcb(colnum6,7,testdata,col7);    blc7 <= backrcb(blcnum6,7,testdata,blc7);
                                    row8 <= backrcb(rownum6,8,testdata,row8);    col8 <= backrcb(colnum6,8,testdata,col8);    blc8 <= backrcb(blcnum6,8,testdata,blc8);
                          end
                    REFRESH:begin
                                if(testdata == 4'd10)   //FSM1返回上一個STATE
                                begin   
                                    fake6 <= 1; use6 <= 0; 
                                end
                                else begin
                                    fake6 <= 0; goco <= 1;
                                    row0 <= newrcb(rownum6,0,testdata,row0);    col0 <= newrcb(colnum6,0,testdata,col0);    blc0 <= newrcb(blcnum6,0,testdata,blc0);
                                    row1 <= newrcb(rownum6,1,testdata,row1);    col1 <= newrcb(colnum6,1,testdata,col1);    blc1 <= newrcb(blcnum6,1,testdata,blc1);
                                    row2 <= newrcb(rownum6,2,testdata,row2);    col2 <= newrcb(colnum6,2,testdata,col2);    blc2 <= newrcb(blcnum6,2,testdata,blc2);
                                    row3 <= newrcb(rownum6,3,testdata,row3);    col3 <= newrcb(colnum6,3,testdata,col3);    blc3 <= newrcb(blcnum6,3,testdata,blc3);
                                    row4 <= newrcb(rownum6,4,testdata,row4);    col4 <= newrcb(colnum6,4,testdata,col4);    blc4 <= newrcb(blcnum6,4,testdata,blc4);
                                    row5 <= newrcb(rownum6,5,testdata,row5);    col5 <= newrcb(colnum6,5,testdata,col5);    blc5 <= newrcb(blcnum6,5,testdata,blc5);
                                    row6 <= newrcb(rownum6,6,testdata,row6);    col6 <= newrcb(colnum6,6,testdata,col6);    blc6 <= newrcb(blcnum6,6,testdata,blc6);
                                    row7 <= newrcb(rownum6,7,testdata,row7);    col7 <= newrcb(colnum6,7,testdata,col7);    blc7 <= newrcb(blcnum6,7,testdata,blc7);
                                    row8 <= newrcb(rownum6,8,testdata,row8);    col8 <= newrcb(colnum6,8,testdata,col8);    blc8 <= newrcb(blcnum6,8,testdata,blc8);
                                end
                          end
                    CORRECT:begin
                                goco <= 0;
                                if(life7 == 0 || life8 == 0 || life9 == 0 || life10 == 0 || life11 == 0 || life12 == 0 || life13 == 0 || life14 == 0)
                                begin    
                                    fail <= 1;
                                    correct6 <= 0;
                                    mask6_change <= testmask;
                                    
                                end
                                else begin
                                    fail <= 0;
                                    correct6 <= 1;
                                    mask6_change <= testmask;
                                    out6 <= testdata;
                                    mask[7] <= mask7;
                                end
                            end
                endcase
                end
            ST8:begin
                case(cs)
                    START:begin
                                fail <= 0; correct7 <= 0; fake7 <= 0; correct6 <= 0;    fake8 <=0;  use8 <= 0;
                                if(use7) begin  //找更改過的
                                    testdata <= out7;
                                    testmask <= mask7_change;
                                end
                                else begin          //沒更動過的
                                    testdata <= first(mask[7]);
                                    testmask <= mask[7];
                                end
                          end
                    FIRST:begin
                                correct7 <= 0;
                                fail <= 0;
                                testdata <= first(testmask);
                                testmask <= newmask(testdata,testmask);
                                use7 <= 1;
                                row0 <= backrcb(rownum7,0,testdata,row0);    col0 <= backrcb(colnum7,0,testdata,col0);    blc0 <= backrcb(blcnum7,0,testdata,blc0);
                                    row1 <= backrcb(rownum7,1,testdata,row1);    col1 <= backrcb(colnum7,1,testdata,col1);    blc1 <= backrcb(blcnum7,1,testdata,blc1);
                                    row2 <= backrcb(rownum7,2,testdata,row2);    col2 <= backrcb(colnum7,2,testdata,col2);    blc2 <= backrcb(blcnum7,2,testdata,blc2);
                                    row3 <= backrcb(rownum7,3,testdata,row3);    col3 <= backrcb(colnum7,3,testdata,col3);    blc3 <= backrcb(blcnum7,3,testdata,blc3);
                                    row4 <= backrcb(rownum7,4,testdata,row4);    col4 <= backrcb(colnum7,4,testdata,col4);    blc4 <= backrcb(blcnum7,4,testdata,blc4);
                                    row5 <= backrcb(rownum7,5,testdata,row5);    col5 <= backrcb(colnum7,5,testdata,col5);    blc5 <= backrcb(blcnum7,5,testdata,blc5);
                                    row6 <= backrcb(rownum7,6,testdata,row6);    col6 <= backrcb(colnum7,6,testdata,col6);    blc6 <= backrcb(blcnum7,6,testdata,blc6);
                                    row7 <= backrcb(rownum7,7,testdata,row7);    col7 <= backrcb(colnum7,7,testdata,col7);    blc7 <= backrcb(blcnum7,7,testdata,blc7);
                                    row8 <= backrcb(rownum7,8,testdata,row8);    col8 <= backrcb(colnum7,8,testdata,col8);    blc8 <= backrcb(blcnum7,8,testdata,blc8);
                          end
                    REFRESH:begin
                                if(testdata == 4'd10)   //FSM1返回上一個STATE
                                begin   
                                    fake7 <= 1; use7 <= 0; 
                                end
                                else begin
                                    fake7 <= 0; goco <= 1;
                                    row0 <= newrcb(rownum7,0,testdata,row0);    col0 <= newrcb(colnum7,0,testdata,col0);    blc0 <= newrcb(blcnum7,0,testdata,blc0);
                                    row1 <= newrcb(rownum7,1,testdata,row1);    col1 <= newrcb(colnum7,1,testdata,col1);    blc1 <= newrcb(blcnum7,1,testdata,blc1);
                                    row2 <= newrcb(rownum7,2,testdata,row2);    col2 <= newrcb(colnum7,2,testdata,col2);    blc2 <= newrcb(blcnum7,2,testdata,blc2);
                                    row3 <= newrcb(rownum7,3,testdata,row3);    col3 <= newrcb(colnum7,3,testdata,col3);    blc3 <= newrcb(blcnum7,3,testdata,blc3);
                                    row4 <= newrcb(rownum7,4,testdata,row4);    col4 <= newrcb(colnum7,4,testdata,col4);    blc4 <= newrcb(blcnum7,4,testdata,blc4);
                                    row5 <= newrcb(rownum7,5,testdata,row5);    col5 <= newrcb(colnum7,5,testdata,col5);    blc5 <= newrcb(blcnum7,5,testdata,blc5);
                                    row6 <= newrcb(rownum7,6,testdata,row6);    col6 <= newrcb(colnum7,6,testdata,col6);    blc6 <= newrcb(blcnum7,6,testdata,blc6);
                                    row7 <= newrcb(rownum7,7,testdata,row7);    col7 <= newrcb(colnum7,7,testdata,col7);    blc7 <= newrcb(blcnum7,7,testdata,blc7);
                                    row8 <= newrcb(rownum7,8,testdata,row8);    col8 <= newrcb(colnum7,8,testdata,col8);    blc8 <= newrcb(blcnum7,8,testdata,blc8);
                                end
                          end
                    CORRECT:begin
                                goco <= 0;
                                if(life8 == 0 || life9 == 0 || life10 == 0 || life11 == 0 || life12 == 0 || life13 == 0 || life14 == 0)
                                begin    
                                    fail <= 1;
                                    correct7 <= 0;
                                    mask7_change <= testmask;
                                    
                                end
                                else begin
                                    fail <= 0;
                                    correct7 <= 1;
                                    mask7_change <= testmask;
                                    out7 <= testdata;
                                    mask[8] <= mask8;
                                end
                            end
                endcase
                end
            ST9:begin
                case(cs)
                    START:begin
                                fail <= 0; correct8 <= 0; fake8 <= 0; correct7 <= 0;    fake9 <= 0; use9 <= 0;
                                if(use8) begin  //找更改過的
                                    testdata <= out8;
                                    testmask <= mask8_change;
                                end
                                else begin          //沒更動過的
                                    testdata <= first(mask[8]);
                                    testmask <= mask[8];
                                end
                          end
                    FIRST:begin
                                correct8 <= 0;
                                fail <= 0;
                                testdata <= first(testmask);
                                testmask <= newmask(testdata,testmask);
                                use8 <= 1;
                                 row0 <= backrcb(rownum8,0,testdata,row0);    col0 <= backrcb(colnum8,0,testdata,col0);    blc0 <= backrcb(blcnum8,0,testdata,blc0);
                                    row1 <= backrcb(rownum8,1,testdata,row1);    col1 <= backrcb(colnum8,1,testdata,col1);    blc1 <= backrcb(blcnum8,1,testdata,blc1);
                                    row2 <= backrcb(rownum8,2,testdata,row2);    col2 <= backrcb(colnum8,2,testdata,col2);    blc2 <= backrcb(blcnum8,2,testdata,blc2);
                                    row3 <= backrcb(rownum8,3,testdata,row3);    col3 <= backrcb(colnum8,3,testdata,col3);    blc3 <= backrcb(blcnum8,3,testdata,blc3);
                                    row4 <= backrcb(rownum8,4,testdata,row4);    col4 <= backrcb(colnum8,4,testdata,col4);    blc4 <= backrcb(blcnum8,4,testdata,blc4);
                                    row5 <= backrcb(rownum8,5,testdata,row5);    col5 <= backrcb(colnum8,5,testdata,col5);    blc5 <= backrcb(blcnum8,5,testdata,blc5);
                                    row6 <= backrcb(rownum8,6,testdata,row6);    col6 <= backrcb(colnum8,6,testdata,col6);    blc6 <= backrcb(blcnum8,6,testdata,blc6);
                                    row7 <= backrcb(rownum8,7,testdata,row7);    col7 <= backrcb(colnum8,7,testdata,col7);    blc7 <= backrcb(blcnum8,7,testdata,blc7);
                                    row8 <= backrcb(rownum8,8,testdata,row8);    col8 <= backrcb(colnum8,8,testdata,col8);    blc8 <= backrcb(blcnum8,8,testdata,blc8);
                          end
                    REFRESH:begin
                                if(testdata == 4'd10)   //FSM1返回上一個STATE
                                begin   
                                    fake8 <= 1; use8 <= 0; 
                                end
                                else begin
                                    fake8 <= 0; goco <= 1;
                                    row0 <= newrcb(rownum8,0,testdata,row0);    col0 <= newrcb(colnum8,0,testdata,col0);    blc0 <= newrcb(blcnum8,0,testdata,blc0);
                                    row1 <= newrcb(rownum8,1,testdata,row1);    col1 <= newrcb(colnum8,1,testdata,col1);    blc1 <= newrcb(blcnum8,1,testdata,blc1);
                                    row2 <= newrcb(rownum8,2,testdata,row2);    col2 <= newrcb(colnum8,2,testdata,col2);    blc2 <= newrcb(blcnum8,2,testdata,blc2);
                                    row3 <= newrcb(rownum8,3,testdata,row3);    col3 <= newrcb(colnum8,3,testdata,col3);    blc3 <= newrcb(blcnum8,3,testdata,blc3);
                                    row4 <= newrcb(rownum8,4,testdata,row4);    col4 <= newrcb(colnum8,4,testdata,col4);    blc4 <= newrcb(blcnum8,4,testdata,blc4);
                                    row5 <= newrcb(rownum8,5,testdata,row5);    col5 <= newrcb(colnum8,5,testdata,col5);    blc5 <= newrcb(blcnum8,5,testdata,blc5);
                                    row6 <= newrcb(rownum8,6,testdata,row6);    col6 <= newrcb(colnum8,6,testdata,col6);    blc6 <= newrcb(blcnum8,6,testdata,blc6);
                                    row7 <= newrcb(rownum8,7,testdata,row7);    col7 <= newrcb(colnum8,7,testdata,col7);    blc7 <= newrcb(blcnum8,7,testdata,blc7);
                                    row8 <= newrcb(rownum8,8,testdata,row8);    col8 <= newrcb(colnum8,8,testdata,col8);    blc8 <= newrcb(blcnum8,8,testdata,blc8);
                                end
                          end
                    CORRECT:begin
                                goco <= 0;
                                if(life9 == 0 || life10 == 0 || life11 == 0 || life12 == 0 || life13 == 0 || life14 == 0)
                                begin    
                                    fail <= 1;
                                    correct8 <= 0;
                                    mask8_change <= testmask;
                                   
                                end
                                else begin
                                    fail <= 0;
                                    correct8 <= 1;
                                    mask8_change <= testmask;
                                    out8 <= testdata;
                                    mask[9] <= mask9;
                                end
                            end
                endcase
                end
            ST10:begin
                case(cs)
                    START:begin
                                fail <= 0; correct9 <= 0; fake9 <= 0; correct8 <= 0;    fake10 <= 0;    use10 <= 0;
                                if(use9) begin  //找更改過的
                                    testdata <= out9;
                                    testmask <= mask9_change;
                                end
                                else begin          //沒更動過的
                                    testdata <= first(mask[9]);
                                    testmask <= mask[9];
                                end
                          end
                    FIRST:begin
                                correct9 <= 0;
                                fail <= 0;
                                testdata <= first(testmask);
                                testmask <= newmask(testdata,testmask);
                                use9 <= 1;
                                 row0 <= backrcb(rownum9,0,testdata,row0);    col0 <= backrcb(colnum9,0,testdata,col0);    blc0 <= backrcb(blcnum9,0,testdata,blc0);
                                    row1 <= backrcb(rownum9,1,testdata,row1);    col1 <= backrcb(colnum9,1,testdata,col1);    blc1 <= backrcb(blcnum9,1,testdata,blc1);
                                    row2 <= backrcb(rownum9,2,testdata,row2);    col2 <= backrcb(colnum9,2,testdata,col2);    blc2 <= backrcb(blcnum9,2,testdata,blc2);
                                    row3 <= backrcb(rownum9,3,testdata,row3);    col3 <= backrcb(colnum9,3,testdata,col3);    blc3 <= backrcb(blcnum9,3,testdata,blc3);
                                    row4 <= backrcb(rownum9,4,testdata,row4);    col4 <= backrcb(colnum9,4,testdata,col4);    blc4 <= backrcb(blcnum9,4,testdata,blc4);
                                    row5 <= backrcb(rownum9,5,testdata,row5);    col5 <= backrcb(colnum9,5,testdata,col5);    blc5 <= backrcb(blcnum9,5,testdata,blc5);
                                    row6 <= backrcb(rownum9,6,testdata,row6);    col6 <= backrcb(colnum9,6,testdata,col6);    blc6 <= backrcb(blcnum9,6,testdata,blc6);
                                    row7 <= backrcb(rownum9,7,testdata,row7);    col7 <= backrcb(colnum9,7,testdata,col7);    blc7 <= backrcb(blcnum9,7,testdata,blc7);
                                    row8 <= backrcb(rownum9,8,testdata,row8);    col8 <= backrcb(colnum9,8,testdata,col8);    blc8 <= backrcb(blcnum9,8,testdata,blc8);
                          end
                    REFRESH:begin
                                if(testdata == 4'd10)   //FSM1返回上一個STATE
                                begin   
                                    fake9 <= 1; use9 <= 0; 
                                end
                                else begin
                                    fake9 <= 0; goco <= 1;
                                    row0 <= newrcb(rownum9,0,testdata,row0);    col0 <= newrcb(colnum9,0,testdata,col0);    blc0 <= newrcb(blcnum9,0,testdata,blc0);
                                    row1 <= newrcb(rownum9,1,testdata,row1);    col1 <= newrcb(colnum9,1,testdata,col1);    blc1 <= newrcb(blcnum9,1,testdata,blc1);
                                    row2 <= newrcb(rownum9,2,testdata,row2);    col2 <= newrcb(colnum9,2,testdata,col2);    blc2 <= newrcb(blcnum9,2,testdata,blc2);
                                    row3 <= newrcb(rownum9,3,testdata,row3);    col3 <= newrcb(colnum9,3,testdata,col3);    blc3 <= newrcb(blcnum9,3,testdata,blc3);
                                    row4 <= newrcb(rownum9,4,testdata,row4);    col4 <= newrcb(colnum9,4,testdata,col4);    blc4 <= newrcb(blcnum9,4,testdata,blc4);
                                    row5 <= newrcb(rownum9,5,testdata,row5);    col5 <= newrcb(colnum9,5,testdata,col5);    blc5 <= newrcb(blcnum9,5,testdata,blc5);
                                    row6 <= newrcb(rownum9,6,testdata,row6);    col6 <= newrcb(colnum9,6,testdata,col6);    blc6 <= newrcb(blcnum9,6,testdata,blc6);
                                    row7 <= newrcb(rownum9,7,testdata,row7);    col7 <= newrcb(colnum9,7,testdata,col7);    blc7 <= newrcb(blcnum9,7,testdata,blc7);
                                    row8 <= newrcb(rownum9,8,testdata,row8);    col8 <= newrcb(colnum9,8,testdata,col8);    blc8 <= newrcb(blcnum9,8,testdata,blc8);
                                end
                          end
                    CORRECT:begin
                                goco <= 0;
                                if(life10 == 0 || life11 == 0 || life12 == 0 || life13 == 0 || life14 == 0)
                                begin    
                                    fail <= 1;
                                    correct9 <= 0;
                                    mask9_change <= testmask;
                                   
                                end
                                else begin
                                    fail <= 0;
                                    correct9 <= 1;
                                    mask9_change <= testmask;
                                    out9 <= testdata;
                                    mask[10] <= mask10;
                                end
                            end
                endcase
                end
            ST11:begin
                case(cs)
                    START:begin
                                fail <= 0; correct10 <= 0; fake10 <= 0; correct9 <= 0;  fake11 <= 0;    use11 <= 0;
                                if(use10) begin  //找更改過的
                                    testdata <= out10;
                                    testmask <= mask10_change;
                                end
                                else begin          //沒更動過的
                                    testdata <= first(mask[10]);
                                    testmask <= mask[10];
                                end
                          end
                    FIRST:begin
                                correct10 <= 0;
                                fail <= 0;
                                testdata <= first(testmask);
                                testmask <= newmask(testdata,testmask);
                                use10 <= 1;
                                row0 <= backrcb(rownum10,0,testdata,row0);    col0<= backrcb(colnum10,0,testdata,col0);    blc0 <= backrcb(blcnum10,0,testdata,blc0);
                                    row1 <= backrcb(rownum10,1,testdata,row1);    col1<= backrcb(colnum10,1,testdata,col1);    blc1 <= backrcb(blcnum10,1,testdata,blc1);
                                    row2 <= backrcb(rownum10,2,testdata,row2);    col2<= backrcb(colnum10,2,testdata,col2);    blc2 <= backrcb(blcnum10,2,testdata,blc2);
                                    row3 <= backrcb(rownum10,3,testdata,row3);    col3<= backrcb(colnum10,3,testdata,col3);    blc3 <= backrcb(blcnum10,3,testdata,blc3);
                                    row4 <= backrcb(rownum10,4,testdata,row4);    col4<= backrcb(colnum10,4,testdata,col4);    blc4 <= backrcb(blcnum10,4,testdata,blc4);
                                    row5 <= backrcb(rownum10,5,testdata,row5);    col5<= backrcb(colnum10,5,testdata,col5);    blc5 <= backrcb(blcnum10,5,testdata,blc5);
                                    row6 <= backrcb(rownum10,6,testdata,row6);    col6<= backrcb(colnum10,6,testdata,col6);    blc6 <= backrcb(blcnum10,6,testdata,blc6);
                                    row7 <= backrcb(rownum10,7,testdata,row7);    col7<= backrcb(colnum10,7,testdata,col7);    blc7 <= backrcb(blcnum10,7,testdata,blc7);
                                    row8 <= backrcb(rownum10,8,testdata,row8);    col8<= backrcb(colnum10,8,testdata,col8);    blc8 <= backrcb(blcnum10,8,testdata,blc8);
                          end
                    REFRESH:begin
                                if(testdata == 4'd10)   //FSM1返回上一個STATE
                                begin   
                                    fake10 <= 1; use10 <= 0; 
                                end
                                else begin
                                    fake10 <= 0;    goco <= 1;
                                    row0 <= newrcb(rownum10,0,testdata,row0);    col0<= newrcb(colnum10,0,testdata,col0);    blc0 <= newrcb(blcnum10,0,testdata,blc0);
                                    row1 <= newrcb(rownum10,1,testdata,row1);    col1<= newrcb(colnum10,1,testdata,col1);    blc1 <= newrcb(blcnum10,1,testdata,blc1);
                                    row2 <= newrcb(rownum10,2,testdata,row2);    col2<= newrcb(colnum10,2,testdata,col2);    blc2 <= newrcb(blcnum10,2,testdata,blc2);
                                    row3 <= newrcb(rownum10,3,testdata,row3);    col3<= newrcb(colnum10,3,testdata,col3);    blc3 <= newrcb(blcnum10,3,testdata,blc3);
                                    row4 <= newrcb(rownum10,4,testdata,row4);    col4<= newrcb(colnum10,4,testdata,col4);    blc4 <= newrcb(blcnum10,4,testdata,blc4);
                                    row5 <= newrcb(rownum10,5,testdata,row5);    col5<= newrcb(colnum10,5,testdata,col5);    blc5 <= newrcb(blcnum10,5,testdata,blc5);
                                    row6 <= newrcb(rownum10,6,testdata,row6);    col6<= newrcb(colnum10,6,testdata,col6);    blc6 <= newrcb(blcnum10,6,testdata,blc6);
                                    row7 <= newrcb(rownum10,7,testdata,row7);    col7<= newrcb(colnum10,7,testdata,col7);    blc7 <= newrcb(blcnum10,7,testdata,blc7);
                                    row8 <= newrcb(rownum10,8,testdata,row8);    col8<= newrcb(colnum10,8,testdata,col8);    blc8 <= newrcb(blcnum10,8,testdata,blc8);
                                end
                          end
                    CORRECT:begin
                                goco <= 1;
                                if(life11 == 0 || life12 == 0 || life13 == 0 || life14 == 0)
                                begin    
                                    fail <= 1;
                                    correct10 <= 0;
                                    mask10_change <= testmask;
                                    
                                end
                                else begin
                                    fail <= 0;
                                    correct10 <= 1;
                                    mask10_change <= testmask;
                                    out10 <= testdata;
                                    mask[11] <= mask11;
                                end
                            end
                endcase
                end
            ST12:begin
                case(cs)
                    START:begin
                                fail <= 0; correct11 <= 0; fake11 <= 0; correct10 <= 0; fake12 <= 0;    use12 <= 0;
                                if(use11) begin  //找更改過的
                                    testdata <= out11;
                                    testmask <= mask11_change;
                                end
                                else begin          //沒更動過的
                                    testdata <= first(mask[11]);
                                    testmask <= mask[11];
                                end
                          end
                    FIRST:begin
                                correct11 <= 0;
                                fail <= 0;
                                testdata <= first(testmask);
                                testmask <= newmask(testdata,testmask);
                                use11 <= 1;
                                row0 <= backrcb(rownum11,0,testdata,row0);    col0 <= backrcb(colnum11,0,testdata,col0);    blc0 <= backrcb(blcnum11,0,testdata,blc0);
                                    row1 <= backrcb(rownum11,1,testdata,row1);    col1 <= backrcb(colnum11,1,testdata,col1);    blc1 <= backrcb(blcnum11,1,testdata,blc1);
                                    row2 <= backrcb(rownum11,2,testdata,row2);    col2 <= backrcb(colnum11,2,testdata,col2);    blc2 <= backrcb(blcnum11,2,testdata,blc2);
                                    row3 <= backrcb(rownum11,3,testdata,row3);    col3 <= backrcb(colnum11,3,testdata,col3);    blc3 <= backrcb(blcnum11,3,testdata,blc3);
                                    row4 <= backrcb(rownum11,4,testdata,row4);    col4 <= backrcb(colnum11,4,testdata,col4);    blc4 <= backrcb(blcnum11,4,testdata,blc4);
                                    row5 <= backrcb(rownum11,5,testdata,row5);    col5 <= backrcb(colnum11,5,testdata,col5);    blc5 <= backrcb(blcnum11,5,testdata,blc5);
                                    row6 <= backrcb(rownum11,6,testdata,row6);    col6 <= backrcb(colnum11,6,testdata,col6);    blc6 <= backrcb(blcnum11,6,testdata,blc6);
                                    row7 <= backrcb(rownum11,7,testdata,row7);    col7 <= backrcb(colnum11,7,testdata,col7);    blc7 <= backrcb(blcnum11,7,testdata,blc7);
                                    row8 <= backrcb(rownum11,8,testdata,row8);    col8 <= backrcb(colnum11,8,testdata,col8);    blc8 <= backrcb(blcnum11,8,testdata,blc8);
                          end
                    REFRESH:begin
                                if(testdata == 4'd10)   //FSM1返回上一個STATE
                                begin   
                                    fake11 <= 1; use11 <= 0; 
                                end
                                else begin
                                    fake11 <= 0;    goco <= 1;
                                    row0 <= newrcb(rownum11,0,testdata,row0);    col0 <= newrcb(colnum11,0,testdata,col0);    blc0 <= newrcb(blcnum11,0,testdata,blc0);
                                    row1 <= newrcb(rownum11,1,testdata,row1);    col1 <= newrcb(colnum11,1,testdata,col1);    blc1 <= newrcb(blcnum11,1,testdata,blc1);
                                    row2 <= newrcb(rownum11,2,testdata,row2);    col2 <= newrcb(colnum11,2,testdata,col2);    blc2 <= newrcb(blcnum11,2,testdata,blc2);
                                    row3 <= newrcb(rownum11,3,testdata,row3);    col3 <= newrcb(colnum11,3,testdata,col3);    blc3 <= newrcb(blcnum11,3,testdata,blc3);
                                    row4 <= newrcb(rownum11,4,testdata,row4);    col4 <= newrcb(colnum11,4,testdata,col4);    blc4 <= newrcb(blcnum11,4,testdata,blc4);
                                    row5 <= newrcb(rownum11,5,testdata,row5);    col5 <= newrcb(colnum11,5,testdata,col5);    blc5 <= newrcb(blcnum11,5,testdata,blc5);
                                    row6 <= newrcb(rownum11,6,testdata,row6);    col6 <= newrcb(colnum11,6,testdata,col6);    blc6 <= newrcb(blcnum11,6,testdata,blc6);
                                    row7 <= newrcb(rownum11,7,testdata,row7);    col7 <= newrcb(colnum11,7,testdata,col7);    blc7 <= newrcb(blcnum11,7,testdata,blc7);
                                    row8 <= newrcb(rownum11,8,testdata,row8);    col8 <= newrcb(colnum11,8,testdata,col8);    blc8 <= newrcb(blcnum11,8,testdata,blc8);
                                end
                          end
                    CORRECT:begin
                                goco <= 1;
                                if(life12 == 0 || life13 == 0 || life14 == 0)
                                begin    
                                    fail <= 1;
                                    correct11 <= 0;
                                    mask11_change <= testmask;
                                    
                                end
                                else begin
                                    fail <= 0;
                                    correct11 <= 1;
                                    mask11_change <= testmask;
                                    out11 <= testdata;
                                    mask[12] <= mask12;
                                end
                            end
                endcase
                end
            ST13:begin
                case(cs)
                    START:begin
                                fail <= 0; correct12 <= 0; fake12 <= 0; correct11 <= 0; fake13 <= 0;    use13 <= 0;
                                if(use12) begin  //找更改過的
                                    testdata <= out12;
                                    testmask <= mask12_change;
                                end
                                else begin          //沒更動過的
                                    testdata <= first(mask[12]);
                                    testmask <= mask[12];
                                end
                          end
                    FIRST:begin
                                correct12 <= 0;
                                fail <= 0;
                                testdata <= first(testmask);
                                testmask <= newmask(testdata,testmask);
                                use12 <= 1;
                                row0 <= backrcb(rownum12,0,testdata,row0);    col0 <= backrcb(colnum12,0,testdata,col0);    blc0 <= backrcb(blcnum12,0,testdata,blc0);
                                    row1 <= backrcb(rownum12,1,testdata,row1);    col1 <= backrcb(colnum12,1,testdata,col1);    blc1 <= backrcb(blcnum12,1,testdata,blc1);
                                    row2 <= backrcb(rownum12,2,testdata,row2);    col2 <= backrcb(colnum12,2,testdata,col2);    blc2 <= backrcb(blcnum12,2,testdata,blc2);
                                    row3 <= backrcb(rownum12,3,testdata,row3);    col3 <= backrcb(colnum12,3,testdata,col3);    blc3 <= backrcb(blcnum12,3,testdata,blc3);
                                    row4 <= backrcb(rownum12,4,testdata,row4);    col4 <= backrcb(colnum12,4,testdata,col4);    blc4 <= backrcb(blcnum12,4,testdata,blc4);
                                    row5 <= backrcb(rownum12,5,testdata,row5);    col5 <= backrcb(colnum12,5,testdata,col5);    blc5 <= backrcb(blcnum12,5,testdata,blc5);
                                    row6 <= backrcb(rownum12,6,testdata,row6);    col6 <= backrcb(colnum12,6,testdata,col6);    blc6 <= backrcb(blcnum12,6,testdata,blc6);
                                    row7 <= backrcb(rownum12,7,testdata,row7);    col7 <= backrcb(colnum12,7,testdata,col7);    blc7 <= backrcb(blcnum12,7,testdata,blc7);
                                    row8 <= backrcb(rownum12,8,testdata,row8);    col8 <= backrcb(colnum12,8,testdata,col8);    blc8 <= backrcb(blcnum12,8,testdata,blc8);
                          end
                    REFRESH:begin
                                if(testdata == 4'd10)   //FSM1返回上一個STATE
                                begin   
                                    fake12 <= 1; use12 <= 0; 
                                end
                                else begin
                                    fake12 <= 0;    goco <= 1;
                                    row0 <= newrcb(rownum12,0,testdata,row0);    col0 <= newrcb(colnum12,0,testdata,col0);    blc0 <= newrcb(blcnum12,0,testdata,blc0);
                                    row1 <= newrcb(rownum12,1,testdata,row1);    col1 <= newrcb(colnum12,1,testdata,col1);    blc1 <= newrcb(blcnum12,1,testdata,blc1);
                                    row2 <= newrcb(rownum12,2,testdata,row2);    col2 <= newrcb(colnum12,2,testdata,col2);    blc2 <= newrcb(blcnum12,2,testdata,blc2);
                                    row3 <= newrcb(rownum12,3,testdata,row3);    col3 <= newrcb(colnum12,3,testdata,col3);    blc3 <= newrcb(blcnum12,3,testdata,blc3);
                                    row4 <= newrcb(rownum12,4,testdata,row4);    col4 <= newrcb(colnum12,4,testdata,col4);    blc4 <= newrcb(blcnum12,4,testdata,blc4);
                                    row5 <= newrcb(rownum12,5,testdata,row5);    col5 <= newrcb(colnum12,5,testdata,col5);    blc5 <= newrcb(blcnum12,5,testdata,blc5);
                                    row6 <= newrcb(rownum12,6,testdata,row6);    col6 <= newrcb(colnum12,6,testdata,col6);    blc6 <= newrcb(blcnum12,6,testdata,blc6);
                                    row7 <= newrcb(rownum12,7,testdata,row7);    col7 <= newrcb(colnum12,7,testdata,col7);    blc7 <= newrcb(blcnum12,7,testdata,blc7);
                                    row8 <= newrcb(rownum12,8,testdata,row8);    col8 <= newrcb(colnum12,8,testdata,col8);    blc8 <= newrcb(blcnum12,8,testdata,blc8);
                                end
                          end
                    CORRECT:begin
                                goco <= 0;
                                if(life13 == 0 || life14 == 0)
                                begin    
                                    fail <= 1;
                                    correct12 <= 0;
                                    mask12_change <= testmask;
                                    
                                end
                                else begin
                                    fail <= 0;
                                    correct12 <= 1;
                                    mask12_change <= testmask;
                                    out12 <= testdata;
                                    mask[13] <= mask13;
                                end
                            end
                endcase
                end
            ST14:begin
                case(cs)
                    START:begin
                                fail <= 0; correct13 <= 0; fake13 <= 0; correct12 <= 0; fake14 <= 0;    use14 <= 0;
                                if(use13) begin  //找更改過的
                                    testdata <= out13;
                                    testmask <= mask13_change;
                                end
                                else begin          //沒更動過的
                                    testdata <= first(mask[13]);
                                    testmask <= mask[13];
                                end
                          end
                    FIRST:begin
                                correct13 <= 0;
                                fail <= 0;
                                testdata <= first(testmask);
                                testmask <= newmask(testdata,testmask);
                                use13 <= 1;
                                row0 <= backrcb(rownum13,0,testdata,row0);    col0 <= backrcb(colnum13,0,testdata,col0);    blc0 <= backrcb(blcnum13,0,testdata,blc0);
                                    row1 <= backrcb(rownum13,1,testdata,row1);    col1 <= backrcb(colnum13,1,testdata,col1);    blc1 <= backrcb(blcnum13,1,testdata,blc1);
                                    row2 <= backrcb(rownum13,2,testdata,row2);    col2 <= backrcb(colnum13,2,testdata,col2);    blc2 <= backrcb(blcnum13,2,testdata,blc2);
                                    row3 <= backrcb(rownum13,3,testdata,row3);    col3 <= backrcb(colnum13,3,testdata,col3);    blc3 <= backrcb(blcnum13,3,testdata,blc3);
                                    row4 <= backrcb(rownum13,4,testdata,row4);    col4 <= backrcb(colnum13,4,testdata,col4);    blc4 <= backrcb(blcnum13,4,testdata,blc4);
                                    row5 <= backrcb(rownum13,5,testdata,row5);    col5 <= backrcb(colnum13,5,testdata,col5);    blc5 <= backrcb(blcnum13,5,testdata,blc5);
                                    row6 <= backrcb(rownum13,6,testdata,row6);    col6 <= backrcb(colnum13,6,testdata,col6);    blc6 <= backrcb(blcnum13,6,testdata,blc6);
                                    row7 <= backrcb(rownum13,7,testdata,row7);    col7 <= backrcb(colnum13,7,testdata,col7);    blc7 <= backrcb(blcnum13,7,testdata,blc7);
                                    row8 <= backrcb(rownum13,8,testdata,row8);    col8 <= backrcb(colnum13,8,testdata,col8);    blc8 <= backrcb(blcnum13,8,testdata,blc8);
                          end
                    REFRESH:begin
                                if(testdata == 4'd10)   //FSM1返回上一個STATE
                                begin   
                                    fake13 <= 1; use13 <= 0; 
                                end
                                else begin
                                    fake13 <= 0;    goco <= 1;
                                    row0 <= newrcb(rownum13,0,testdata,row0);    col0 <= newrcb(colnum13,0,testdata,col0);    blc0 <= newrcb(blcnum13,0,testdata,blc0);
                                    row1 <= newrcb(rownum13,1,testdata,row1);    col1 <= newrcb(colnum13,1,testdata,col1);    blc1 <= newrcb(blcnum13,1,testdata,blc1);
                                    row2 <= newrcb(rownum13,2,testdata,row2);    col2 <= newrcb(colnum13,2,testdata,col2);    blc2 <= newrcb(blcnum13,2,testdata,blc2);
                                    row3 <= newrcb(rownum13,3,testdata,row3);    col3 <= newrcb(colnum13,3,testdata,col3);    blc3 <= newrcb(blcnum13,3,testdata,blc3);
                                    row4 <= newrcb(rownum13,4,testdata,row4);    col4 <= newrcb(colnum13,4,testdata,col4);    blc4 <= newrcb(blcnum13,4,testdata,blc4);
                                    row5 <= newrcb(rownum13,5,testdata,row5);    col5 <= newrcb(colnum13,5,testdata,col5);    blc5 <= newrcb(blcnum13,5,testdata,blc5);
                                    row6 <= newrcb(rownum13,6,testdata,row6);    col6 <= newrcb(colnum13,6,testdata,col6);    blc6 <= newrcb(blcnum13,6,testdata,blc6);
                                    row7 <= newrcb(rownum13,7,testdata,row7);    col7 <= newrcb(colnum13,7,testdata,col7);    blc7 <= newrcb(blcnum13,7,testdata,blc7);
                                    row8 <= newrcb(rownum13,8,testdata,row8);    col8 <= newrcb(colnum13,8,testdata,col8);    blc8 <= newrcb(blcnum13,8,testdata,blc8);
                                end
                          end
                    CORRECT:begin
                                goco <= 0;
                                if(life14 == 0)
                                begin    
                                    fail <= 1;
                                    correct13 <= 0;
                                    mask13_change <= testmask;
                                    
                                end
                                else begin
                                    fail <= 0;
                                    correct13 <= 1;
                                    mask13_change <= testmask;
                                    out13 <= testdata;
                                    mask[14] <= mask14;
                                end
                            end
                endcase
                end
            ST15:begin
                case(cs)
                    START:begin
                                fail <= 0; correct14 <= 0; fake14 <= 0; correct13 <= 0;
                                if(use14) begin  //找更改過的
                                    testdata <= out14;
                                    testmask <= mask14_change;
                                end
                                else begin          //沒更動過的
                                    testdata <= first(mask[14]);
                                    testmask <= mask[14];
                                end
                          end
                    FIRST:begin
                                fail <= 0;
                                testdata <= first(testmask);
                                testmask <= newmask(testdata,testmask);
                                use14 <= 1;
                          end
                    REFRESH:begin
                                    goco <= 1;
                                    row0 <= newrcb(rownum14,0,testdata,row0);    col0 <= newrcb(colnum14,0,testdata,col0);    blc0 <= newrcb(blcnum14,0,testdata,blc0);
                                    row1 <= newrcb(rownum14,1,testdata,row1);    col1 <= newrcb(colnum14,1,testdata,col1);    blc1 <= newrcb(blcnum14,1,testdata,blc1);
                                    row2 <= newrcb(rownum14,2,testdata,row2);    col2 <= newrcb(colnum14,2,testdata,col2);    blc2 <= newrcb(blcnum14,2,testdata,blc2);
                                    row3 <= newrcb(rownum14,3,testdata,row3);    col3 <= newrcb(colnum14,3,testdata,col3);    blc3 <= newrcb(blcnum14,3,testdata,blc3);
                                    row4 <= newrcb(rownum14,4,testdata,row4);    col4 <= newrcb(colnum14,4,testdata,col4);    blc4 <= newrcb(blcnum14,4,testdata,blc4);
                                    row5 <= newrcb(rownum14,5,testdata,row5);    col5 <= newrcb(colnum14,5,testdata,col5);    blc5 <= newrcb(blcnum14,5,testdata,blc5);
                                    row6 <= newrcb(rownum14,6,testdata,row6);    col6 <= newrcb(colnum14,6,testdata,col6);    blc6 <= newrcb(blcnum14,6,testdata,blc6);
                                    row7 <= newrcb(rownum14,7,testdata,row7);    col7 <= newrcb(colnum14,7,testdata,col7);    blc7 <= newrcb(blcnum14,7,testdata,blc7);
                                    row8 <= newrcb(rownum14,8,testdata,row8);    col8 <= newrcb(colnum14,8,testdata,col8);    blc8 <= newrcb(blcnum14,8,testdata,blc8);
                          end
                    CORRECT:begin
                                    goco <= 0;
                                    correct14 <= 1;
                                    fail <= 0;
                                    mask14_change <= testmask;
                                    out14 <= testdata;
                                    go <= 0;
                            end
                endcase
                end
            SUCCESS:
                begin
                     out_valid <= 1;
                end
            SUCCESS2:
                begin
                    if(out_count < 4'b0001)  out_valid <= 0;
                    else out_valid <= out_valid;
                   
                end
            FAIL:
                begin
                    disobey <= 0;
                    out_valid <= 1;
                end
            FAIL2:
                begin
                    if(out_count < 4'b0010 && out_count > 4'b0000) out_valid <= out_valid;
                    else begin 
                        out_valid <= 0;
                    end
                end
            default:begin
                array0 <= array0 ;  array10 <= array10;  array20 <= array20;  array30 <= array30;  array40 <= array40;    place0  <= place0;     mask[0 ] <= mask[0 ];     mask0_change  <= mask0_change;     use0  <= use0;       out0  <= out0; 
                array1 <= array1 ;  array11 <= array11;  array21 <= array21;  array31 <= array31;  array41 <= array41;    place1  <= place1;     mask[1 ] <= mask[1 ];     mask1_change  <= mask1_change;     use1  <= use1;       out1  <= out1;             
                array2 <= array2 ;  array12 <= array12;  array22 <= array22;  array32 <= array32;  array42 <= array42;    place2  <= place2;     mask[2 ] <= mask[2 ];     mask2_change  <= mask2_change;     use2  <= use2;       out2  <= out2;             
                array3 <= array3 ;  array13 <= array13;  array23 <= array23;  array33 <= array33;  array43 <= array43;    place3  <= place3;     mask[3 ] <= mask[3 ];     mask3_change  <= mask3_change;     use3  <= use3;       out3  <= out3;             
                array4 <= array4 ;  array14 <= array14;  array24 <= array24;  array34 <= array34;  array44 <= array44;    place4  <= place4;     mask[4 ] <= mask[4 ];     mask4_change  <= mask4_change;     use4  <= use4;       out4  <= out4;             
                array5 <= array5 ;  array15 <= array15;  array25 <= array25;  array35 <= array35;  array45 <= array45;    place5  <= place5;     mask[5 ] <= mask[5 ];     mask5_change  <= mask5_change;     use5  <= use5;       out5  <= out5;             
                array6 <= array6 ;  array16 <= array16;  array26 <= array26;  array36 <= array36;  array46 <= array46;    place6  <= place6;     mask[6 ] <= mask[6 ];     mask6_change  <= mask6_change;     use6  <= use6;       out6  <= out6;                                                                  
                array7 <= array7 ;  array17 <= array17;  array27 <= array27;  array37 <= array37;  array47 <= array47;    place7  <= place7;     mask[7 ] <= mask[7 ];     mask7_change  <= mask7_change;     use7  <= use7;       out7  <= out7;                                                                  
                array8 <= array8 ;  array18 <= array18;  array28 <= array28;  array38 <= array38;  array48 <= array48;    place8  <= place8;     mask[8 ] <= mask[8 ];     mask8_change  <= mask8_change;     use8  <= use8;       out8  <= out8;                                                                  
                array9 <= array9 ;  array19 <= array19;  array29 <= array29;  array39 <= array39;  array49 <= array49;    place9  <= place9;     mask[9 ] <= mask[9 ];     mask9_change  <= mask9_change;     use9  <= use9;       out9  <= out9;                                                                                             
                                                                                                                          place10 <= place10 ;   mask[10] <= mask[10];     mask10_change <= mask10_change;    use10 <= use10;       out10 <= out10;  
                array50 <= array50;  array60 <= array60;  array70 <= array70;  array80 <= array80;                        place11 <= place11 ;   mask[11] <= mask[11];     mask11_change <= mask11_change;    use11 <= use11;       out11 <= out11;  
                array51 <= array51;  array61 <= array61;  array71 <= array71;  work <= work;                              place12 <= place12 ;   mask[12] <= mask[12];     mask12_change <= mask12_change;    use12 <= use12;       out12 <= out12;  
                array52 <= array52;  array62 <= array62;  array72 <= array72;  out_valid <= out_valid;                    place13 <= place13 ;   mask[13] <= mask[13];     mask13_change <= mask13_change;    use13 <= use13;       out13 <= out13;  
                array53 <= array53;  array63 <= array63;  array73 <= array73;                                             place14 <= place14 ;   mask[14] <= mask[14];     mask14_change <= mask14_change;    use14 <= use14;       out14 <= out14;  
                array54 <= array54;  array64 <= array64;  array74 <= array74;  goco  <= goco;                             testdata<= testdata;  
                array55 <= array55;  array65 <= array65;  array75 <= array75;  fail <= fail;                              testmask<= testmask;  fake0  <= fake0 ;       correct0  <= correct0 ;        
                array56 <= array56;  array66 <= array66;  array76 <= array76;  disobey <= disobey;                                              fake1  <= fake1 ;       correct1  <= correct1 ;        
                array57 <= array57;  array67 <= array67;  array77 <= array77;  go <= go;                                                        fake2  <= fake2 ;       correct2  <= correct2 ;        
                array58 <= array58;  array68 <= array68;  array78 <= array78;  done <= done;                                                    fake3  <= fake3 ;       correct3  <= correct3 ;        
                array59 <= array59;  array69 <= array69;  array79 <= array79;                                                                   fake4  <= fake4 ;       correct4  <= correct4 ;        
                                                                                                                                                fake5  <= fake5 ;       correct5  <= correct5 ;        
                row0 <= row0;  col0 <= col0;    blc0 <= blc0;                                                                                   fake6  <= fake6 ;       correct6  <= correct6 ;        
                row1 <= row1;  col1 <= col1;    blc1 <= blc1;                                                                                   fake7  <= fake7 ;       correct7  <= correct7 ;        
                row2 <= row2;  col2 <= col2;    blc2 <= blc2;                                                                                   fake8  <= fake8 ;       correct8  <= correct8 ;        
                row3 <= row3;  col3 <= col3;    blc3 <= blc3;                                                                                   fake9  <= fake9 ;       correct9  <= correct9 ;        
                row4 <= row4;  col4 <= col4;    blc4 <= blc4;                                                                                   fake10 <= fake10;       correct10 <= correct10;        
                row5 <= row5;  col5 <= col5;    blc5 <= blc5;                                                                                   fake11 <= fake11;       correct11 <= correct11;        
                row6 <= row6;  col6 <= col6;    blc6 <= blc6;                                                                                   fake12 <= fake12;       correct12 <= correct12;        
                row7 <= row7;  col7 <= col7;    blc7 <= blc7;                                                                                   fake13 <= fake13;       correct13 <= correct13;        
                row8 <= row8;  col8 <= col8;    blc8 <= blc8;                                                                                   fake14 <= fake14;       correct14 <= correct14;        
            end
        endcase
    end
end
/////////////////////////////OUTPUT COUNTER/////////////////////////////////////////
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        out_count <= 4'b0000;
    end
    else if(next_state == SUCCESS || next_state == FAIL || next_state == SUCCESS2 || next_state == FAIL2)begin
        out_count <= out_count + 1;
    end
    else if(out_count > 4'd14)
        out_count <= 0;
    else    out_count <= 0;
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)  out<=0;
    else begin
     case(state)
     SUCCESS:begin
             case(out_count)
                4'd1 :  out <= out0 ;
                4'd2 :  out <= out1 ;
                4'd3 :  out <= out2 ;
                4'd4 :  out <= out3 ;
                4'd5 :  out <= out4 ;
                4'd6 :  out <= out5 ;
                4'd7 :  out <= out6 ;
                4'd8 :  out <= out7 ;
                4'd9 :  out <= out8 ;
                4'd10:  out <= out9 ;
                4'd11:  out <= out10;
                4'd12:  out <= out11;
                4'd13:  out <= out12;
                4'd14:  out <= out13;
                4'd15:  out <= out14;
                default:out <= 4'd0;
                endcase
             end
     SUCCESS2:begin
             case(out_count)
                4'd2 :  out <= out1 ;
                4'd3 :  out <= out2 ;
                4'd4 :  out <= out3 ;
                4'd5 :  out <= out4 ;
                4'd6 :  out <= out5 ;
                4'd7 :  out <= out6 ;
                4'd8 :  out <= out7 ;
                4'd9 :  out <= out8 ;
                4'd10:  out <= out9 ;
                4'd11:  out <= out10;
                4'd12:  out <= out11;
                4'd13:  out <= out12;
                4'd14:  out <= out13;
                4'd15:  out <= out14;
                default:out <= 4'd0;
                endcase
             end
     FAIL:begin
                case(out_count)
                4'd1 :  out <= 4'd10 ;
                default:out <= 4'd0;
                endcase
             end
     default:out <= 0 ;
     endcase
     end
end
////////////////////////////////FSM2 RECURSIVE////////////////////////////////////////
always @(posedge clk or negedge rst_n)
begin
   if(!rst_n) begin
        cs <= START;
   end
   else begin                 
        cs <= ns;
   end
end

always @(*) begin
    case(cs)
        START:begin
            if(go)  ns = FIRST;
            else    ns = cs;
        end
        FIRST:begin
            ns = REFRESH;
        end
        REFRESH:begin
            if(fake0 == 1 || fake1 == 1 ||fake2 == 1 || fake3 == 1 || fake4==1 || fake5==1 ||fake6==1 ||fake7==1 || fake8==1 || fake9==1 || fake10==1 || fake11==1 || fake12==1 || fake13==1 || fake14==1) ns = START;       //FSM1跳回前一個STATE
            else if(goco == 1) ns = CORRECT;
            else ns = cs;
        end
        CORRECT:begin
            if(fail) ns = FIRST;            //FSM2重選一個新值
            else if(correct0 == 1 || correct1 == 1 ||correct2 == 1 || correct3 == 1 || correct4==1 || correct5==1 ||correct6==1 ||correct7==1 || correct8==1 || correct9==1 || correct10==1 || correct11==1 || correct12==1 || correct13==1 || correct14==1) ns = START;    //FSM1往下一個STATE
            else ns = cs;
        end
        default:ns = cs;
    endcase
end

//--------------------function-----------------------//
function [3:0] first;               ///尋找第一位
   input [9:0] data;
   begin
        casex(data)
            10'bxx_xxxx_xxx1:   first = 4'd1;
            10'bxx_xxxx_xx10:   first = 4'd2;
            10'bxx_xxxx_x100:   first = 4'd3;
            10'bxx_xxxx_1000:   first = 4'd4;
            10'bxx_xxx1_0000:   first = 4'd5;
            10'bxx_xx10_0000:   first = 4'd6;
            10'bxx_x100_0000:   first = 4'd7;
            10'bxx_1000_0000:   first = 4'd8;
            10'bx1_0000_0000:   first = 4'd9;
            10'b10_0000_0000:   first = 4'd10;
            default:            first = 4'd0;
        endcase
   end
endfunction

function [9:0] newmask;         //設定新的mask
   input [3:0] data;
   input [9:0] mask;
   begin
        case(data)
            4'd1:   newmask = mask & 10'b11_1111_1110;
            4'd2:   newmask = mask & 10'b11_1111_1101;
            4'd3:   newmask = mask & 10'b11_1111_1011;
            4'd4:   newmask = mask & 10'b11_1111_0111;
            4'd5:   newmask = mask & 10'b11_1110_1111;
            4'd6:   newmask = mask & 10'b11_1101_1111;
            4'd7:   newmask = mask & 10'b11_1011_1111;
            4'd8:   newmask = mask & 10'b11_0111_1111;
            4'd9:   newmask = mask & 10'b10_1111_1111;
            4'd10:  newmask = mask & 10'b01_1111_1111;
            default:newmask = mask;
        endcase
   end
endfunction

function [8:0] newrcb;          //輸入新data後得到的新地圖
   input [3:0] target_number;   //現在這個0所在的rcb位子
   input [3:0] rcb_number;      //目前要刷新的rcb位子
   input [3:0] data;
   input [8:0] rcb;
   begin
        if(rcb_number == target_number) begin
            case(data)
                4'd1:   newrcb = rcb & 10'b11_1111_1110;
                4'd2:   newrcb = rcb & 10'b11_1111_1101;
                4'd3:   newrcb = rcb & 10'b11_1111_1011;
                4'd4:   newrcb = rcb & 10'b11_1111_0111;
                4'd5:   newrcb = rcb & 10'b11_1110_1111;
                4'd6:   newrcb = rcb & 10'b11_1101_1111;
                4'd7:   newrcb = rcb & 10'b11_1011_1111;
                4'd8:   newrcb = rcb & 10'b11_0111_1111;
                4'd9:   newrcb = rcb & 10'b10_1111_1111;
                default:newrcb = rcb;
            endcase
        end
        else begin
            newrcb = rcb;
        end
   end
endfunction

function [8:0] backrcb;          //輸入新data後得到的新地圖
   input [3:0] target_number;   //現在這個0所在的rcb位子
   input [3:0] rcb_number;      //目前要刷新的rcb位子
   input [3:0] data;
   input [8:0] rcb;
   begin
        if(rcb_number == target_number) begin
            case(data)
                4'd1:   backrcb = rcb | 10'b00_0000_0001;
                4'd2:   backrcb = rcb | 10'b00_0000_0010;
                4'd3:   backrcb = rcb | 10'b00_0000_0100;
                4'd4:   backrcb = rcb | 10'b00_0000_1000;
                4'd5:   backrcb = rcb | 10'b00_0001_0000;
                4'd6:   backrcb = rcb | 10'b00_0010_0000;
                4'd7:   backrcb = rcb | 10'b00_0100_0000;
                4'd8:   backrcb = rcb | 10'b00_1000_0000;
                4'd9:   backrcb = rcb | 10'b01_0000_0000;
                default:backrcb = rcb;
            endcase
        end
        else begin
            backrcb = rcb;
        end
   end
endfunction
/////////////// COUNTING POSITION & PUT DATA INTO ARRAY_IN//////////////////
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        counter <= 7'b000_0000;
    end
    else if(in_valid) begin
        counter <= counter + 1;
    end
    else begin 
        counter <= 0;
    end
end

genvar i;
generate
    for(i = 0; i < 81; i = i + 1)begin: data_in
        always @(posedge clk or negedge rst_n) begin
            if(!rst_n)  
                    array_in[i] <= 4'b0000;
            else if(in_valid && i==counter) begin
                    array_in[i] <= in;
            end
            else if(state == 4'd0)
                    array_in[i] <= 0;
            else              
                    array_in[i] <= array_in[i];
        end
    end
endgenerate
/////////////// COUNTING ZEROS //////////////////
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)  begin
        count <= 4'b0000;
    end
    else if(state == 4'd0)
        count <= 4'b0000;
    else if(flag)    begin
        count <= count + 1;
    end
    else begin
        count <= count;
    end
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)  begin
        place_t <= 7'b00_00000;
    end
    else if(state == 4'd0)
        place_t <= 7'b00_00000;
    else if(flag)    begin
        place_t <= counter - 1;
    end
    else begin
        place_t <= place_t;
    end
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)  begin
        flag <= 0;
    end
    else if(in == 4'd0 && in_valid == 1'b1)    begin
        flag <= 1;
    end
    else begin
        flag <= 0;
    end
end
/////////////// SETTING ZERO PLACES //////////////////
//genvar j;
//generate
//    for(j = 0; j < 15; j = j + 1)begin: place_in
//        always @(posedge clk or negedge rst_n) begin
//            if(!rst_n)  begin
//                    place[j ] <= 4'h0;
//            end
//            else if((j ==count) && flag) begin
//                    place[j ] <= counter - 1;
//            end
//            else if(state == 4'd0)
//                    place[j] <= 0;
//            else begin           
//                    place[j ] <= place[j ];
//            end
//        end
//    end
//endgenerate

always @(posedge clk or negedge rst_n)
begin   
    if(!rst_n)
    begin
        place[0 ] <= 0;
        place[1 ] <= 0;
        place[2 ] <= 0;
        place[3 ] <= 0;
        place[4 ] <= 0;
        place[5 ] <= 0;
        place[6 ] <= 0;
        place[7 ] <= 0;
        place[8 ] <= 0;
        place[9 ] <= 0;
        place[10] <= 0;
        place[11] <= 0;
        place[12] <= 0;
        place[13] <= 0;
        place[14] <= 0;
    end
    else if (next_state == 4'd0)
        begin
        place[0 ] <= 0;
        place[1 ] <= 0;
        place[2 ] <= 0;
        place[3 ] <= 0;
        place[4 ] <= 0;
        place[5 ] <= 0;
        place[6 ] <= 0;
        place[7 ] <= 0;
        place[8 ] <= 0;
        place[9 ] <= 0;
        place[10] <= 0;
        place[11] <= 0;
        place[12] <= 0;
        place[13] <= 0;
        place[14] <= 0;
        end
    else if(state == 5'd1) begin
        case(count)
            4'd1 : place[0 ] <= place_t;
            4'd2 : place[1 ] <= place_t;
            4'd3 : place[2 ] <= place_t;
            4'd4 : place[3 ] <= place_t;
            4'd5 : place[4 ] <= place_t;
            4'd6 : place[5 ] <= place_t;
            4'd7 : place[6 ] <= place_t;
            4'd8 : place[7 ] <= place_t;
            4'd9 : place[8 ] <= place_t;
            4'd10: place[9 ] <= place_t;
            4'd11: place[10] <= place_t;
            4'd12: place[11] <= place_t;
            4'd13: place[12] <= place_t;
            4'd14: place[13] <= place_t;
            4'd15: place[14] <= place_t;
        endcase
    end
    else begin
            place[0 ] <= place[0 ];
            place[1 ] <= place[1 ];
            place[2 ] <= place[2 ];
            place[3 ] <= place[3 ];
            place[4 ] <= place[4 ];
            place[5 ] <= place[5 ];
            place[6 ] <= place[6 ];
            place[7 ] <= place[7 ];
            place[8 ] <= place[8 ];
            place[9 ] <= place[9 ];
            place[10] <= place[10];
            place[11] <= place[11];
            place[12] <= place[12];
            place[13] <= place[13];
            place[14] <= place[14];
    end
end

/////////////////////FIXED MASK////////////////////////////

FixMask R0(.clk(clk),.rst_n(rst_n),.state(state),.array0(array0 ),.array1(array1 ),.array2(array2 ),.array3(array3 ),.array4(array4 ),.array5(array5 ),.array6(array6 ),.array7(array7 ),.array8(array8 ),.mask(row[0]),.disobey(disobey0));
FixMask R1(.clk(clk),.rst_n(rst_n),.state(state),.array0(array9 ),.array1(array10),.array2(array11),.array3(array12),.array4(array13),.array5(array14),.array6(array15),.array7(array16),.array8(array17),.mask(row[1]),.disobey(disobey1));
FixMask R2(.clk(clk),.rst_n(rst_n),.state(state),.array0(array18),.array1(array19),.array2(array20),.array3(array21),.array4(array22),.array5(array23),.array6(array24),.array7(array25),.array8(array26),.mask(row[2]),.disobey(disobey2));
FixMask R3(.clk(clk),.rst_n(rst_n),.state(state),.array0(array27),.array1(array28),.array2(array29),.array3(array30),.array4(array31),.array5(array32),.array6(array33),.array7(array34),.array8(array35),.mask(row[3]),.disobey(disobey3));
FixMask R4(.clk(clk),.rst_n(rst_n),.state(state),.array0(array36),.array1(array37),.array2(array38),.array3(array39),.array4(array40),.array5(array41),.array6(array42),.array7(array43),.array8(array44),.mask(row[4]),.disobey(disobey4));
FixMask R5(.clk(clk),.rst_n(rst_n),.state(state),.array0(array45),.array1(array46),.array2(array47),.array3(array48),.array4(array49),.array5(array50),.array6(array51),.array7(array52),.array8(array53),.mask(row[5]),.disobey(disobey5));
FixMask R6(.clk(clk),.rst_n(rst_n),.state(state),.array0(array54),.array1(array55),.array2(array56),.array3(array57),.array4(array58),.array5(array59),.array6(array60),.array7(array61),.array8(array62),.mask(row[6]),.disobey(disobey6));
FixMask R7(.clk(clk),.rst_n(rst_n),.state(state),.array0(array63),.array1(array64),.array2(array65),.array3(array66),.array4(array67),.array5(array68),.array6(array69),.array7(array70),.array8(array71),.mask(row[7]),.disobey(disobey7));
FixMask R8(.clk(clk),.rst_n(rst_n),.state(state),.array0(array72),.array1(array73),.array2(array74),.array3(array75),.array4(array76),.array5(array77),.array6(array78),.array7(array79),.array8(array80),.mask(row[8]),.disobey(disobey8)); 
                                                                                                                                                                                               
FixMask C0(.clk(clk),.rst_n(rst_n),.state(state),.array0(array0 ),.array1(array9 ),.array2(array18),.array3(array27),.array4(array36),.array5(array45),.array6(array54),.array7(array63),.array8(array72),.mask(col[0]),.disobey(disobey9));
FixMask C1(.clk(clk),.rst_n(rst_n),.state(state),.array0(array1 ),.array1(array10),.array2(array19),.array3(array28),.array4(array37),.array5(array46),.array6(array55),.array7(array64),.array8(array73),.mask(col[1]),.disobey(disobey10));
FixMask C2(.clk(clk),.rst_n(rst_n),.state(state),.array0(array2 ),.array1(array11),.array2(array20),.array3(array29),.array4(array38),.array5(array47),.array6(array56),.array7(array65),.array8(array74),.mask(col[2]),.disobey(disobey11));
FixMask C3(.clk(clk),.rst_n(rst_n),.state(state),.array0(array3 ),.array1(array12),.array2(array21),.array3(array30),.array4(array39),.array5(array48),.array6(array57),.array7(array66),.array8(array75),.mask(col[3]),.disobey(disobey12));
FixMask C4(.clk(clk),.rst_n(rst_n),.state(state),.array0(array4 ),.array1(array13),.array2(array22),.array3(array31),.array4(array40),.array5(array49),.array6(array58),.array7(array67),.array8(array76),.mask(col[4]),.disobey(disobey13));
FixMask C5(.clk(clk),.rst_n(rst_n),.state(state),.array0(array5 ),.array1(array14),.array2(array23),.array3(array32),.array4(array41),.array5(array50),.array6(array59),.array7(array68),.array8(array77),.mask(col[5]),.disobey(disobey14));
FixMask C6(.clk(clk),.rst_n(rst_n),.state(state),.array0(array6 ),.array1(array15),.array2(array24),.array3(array33),.array4(array42),.array5(array51),.array6(array60),.array7(array69),.array8(array78),.mask(col[6]),.disobey(disobey15));
FixMask C7(.clk(clk),.rst_n(rst_n),.state(state),.array0(array7 ),.array1(array16),.array2(array25),.array3(array34),.array4(array43),.array5(array52),.array6(array61),.array7(array70),.array8(array79),.mask(col[7]),.disobey(disobey16));
FixMask C8(.clk(clk),.rst_n(rst_n),.state(state),.array0(array8 ),.array1(array17),.array2(array26),.array3(array35),.array4(array44),.array5(array53),.array6(array62),.array7(array71),.array8(array80),.mask(col[8]),.disobey(disobey17)); 
                                                                                                                                                                                       
FixMask B0(.clk(clk),.rst_n(rst_n),.state(state),.array0(array0 ),.array1(array1 ),.array2(array2 ),.array3(array9 ),.array4(array10),.array5(array11),.array6(array18),.array7(array19),.array8(array20),.mask(blc[0]),.disobey(disobey18));
FixMask B1(.clk(clk),.rst_n(rst_n),.state(state),.array0(array3 ),.array1(array4 ),.array2(array5 ),.array3(array12),.array4(array13),.array5(array14),.array6(array21),.array7(array22),.array8(array23),.mask(blc[1]),.disobey(disobey19));
FixMask B2(.clk(clk),.rst_n(rst_n),.state(state),.array0(array6 ),.array1(array7 ),.array2(array8 ),.array3(array15),.array4(array16),.array5(array17),.array6(array24),.array7(array25),.array8(array26),.mask(blc[2]),.disobey(disobey20));
FixMask B3(.clk(clk),.rst_n(rst_n),.state(state),.array0(array27),.array1(array28),.array2(array29),.array3(array36),.array4(array37),.array5(array38),.array6(array45),.array7(array46),.array8(array47),.mask(blc[3]),.disobey(disobey21));
FixMask B4(.clk(clk),.rst_n(rst_n),.state(state),.array0(array30),.array1(array31),.array2(array32),.array3(array39),.array4(array40),.array5(array41),.array6(array48),.array7(array49),.array8(array50),.mask(blc[4]),.disobey(disobey22));
FixMask B5(.clk(clk),.rst_n(rst_n),.state(state),.array0(array33),.array1(array34),.array2(array35),.array3(array42),.array4(array43),.array5(array44),.array6(array51),.array7(array52),.array8(array53),.mask(blc[5]),.disobey(disobey23));
FixMask B6(.clk(clk),.rst_n(rst_n),.state(state),.array0(array54),.array1(array55),.array2(array56),.array3(array63),.array4(array64),.array5(array65),.array6(array72),.array7(array73),.array8(array74),.mask(blc[6]),.disobey(disobey24));
FixMask B7(.clk(clk),.rst_n(rst_n),.state(state),.array0(array57),.array1(array58),.array2(array59),.array3(array66),.array4(array67),.array5(array68),.array6(array75),.array7(array76),.array8(array77),.mask(blc[7]),.disobey(disobey25));
FixMask B8(.clk(clk),.rst_n(rst_n),.state(state),.array0(array60),.array1(array61),.array2(array62),.array3(array69),.array4(array70),.array5(array71),.array6(array78),.array7(array79),.array8(array80),.mask(blc[8]),.disobey(disobey26)); 
//////////////////////////ZERO MASK///////////////////////////////////////////
ZeroMask Z0 (.place(place0 ),.row0(row0),.row1(row1),.row2(row2),.row3(row3),.row4(row4),.row5(row5),.row6(row6),.row7(row7),.row8(row8),.r(rownum0),
                             .col0(col0),.col1(col1),.col2(col2),.col3(col3),.col4(col4),.col5(col5),.col6(col6),.col7(col7),.col8(col8),.c(colnum0),
                             .blc0(blc0),.blc1(blc1),.blc2(blc2),.blc3(blc3),.blc4(blc4),.blc5(blc5),.blc6(blc6),.blc7(blc7),.blc8(blc8),.b(blcnum0),.mask(mask0),.life(life0));
ZeroMask Z1 (.place(place1 ),.row0(row0),.row1(row1),.row2(row2),.row3(row3),.row4(row4),.row5(row5),.row6(row6),.row7(row7),.row8(row8),.r(rownum1),
                             .col0(col0),.col1(col1),.col2(col2),.col3(col3),.col4(col4),.col5(col5),.col6(col6),.col7(col7),.col8(col8),.c(colnum1),
                             .blc0(blc0),.blc1(blc1),.blc2(blc2),.blc3(blc3),.blc4(blc4),.blc5(blc5),.blc6(blc6),.blc7(blc7),.blc8(blc8),.b(blcnum1),.mask(mask1),.life(life1));
ZeroMask Z2 (.place(place2 ),.row0(row0),.row1(row1),.row2(row2),.row3(row3),.row4(row4),.row5(row5),.row6(row6),.row7(row7),.row8(row8),.r(rownum2),
                             .col0(col0),.col1(col1),.col2(col2),.col3(col3),.col4(col4),.col5(col5),.col6(col6),.col7(col7),.col8(col8),.c(colnum2),
                             .blc0(blc0),.blc1(blc1),.blc2(blc2),.blc3(blc3),.blc4(blc4),.blc5(blc5),.blc6(blc6),.blc7(blc7),.blc8(blc8),.b(blcnum2),.mask(mask2),.life(life2));
ZeroMask Z3 (.place(place3 ),.row0(row0),.row1(row1),.row2(row2),.row3(row3),.row4(row4),.row5(row5),.row6(row6),.row7(row7),.row8(row8),.r(rownum3),
                             .col0(col0),.col1(col1),.col2(col2),.col3(col3),.col4(col4),.col5(col5),.col6(col6),.col7(col7),.col8(col8),.c(colnum3),
                             .blc0(blc0),.blc1(blc1),.blc2(blc2),.blc3(blc3),.blc4(blc4),.blc5(blc5),.blc6(blc6),.blc7(blc7),.blc8(blc8),.b(blcnum3),.mask(mask3),.life(life3));
ZeroMask Z4 (.place(place4 ),.row0(row0),.row1(row1),.row2(row2),.row3(row3),.row4(row4),.row5(row5),.row6(row6),.row7(row7),.row8(row8),.r(rownum4),
                             .col0(col0),.col1(col1),.col2(col2),.col3(col3),.col4(col4),.col5(col5),.col6(col6),.col7(col7),.col8(col8),.c(colnum4),
                             .blc0(blc0),.blc1(blc1),.blc2(blc2),.blc3(blc3),.blc4(blc4),.blc5(blc5),.blc6(blc6),.blc7(blc7),.blc8(blc8),.b(blcnum4),.mask(mask4),.life(life4));
ZeroMask Z5 (.place(place5 ),.row0(row0),.row1(row1),.row2(row2),.row3(row3),.row4(row4),.row5(row5),.row6(row6),.row7(row7),.row8(row8),.r(rownum5),
                             .col0(col0),.col1(col1),.col2(col2),.col3(col3),.col4(col4),.col5(col5),.col6(col6),.col7(col7),.col8(col8),.c(colnum5),
                             .blc0(blc0),.blc1(blc1),.blc2(blc2),.blc3(blc3),.blc4(blc4),.blc5(blc5),.blc6(blc6),.blc7(blc7),.blc8(blc8),.b(blcnum5),.mask(mask5),.life(life5));
ZeroMask Z6 (.place(place6 ),.row0(row0),.row1(row1),.row2(row2),.row3(row3),.row4(row4),.row5(row5),.row6(row6),.row7(row7),.row8(row8),.r(rownum6),
                             .col0(col0),.col1(col1),.col2(col2),.col3(col3),.col4(col4),.col5(col5),.col6(col6),.col7(col7),.col8(col8),.c(colnum6),
                             .blc0(blc0),.blc1(blc1),.blc2(blc2),.blc3(blc3),.blc4(blc4),.blc5(blc5),.blc6(blc6),.blc7(blc7),.blc8(blc8),.b(blcnum6),.mask(mask6),.life(life6));
ZeroMask Z7 (.place(place7 ),.row0(row0),.row1(row1),.row2(row2),.row3(row3),.row4(row4),.row5(row5),.row6(row6),.row7(row7),.row8(row8),.r(rownum7),
                             .col0(col0),.col1(col1),.col2(col2),.col3(col3),.col4(col4),.col5(col5),.col6(col6),.col7(col7),.col8(col8),.c(colnum7),
                             .blc0(blc0),.blc1(blc1),.blc2(blc2),.blc3(blc3),.blc4(blc4),.blc5(blc5),.blc6(blc6),.blc7(blc7),.blc8(blc8),.b(blcnum7),.mask(mask7),.life(life7));
ZeroMask Z8 (.place(place8 ),.row0(row0),.row1(row1),.row2(row2),.row3(row3),.row4(row4),.row5(row5),.row6(row6),.row7(row7),.row8(row8),.r(rownum8),
                             .col0(col0),.col1(col1),.col2(col2),.col3(col3),.col4(col4),.col5(col5),.col6(col6),.col7(col7),.col8(col8),.c(colnum8),
                             .blc0(blc0),.blc1(blc1),.blc2(blc2),.blc3(blc3),.blc4(blc4),.blc5(blc5),.blc6(blc6),.blc7(blc7),.blc8(blc8),.b(blcnum8),.mask(mask8),.life(life8));
ZeroMask Z9 (.place(place9 ),.row0(row0),.row1(row1),.row2(row2),.row3(row3),.row4(row4),.row5(row5),.row6(row6),.row7(row7),.row8(row8),.r(rownum9),
                             .col0(col0),.col1(col1),.col2(col2),.col3(col3),.col4(col4),.col5(col5),.col6(col6),.col7(col7),.col8(col8),.c(colnum9),
                             .blc0(blc0),.blc1(blc1),.blc2(blc2),.blc3(blc3),.blc4(blc4),.blc5(blc5),.blc6(blc6),.blc7(blc7),.blc8(blc8),.b(blcnum9),.mask(mask9),.life(life9));
ZeroMask Z10(.place(place10),.row0(row0),.row1(row1),.row2(row2),.row3(row3),.row4(row4),.row5(row5),.row6(row6),.row7(row7),.row8(row8),.r(rownum10),
                             .col0(col0),.col1(col1),.col2(col2),.col3(col3),.col4(col4),.col5(col5),.col6(col6),.col7(col7),.col8(col8),.c(colnum10),
                             .blc0(blc0),.blc1(blc1),.blc2(blc2),.blc3(blc3),.blc4(blc4),.blc5(blc5),.blc6(blc6),.blc7(blc7),.blc8(blc8),.b(blcnum10),.mask(mask10),.life(life10));
ZeroMask Z11(.place(place11),.row0(row0),.row1(row1),.row2(row2),.row3(row3),.row4(row4),.row5(row5),.row6(row6),.row7(row7),.row8(row8),.r(rownum11),
                             .col0(col0),.col1(col1),.col2(col2),.col3(col3),.col4(col4),.col5(col5),.col6(col6),.col7(col7),.col8(col8),.c(colnum11),
                             .blc0(blc0),.blc1(blc1),.blc2(blc2),.blc3(blc3),.blc4(blc4),.blc5(blc5),.blc6(blc6),.blc7(blc7),.blc8(blc8),.b(blcnum11),.mask(mask11),.life(life11));
ZeroMask Z12(.place(place12),.row0(row0),.row1(row1),.row2(row2),.row3(row3),.row4(row4),.row5(row5),.row6(row6),.row7(row7),.row8(row8),.r(rownum12),
                             .col0(col0),.col1(col1),.col2(col2),.col3(col3),.col4(col4),.col5(col5),.col6(col6),.col7(col7),.col8(col8),.c(colnum12),
                             .blc0(blc0),.blc1(blc1),.blc2(blc2),.blc3(blc3),.blc4(blc4),.blc5(blc5),.blc6(blc6),.blc7(blc7),.blc8(blc8),.b(blcnum12),.mask(mask12),.life(life12));
ZeroMask Z13(.place(place13),.row0(row0),.row1(row1),.row2(row2),.row3(row3),.row4(row4),.row5(row5),.row6(row6),.row7(row7),.row8(row8),.r(rownum13),
                             .col0(col0),.col1(col1),.col2(col2),.col3(col3),.col4(col4),.col5(col5),.col6(col6),.col7(col7),.col8(col8),.c(colnum13),
                             .blc0(blc0),.blc1(blc1),.blc2(blc2),.blc3(blc3),.blc4(blc4),.blc5(blc5),.blc6(blc6),.blc7(blc7),.blc8(blc8),.b(blcnum13),.mask(mask13),.life(life13));
ZeroMask Z14(.place(place14),.row0(row0),.row1(row1),.row2(row2),.row3(row3),.row4(row4),.row5(row5),.row6(row6),.row7(row7),.row8(row8),.r(rownum14),
                             .col0(col0),.col1(col1),.col2(col2),.col3(col3),.col4(col4),.col5(col5),.col6(col6),.col7(col7),.col8(col8),.c(colnum14),
                             .blc0(blc0),.blc1(blc1),.blc2(blc2),.blc3(blc3),.blc4(blc4),.blc5(blc5),.blc6(blc6),.blc7(blc7),.blc8(blc8),.b(blcnum14),.mask(mask14),.life(life14));




endmodule


module FixMask(clk,rst_n,state,array0,array1,array2,array3,array4,array5,array6,array7,array8,mask,disobey);
input clk,rst_n;
input [4:0] state;
input [3:0] array0,array1,array2,array3,array4,array5,array6,array7,array8;
output wire [8:0] mask ;
reg [8:0] mask1 ,mask2,mask3,mask4,mask5,mask6,mask7,mask8,mask9 ;

output reg disobey;
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        mask1 <= 9'd511;
        mask2 <= 9'd511;
        mask3 <= 9'd511;
        mask4 <= 9'd511;
        mask5 <= 9'd511;
        mask6 <= 9'd511;
        mask7 <= 9'd511;
        mask8 <= 9'd511;
        mask9 <= 9'd511;
    end
    else begin
        case(state)
        5'd0:begin
                 mask1 <= 9'd511;
                 mask2 <= 9'd511;
                 mask3 <= 9'd511;
                 mask4 <= 9'd511;
                 mask5 <= 9'd511;
                 mask6 <= 9'd511;
                 mask7 <= 9'd511;
                 mask8 <= 9'd511;
                 mask9 <= 9'd511;
            end
        default:begin
            case(array0)
                4'd1:   mask1[0] <= 0;
                4'd2:   mask1[1] <= 0;
                4'd3:   mask1[2] <= 0;
                4'd4:   mask1[3] <= 0;
                4'd5:   mask1[4] <= 0;
                4'd6:   mask1[5] <= 0;
                4'd7:   mask1[6] <= 0;
                4'd8:   mask1[7] <= 0;
                4'd9:   mask1[8] <= 0;    
                default:begin
                        mask1 <= mask1;
                        end
            endcase
            case(array1)
                4'd1:   mask2[0] <= 0;
                4'd2:   mask2[1] <= 0;
                4'd3:   mask2[2] <= 0;
                4'd4:   mask2[3] <= 0;
                4'd5:   mask2[4] <= 0;
                4'd6:   mask2[5] <= 0;
                4'd7:   mask2[6] <= 0;
                4'd8:   mask2[7] <= 0;
                4'd9:   mask2[8] <= 0;    
                default:begin
                        mask2<=mask2;
                        end
            endcase
            case(array2)
                4'd1:   mask3[0] <= 0;
                4'd2:   mask3[1] <= 0;
                4'd3:   mask3[2] <= 0;
                4'd4:   mask3[3] <= 0;
                4'd5:   mask3[4] <= 0;
                4'd6:   mask3[5] <= 0;
                4'd7:   mask3[6] <= 0;
                4'd8:   mask3[7] <= 0;
                4'd9:   mask3[8] <= 0;    
                default:begin
                        mask3<=mask3;
                        end
            endcase
            case(array3)
                4'd1:   mask4[0] <= 0;
                4'd2:   mask4[1] <= 0;
                4'd3:   mask4[2] <= 0;
                4'd4:   mask4[3] <= 0;
                4'd5:   mask4[4] <= 0;
                4'd6:   mask4[5] <= 0;
                4'd7:   mask4[6] <= 0;
                4'd8:   mask4[7] <= 0;
                4'd9:   mask4[8] <= 0;    
                default:begin
                        mask4<=mask4;
                        end
            endcase
            case(array4)
                4'd1:   mask5[0] <= 0;
                4'd2:   mask5[1] <= 0;
                4'd3:   mask5[2] <= 0;
                4'd4:   mask5[3] <= 0;
                4'd5:   mask5[4] <= 0;
                4'd6:   mask5[5] <= 0;
                4'd7:   mask5[6] <= 0;
                4'd8:   mask5[7] <= 0;
                4'd9:   mask5[8] <= 0;    
                default:begin
                        mask5<=mask5;
                        end
            endcase
            case(array5)
                4'd1:   mask6[0] <= 0;
                4'd2:   mask6[1] <= 0;
                4'd3:   mask6[2] <= 0;
                4'd4:   mask6[3] <= 0;
                4'd5:   mask6[4] <= 0;
                4'd6:   mask6[5] <= 0;
                4'd7:   mask6[6] <= 0;
                4'd8:   mask6[7] <= 0;
                4'd9:   mask6[8] <= 0;    
                default:begin
                        mask6<=mask6;
                        end
            endcase
            case(array6)
                4'd1:   mask7[0] <= 0;
                4'd2:   mask7[1] <= 0;
                4'd3:   mask7[2] <= 0;
                4'd4:   mask7[3] <= 0;
                4'd5:   mask7[4] <= 0;
                4'd6:   mask7[5] <= 0;
                4'd7:   mask7[6] <= 0;
                4'd8:   mask7[7] <= 0;
                4'd9:   mask7[8] <= 0;    
                default:begin
                        mask7<=mask7;
                        end
            endcase
            case(array7)
                4'd1:   mask8[0] <= 0;
                4'd2:   mask8[1] <= 0;
                4'd3:   mask8[2] <= 0;
                4'd4:   mask8[3] <= 0;
                4'd5:   mask8[4] <= 0;
                4'd6:   mask8[5] <= 0;
                4'd7:   mask8[6] <= 0;
                4'd8:   mask8[7] <= 0;
                4'd9:   mask8[8] <= 0;    
                default:begin
                        mask8<=mask8;
                        end
            endcase
            case(array8)
                4'd1:   mask9[0] <= 0;
                4'd2:   mask9[1] <= 0;
                4'd3:   mask9[2] <= 0;
                4'd4:   mask9[3] <= 0;
                4'd5:   mask9[4] <= 0;
                4'd6:   mask9[5] <= 0;
                4'd7:   mask9[6] <= 0;
                4'd8:   mask9[7] <= 0;
                4'd9:   mask9[8] <= 0;    
                default:begin
                        mask9<=mask9;
                        end
            endcase
        end
        endcase
    end
end
assign mask = mask1 & mask2 & mask3 & mask4 & mask5 & mask6 & mask7 & mask8 & mask9;
always @(*)
begin
    if((array0 !=0 && array0 == array1) || (array0 !=0 && array0 == array2) || (array0 !=0 && array0 == array3) || (array0 !=0 && array0 == array4) || (array0 !=0 && array0 == array5) || (array0 !=0 && array0 == array6) || (array0 !=0 && array0 == array7) || (array0 !=0 && array0 == array8)
     ||(array1 !=0 && array1 == array2) || (array1 !=0 && array1 == array3) || (array1 !=0 && array1 == array4) || (array1 !=0 && array1 == array5) || (array1 !=0 && array1 == array6) || (array1 !=0 && array1 == array7) || (array1 !=0 && array1 == array8)
     ||(array2 !=0 && array2 == array3) || (array2 !=0 && array2 == array4) || (array2 !=0 && array2 == array5) || (array2 !=0 && array2 == array6) || (array2 !=0 && array2 == array7) || (array2 !=0 && array2 == array8)
     ||(array3 !=0 && array3 == array4) || (array3 !=0 && array3 == array5) || (array3 !=0 && array3 == array6) || (array3 !=0 && array3 == array7) || (array3 !=0 && array3 == array8)
     ||(array4 !=0 && array4 == array5) || (array4 !=0 && array4 == array6) || (array4 !=0 && array4 == array7) || (array4 !=0 && array4 == array8)
     ||(array5 !=0 && array5 == array6) || (array5 !=0 && array5 == array7) || (array5 !=0 && array5 == array8)
     ||(array6 !=0 && array6 == array7) || (array6 !=0 && array6 == array8)
     ||(array7 !=0 && array7 == array8))
        disobey = 1;
     else disobey = 0;
end
endmodule




module ZeroMask(place,row0,row1,row2,row3,row4,row5,row6,row7,row8,r,
                col0,col1,col2,col3,col4,col5,col6,col7,col8,c,
                blc0,blc1,blc2,blc3,blc4,blc5,blc6,blc7,blc8,b,mask,life);
input [6:0] place;
input [8:0] row0,row1,row2,row3,row4,row5,row6,row7,row8,
            col0,col1,col2,col3,col4,col5,col6,col7,col8,
            blc0,blc1,blc2,blc3,blc4,blc5,blc6,blc7,blc8;
output wire [9:0] mask ;
output wire [3:0] r,c,b;
reg [8:0] row,col,blc ;
output wire [3:0] life;
assign r = place / 9;
assign c = place % 9;
assign b = (r/3)*3 + c/3;
always @(*)
begin
    case(r)
        4'd0:  row = row0;  
        4'd1:  row = row1;
        4'd2:  row = row2;
        4'd3:  row = row3;
        4'd4:  row = row4;
        4'd5:  row = row5;
        4'd6:  row = row6;
        4'd7:  row = row7;
        4'd8:  row = row8;
        default:row = 0;
    endcase
    case(c)
        4'd0:  col = col0;  
        4'd1:  col = col1;
        4'd2:  col = col2;
        4'd3:  col = col3;
        4'd4:  col = col4;
        4'd5:  col = col5;
        4'd6:  col = col6;
        4'd7:  col = col7;
        4'd8:  col = col8;
        default:col = 0;
    endcase
    case(b)
        4'd0:  blc = blc0;  
        4'd1:  blc = blc1;
        4'd2:  blc = blc2;
        4'd3:  blc = blc3;
        4'd4:  blc = blc4;
        4'd5:  blc = blc5;
        4'd6:  blc = blc6;
        4'd7:  blc = blc7;
        4'd8:  blc = blc8;
        default:blc = 0;
    endcase
end

assign mask = {1'b1,row & col & blc};
assign life = mask[0] + mask[1] + mask[2] + mask[3] + mask[4] + mask[5] + mask[6] + mask[7] + mask[8];
endmodule         


