`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/10 20:47:10
// Design Name: 
// Module Name: SME
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


module SME(clk,rst_n,chardata,isstring,ispattern,out_valid,match,match_index,clk2
//          ,array_reg0  , 
//           array_reg1  , 
//           array_reg2  , 
//           array_reg3  , 
//           array_reg4  , 
//           array_reg5  , 
//           array_reg6  , 
//           array_reg7  
//       string_reg0  , 
//       string_reg1  , 
//       string_reg2  , 
//       string_reg3  , 
//       string_reg4  , 
//       string_reg5  , 
//       string_reg6  , 
//       string_reg7  , 
//       string_reg8  , 
//       string_reg9  , 
//       string_reg10 , 
//       string_reg11 , 
//       string_reg12 , 
//       string_reg13 , 
//       string_reg14 , 
//       string_reg15 , 
//       string_reg16 , 
//       string_reg17 , 
//       string_reg18 , 
//       string_reg19 , 
//       string_reg20 , 
//       string_reg21 , 
//       string_reg22 , 
//       string_reg23 , 
//       string_reg24 , 
//       string_reg25 , 
//       string_reg26 , 
//       string_reg27 , 
//       string_reg28 , 
//       string_reg29 , 
//       string_reg30 , 
//       string_reg31 
//      ,pattern_reg0,
//       pattern_reg1,///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////;

//       pattern_reg2,
//       pattern_reg3,
//       pattern_reg4,
//       pattern_reg5,
//       pattern_reg6,
//       pattern_reg7
//       pattern0,
//       pattern1,
//       pattern2,
//       pattern3,
//       pattern4,
//       pattern5,
//       pattern6,
////       pattern7,
//      , suma,sumb,sumc,sum_reg,sum_L_reg,sum_R_reg
//      ,sum_star_reg
////      //,sum_L,sum_R
//      ,sum_Ra,sum_Rb,sum_Rc,sum_La,sum_Lb,sum_Lc
//      ,current_state,next_state
//      ,front_reg,back_reg,star_reg
//    ,place,place_L,place_R,f_place
//       ,valid,isback
);
           
input clk;
input rst_n;
input [7:0] chardata;
input isstring;
input ispattern;
output reg match;
output reg [4:0] match_index;
output reg out_valid;
output wire clk2;
//output
 reg [7:0] string0 =0 , string1 =0 , string2 =0 , string3 =0 , string4 =0 , string5=0 , string6 =0 , 
string7  =0 , string8  =0, string9  =0, string10 =0, string11 =0, string12 =0, string13=0, string14 =0, 
string15 =0 , string16 =0, string17 =0, string18 =0, string19 =0, string20 =0, string21=0, string22 =0, 
string23 =0 , string24 =0, string25 =0, string26 =0, string27 =0, string28 =0, string29=0, string30 =0, string31 =0;
//output 
reg [7:0] string_reg0  , string_reg1  , string_reg2  , string_reg3  , string_reg4  , string_reg5  , string_reg6  , 
string_reg7  , string_reg8  , string_reg9  , string_reg10 , string_reg11 , string_reg12 , string_reg13 , string_reg14 , 
string_reg15 , string_reg16 , string_reg17 , string_reg18 , string_reg19 , string_reg20 , string_reg21 , string_reg22 , 
string_reg23 , string_reg24 , string_reg25 , string_reg26 , string_reg27 , string_reg28 , string_reg29 , string_reg30 , string_reg31 ;
//output 
reg [7:0] pattern_reg0, pattern_reg1,pattern_reg2,pattern_reg3,pattern_reg4,pattern_reg5,pattern_reg6,pattern_reg7 ;
//output 
reg [7:0] pattern0 =0, pattern1=0,pattern2=0,pattern3=0,pattern4=0,pattern5=0,pattern6=0,pattern7 =0;
parameter START = 4'd0,STRING = 4'd1,PATTERN = 4'd2, COMP = 4'd3,WAIT = 4'd4, MUL1 = 4'd5, MUL2 = 4'd6,MUL3 = 4'd7, OUT1 = 4'd8;
//output 
reg [3:0] current_state,next_state;
//output 
reg [4:0] d = 0; 
wire e,f,g;

//output 
reg isback;
reg [5:0] flag=0;
reg [2:0] sel=0;
reg [5:0] string_len;
wire [2:0] star_location;
//output 
reg [2:0] last_pattern_place;
//output 
reg [31:0] sum_L_reg,sum_reg,sum_R_reg;
//output
reg [31:0] suma=0,sumb=0,sumc=0;
//output
reg sum_star_reg;
//output
reg [31:0] sum_Ra = 0,sum_Rb = 0,sum_Rc = 0,sum_La = 0,sum_Lb = 0,sum_Lc = 0;
reg sum_temp;
////output 
//reg sum_star;
//output 
wire [31:0] array0,array1,array2,array3,array4,array5,array6,array7;
//output
reg [31:0] array_reg0,array_reg1,array_reg2,array_reg3,array_reg4,array_reg5,array_reg6,array_reg7;
//output 
wire [7:0] front,back,star;
//output 
reg front_reg,back_reg,star_reg;
//output 
wire [4:0] place,place_L,place_R;
//output 
reg [4:0] f_place = 0;
reg to_mul2,to_mul3,done,valid,to_wait,isback2;
//wire insig;
reg match_reg = 0;
reg [31:0] match_index_reg = 0;
ClkDiv U0(.clk(clk),.clk2(clk2),.rst_n(rst_n));
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////     FSM   ////////////////////////////////////////////////////////////////////////         
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)  
    begin 
        current_state <= START;
    end
    else begin
        current_state <= next_state;
    end
end

always @(*) begin
        case(current_state)
            START: begin
                        if(isstring) next_state = STRING;
                        else if(ispattern)   next_state = PATTERN;
                        else next_state = current_state;
                    end
            STRING: begin
                        if(ispattern)  next_state = PATTERN;
                        else next_state = current_state;
                    end
            PATTERN:begin
                        if(!sel)  next_state = COMP;
                        else next_state = current_state;
                    end
            COMP:    begin
                        if(to_wait)  next_state = WAIT;
                        else next_state = current_state;
                    end
            WAIT:    begin
                        if(done)  next_state = MUL1;
                        else next_state = current_state;
                    end
            MUL1:    begin
                        if(to_mul2)  next_state = MUL2;
                        else next_state = current_state;
                    end
            MUL2:    begin
                        if(to_mul3)  next_state = MUL3;
                        else next_state = current_state;
                    end
            MUL3:    begin
                        if(valid)  next_state = OUT1;
                        else next_state = current_state;
                    end
            OUT1:    begin
                        if(isback)  next_state = START;
                        else next_state = current_state;
                    end
            default:    next_state = current_state;
         endcase
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        to_wait <= 0;
        ///////
        front_reg <= 0;
        back_reg  <= 0;
        star_reg  <= 0;
        array_reg0 <= 0;
        array_reg1 <= 0;
        array_reg2 <= 0;
        array_reg3 <= 0;
        array_reg4 <= 0;
        array_reg5 <= 0;
        array_reg6 <= 0;
        array_reg7 <= 0;
        done <= 0;
        ///
        to_mul2 <= 0;
        ///
        sum_reg <=  0;
        sum_R_reg <= 0 ;
        sum_L_reg <= 0;
        to_mul3 <= 0;
        ///
        sum_star_reg <= 0;
        valid <= 0;
        ///
        sum_temp <= 0;
        isback <= 0;
        //
        out_valid <= 0;
        match <= 0;
        match_index <= 0;
    end
    else begin
        case(current_state)
        PATTERN: begin  to_wait <= 1;
        end
        COMP:begin
        front_reg <= |front;
        back_reg  <= |back;
        star_reg  <= |star;
        array_reg0 <= array0;
        array_reg1 <= array1;
        array_reg2 <= array2;
        array_reg3 <= array3;
        array_reg4 <= array4;
        array_reg5 <= array5;
        array_reg6 <= array6;
        array_reg7 <= array7;
        done <= 1;
        end
        WAIT:begin
        to_mul2 <= 1;
        end
        MUL1: begin
        sum_reg <=  suma & sumb & sumc;
        sum_R_reg <= sum_Ra & sum_Rb & sum_Rc ;
        sum_L_reg <= sum_La & sum_Lb & sum_Lc;
        to_mul3 <= 1;
        end
        MUL2: begin
        sum_star_reg <= e & g & f;
        valid <= 1;
        end
        MUL3: begin
        sum_temp <= (sum_reg != 0 || sum_star_reg != 0) ? 1'b1:1'b0;
        end
        OUT1:  begin
        isback <= 1;
        out_valid <= 1;
        match <= match_reg;
        match_index <= match_index_reg;
        end
        default:begin
        to_wait <= 0;
        ///////
        front_reg  <= front_reg ;
        back_reg   <= back_reg  ;
        star_reg   <= star_reg  ;
        array_reg0 <= array_reg0;
        array_reg1 <= array_reg1;
        array_reg2 <= array_reg2;
        array_reg3 <= array_reg3;
        array_reg4 <= array_reg4;
        array_reg5 <= array_reg5;
        array_reg6 <= array_reg6;
        array_reg7 <= array_reg7;
        done <= 0;
        ///
        to_mul2 <= 0;
        ///
        sum_reg   <= sum_reg  ;
        sum_R_reg <= sum_R_reg;
        sum_L_reg <= sum_L_reg;
        to_mul3   <= 0;
        ///
        sum_star_reg <= sum_star_reg;
        valid        <= 0;
        ///
        sum_temp     <= sum_temp;
        isback       <= 0;
        //
        out_valid    <= 0;
        match        <= 0;
        match_index  <= 0;
        end
        endcase
   end
end

/////////////////////  找位子 的 COMB  /////////////////////////////////
wire [1:0] c;
assign c = (front_reg == 0 && place == 0) ? 2'd0:
           (front_reg == 0 && place != 0) ? 2'd1:
                                            2'd2;

First F0(.in(sum_reg),.out(place));
First F1(.in(sum_L_reg),.out(place_L));
Last F2(.in(sum_R_reg),.out(place_R));
/////////////////////  sum_star_reg的COMB  /////////////////////////////////
always @(*)
begin
    case(star_location)
    3'd0: d = 0;
    3'd1:begin
         if(last_pattern_place) d = place_L + star_location;
         else d = place_L + star_location - 1;
         end
    default:d = place_L + star_location - 1;
    endcase
end


assign    e = ((sum_L_reg) != 0) ? 1'b1:1'b0;
assign    f = (sum_R_reg != 0)  ? 1'b1:1'b0;
assign    g = (d <= place_R) ? 1'b1:1'b0;

/////////////////////  求MATCH_INDEX 的COMB  /////////////////////////////////
always @(*)
begin
    if(star_reg == 0)begin
        case(last_pattern_place )  
        3'd0:   f_place = place;
        3'd1:   f_place = place;
        default:begin
            case(c)
            2'd0:   f_place = place;
            2'd1:   f_place = place -1 ;
            default:f_place = place  ;
            endcase
        end
        endcase
    end
    else begin  //star_reg = 1
        case(star_location)
            3'd0:f_place = 0;
            3'd1:f_place = place_L;
            default:begin
            if(!front_reg)      begin//
                if(place_L != 0)
                    f_place = place_L -1 ;
                else
                    f_place = place_L;
            end
            else
                f_place = place_L  ;
            end
        endcase
    end
end
always @(*)
begin
    if (sum_temp) begin
        match_reg = 1;
        match_index_reg = f_place;
    end
    else begin
        match_reg = 0;
        match_index_reg = 0;
    end
end



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////      PUT STRING   ////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

always @(posedge clk)
begin
    if (isstring) // string
    begin
        flag <= flag + 1;   
    end
    else begin
        flag <= 0;
    end
end

always @(posedge clk )
begin
    if(isstring)
    begin
        case(flag)
        5'd0: begin   string0   <= chardata;  end
        5'd1: begin   string1   <= chardata;  end
        5'd2: begin   string2   <= chardata;  end
        5'd3: begin   string3   <= chardata;  end
        5'd4: begin   string4   <= chardata;  end
        5'd5: begin   string5   <= chardata;  end
        5'd6: begin   string6   <= chardata;  end
        5'd7: begin   string7   <= chardata;  end
        5'd8: begin   string8   <= chardata;  end
        5'd9: begin   string9   <= chardata;  end
        5'd10:begin   string10  <= chardata;  end
        5'd11:begin   string11  <= chardata;  end
        5'd12:begin   string12  <= chardata;  end
        5'd13:begin   string13  <= chardata;  end
        5'd14:begin   string14  <= chardata;  end
        5'd15:begin   string15  <= chardata;  end
        5'd16:begin   string16  <= chardata;  end
        5'd17:begin   string17  <= chardata;  end
        5'd18:begin   string18  <= chardata;  end
        5'd19:begin   string19  <= chardata;  end
        5'd20:begin   string20  <= chardata;  end
        5'd21:begin   string21  <= chardata;  end
        5'd22:begin   string22  <= chardata;  end
        5'd23:begin   string23  <= chardata;  end
        5'd24:begin   string24  <= chardata;  end
        5'd25:begin   string25  <= chardata;  end
        5'd26:begin   string26  <= chardata;  end
        5'd27:begin   string27  <= chardata;  end
        5'd28:begin   string28  <= chardata;  end
        5'd29:begin   string29  <= chardata;  end
        5'd30:begin   string30  <= chardata;  end
        5'd31:begin   string31  <= chardata;  end
        endcase
    end
    else begin
        string0  <=  0;
        string1  <=  0;
        string2  <=  0;
        string3  <=  0;
        string4  <=  0;
        string5  <=  0;
        string6  <=  0;
        string7  <=  0;
        string8  <=  0;
        string9  <=  0;
        string10 <= 0;
        string11 <= 0;
        string12 <= 0;
        string13 <= 0;
        string14 <= 0;
        string15 <= 0;
        string16 <= 0;
        string17 <= 0;
        string18 <= 0;
        string19 <= 0;
        string20 <= 0;
        string21 <= 0;
        string22 <= 0;
        string23 <= 0;
        string24 <= 0;
        string25 <= 0;
        string26 <= 0;
        string27 <= 0;
        string28 <= 0;
        string29 <= 0;
        string30 <= 0;
        string31 <= 0;
    end
end

always @(negedge isstring or negedge rst_n)
begin
    if(!rst_n)
    begin
        string_len <= 0;
        string_reg0   <= 0;
        string_reg1   <= 0;
        string_reg2   <= 0;
        string_reg3   <= 0;
        string_reg4   <= 0;
        string_reg5   <= 0;
        string_reg6   <= 0;
        string_reg7   <= 0;
        string_reg8   <= 0;
        string_reg9   <= 0;
        string_reg10  <= 0;
        string_reg11  <= 0;
        string_reg12  <= 0;
        string_reg13  <= 0;
        string_reg14  <= 0;
        string_reg15  <= 0;
        string_reg16  <= 0;
        string_reg17  <= 0;
        string_reg18  <= 0;
        string_reg19  <= 0;
        string_reg20  <= 0;
        string_reg21  <= 0;
        string_reg22  <= 0;
        string_reg23  <= 0;
        string_reg24  <= 0;
        string_reg25  <= 0;
        string_reg26  <= 0;
        string_reg27  <= 0;
        string_reg28  <= 0;
        string_reg29  <= 0;
        string_reg30  <= 0;
        string_reg31  <= 0;
    end
    else begin
        string_len <= flag ;
        string_reg0   <= string0 ;
        string_reg1   <= string1 ;
        string_reg2   <= string2 ;
        string_reg3   <= string3 ;
        string_reg4   <= string4 ;
        string_reg5   <= string5 ;
        string_reg6   <= string6 ;
        string_reg7   <= string7 ;
        string_reg8   <= string8 ;
        string_reg9   <= string9 ;
        string_reg10  <= string10;
        string_reg11  <= string11;
        string_reg12  <= string12;
        string_reg13  <= string13;
        string_reg14  <= string14;
        string_reg15  <= string15;
        string_reg16  <= string16;
        string_reg17  <= string17;
        string_reg18  <= string18;
        string_reg19  <= string19;
        string_reg20  <= string20;
        string_reg21  <= string21;
        string_reg22  <= string22;
        string_reg23  <= string23;
        string_reg24  <= string24;
        string_reg25  <= string25;
        string_reg26  <= string26;
        string_reg27  <= string27;
        string_reg28  <= string28;
        string_reg29  <= string29;
        string_reg30  <= string30;
        string_reg31  <= string31;
    end
end



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////      PUT PATTERN   ////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

always @(posedge clk)
begin
    if (ispattern) // PATTERN
    begin
        sel <= sel + 1;   
    end
    else begin
        sel <= 0;
    end
end
always @(posedge clk )
begin
    if(ispattern == 1)
    begin
        case(sel)
        3'd0: begin   pattern0  <= chardata;  end
        3'd1: begin   pattern1  <= chardata;  end
        3'd2: begin   pattern2  <= chardata;  end
        3'd3: begin   pattern3  <= chardata;  end
        3'd4: begin   pattern4  <= chardata;  end
        3'd5: begin   pattern5  <= chardata;  end
        3'd6: begin   pattern6  <= chardata;  end
        3'd7: begin   pattern7  <= chardata;  end
        endcase
    end
    else begin
        pattern0  <= 0 ;
        pattern1  <= 0 ;
        pattern2  <= 0 ;
        pattern3  <= 0 ;
        pattern4  <= 0 ;
        pattern5  <= 0 ;
        pattern6  <= 0 ;
        pattern7  <= 0 ;
    end
end

always @(negedge rst_n or negedge ispattern)
begin
    if(!rst_n)
    begin
        last_pattern_place <= 0;
        pattern_reg0  <= 0 ;
        pattern_reg1  <= 0 ;
        pattern_reg2  <= 0 ;
        pattern_reg3  <= 0 ;
        pattern_reg4  <= 0 ;
        pattern_reg5  <= 0 ;
        pattern_reg6  <= 0 ;
        pattern_reg7  <= 0 ;
    end
    else begin
        last_pattern_place <= sel -1;
        pattern_reg0  <= pattern0 ;
        pattern_reg1  <= pattern1 ;
        pattern_reg2  <= pattern2 ;
        pattern_reg3  <= pattern3 ;
        pattern_reg4  <= pattern4 ;
        pattern_reg5  <= pattern5 ;
        pattern_reg6  <= pattern6 ;
        pattern_reg7  <= pattern7 ;
    end
end


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////      COMPARE   ///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//比較pattern與string找出字母的位子

Compare C0(.string31(string_reg31),.string30(string_reg30),
           .string29(string_reg29),.string28(string_reg28),.string27(string_reg27),.string26(string_reg26),.string25(string_reg25),
           .string24(string_reg24),.string23(string_reg23),.string22(string_reg22),.string21(string_reg21),.string20(string_reg20),
           .string19(string_reg19),.string18(string_reg18),.string17(string_reg17),.string16(string_reg16),.string15(string_reg15),
           .string14(string_reg14),.string13(string_reg13),.string12(string_reg12),.string11(string_reg11),.string10(string_reg10),
           .string9 (string_reg9 ),.string8 (string_reg8 ),.string7 (string_reg7 ),.string6 (string_reg6 ),.string5 (string_reg5 ),
           .string4 (string_reg4 ),.string3 (string_reg3 ),.string2 (string_reg2 ),.string1 (string_reg1 ),.string0 (string_reg0 ),
           .pattern(pattern_reg0 ),.array(array0),.front(front[0]),.back(back[0]),.string_len(string_len),
           .star(star[0]));
Compare C1(.string31(string_reg31),.string30(string_reg30),
           .string29(string_reg29),.string28(string_reg28),.string27(string_reg27),.string26(string_reg26),.string25(string_reg25),
           .string24(string_reg24),.string23(string_reg23),.string22(string_reg22),.string21(string_reg21),.string20(string_reg20),
           .string19(string_reg19),.string18(string_reg18),.string17(string_reg17),.string16(string_reg16),.string15(string_reg15),
           .string14(string_reg14),.string13(string_reg13),.string12(string_reg12),.string11(string_reg11),.string10(string_reg10),
           .string9 (string_reg9 ),.string8 (string_reg8 ),.string7 (string_reg7 ),.string6 (string_reg6 ),.string5 (string_reg5 ),
           .string4 (string_reg4 ),.string3 (string_reg3 ),.string2 (string_reg2 ),.string1 (string_reg1 ),.string0 (string_reg0 ),
           .pattern(pattern_reg1 ),.array(array1),.front(front[1]),.back(back[1]),.string_len(string_len),
           .star(star[1]));
Compare C2(.string31(string_reg31),.string30(string_reg30),
           .string29(string_reg29),.string28(string_reg28),.string27(string_reg27),.string26(string_reg26),.string25(string_reg25),
           .string24(string_reg24),.string23(string_reg23),.string22(string_reg22),.string21(string_reg21),.string20(string_reg20),
           .string19(string_reg19),.string18(string_reg18),.string17(string_reg17),.string16(string_reg16),.string15(string_reg15),
           .string14(string_reg14),.string13(string_reg13),.string12(string_reg12),.string11(string_reg11),.string10(string_reg10),
           .string9 (string_reg9 ),.string8 (string_reg8 ),.string7 (string_reg7 ),.string6 (string_reg6 ),.string5 (string_reg5 ),
           .string4 (string_reg4 ),.string3 (string_reg3 ),.string2 (string_reg2 ),.string1 (string_reg1 ),.string0 (string_reg0 ),
           .pattern(pattern_reg2 ),.array(array2),.front(front[2]),.back(back[2]),.string_len(string_len),
           .star(star[2]));
Compare C3(.string31(string_reg31),.string30(string_reg30),
           .string29(string_reg29),.string28(string_reg28),.string27(string_reg27),.string26(string_reg26),.string25(string_reg25),
           .string24(string_reg24),.string23(string_reg23),.string22(string_reg22),.string21(string_reg21),.string20(string_reg20),
           .string19(string_reg19),.string18(string_reg18),.string17(string_reg17),.string16(string_reg16),.string15(string_reg15),
           .string14(string_reg14),.string13(string_reg13),.string12(string_reg12),.string11(string_reg11),.string10(string_reg10),
           .string9 (string_reg9 ),.string8 (string_reg8 ),.string7 (string_reg7 ),.string6 (string_reg6 ),.string5 (string_reg5 ),
           .string4 (string_reg4 ),.string3 (string_reg3 ),.string2 (string_reg2 ),.string1 (string_reg1 ),.string0 (string_reg0 ),
           .pattern(pattern_reg3 ),.array(array3),.front(front[3]),.back(back[3]),.string_len(string_len),
           .star(star[3]));              
Compare C4(.string31(string_reg31),.string30(string_reg30),
           .string29(string_reg29),.string28(string_reg28),.string27(string_reg27),.string26(string_reg26),.string25(string_reg25),
           .string24(string_reg24),.string23(string_reg23),.string22(string_reg22),.string21(string_reg21),.string20(string_reg20),
           .string19(string_reg19),.string18(string_reg18),.string17(string_reg17),.string16(string_reg16),.string15(string_reg15),
           .string14(string_reg14),.string13(string_reg13),.string12(string_reg12),.string11(string_reg11),.string10(string_reg10),
           .string9 (string_reg9 ),.string8 (string_reg8 ),.string7 (string_reg7 ),.string6 (string_reg6 ),.string5 (string_reg5 ),
           .string4 (string_reg4 ),.string3 (string_reg3 ),.string2 (string_reg2 ),.string1 (string_reg1 ),.string0 (string_reg0 ),
           .pattern(pattern_reg4 ),.array(array4),.front(front[4]),.back(back[4]),.string_len(string_len),
           .star(star[4]));
Compare C5(.string31(string_reg31),.string30(string_reg30),
           .string29(string_reg29),.string28(string_reg28),.string27(string_reg27),.string26(string_reg26),.string25(string_reg25),
           .string24(string_reg24),.string23(string_reg23),.string22(string_reg22),.string21(string_reg21),.string20(string_reg20),
           .string19(string_reg19),.string18(string_reg18),.string17(string_reg17),.string16(string_reg16),.string15(string_reg15),
           .string14(string_reg14),.string13(string_reg13),.string12(string_reg12),.string11(string_reg11),.string10(string_reg10),
           .string9 (string_reg9 ),.string8 (string_reg8 ),.string7 (string_reg7 ),.string6 (string_reg6 ),.string5 (string_reg5 ),
           .string4 (string_reg4 ),.string3 (string_reg3 ),.string2 (string_reg2 ),.string1 (string_reg1 ),.string0 (string_reg0 ),
           .pattern(pattern_reg5 ),.array(array5),.front(front[5]),.back(back[5]),.string_len(string_len),
           .star(star[5]));
Compare C6(.string31(string_reg31),.string30(string_reg30),
           .string29(string_reg29),.string28(string_reg28),.string27(string_reg27),.string26(string_reg26),.string25(string_reg25),
           .string24(string_reg24),.string23(string_reg23),.string22(string_reg22),.string21(string_reg21),.string20(string_reg20),
           .string19(string_reg19),.string18(string_reg18),.string17(string_reg17),.string16(string_reg16),.string15(string_reg15),
           .string14(string_reg14),.string13(string_reg13),.string12(string_reg12),.string11(string_reg11),.string10(string_reg10),
           .string9 (string_reg9 ),.string8 (string_reg8 ),.string7 (string_reg7 ),.string6 (string_reg6 ),.string5 (string_reg5 ),
           .string4 (string_reg4 ),.string3 (string_reg3 ),.string2 (string_reg2 ),.string1 (string_reg1 ),.string0 (string_reg0 ),
           .pattern(pattern_reg6 ),.array(array6),.front(front[6]),.back(back[6]),.string_len(string_len),
           .star(star[6]));
Compare C7(.string31(string_reg31),.string30(string_reg30),
           .string29(string_reg29),.string28(string_reg28),.string27(string_reg27),.string26(string_reg26),.string25(string_reg25),
           .string24(string_reg24),.string23(string_reg23),.string22(string_reg22),.string21(string_reg21),.string20(string_reg20),
           .string19(string_reg19),.string18(string_reg18),.string17(string_reg17),.string16(string_reg16),.string15(string_reg15),
           .string14(string_reg14),.string13(string_reg13),.string12(string_reg12),.string11(string_reg11),.string10(string_reg10),
           .string9 (string_reg9 ),.string8 (string_reg8 ),.string7 (string_reg7 ),.string6 (string_reg6 ),.string5 (string_reg5 ),
           .string4 (string_reg4 ),.string3 (string_reg3 ),.string2 (string_reg2 ),.string1 (string_reg1 ),.string0 (string_reg0 ),
           .pattern(pattern_reg7 ),.array(array7),.front(front[7]),.back(back[7]),.string_len(string_len),
           .star(star[7]));

assign star_location = (star[0] == 1) ? 3'd0:
                       (star[1] == 1) ? 3'd1:
                       (star[2] == 1) ? 3'd2:
                       (star[3] == 1) ? 3'd3:
                       (star[4] == 1) ? 3'd4:
                       (star[5] == 1) ? 3'd5:
                       (star[6] == 1) ? 3'd6:
                                        3'd7;





///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////      MULTIPLICATION   ///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//比對是否成立
wire [1:0] mode;
assign mode = (front_reg == 1) ? 2'd0:
              (back_reg == 1)  ? 2'd1:
              (star_reg == 1)  ? 2'd2:
                                 2'd3;

always @(*)
begin
    if(star_reg)begin
    case(last_pattern_place)
        3'd0:begin  //只比對一個
                sum_La = 32'hffff_ffff; 
            end
       3'd1:begin  //比對兩個
                    case(star_location)
                        3'd0:begin
                                sum_La = 32'hffff_ffff;
                             end
                        3'd1:begin
                                sum_La = array_reg0;
                             end
                          default:begin
                                sum_La = 0;
                             end
                    endcase
            end
      3'd2:begin  //比對三個
                    case(star_location)
                        3'd0:begin  //*xx
                                sum_La = 32'hffff_ffff;
                             end
                        3'd1:begin  //x*x
                                sum_La = array_reg0;
                             end
                        3'd2:begin  //xx*
                                sum_La[0 ] = front_reg  & array_reg1[0 ];
                                sum_La[1 ] = array_reg0[0 ] & array_reg1[1 ];
                                sum_La[2 ] = array_reg0[1 ] & array_reg1[2 ];
                                sum_La[3 ] = array_reg0[2 ] & array_reg1[3 ];                      
                                sum_La[4 ] = array_reg0[3 ] & array_reg1[4 ];
                                sum_La[5 ] = array_reg0[4 ] & array_reg1[5 ];
                                sum_La[6 ] = array_reg0[5 ] & array_reg1[6 ];
                                sum_La[7 ] = array_reg0[6 ] & array_reg1[7 ];
                                sum_La[8 ] = array_reg0[7 ] & array_reg1[8 ];
                                sum_La[9 ] = array_reg0[8 ] & array_reg1[9 ];
                                sum_La[10] = array_reg0[9 ] & array_reg1[10];
                                sum_La[11] = array_reg0[10] & array_reg1[11];
                                sum_La[12] = array_reg0[11] & array_reg1[12];
                                sum_La[13] = array_reg0[12] & array_reg1[13];
                                sum_La[14] = array_reg0[13] & array_reg1[14];
                                sum_La[15] = array_reg0[14] & array_reg1[15];
                                sum_La[16] = array_reg0[15] & array_reg1[16];
                                sum_La[17] = array_reg0[16] & array_reg1[17];
                                sum_La[18] = array_reg0[17] & array_reg1[18];
                                sum_La[19] = array_reg0[18] & array_reg1[19];
                                sum_La[20] = array_reg0[19] & array_reg1[20];
                                sum_La[21] = array_reg0[20] & array_reg1[21];
                                sum_La[22] = array_reg0[21] & array_reg1[22];
                                sum_La[23] = array_reg0[22] & array_reg1[23];
                                sum_La[24] = array_reg0[23] & array_reg1[24];
                                sum_La[25] = array_reg0[24] & array_reg1[25];
                                sum_La[26] = array_reg0[25] & array_reg1[26];
                                sum_La[27] = array_reg0[26] & array_reg1[27];
                                sum_La[28] = array_reg0[27] & array_reg1[28];
                                sum_La[29] = array_reg0[28] & array_reg1[29];
                                sum_La[30] = array_reg0[29] & array_reg1[30];
                                sum_La[31] = array_reg0[30] & array_reg1[31];
                             end
                          default:begin
                                sum_La = 0;
                             end
                    endcase
            end    
      3'd3:begin  //比對四個
                    case(star_location)
                        3'd0:begin  //*xxx
                                sum_La = 32'hffff_ffff;
                             end
                        3'd1:begin  //x*xx
                                sum_La = array_reg0;
                             end
                        3'd2:begin  //xx*x
                                sum_La[0 ] = front_reg  & array_reg1[0 ];
                                sum_La[1 ] = array_reg0[0 ] & array_reg1[1 ];
                                sum_La[2 ] = array_reg0[1 ] & array_reg1[2 ];
                                sum_La[3 ] = array_reg0[2 ] & array_reg1[3 ];                        
                                sum_La[4 ] = array_reg0[3 ] & array_reg1[4 ];
                                sum_La[5 ] = array_reg0[4 ] & array_reg1[5 ];
                                sum_La[6 ] = array_reg0[5 ] & array_reg1[6 ];
                                sum_La[7 ] = array_reg0[6 ] & array_reg1[7 ];
                                sum_La[8 ] = array_reg0[7 ] & array_reg1[8 ];
                                sum_La[9 ] = array_reg0[8 ] & array_reg1[9 ];
                                sum_La[10] = array_reg0[9 ] & array_reg1[10];
                                sum_La[11] = array_reg0[10] & array_reg1[11];
                                sum_La[12] = array_reg0[11] & array_reg1[12];
                                sum_La[13] = array_reg0[12] & array_reg1[13];
                                sum_La[14] = array_reg0[13] & array_reg1[14];
                                sum_La[15] = array_reg0[14] & array_reg1[15];
                                sum_La[16] = array_reg0[15] & array_reg1[16];
                                sum_La[17] = array_reg0[16] & array_reg1[17];
                                sum_La[18] = array_reg0[17] & array_reg1[18];
                                sum_La[19] = array_reg0[18] & array_reg1[19];
                                sum_La[20] = array_reg0[19] & array_reg1[20];
                                sum_La[21] = array_reg0[20] & array_reg1[21];
                                sum_La[22] = array_reg0[21] & array_reg1[22];
                                sum_La[23] = array_reg0[22] & array_reg1[23];
                                sum_La[24] = array_reg0[23] & array_reg1[24];
                                sum_La[25] = array_reg0[24] & array_reg1[25];
                                sum_La[26] = array_reg0[25] & array_reg1[26];
                                sum_La[27] = array_reg0[26] & array_reg1[27];
                                sum_La[28] = array_reg0[27] & array_reg1[28];
                                sum_La[29] = array_reg0[28] & array_reg1[29];
                                sum_La[30] = array_reg0[29] & array_reg1[30];
                                sum_La[31] = array_reg0[30] & array_reg1[31];
                             end
                        3'd3:begin  //xxx*
                                sum_La[0 ] =       front_reg  & array_reg1[0 ];
                                sum_La[1 ] = array_reg0[0 ] & array_reg1[1 ];
                                sum_La[2 ] = array_reg0[1 ] & array_reg1[2 ];
                                sum_La[3 ] = array_reg0[2 ] & array_reg1[3 ];                        
                                sum_La[4 ] = array_reg0[3 ] & array_reg1[4 ];
                                sum_La[5 ] = array_reg0[4 ] & array_reg1[5 ];
                                sum_La[6 ] = array_reg0[5 ] & array_reg1[6 ];
                                sum_La[7 ] = array_reg0[6 ] & array_reg1[7 ];
                                sum_La[8 ] = array_reg0[7 ] & array_reg1[8 ];
                                sum_La[9 ] = array_reg0[8 ] & array_reg1[9 ];
                                sum_La[10] = array_reg0[9 ] & array_reg1[10];
                                sum_La[11] = array_reg0[10] & array_reg1[11];
                                sum_La[12] = array_reg0[11] & array_reg1[12];
                                sum_La[13] = array_reg0[12] & array_reg1[13];
                                sum_La[14] = array_reg0[13] & array_reg1[14];
                                sum_La[15] = array_reg0[14] & array_reg1[15];
                                sum_La[16] = array_reg0[15] & array_reg1[16];
                                sum_La[17] = array_reg0[16] & array_reg1[17];
                                sum_La[18] = array_reg0[17] & array_reg1[18];
                                sum_La[19] = array_reg0[18] & array_reg1[19];
                                sum_La[20] = array_reg0[19] & array_reg1[20];
                                sum_La[21] = array_reg0[20] & array_reg1[21];
                                sum_La[22] = array_reg0[21] & array_reg1[22];
                                sum_La[23] = array_reg0[22] & array_reg1[23];
                                sum_La[24] = array_reg0[23] & array_reg1[24];
                                sum_La[25] = array_reg0[24] & array_reg1[25];
                                sum_La[26] = array_reg0[25] & array_reg1[26];
                                sum_La[27] = array_reg0[26] & array_reg1[27];
                                sum_La[28] = array_reg0[27] & array_reg1[28];
                                sum_La[29] = array_reg0[28] & array_reg1[29];
                                sum_La[30] = array_reg0[29] & array_reg1[30];
                                sum_La[31] = 0;
                             end
                        default:begin
                                sum_La = 0;
                             end
                    endcase
            end
      3'd4:begin  //比對五個
                    case(star_location)
                        3'd0:begin  //*xxxx
                                sum_La = 32'hffff_ffff;
                             end
                        3'd1:begin  //x*xxx
                                sum_La = array_reg0;
                             end
                        3'd2:begin  //xx*xx
                                sum_La[0 ] =       front_reg  & array_reg1[0 ];  
                                sum_La[1 ] = array_reg0[0 ] & array_reg1[1 ];  
                                sum_La[2 ] = array_reg0[1 ] & array_reg1[2 ];  
                                sum_La[3 ] = array_reg0[2 ] & array_reg1[3 ];                
                                sum_La[4 ] = array_reg0[3 ] & array_reg1[4 ];  
                                sum_La[5 ] = array_reg0[4 ] & array_reg1[5 ];  
                                sum_La[6 ] = array_reg0[5 ] & array_reg1[6 ];  
                                sum_La[7 ] = array_reg0[6 ] & array_reg1[7 ];  
                                sum_La[8 ] = array_reg0[7 ] & array_reg1[8 ];  
                                sum_La[9 ] = array_reg0[8 ] & array_reg1[9 ];  
                                sum_La[10] = array_reg0[9 ] & array_reg1[10];  
                                sum_La[11] = array_reg0[10] & array_reg1[11];  
                                sum_La[12] = array_reg0[11] & array_reg1[12];  
                                sum_La[13] = array_reg0[12] & array_reg1[13];  
                                sum_La[14] = array_reg0[13] & array_reg1[14];  
                                sum_La[15] = array_reg0[14] & array_reg1[15];  
                                sum_La[16] = array_reg0[15] & array_reg1[16];  
                                sum_La[17] = array_reg0[16] & array_reg1[17];  
                                sum_La[18] = array_reg0[17] & array_reg1[18];  
                                sum_La[19] = array_reg0[18] & array_reg1[19];  
                                sum_La[20] = array_reg0[19] & array_reg1[20];  
                                sum_La[21] = array_reg0[20] & array_reg1[21];  
                                sum_La[22] = array_reg0[21] & array_reg1[22];  
                                sum_La[23] = array_reg0[22] & array_reg1[23];  
                                sum_La[24] = array_reg0[23] & array_reg1[24];  
                                sum_La[25] = array_reg0[24] & array_reg1[25];  
                                sum_La[26] = array_reg0[25] & array_reg1[26];  
                                sum_La[27] = array_reg0[26] & array_reg1[27];  
                                sum_La[28] = array_reg0[27] & array_reg1[28];  
                                sum_La[29] = array_reg0[28] & array_reg1[29];  
                                sum_La[30] = array_reg0[29] & array_reg1[30];  
                                sum_La[31] = array_reg0[30] & array_reg1[31];  
                             end
                         3'd3:begin  //xxx*x
                                sum_La[0 ] =       front_reg  & array_reg1[0 ];
                                sum_La[1 ] = array_reg0[0 ] & array_reg1[1 ];
                                sum_La[2 ] = array_reg0[1 ] & array_reg1[2 ];
                                sum_La[3 ] = array_reg0[2 ] & array_reg1[3 ];                        
                                sum_La[4 ] = array_reg0[3 ] & array_reg1[4 ];
                                sum_La[5 ] = array_reg0[4 ] & array_reg1[5 ];
                                sum_La[6 ] = array_reg0[5 ] & array_reg1[6 ];
                                sum_La[7 ] = array_reg0[6 ] & array_reg1[7 ];
                                sum_La[8 ] = array_reg0[7 ] & array_reg1[8 ];
                                sum_La[9 ] = array_reg0[8 ] & array_reg1[9 ];
                                sum_La[10] = array_reg0[9 ] & array_reg1[10];
                                sum_La[11] = array_reg0[10] & array_reg1[11];
                                sum_La[12] = array_reg0[11] & array_reg1[12];
                                sum_La[13] = array_reg0[12] & array_reg1[13];
                                sum_La[14] = array_reg0[13] & array_reg1[14];
                                sum_La[15] = array_reg0[14] & array_reg1[15];
                                sum_La[16] = array_reg0[15] & array_reg1[16];
                                sum_La[17] = array_reg0[16] & array_reg1[17];
                                sum_La[18] = array_reg0[17] & array_reg1[18];
                                sum_La[19] = array_reg0[18] & array_reg1[19];
                                sum_La[20] = array_reg0[19] & array_reg1[20];
                                sum_La[21] = array_reg0[20] & array_reg1[21];
                                sum_La[22] = array_reg0[21] & array_reg1[22];
                                sum_La[23] = array_reg0[22] & array_reg1[23];
                                sum_La[24] = array_reg0[23] & array_reg1[24];
                                sum_La[25] = array_reg0[24] & array_reg1[25];
                                sum_La[26] = array_reg0[25] & array_reg1[26];
                                sum_La[27] = array_reg0[26] & array_reg1[27];
                                sum_La[28] = array_reg0[27] & array_reg1[28];
                                sum_La[29] = array_reg0[28] & array_reg1[29];
                                sum_La[30] = array_reg0[29] & array_reg1[30];
                                sum_La[31] = 0;
                             end
                        3'd4:begin  //xxxx*
                                sum_La[0 ] =       front_reg  & array_reg1[0 ];
                                sum_La[1 ] = array_reg0[0 ] & array_reg1[1 ];
                                sum_La[2 ] = array_reg0[1 ] & array_reg1[2 ];
                                sum_La[3 ] = array_reg0[2 ] & array_reg1[3 ];                        
                                sum_La[4 ] = array_reg0[3 ] & array_reg1[4 ];
                                sum_La[5 ] = array_reg0[4 ] & array_reg1[5 ];
                                sum_La[6 ] = array_reg0[5 ] & array_reg1[6 ];
                                sum_La[7 ] = array_reg0[6 ] & array_reg1[7 ];
                                sum_La[8 ] = array_reg0[7 ] & array_reg1[8 ];
                                sum_La[9 ] = array_reg0[8 ] & array_reg1[9 ];
                                sum_La[10] = array_reg0[9 ] & array_reg1[10];
                                sum_La[11] = array_reg0[10] & array_reg1[11];
                                sum_La[12] = array_reg0[11] & array_reg1[12];
                                sum_La[13] = array_reg0[12] & array_reg1[13];
                                sum_La[14] = array_reg0[13] & array_reg1[14];
                                sum_La[15] = array_reg0[14] & array_reg1[15];
                                sum_La[16] = array_reg0[15] & array_reg1[16];
                                sum_La[17] = array_reg0[16] & array_reg1[17];
                                sum_La[18] = array_reg0[17] & array_reg1[18];
                                sum_La[19] = array_reg0[18] & array_reg1[19];
                                sum_La[20] = array_reg0[19] & array_reg1[20];
                                sum_La[21] = array_reg0[20] & array_reg1[21];
                                sum_La[22] = array_reg0[21] & array_reg1[22];
                                sum_La[23] = array_reg0[22] & array_reg1[23];
                                sum_La[24] = array_reg0[23] & array_reg1[24];
                                sum_La[25] = array_reg0[24] & array_reg1[25];
                                sum_La[26] = array_reg0[25] & array_reg1[26];
                                sum_La[27] = array_reg0[26] & array_reg1[27];
                                sum_La[28] = array_reg0[27] & array_reg1[28];
                                sum_La[29] = array_reg0[28] & array_reg1[29];
                                sum_La[30] = 0;
                                sum_La[31] = 0;
                             end  
                          default:begin
                                sum_La = 0;
                             end
                    endcase
            end
      3'd5:begin  //比對六個
                    case(star_location)
                        3'd0:begin  //*xxxxx
                                sum_La = 32'hffff_ffff;
                             end
                        3'd1:begin  //x*xxxx
                                sum_La = array_reg0;
                             end
                        3'd2:begin  //xx*xxx
                                sum_La[0 ] = front_reg  & array_reg1[0 ];             
                                sum_La[1 ] = array_reg0[0 ] & array_reg1[1 ];       
                                sum_La[2 ] = array_reg0[1 ] & array_reg1[2 ];       
                                sum_La[3 ] = array_reg0[2 ] & array_reg1[3 ];                      
                                sum_La[4 ] = array_reg0[3 ] & array_reg1[4 ];       
                                sum_La[5 ] = array_reg0[4 ] & array_reg1[5 ];       
                                sum_La[6 ] = array_reg0[5 ] & array_reg1[6 ];       
                                sum_La[7 ] = array_reg0[6 ] & array_reg1[7 ];       
                                sum_La[8 ] = array_reg0[7 ] & array_reg1[8 ];       
                                sum_La[9 ] = array_reg0[8 ] & array_reg1[9 ];       
                                sum_La[10] = array_reg0[9 ] & array_reg1[10];       
                                sum_La[11] = array_reg0[10] & array_reg1[11];       
                                sum_La[12] = array_reg0[11] & array_reg1[12];       
                                sum_La[13] = array_reg0[12] & array_reg1[13];       
                                sum_La[14] = array_reg0[13] & array_reg1[14];       
                                sum_La[15] = array_reg0[14] & array_reg1[15];       
                                sum_La[16] = array_reg0[15] & array_reg1[16];       
                                sum_La[17] = array_reg0[16] & array_reg1[17];       
                                sum_La[18] = array_reg0[17] & array_reg1[18];       
                                sum_La[19] = array_reg0[18] & array_reg1[19];       
                                sum_La[20] = array_reg0[19] & array_reg1[20];       
                                sum_La[21] = array_reg0[20] & array_reg1[21];       
                                sum_La[22] = array_reg0[21] & array_reg1[22];       
                                sum_La[23] = array_reg0[22] & array_reg1[23];       
                                sum_La[24] = array_reg0[23] & array_reg1[24];       
                                sum_La[25] = array_reg0[24] & array_reg1[25];       
                                sum_La[26] = array_reg0[25] & array_reg1[26];       
                                sum_La[27] = array_reg0[26] & array_reg1[27];       
                                sum_La[28] = array_reg0[27] & array_reg1[28];       
                                sum_La[29] = array_reg0[28] & array_reg1[29];       
                                sum_La[30] = array_reg0[29] & array_reg1[30];       
                                sum_La[31] = array_reg0[30] & array_reg1[31];       
                             end
                         3'd3:begin  //xxx*xx
                                sum_La[0 ] =       front_reg  & array_reg1[0 ];      
                                sum_La[1 ] = array_reg0[0 ] & array_reg1[1 ];      
                                sum_La[2 ] = array_reg0[1 ] & array_reg1[2 ];      
                                sum_La[3 ] = array_reg0[2 ] & array_reg1[3 ];                       
                                sum_La[4 ] = array_reg0[3 ] & array_reg1[4 ];      
                                sum_La[5 ] = array_reg0[4 ] & array_reg1[5 ];      
                                sum_La[6 ] = array_reg0[5 ] & array_reg1[6 ];      
                                sum_La[7 ] = array_reg0[6 ] & array_reg1[7 ];      
                                sum_La[8 ] = array_reg0[7 ] & array_reg1[8 ];      
                                sum_La[9 ] = array_reg0[8 ] & array_reg1[9 ];      
                                sum_La[10] = array_reg0[9 ] & array_reg1[10];      
                                sum_La[11] = array_reg0[10] & array_reg1[11];      
                                sum_La[12] = array_reg0[11] & array_reg1[12];      
                                sum_La[13] = array_reg0[12] & array_reg1[13];      
                                sum_La[14] = array_reg0[13] & array_reg1[14];      
                                sum_La[15] = array_reg0[14] & array_reg1[15];      
                                sum_La[16] = array_reg0[15] & array_reg1[16];      
                                sum_La[17] = array_reg0[16] & array_reg1[17];      
                                sum_La[18] = array_reg0[17] & array_reg1[18];      
                                sum_La[19] = array_reg0[18] & array_reg1[19];      
                                sum_La[20] = array_reg0[19] & array_reg1[20];      
                                sum_La[21] = array_reg0[20] & array_reg1[21];      
                                sum_La[22] = array_reg0[21] & array_reg1[22];      
                                sum_La[23] = array_reg0[22] & array_reg1[23];      
                                sum_La[24] = array_reg0[23] & array_reg1[24];      
                                sum_La[25] = array_reg0[24] & array_reg1[25];      
                                sum_La[26] = array_reg0[25] & array_reg1[26];      
                                sum_La[27] = array_reg0[26] & array_reg1[27];      
                                sum_La[28] = array_reg0[27] & array_reg1[28];      
                                sum_La[29] = array_reg0[28] & array_reg1[29];      
                                sum_La[30] = array_reg0[29] & array_reg1[30];      
                                sum_La[31] = 0;                                             
                             end
                        3'd4:begin  //xxxx*x
                                sum_La[0 ] =       front_reg  & array_reg1[0 ];
                                sum_La[1 ] = array_reg0[0 ] & array_reg1[1 ];
                                sum_La[2 ] = array_reg0[1 ] & array_reg1[2 ];
                                sum_La[3 ] = array_reg0[2 ] & array_reg1[3 ];                        
                                sum_La[4 ] = array_reg0[3 ] & array_reg1[4 ];
                                sum_La[5 ] = array_reg0[4 ] & array_reg1[5 ];
                                sum_La[6 ] = array_reg0[5 ] & array_reg1[6 ];
                                sum_La[7 ] = array_reg0[6 ] & array_reg1[7 ];
                                sum_La[8 ] = array_reg0[7 ] & array_reg1[8 ];
                                sum_La[9 ] = array_reg0[8 ] & array_reg1[9 ];
                                sum_La[10] = array_reg0[9 ] & array_reg1[10];
                                sum_La[11] = array_reg0[10] & array_reg1[11];
                                sum_La[12] = array_reg0[11] & array_reg1[12];
                                sum_La[13] = array_reg0[12] & array_reg1[13];
                                sum_La[14] = array_reg0[13] & array_reg1[14];
                                sum_La[15] = array_reg0[14] & array_reg1[15];
                                sum_La[16] = array_reg0[15] & array_reg1[16];
                                sum_La[17] = array_reg0[16] & array_reg1[17];
                                sum_La[18] = array_reg0[17] & array_reg1[18];
                                sum_La[19] = array_reg0[18] & array_reg1[19];
                                sum_La[20] = array_reg0[19] & array_reg1[20];
                                sum_La[21] = array_reg0[20] & array_reg1[21];
                                sum_La[22] = array_reg0[21] & array_reg1[22];
                                sum_La[23] = array_reg0[22] & array_reg1[23];
                                sum_La[24] = array_reg0[23] & array_reg1[24];
                                sum_La[25] = array_reg0[24] & array_reg1[25];
                                sum_La[26] = array_reg0[25] & array_reg1[26];
                                sum_La[27] = array_reg0[26] & array_reg1[27];
                                sum_La[28] = array_reg0[27] & array_reg1[28];
                                sum_La[29] = array_reg0[28] & array_reg1[29];
                                sum_La[30] = 0;
                                sum_La[31] = 0;
                             end  
                         3'd5:begin  //xxxxx*
                                sum_La[0 ] =       front_reg  & array_reg1[0 ];
                                sum_La[1 ] = array_reg0[0 ] & array_reg1[1 ];
                                sum_La[2 ] = array_reg0[1 ] & array_reg1[2 ];
                                sum_La[3 ] = array_reg0[2 ] & array_reg1[3 ];                        
                                sum_La[4 ] = array_reg0[3 ] & array_reg1[4 ];
                                sum_La[5 ] = array_reg0[4 ] & array_reg1[5 ];
                                sum_La[6 ] = array_reg0[5 ] & array_reg1[6 ];
                                sum_La[7 ] = array_reg0[6 ] & array_reg1[7 ];
                                sum_La[8 ] = array_reg0[7 ] & array_reg1[8 ];
                                sum_La[9 ] = array_reg0[8 ] & array_reg1[9 ];
                                sum_La[10] = array_reg0[9 ] & array_reg1[10];
                                sum_La[11] = array_reg0[10] & array_reg1[11];
                                sum_La[12] = array_reg0[11] & array_reg1[12];
                                sum_La[13] = array_reg0[12] & array_reg1[13];
                                sum_La[14] = array_reg0[13] & array_reg1[14];
                                sum_La[15] = array_reg0[14] & array_reg1[15];
                                sum_La[16] = array_reg0[15] & array_reg1[16];
                                sum_La[17] = array_reg0[16] & array_reg1[17];
                                sum_La[18] = array_reg0[17] & array_reg1[18];
                                sum_La[19] = array_reg0[18] & array_reg1[19];
                                sum_La[20] = array_reg0[19] & array_reg1[20];
                                sum_La[21] = array_reg0[20] & array_reg1[21];
                                sum_La[22] = array_reg0[21] & array_reg1[22];
                                sum_La[23] = array_reg0[22] & array_reg1[23];
                                sum_La[24] = array_reg0[23] & array_reg1[24];
                                sum_La[25] = array_reg0[24] & array_reg1[25];
                                sum_La[26] = array_reg0[25] & array_reg1[26];
                                sum_La[27] = array_reg0[26] & array_reg1[27];
                                sum_La[28] = array_reg0[27] & array_reg1[28];
                                sum_La[29] = 0;
                                sum_La[30] = 0;
                                sum_La[31] = 0;
                             end  
                          default:begin
                                sum_La = 0;
                             end
                    endcase
            end
      3'd6:begin  //比對七個
                    case(star_location)
                        3'd0:begin  //*xxxxxx
                                sum_La = 32'hffff_ffff;
                             end
                        3'd1:begin  //x*xxxxx
                                sum_La = array_reg0;
                             end
                        3'd2:begin  //xx*xxxx
                                sum_La[0 ] = front_reg  & array_reg1[0 ];            
                                sum_La[1 ] = array_reg0[0 ] & array_reg1[1 ];      
                                sum_La[2 ] = array_reg0[1 ] & array_reg1[2 ];      
                                sum_La[3 ] = array_reg0[2 ] & array_reg1[3 ];                     
                                sum_La[4 ] = array_reg0[3 ] & array_reg1[4 ];      
                                sum_La[5 ] = array_reg0[4 ] & array_reg1[5 ];      
                                sum_La[6 ] = array_reg0[5 ] & array_reg1[6 ];      
                                sum_La[7 ] = array_reg0[6 ] & array_reg1[7 ];      
                                sum_La[8 ] = array_reg0[7 ] & array_reg1[8 ];      
                                sum_La[9 ] = array_reg0[8 ] & array_reg1[9 ];      
                                sum_La[10] = array_reg0[9 ] & array_reg1[10];      
                                sum_La[11] = array_reg0[10] & array_reg1[11];      
                                sum_La[12] = array_reg0[11] & array_reg1[12];      
                                sum_La[13] = array_reg0[12] & array_reg1[13];      
                                sum_La[14] = array_reg0[13] & array_reg1[14];      
                                sum_La[15] = array_reg0[14] & array_reg1[15];      
                                sum_La[16] = array_reg0[15] & array_reg1[16];      
                                sum_La[17] = array_reg0[16] & array_reg1[17];      
                                sum_La[18] = array_reg0[17] & array_reg1[18];      
                                sum_La[19] = array_reg0[18] & array_reg1[19];      
                                sum_La[20] = array_reg0[19] & array_reg1[20];      
                                sum_La[21] = array_reg0[20] & array_reg1[21];      
                                sum_La[22] = array_reg0[21] & array_reg1[22];      
                                sum_La[23] = array_reg0[22] & array_reg1[23];      
                                sum_La[24] = array_reg0[23] & array_reg1[24];      
                                sum_La[25] = array_reg0[24] & array_reg1[25];      
                                sum_La[26] = array_reg0[25] & array_reg1[26];      
                                sum_La[27] = array_reg0[26] & array_reg1[27];      
                                sum_La[28] = array_reg0[27] & array_reg1[28];      
                                sum_La[29] = array_reg0[28] & array_reg1[29];      
                                sum_La[30] = array_reg0[29] & array_reg1[30];      
                                sum_La[31] = array_reg0[30] & array_reg1[31];      
                             end
                         3'd3:begin  //xxx*xxx
                                sum_La[0 ] =       front_reg  & array_reg1[0 ];       
                                sum_La[1 ] = array_reg0[0 ] & array_reg1[1 ];       
                                sum_La[2 ] = array_reg0[1 ] & array_reg1[2 ];       
                                sum_La[3 ] = array_reg0[2 ] & array_reg1[3 ];                      
                                sum_La[4 ] = array_reg0[3 ] & array_reg1[4 ];       
                                sum_La[5 ] = array_reg0[4 ] & array_reg1[5 ];       
                                sum_La[6 ] = array_reg0[5 ] & array_reg1[6 ];       
                                sum_La[7 ] = array_reg0[6 ] & array_reg1[7 ];       
                                sum_La[8 ] = array_reg0[7 ] & array_reg1[8 ];       
                                sum_La[9 ] = array_reg0[8 ] & array_reg1[9 ];       
                                sum_La[10] = array_reg0[9 ] & array_reg1[10];       
                                sum_La[11] = array_reg0[10] & array_reg1[11];       
                                sum_La[12] = array_reg0[11] & array_reg1[12];       
                                sum_La[13] = array_reg0[12] & array_reg1[13];       
                                sum_La[14] = array_reg0[13] & array_reg1[14];       
                                sum_La[15] = array_reg0[14] & array_reg1[15];       
                                sum_La[16] = array_reg0[15] & array_reg1[16];       
                                sum_La[17] = array_reg0[16] & array_reg1[17];       
                                sum_La[18] = array_reg0[17] & array_reg1[18];       
                                sum_La[19] = array_reg0[18] & array_reg1[19];       
                                sum_La[20] = array_reg0[19] & array_reg1[20];       
                                sum_La[21] = array_reg0[20] & array_reg1[21];       
                                sum_La[22] = array_reg0[21] & array_reg1[22];       
                                sum_La[23] = array_reg0[22] & array_reg1[23];       
                                sum_La[24] = array_reg0[23] & array_reg1[24];       
                                sum_La[25] = array_reg0[24] & array_reg1[25];       
                                sum_La[26] = array_reg0[25] & array_reg1[26];       
                                sum_La[27] = array_reg0[26] & array_reg1[27];       
                                sum_La[28] = array_reg0[27] & array_reg1[28];       
                                sum_La[29] = array_reg0[28] & array_reg1[29];       
                                sum_La[30] = array_reg0[29] & array_reg1[30];       
                                sum_La[31] = 0;                                         
                             end
                        3'd4:begin  //xxxx*xx
                                sum_La[0 ] =       front_reg  & array_reg1[0 ];     
                                sum_La[1 ] = array_reg0[0 ] & array_reg1[1 ];     
                                sum_La[2 ] = array_reg0[1 ] & array_reg1[2 ];     
                                sum_La[3 ] = array_reg0[2 ] & array_reg1[3 ];                  
                                sum_La[4 ] = array_reg0[3 ] & array_reg1[4 ];     
                                sum_La[5 ] = array_reg0[4 ] & array_reg1[5 ];     
                                sum_La[6 ] = array_reg0[5 ] & array_reg1[6 ];     
                                sum_La[7 ] = array_reg0[6 ] & array_reg1[7 ];     
                                sum_La[8 ] = array_reg0[7 ] & array_reg1[8 ];     
                                sum_La[9 ] = array_reg0[8 ] & array_reg1[9 ];     
                                sum_La[10] = array_reg0[9 ] & array_reg1[10];     
                                sum_La[11] = array_reg0[10] & array_reg1[11];     
                                sum_La[12] = array_reg0[11] & array_reg1[12];     
                                sum_La[13] = array_reg0[12] & array_reg1[13];     
                                sum_La[14] = array_reg0[13] & array_reg1[14];     
                                sum_La[15] = array_reg0[14] & array_reg1[15];     
                                sum_La[16] = array_reg0[15] & array_reg1[16];     
                                sum_La[17] = array_reg0[16] & array_reg1[17];     
                                sum_La[18] = array_reg0[17] & array_reg1[18];     
                                sum_La[19] = array_reg0[18] & array_reg1[19];     
                                sum_La[20] = array_reg0[19] & array_reg1[20];     
                                sum_La[21] = array_reg0[20] & array_reg1[21];     
                                sum_La[22] = array_reg0[21] & array_reg1[22];     
                                sum_La[23] = array_reg0[22] & array_reg1[23];     
                                sum_La[24] = array_reg0[23] & array_reg1[24];     
                                sum_La[25] = array_reg0[24] & array_reg1[25];     
                                sum_La[26] = array_reg0[25] & array_reg1[26];     
                                sum_La[27] = array_reg0[26] & array_reg1[27];     
                                sum_La[28] = array_reg0[27] & array_reg1[28];     
                                sum_La[29] = array_reg0[28] & array_reg1[29];     
                                sum_La[30] = 0;                                       
                                sum_La[31] = 0;                                       
                             end  
                         3'd5:begin  //xxxxx*x
                                sum_La[0 ] =       front_reg  & array_reg1[0 ];
                                sum_La[1 ] = array_reg0[0 ] & array_reg1[1 ];
                                sum_La[2 ] = array_reg0[1 ] & array_reg1[2 ];
                                sum_La[3 ] = array_reg0[2 ] & array_reg1[3 ];                        
                                sum_La[4 ] = array_reg0[3 ] & array_reg1[4 ];
                                sum_La[5 ] = array_reg0[4 ] & array_reg1[5 ];
                                sum_La[6 ] = array_reg0[5 ] & array_reg1[6 ];
                                sum_La[7 ] = array_reg0[6 ] & array_reg1[7 ];
                                sum_La[8 ] = array_reg0[7 ] & array_reg1[8 ];
                                sum_La[9 ] = array_reg0[8 ] & array_reg1[9 ];
                                sum_La[10] = array_reg0[9 ] & array_reg1[10];
                                sum_La[11] = array_reg0[10] & array_reg1[11];
                                sum_La[12] = array_reg0[11] & array_reg1[12];
                                sum_La[13] = array_reg0[12] & array_reg1[13];
                                sum_La[14] = array_reg0[13] & array_reg1[14];
                                sum_La[15] = array_reg0[14] & array_reg1[15];
                                sum_La[16] = array_reg0[15] & array_reg1[16];
                                sum_La[17] = array_reg0[16] & array_reg1[17];
                                sum_La[18] = array_reg0[17] & array_reg1[18];
                                sum_La[19] = array_reg0[18] & array_reg1[19];
                                sum_La[20] = array_reg0[19] & array_reg1[20];
                                sum_La[21] = array_reg0[20] & array_reg1[21];
                                sum_La[22] = array_reg0[21] & array_reg1[22];
                                sum_La[23] = array_reg0[22] & array_reg1[23];
                                sum_La[24] = array_reg0[23] & array_reg1[24];
                                sum_La[25] = array_reg0[24] & array_reg1[25];
                                sum_La[26] = array_reg0[25] & array_reg1[26];
                                sum_La[27] = array_reg0[26] & array_reg1[27];
                                sum_La[28] = array_reg0[27] & array_reg1[28];
                                sum_La[29] = 0;
                                sum_La[30] = 0;
                                sum_La[31] = 0;
                             end  
                         3'd6:begin  //xxxxxx*
                                sum_La[0 ] =       front_reg  & array_reg1[0 ];
                                sum_La[1 ] = array_reg0[0 ] & array_reg1[1 ];
                                sum_La[2 ] = array_reg0[1 ] & array_reg1[2 ];
                                sum_La[3 ] = array_reg0[2 ] & array_reg1[3 ];                        
                                sum_La[4 ] = array_reg0[3 ] & array_reg1[4 ];
                                sum_La[5 ] = array_reg0[4 ] & array_reg1[5 ];
                                sum_La[6 ] = array_reg0[5 ] & array_reg1[6 ];
                                sum_La[7 ] = array_reg0[6 ] & array_reg1[7 ];
                                sum_La[8 ] = array_reg0[7 ] & array_reg1[8 ];
                                sum_La[9 ] = array_reg0[8 ] & array_reg1[9 ];
                                sum_La[10] = array_reg0[9 ] & array_reg1[10];
                                sum_La[11] = array_reg0[10] & array_reg1[11];
                                sum_La[12] = array_reg0[11] & array_reg1[12];
                                sum_La[13] = array_reg0[12] & array_reg1[13];
                                sum_La[14] = array_reg0[13] & array_reg1[14];
                                sum_La[15] = array_reg0[14] & array_reg1[15];
                                sum_La[16] = array_reg0[15] & array_reg1[16];
                                sum_La[17] = array_reg0[16] & array_reg1[17];
                                sum_La[18] = array_reg0[17] & array_reg1[18];
                                sum_La[19] = array_reg0[18] & array_reg1[19];
                                sum_La[20] = array_reg0[19] & array_reg1[20];
                                sum_La[21] = array_reg0[20] & array_reg1[21];
                                sum_La[22] = array_reg0[21] & array_reg1[22];
                                sum_La[23] = array_reg0[22] & array_reg1[23];
                                sum_La[24] = array_reg0[23] & array_reg1[24];
                                sum_La[25] = array_reg0[24] & array_reg1[25];
                                sum_La[26] = array_reg0[25] & array_reg1[26];
                                sum_La[27] = array_reg0[26] & array_reg1[27];
                                sum_La[28] = 0;
                                sum_La[29] = 0;
                                sum_La[30] = 0;
                                sum_La[31] = 0;
                             end  
                          default:begin
                                sum_La = 0;
                             end
                    endcase
            end
      3'd7:begin  //比對八個
                    case(star_location)
                        3'd0:begin  //*xxxxxxx
                                sum_La = 32'hffff_ffff;
                             end
                        3'd1:begin  //x*xxxxxx
                                sum_La = array_reg0;
                             end
                        3'd2:begin  //xx*xxxxx
                                sum_La[0 ] =       front_reg  & array_reg1[0 ];       
                                sum_La[1 ] = array_reg0[0 ] & array_reg1[1 ];       
                                sum_La[2 ] = array_reg0[1 ] & array_reg1[2 ];       
                                sum_La[3 ] = array_reg0[2 ] & array_reg1[3 ];                      
                                sum_La[4 ] = array_reg0[3 ] & array_reg1[4 ];       
                                sum_La[5 ] = array_reg0[4 ] & array_reg1[5 ];       
                                sum_La[6 ] = array_reg0[5 ] & array_reg1[6 ];       
                                sum_La[7 ] = array_reg0[6 ] & array_reg1[7 ];       
                                sum_La[8 ] = array_reg0[7 ] & array_reg1[8 ];       
                                sum_La[9 ] = array_reg0[8 ] & array_reg1[9 ];       
                                sum_La[10] = array_reg0[9 ] & array_reg1[10];       
                                sum_La[11] = array_reg0[10] & array_reg1[11];       
                                sum_La[12] = array_reg0[11] & array_reg1[12];       
                                sum_La[13] = array_reg0[12] & array_reg1[13];       
                                sum_La[14] = array_reg0[13] & array_reg1[14];       
                                sum_La[15] = array_reg0[14] & array_reg1[15];       
                                sum_La[16] = array_reg0[15] & array_reg1[16];       
                                sum_La[17] = array_reg0[16] & array_reg1[17];       
                                sum_La[18] = array_reg0[17] & array_reg1[18];       
                                sum_La[19] = array_reg0[18] & array_reg1[19];       
                                sum_La[20] = array_reg0[19] & array_reg1[20];       
                                sum_La[21] = array_reg0[20] & array_reg1[21];       
                                sum_La[22] = array_reg0[21] & array_reg1[22];       
                                sum_La[23] = array_reg0[22] & array_reg1[23];       
                                sum_La[24] = array_reg0[23] & array_reg1[24];       
                                sum_La[25] = array_reg0[24] & array_reg1[25];       
                                sum_La[26] = array_reg0[25] & array_reg1[26];       
                                sum_La[27] = array_reg0[26] & array_reg1[27];       
                                sum_La[28] = array_reg0[27] & array_reg1[28];       
                                sum_La[29] = array_reg0[28] & array_reg1[29];       
                                sum_La[30] = array_reg0[29] & array_reg1[30];       
                                sum_La[31] = array_reg0[30] & array_reg1[31];       
                             end
                         3'd3:begin  //xxx*xxxx
                                sum_La[0 ] =       front_reg  & array_reg1[0 ];       
                                sum_La[1 ] = array_reg0[0 ] & array_reg1[1 ];       
                                sum_La[2 ] = array_reg0[1 ] & array_reg1[2 ];       
                                sum_La[3 ] = array_reg0[2 ] & array_reg1[3 ];                       
                                sum_La[4 ] = array_reg0[3 ] & array_reg1[4 ];       
                                sum_La[5 ] = array_reg0[4 ] & array_reg1[5 ];       
                                sum_La[6 ] = array_reg0[5 ] & array_reg1[6 ];       
                                sum_La[7 ] = array_reg0[6 ] & array_reg1[7 ];       
                                sum_La[8 ] = array_reg0[7 ] & array_reg1[8 ];       
                                sum_La[9 ] = array_reg0[8 ] & array_reg1[9 ];       
                                sum_La[10] = array_reg0[9 ] & array_reg1[10];       
                                sum_La[11] = array_reg0[10] & array_reg1[11];       
                                sum_La[12] = array_reg0[11] & array_reg1[12];       
                                sum_La[13] = array_reg0[12] & array_reg1[13];       
                                sum_La[14] = array_reg0[13] & array_reg1[14];       
                                sum_La[15] = array_reg0[14] & array_reg1[15];       
                                sum_La[16] = array_reg0[15] & array_reg1[16];       
                                sum_La[17] = array_reg0[16] & array_reg1[17];       
                                sum_La[18] = array_reg0[17] & array_reg1[18];       
                                sum_La[19] = array_reg0[18] & array_reg1[19];       
                                sum_La[20] = array_reg0[19] & array_reg1[20];       
                                sum_La[21] = array_reg0[20] & array_reg1[21];       
                                sum_La[22] = array_reg0[21] & array_reg1[22];       
                                sum_La[23] = array_reg0[22] & array_reg1[23];       
                                sum_La[24] = array_reg0[23] & array_reg1[24];       
                                sum_La[25] = array_reg0[24] & array_reg1[25];       
                                sum_La[26] = array_reg0[25] & array_reg1[26];       
                                sum_La[27] = array_reg0[26] & array_reg1[27];       
                                sum_La[28] = array_reg0[27] & array_reg1[28];       
                                sum_La[29] = array_reg0[28] & array_reg1[29];       
                                sum_La[30] = array_reg0[29] & array_reg1[30];       
                                sum_La[31] = 0;                                         
                             end
                        3'd4:begin  //xxxx*xxx
                                sum_La[0 ] =       front_reg  & array_reg1[0 ];      
                                sum_La[1 ] = array_reg0[0 ] & array_reg1[1 ];      
                                sum_La[2 ] = array_reg0[1 ] & array_reg1[2 ];      
                                sum_La[3 ] = array_reg0[2 ] & array_reg1[3 ];                       
                                sum_La[4 ] = array_reg0[3 ] & array_reg1[4 ];      
                                sum_La[5 ] = array_reg0[4 ] & array_reg1[5 ];      
                                sum_La[6 ] = array_reg0[5 ] & array_reg1[6 ];      
                                sum_La[7 ] = array_reg0[6 ] & array_reg1[7 ];      
                                sum_La[8 ] = array_reg0[7 ] & array_reg1[8 ];      
                                sum_La[9 ] = array_reg0[8 ] & array_reg1[9 ];      
                                sum_La[10] = array_reg0[9 ] & array_reg1[10];      
                                sum_La[11] = array_reg0[10] & array_reg1[11];      
                                sum_La[12] = array_reg0[11] & array_reg1[12];      
                                sum_La[13] = array_reg0[12] & array_reg1[13];      
                                sum_La[14] = array_reg0[13] & array_reg1[14];      
                                sum_La[15] = array_reg0[14] & array_reg1[15];      
                                sum_La[16] = array_reg0[15] & array_reg1[16];      
                                sum_La[17] = array_reg0[16] & array_reg1[17];      
                                sum_La[18] = array_reg0[17] & array_reg1[18];      
                                sum_La[19] = array_reg0[18] & array_reg1[19];      
                                sum_La[20] = array_reg0[19] & array_reg1[20];      
                                sum_La[21] = array_reg0[20] & array_reg1[21];      
                                sum_La[22] = array_reg0[21] & array_reg1[22];      
                                sum_La[23] = array_reg0[22] & array_reg1[23];      
                                sum_La[24] = array_reg0[23] & array_reg1[24];      
                                sum_La[25] = array_reg0[24] & array_reg1[25];      
                                sum_La[26] = array_reg0[25] & array_reg1[26];      
                                sum_La[27] = array_reg0[26] & array_reg1[27];      
                                sum_La[28] = array_reg0[27] & array_reg1[28];      
                                sum_La[29] = array_reg0[28] & array_reg1[29];      
                                sum_La[30] = 0;                                        
                                sum_La[31] = 0;                                        
                             end  
                         3'd5:begin  //xxxxx*xx
                                sum_La[0 ] =       front_reg  & array_reg1[0 ];     
                                sum_La[1 ] = array_reg0[0 ] & array_reg1[1 ];     
                                sum_La[2 ] = array_reg0[1 ] & array_reg1[2 ];     
                                sum_La[3 ] = array_reg0[2 ] & array_reg1[3 ];                   
                                sum_La[4 ] = array_reg0[3 ] & array_reg1[4 ];     
                                sum_La[5 ] = array_reg0[4 ] & array_reg1[5 ];     
                                sum_La[6 ] = array_reg0[5 ] & array_reg1[6 ];     
                                sum_La[7 ] = array_reg0[6 ] & array_reg1[7 ];     
                                sum_La[8 ] = array_reg0[7 ] & array_reg1[8 ];     
                                sum_La[9 ] = array_reg0[8 ] & array_reg1[9 ];     
                                sum_La[10] = array_reg0[9 ] & array_reg1[10];     
                                sum_La[11] = array_reg0[10] & array_reg1[11];     
                                sum_La[12] = array_reg0[11] & array_reg1[12];     
                                sum_La[13] = array_reg0[12] & array_reg1[13];     
                                sum_La[14] = array_reg0[13] & array_reg1[14];     
                                sum_La[15] = array_reg0[14] & array_reg1[15];     
                                sum_La[16] = array_reg0[15] & array_reg1[16];     
                                sum_La[17] = array_reg0[16] & array_reg1[17];     
                                sum_La[18] = array_reg0[17] & array_reg1[18];     
                                sum_La[19] = array_reg0[18] & array_reg1[19];     
                                sum_La[20] = array_reg0[19] & array_reg1[20];     
                                sum_La[21] = array_reg0[20] & array_reg1[21];     
                                sum_La[22] = array_reg0[21] & array_reg1[22];     
                                sum_La[23] = array_reg0[22] & array_reg1[23];     
                                sum_La[24] = array_reg0[23] & array_reg1[24];     
                                sum_La[25] = array_reg0[24] & array_reg1[25];     
                                sum_La[26] = array_reg0[25] & array_reg1[26];     
                                sum_La[27] = array_reg0[26] & array_reg1[27];     
                                sum_La[28] = array_reg0[27] & array_reg1[28];     
                                sum_La[29] = 0;                                       
                                sum_La[30] = 0;                                       
                                sum_La[31] = 0;                                       
                             end  
                         3'd6:begin  //xxxxxx*x
                                sum_La[0 ] =       front_reg  & array_reg1[0 ];
                                sum_La[1 ] = array_reg0[0 ] & array_reg1[1 ];
                                sum_La[2 ] = array_reg0[1 ] & array_reg1[2 ];
                                sum_La[3 ] = array_reg0[2 ] & array_reg1[3 ];                        
                                sum_La[4 ] = array_reg0[3 ] & array_reg1[4 ];
                                sum_La[5 ] = array_reg0[4 ] & array_reg1[5 ];
                                sum_La[6 ] = array_reg0[5 ] & array_reg1[6 ];
                                sum_La[7 ] = array_reg0[6 ] & array_reg1[7 ];
                                sum_La[8 ] = array_reg0[7 ] & array_reg1[8 ];
                                sum_La[9 ] = array_reg0[8 ] & array_reg1[9 ];
                                sum_La[10] = array_reg0[9 ] & array_reg1[10];
                                sum_La[11] = array_reg0[10] & array_reg1[11];
                                sum_La[12] = array_reg0[11] & array_reg1[12];
                                sum_La[13] = array_reg0[12] & array_reg1[13];
                                sum_La[14] = array_reg0[13] & array_reg1[14];
                                sum_La[15] = array_reg0[14] & array_reg1[15];
                                sum_La[16] = array_reg0[15] & array_reg1[16];
                                sum_La[17] = array_reg0[16] & array_reg1[17];
                                sum_La[18] = array_reg0[17] & array_reg1[18];
                                sum_La[19] = array_reg0[18] & array_reg1[19];
                                sum_La[20] = array_reg0[19] & array_reg1[20];
                                sum_La[21] = array_reg0[20] & array_reg1[21];
                                sum_La[22] = array_reg0[21] & array_reg1[22];
                                sum_La[23] = array_reg0[22] & array_reg1[23];
                                sum_La[24] = array_reg0[23] & array_reg1[24];
                                sum_La[25] = array_reg0[24] & array_reg1[25];
                                sum_La[26] = array_reg0[25] & array_reg1[26];
                                sum_La[27] = array_reg0[26] & array_reg1[27];
                                sum_La[28] = 0;
                                sum_La[29] = 0;
                                sum_La[30] = 0;
                                sum_La[31] = 0;
                             end  
                         3'd7:begin  //xxxxxxx*
                                sum_La[0 ] =       front_reg  & array_reg1[0 ] & array_reg2[1 ];
                                sum_La[1 ] = array_reg0[0 ] & array_reg1[1 ] & array_reg2[2 ];
                                sum_La[2 ] = array_reg0[1 ] & array_reg1[2 ] & array_reg2[3 ];
                                sum_La[3 ] = array_reg0[2 ] & array_reg1[3 ] & array_reg2[4 ];                        
                                sum_La[4 ] = array_reg0[3 ] & array_reg1[4 ] & array_reg2[5 ];
                                sum_La[5 ] = array_reg0[4 ] & array_reg1[5 ] & array_reg2[6 ];
                                sum_La[6 ] = array_reg0[5 ] & array_reg1[6 ] & array_reg2[7 ];
                                sum_La[7 ] = array_reg0[6 ] & array_reg1[7 ] & array_reg2[8 ];
                                sum_La[8 ] = array_reg0[7 ] & array_reg1[8 ] & array_reg2[9 ];
                                sum_La[9 ] = array_reg0[8 ] & array_reg1[9 ] & array_reg2[10];
                                sum_La[10] = array_reg0[9 ] & array_reg1[10] & array_reg2[11];
                                sum_La[11] = array_reg0[10] & array_reg1[11] & array_reg2[12];
                                sum_La[12] = array_reg0[11] & array_reg1[12] & array_reg2[13];
                                sum_La[13] = array_reg0[12] & array_reg1[13] & array_reg2[14];
                                sum_La[14] = array_reg0[13] & array_reg1[14] & array_reg2[15];
                                sum_La[15] = array_reg0[14] & array_reg1[15] & array_reg2[16];
                                sum_La[16] = array_reg0[15] & array_reg1[16] & array_reg2[17];
                                sum_La[17] = array_reg0[16] & array_reg1[17] & array_reg2[18];
                                sum_La[18] = array_reg0[17] & array_reg1[18] & array_reg2[19];
                                sum_La[19] = array_reg0[18] & array_reg1[19] & array_reg2[20];
                                sum_La[20] = array_reg0[19] & array_reg1[20] & array_reg2[21];
                                sum_La[21] = array_reg0[20] & array_reg1[21] & array_reg2[22];
                                sum_La[22] = array_reg0[21] & array_reg1[22] & array_reg2[23];
                                sum_La[23] = array_reg0[22] & array_reg1[23] & array_reg2[24];
                                sum_La[24] = array_reg0[23] & array_reg1[24] & array_reg2[25];
                                sum_La[25] = array_reg0[24] & array_reg1[25] & array_reg2[26];
                                sum_La[26] = array_reg0[25] & array_reg1[26] & array_reg2[27];
                                sum_La[27] = 0;
                                sum_La[28] = 0;
                                sum_La[29] = 0;
                                sum_La[30] = 0;
                                sum_La[31] = 0;
                             end  
                    endcase
            end
   endcase
end
else begin
    sum_La = 0;
end
end

always @(*)
begin
    if(star_reg)begin
    case(last_pattern_place)
        3'd0:begin  //只比對一個
                sum_Ra = 32'hffff_ffff;
            end
       3'd1:begin  //比對兩個
                    case(star_location)
                        3'd0:begin
                                sum_Ra = array_reg1;
                             end
                        3'd1:begin
                                sum_Ra = 32'hffff_ffff;
                             end
                          default:begin
                                sum_Ra = 0;
                             end
                    endcase
            end
      3'd2:begin  //比對三個
                    case(star_location)
                        3'd0:begin  //*xx
                                sum_Ra[0 ] = array_reg1[0 ] & array_reg2[1 ];
                                sum_Ra[1 ] = array_reg1[1 ] & array_reg2[2 ];
                                sum_Ra[2 ] = array_reg1[2 ] & array_reg2[3 ];
                                sum_Ra[3 ] = array_reg1[3 ] & array_reg2[4 ];                        
                                sum_Ra[4 ] = array_reg1[4 ] & array_reg2[5 ];
                                sum_Ra[5 ] = array_reg1[5 ] & array_reg2[6 ];
                                sum_Ra[6 ] = array_reg1[6 ] & array_reg2[7 ];
                                sum_Ra[7 ] = array_reg1[7 ] & array_reg2[8 ];
                                sum_Ra[8 ] = array_reg1[8 ] & array_reg2[9 ];
                                sum_Ra[9 ] = array_reg1[9 ] & array_reg2[10];
                                sum_Ra[10] = array_reg1[10] & array_reg2[11];
                                sum_Ra[11] = array_reg1[11] & array_reg2[12];
                                sum_Ra[12] = array_reg1[12] & array_reg2[13];
                                sum_Ra[13] = array_reg1[13] & array_reg2[14];
                                sum_Ra[14] = array_reg1[14] & array_reg2[15];
                                sum_Ra[15] = array_reg1[15] & array_reg2[16];
                                sum_Ra[16] = array_reg1[16] & array_reg2[17];
                                sum_Ra[17] = array_reg1[17] & array_reg2[18];
                                sum_Ra[18] = array_reg1[18] & array_reg2[19];
                                sum_Ra[19] = array_reg1[19] & array_reg2[20];
                                sum_Ra[20] = array_reg1[20] & array_reg2[21];
                                sum_Ra[21] = array_reg1[21] & array_reg2[22];
                                sum_Ra[22] = array_reg1[22] & array_reg2[23];
                                sum_Ra[23] = array_reg1[23] & array_reg2[24];
                                sum_Ra[24] = array_reg1[24] & array_reg2[25];
                                sum_Ra[25] = array_reg1[25] & array_reg2[26];
                                sum_Ra[26] = array_reg1[26] & array_reg2[27];
                                sum_Ra[27] = array_reg1[27] & array_reg2[28];
                                sum_Ra[28] = array_reg1[28] & array_reg2[29];
                                sum_Ra[29] = array_reg1[29] & array_reg2[30];
                                sum_Ra[30] = array_reg1[30] & array_reg2[31];
                                sum_Ra[31] = array_reg1[31] & back_reg;
                             end
                        3'd1:begin  //x*x
                                sum_Ra = array_reg2;
                             end
                        3'd2:begin  //xx*
                                sum_Ra = 32'hffff_ffff;
                             end
                          default:begin
                                sum_Ra = 0;
                             end
                    endcase
            end    
      3'd3:begin  //比對四個
                    case(star_location)
                        3'd0:begin  //*xxx
                                sum_Ra[0 ] = array_reg1[0 ] & array_reg2[1 ];
                                sum_Ra[1 ] = array_reg1[1 ] & array_reg2[2 ];
                                sum_Ra[2 ] = array_reg1[2 ] & array_reg2[3 ];
                                sum_Ra[3 ] = array_reg1[3 ] & array_reg2[4 ];                        
                                sum_Ra[4 ] = array_reg1[4 ] & array_reg2[5 ];
                                sum_Ra[5 ] = array_reg1[5 ] & array_reg2[6 ];
                                sum_Ra[6 ] = array_reg1[6 ] & array_reg2[7 ];
                                sum_Ra[7 ] = array_reg1[7 ] & array_reg2[8 ];
                                sum_Ra[8 ] = array_reg1[8 ] & array_reg2[9 ];
                                sum_Ra[9 ] = array_reg1[9 ] & array_reg2[10];
                                sum_Ra[10] = array_reg1[10] & array_reg2[11];
                                sum_Ra[11] = array_reg1[11] & array_reg2[12];
                                sum_Ra[12] = array_reg1[12] & array_reg2[13];
                                sum_Ra[13] = array_reg1[13] & array_reg2[14];
                                sum_Ra[14] = array_reg1[14] & array_reg2[15];
                                sum_Ra[15] = array_reg1[15] & array_reg2[16];
                                sum_Ra[16] = array_reg1[16] & array_reg2[17];
                                sum_Ra[17] = array_reg1[17] & array_reg2[18];
                                sum_Ra[18] = array_reg1[18] & array_reg2[19];
                                sum_Ra[19] = array_reg1[19] & array_reg2[20];
                                sum_Ra[20] = array_reg1[20] & array_reg2[21];
                                sum_Ra[21] = array_reg1[21] & array_reg2[22];
                                sum_Ra[22] = array_reg1[22] & array_reg2[23];
                                sum_Ra[23] = array_reg1[23] & array_reg2[24];
                                sum_Ra[24] = array_reg1[24] & array_reg2[25];
                                sum_Ra[25] = array_reg1[25] & array_reg2[26];
                                sum_Ra[26] = array_reg1[26] & array_reg2[27];
                                sum_Ra[27] = array_reg1[27] & array_reg2[28];
                                sum_Ra[28] = array_reg1[28] & array_reg2[29];
                                sum_Ra[29] = array_reg1[29] & array_reg2[30];
                                sum_Ra[30] = array_reg1[30] & array_reg2[31];
                                sum_Ra[31] = 0;
                             end
                        3'd1:begin  //x*xx
                                sum_Ra[0 ] = array_reg2[0 ] & array_reg3[1 ] ;
                                sum_Ra[1 ] = array_reg2[1 ] & array_reg3[2 ] ;
                                sum_Ra[2 ] = array_reg2[2 ] & array_reg3[3 ] ;
                                sum_Ra[3 ] = array_reg2[3 ] & array_reg3[4 ] ;                        
                                sum_Ra[4 ] = array_reg2[4 ] & array_reg3[5 ] ;
                                sum_Ra[5 ] = array_reg2[5 ] & array_reg3[6 ] ;
                                sum_Ra[6 ] = array_reg2[6 ] & array_reg3[7 ] ;
                                sum_Ra[7 ] = array_reg2[7 ] & array_reg3[8 ] ;
                                sum_Ra[8 ] = array_reg2[8 ] & array_reg3[9 ] ;
                                sum_Ra[9 ] = array_reg2[9 ] & array_reg3[10] ;
                                sum_Ra[10] = array_reg2[10] & array_reg3[11] ;
                                sum_Ra[11] = array_reg2[11] & array_reg3[12] ;
                                sum_Ra[12] = array_reg2[12] & array_reg3[13] ;
                                sum_Ra[13] = array_reg2[13] & array_reg3[14] ;
                                sum_Ra[14] = array_reg2[14] & array_reg3[15] ;
                                sum_Ra[15] = array_reg2[15] & array_reg3[16] ;
                                sum_Ra[16] = array_reg2[16] & array_reg3[17] ;
                                sum_Ra[17] = array_reg2[17] & array_reg3[18] ;
                                sum_Ra[18] = array_reg2[18] & array_reg3[19] ;
                                sum_Ra[19] = array_reg2[19] & array_reg3[20] ;
                                sum_Ra[20] = array_reg2[20] & array_reg3[21] ;
                                sum_Ra[21] = array_reg2[21] & array_reg3[22] ;
                                sum_Ra[22] = array_reg2[22] & array_reg3[23] ;
                                sum_Ra[23] = array_reg2[23] & array_reg3[24] ;
                                sum_Ra[24] = array_reg2[24] & array_reg3[25] ;
                                sum_Ra[25] = array_reg2[25] & array_reg3[26] ;
                                sum_Ra[26] = array_reg2[26] & array_reg3[27] ;
                                sum_Ra[27] = array_reg2[27] & array_reg3[28] ;
                                sum_Ra[28] = array_reg2[28] & array_reg3[29] ;
                                sum_Ra[29] = array_reg2[29] & array_reg3[30] ;
                                sum_Ra[30] = array_reg2[30] & array_reg3[31] ;
                                sum_Ra[31] = array_reg2[31] &   back_reg ;
                             end
                        3'd2:begin  //xx*x
                                sum_Ra = array_reg3;
                             end
                        3'd3:begin  //xxx*
                                sum_Ra = 32'hffff_ffff;
                             end
                        default:begin
                                sum_Ra = 0;
                             end
                    endcase
            end
      3'd4:begin  //比對五個
                    case(star_location)
                        3'd0:begin  //*xxxx
                                sum_Ra[0 ] = array_reg1[0 ] & array_reg2[1 ];
                                sum_Ra[1 ] = array_reg1[1 ] & array_reg2[2 ];
                                sum_Ra[2 ] = array_reg1[2 ] & array_reg2[3 ];
                                sum_Ra[3 ] = array_reg1[3 ] & array_reg2[4 ];                        
                                sum_Ra[4 ] = array_reg1[4 ] & array_reg2[5 ];
                                sum_Ra[5 ] = array_reg1[5 ] & array_reg2[6 ];
                                sum_Ra[6 ] = array_reg1[6 ] & array_reg2[7 ];
                                sum_Ra[7 ] = array_reg1[7 ] & array_reg2[8 ];
                                sum_Ra[8 ] = array_reg1[8 ] & array_reg2[9 ];
                                sum_Ra[9 ] = array_reg1[9 ] & array_reg2[10];
                                sum_Ra[10] = array_reg1[10] & array_reg2[11];
                                sum_Ra[11] = array_reg1[11] & array_reg2[12];
                                sum_Ra[12] = array_reg1[12] & array_reg2[13];
                                sum_Ra[13] = array_reg1[13] & array_reg2[14];
                                sum_Ra[14] = array_reg1[14] & array_reg2[15];
                                sum_Ra[15] = array_reg1[15] & array_reg2[16];
                                sum_Ra[16] = array_reg1[16] & array_reg2[17];
                                sum_Ra[17] = array_reg1[17] & array_reg2[18];
                                sum_Ra[18] = array_reg1[18] & array_reg2[19];
                                sum_Ra[19] = array_reg1[19] & array_reg2[20];
                                sum_Ra[20] = array_reg1[20] & array_reg2[21];
                                sum_Ra[21] = array_reg1[21] & array_reg2[22];
                                sum_Ra[22] = array_reg1[22] & array_reg2[23];
                                sum_Ra[23] = array_reg1[23] & array_reg2[24];
                                sum_Ra[24] = array_reg1[24] & array_reg2[25];
                                sum_Ra[25] = array_reg1[25] & array_reg2[26];
                                sum_Ra[26] = array_reg1[26] & array_reg2[27];
                                sum_Ra[27] = array_reg1[27] & array_reg2[28];
                                sum_Ra[28] = array_reg1[28] & array_reg2[29];
                                sum_Ra[29] = array_reg1[29] & array_reg2[30];
                                sum_Ra[30] = 0;
                                sum_Ra[31] = 0;
                             end
                        3'd1:begin  //x*xxx
                                sum_Ra[0 ] = array_reg2[0 ] & array_reg3[1 ];
                                sum_Ra[1 ] = array_reg2[1 ] & array_reg3[2 ];
                                sum_Ra[2 ] = array_reg2[2 ] & array_reg3[3 ];
                                sum_Ra[3 ] = array_reg2[3 ] & array_reg3[4 ];                        
                                sum_Ra[4 ] = array_reg2[4 ] & array_reg3[5 ];
                                sum_Ra[5 ] = array_reg2[5 ] & array_reg3[6 ];
                                sum_Ra[6 ] = array_reg2[6 ] & array_reg3[7 ];
                                sum_Ra[7 ] = array_reg2[7 ] & array_reg3[8 ];
                                sum_Ra[8 ] = array_reg2[8 ] & array_reg3[9 ];
                                sum_Ra[9 ] = array_reg2[9 ] & array_reg3[10];
                                sum_Ra[10] = array_reg2[10] & array_reg3[11];
                                sum_Ra[11] = array_reg2[11] & array_reg3[12];
                                sum_Ra[12] = array_reg2[12] & array_reg3[13];
                                sum_Ra[13] = array_reg2[13] & array_reg3[14];
                                sum_Ra[14] = array_reg2[14] & array_reg3[15];
                                sum_Ra[15] = array_reg2[15] & array_reg3[16];
                                sum_Ra[16] = array_reg2[16] & array_reg3[17];
                                sum_Ra[17] = array_reg2[17] & array_reg3[18];
                                sum_Ra[18] = array_reg2[18] & array_reg3[19];
                                sum_Ra[19] = array_reg2[19] & array_reg3[20];
                                sum_Ra[20] = array_reg2[20] & array_reg3[21];
                                sum_Ra[21] = array_reg2[21] & array_reg3[22];
                                sum_Ra[22] = array_reg2[22] & array_reg3[23];
                                sum_Ra[23] = array_reg2[23] & array_reg3[24];
                                sum_Ra[24] = array_reg2[24] & array_reg3[25];
                                sum_Ra[25] = array_reg2[25] & array_reg3[26];
                                sum_Ra[26] = array_reg2[26] & array_reg3[27];
                                sum_Ra[27] = array_reg2[27] & array_reg3[28];
                                sum_Ra[28] = array_reg2[28] & array_reg3[29];
                                sum_Ra[29] = array_reg2[29] & array_reg3[30];
                                sum_Ra[30] = array_reg2[30] & array_reg3[31];
                                sum_Ra[31] = 0 ;
                             end
                        3'd2:begin  //xx*xx
                                sum_Ra[0 ] = array_reg3[0 ] & array_reg4[1 ] ;
                                sum_Ra[1 ] = array_reg3[1 ] & array_reg4[2 ] ;
                                sum_Ra[2 ] = array_reg3[2 ] & array_reg4[3 ] ;
                                sum_Ra[3 ] = array_reg3[3 ] & array_reg4[4 ] ;                
                                sum_Ra[4 ] = array_reg3[4 ] & array_reg4[5 ] ;
                                sum_Ra[5 ] = array_reg3[5 ] & array_reg4[6 ] ;
                                sum_Ra[6 ] = array_reg3[6 ] & array_reg4[7 ] ;
                                sum_Ra[7 ] = array_reg3[7 ] & array_reg4[8 ] ;
                                sum_Ra[8 ] = array_reg3[8 ] & array_reg4[9 ] ;
                                sum_Ra[9 ] = array_reg3[9 ] & array_reg4[10] ;
                                sum_Ra[10] = array_reg3[10] & array_reg4[11] ;
                                sum_Ra[11] = array_reg3[11] & array_reg4[12] ;
                                sum_Ra[12] = array_reg3[12] & array_reg4[13] ;
                                sum_Ra[13] = array_reg3[13] & array_reg4[14] ;
                                sum_Ra[14] = array_reg3[14] & array_reg4[15] ;
                                sum_Ra[15] = array_reg3[15] & array_reg4[16] ;
                                sum_Ra[16] = array_reg3[16] & array_reg4[17] ;
                                sum_Ra[17] = array_reg3[17] & array_reg4[18] ;
                                sum_Ra[18] = array_reg3[18] & array_reg4[19] ;
                                sum_Ra[19] = array_reg3[19] & array_reg4[20] ;
                                sum_Ra[20] = array_reg3[20] & array_reg4[21] ;
                                sum_Ra[21] = array_reg3[21] & array_reg4[22] ;
                                sum_Ra[22] = array_reg3[22] & array_reg4[23] ;
                                sum_Ra[23] = array_reg3[23] & array_reg4[24] ;
                                sum_Ra[24] = array_reg3[24] & array_reg4[25] ;
                                sum_Ra[25] = array_reg3[25] & array_reg4[26] ;
                                sum_Ra[26] = array_reg3[26] & array_reg4[27] ;
                                sum_Ra[27] = array_reg3[27] & array_reg4[28] ;
                                sum_Ra[28] = array_reg3[28] & array_reg4[29] ;
                                sum_Ra[29] = array_reg3[29] & array_reg4[30] ;
                                sum_Ra[30] = array_reg3[30] & array_reg4[31] ;
                                sum_Ra[31] = array_reg3[31] &   back_reg ;
                             end
                         3'd3:begin  //xxx*x
                                sum_Ra = array_reg4;
                             end
                        3'd4:begin  //xxxx*
                                sum_Ra = 32'hffff_ffff;
                             end  
                          default:begin
                                sum_Ra = 0;
                             end
                    endcase
            end
      3'd5:begin  //比對六個
                    case(star_location)
                        3'd0:begin  //*xxxxx
                                sum_Ra[0 ] = array_reg1[0 ] & array_reg2[1 ];
                                sum_Ra[1 ] = array_reg1[1 ] & array_reg2[2 ];
                                sum_Ra[2 ] = array_reg1[2 ] & array_reg2[3 ];
                                sum_Ra[3 ] = array_reg1[3 ] & array_reg2[4 ];                        
                                sum_Ra[4 ] = array_reg1[4 ] & array_reg2[5 ];
                                sum_Ra[5 ] = array_reg1[5 ] & array_reg2[6 ];
                                sum_Ra[6 ] = array_reg1[6 ] & array_reg2[7 ];
                                sum_Ra[7 ] = array_reg1[7 ] & array_reg2[8 ];
                                sum_Ra[8 ] = array_reg1[8 ] & array_reg2[9 ];
                                sum_Ra[9 ] = array_reg1[9 ] & array_reg2[10];
                                sum_Ra[10] = array_reg1[10] & array_reg2[11];
                                sum_Ra[11] = array_reg1[11] & array_reg2[12];
                                sum_Ra[12] = array_reg1[12] & array_reg2[13];
                                sum_Ra[13] = array_reg1[13] & array_reg2[14];
                                sum_Ra[14] = array_reg1[14] & array_reg2[15];
                                sum_Ra[15] = array_reg1[15] & array_reg2[16];
                                sum_Ra[16] = array_reg1[16] & array_reg2[17];
                                sum_Ra[17] = array_reg1[17] & array_reg2[18];
                                sum_Ra[18] = array_reg1[18] & array_reg2[19];
                                sum_Ra[19] = array_reg1[19] & array_reg2[20];
                                sum_Ra[20] = array_reg1[20] & array_reg2[21];
                                sum_Ra[21] = array_reg1[21] & array_reg2[22];
                                sum_Ra[22] = array_reg1[22] & array_reg2[23];
                                sum_Ra[23] = array_reg1[23] & array_reg2[24];
                                sum_Ra[24] = array_reg1[24] & array_reg2[25];
                                sum_Ra[25] = array_reg1[25] & array_reg2[26];
                                sum_Ra[26] = array_reg1[26] & array_reg2[27];
                                sum_Ra[27] = array_reg1[27] & array_reg2[28];
                                sum_Ra[28] = array_reg1[28] & array_reg2[29];
                                sum_Ra[29] = 0;
                                sum_Ra[30] = 0;
                                sum_Ra[31] = 0;
                             end
                        3'd1:begin  //x*xxxx
                                sum_Ra[0 ] = array_reg2[0 ] & array_reg3[1 ];
                                sum_Ra[1 ] = array_reg2[1 ] & array_reg3[2 ];
                                sum_Ra[2 ] = array_reg2[2 ] & array_reg3[3 ];
                                sum_Ra[3 ] = array_reg2[3 ] & array_reg3[4 ];                        
                                sum_Ra[4 ] = array_reg2[4 ] & array_reg3[5 ];
                                sum_Ra[5 ] = array_reg2[5 ] & array_reg3[6 ];
                                sum_Ra[6 ] = array_reg2[6 ] & array_reg3[7 ];
                                sum_Ra[7 ] = array_reg2[7 ] & array_reg3[8 ];
                                sum_Ra[8 ] = array_reg2[8 ] & array_reg3[9 ];
                                sum_Ra[9 ] = array_reg2[9 ] & array_reg3[10];
                                sum_Ra[10] = array_reg2[10] & array_reg3[11];
                                sum_Ra[11] = array_reg2[11] & array_reg3[12];
                                sum_Ra[12] = array_reg2[12] & array_reg3[13];
                                sum_Ra[13] = array_reg2[13] & array_reg3[14];
                                sum_Ra[14] = array_reg2[14] & array_reg3[15];
                                sum_Ra[15] = array_reg2[15] & array_reg3[16];
                                sum_Ra[16] = array_reg2[16] & array_reg3[17];
                                sum_Ra[17] = array_reg2[17] & array_reg3[18];
                                sum_Ra[18] = array_reg2[18] & array_reg3[19];
                                sum_Ra[19] = array_reg2[19] & array_reg3[20];
                                sum_Ra[20] = array_reg2[20] & array_reg3[21];
                                sum_Ra[21] = array_reg2[21] & array_reg3[22];
                                sum_Ra[22] = array_reg2[22] & array_reg3[23];
                                sum_Ra[23] = array_reg2[23] & array_reg3[24];
                                sum_Ra[24] = array_reg2[24] & array_reg3[25];
                                sum_Ra[25] = array_reg2[25] & array_reg3[26];
                                sum_Ra[26] = array_reg2[26] & array_reg3[27];
                                sum_Ra[27] = array_reg2[27] & array_reg3[28];
                                sum_Ra[28] = array_reg2[28] & array_reg3[29];
                                sum_Ra[29] = array_reg2[29] & array_reg3[30];
                                sum_Ra[30] = 0;
                                sum_Ra[31] = 0 ;
                             end
                        3'd2:begin  //xx*xxx
                                sum_Ra[0 ] = array_reg3[0 ] & array_reg4[1 ];
                                sum_Ra[1 ] = array_reg3[1 ] & array_reg4[2 ];
                                sum_Ra[2 ] = array_reg3[2 ] & array_reg4[3 ];
                                sum_Ra[3 ] = array_reg3[3 ] & array_reg4[4 ];                
                                sum_Ra[4 ] = array_reg3[4 ] & array_reg4[5 ];
                                sum_Ra[5 ] = array_reg3[5 ] & array_reg4[6 ];
                                sum_Ra[6 ] = array_reg3[6 ] & array_reg4[7 ];
                                sum_Ra[7 ] = array_reg3[7 ] & array_reg4[8 ];
                                sum_Ra[8 ] = array_reg3[8 ] & array_reg4[9 ];
                                sum_Ra[9 ] = array_reg3[9 ] & array_reg4[10];
                                sum_Ra[10] = array_reg3[10] & array_reg4[11];
                                sum_Ra[11] = array_reg3[11] & array_reg4[12];
                                sum_Ra[12] = array_reg3[12] & array_reg4[13];
                                sum_Ra[13] = array_reg3[13] & array_reg4[14];
                                sum_Ra[14] = array_reg3[14] & array_reg4[15];
                                sum_Ra[15] = array_reg3[15] & array_reg4[16];
                                sum_Ra[16] = array_reg3[16] & array_reg4[17];
                                sum_Ra[17] = array_reg3[17] & array_reg4[18];
                                sum_Ra[18] = array_reg3[18] & array_reg4[19];
                                sum_Ra[19] = array_reg3[19] & array_reg4[20];
                                sum_Ra[20] = array_reg3[20] & array_reg4[21];
                                sum_Ra[21] = array_reg3[21] & array_reg4[22];
                                sum_Ra[22] = array_reg3[22] & array_reg4[23];
                                sum_Ra[23] = array_reg3[23] & array_reg4[24];
                                sum_Ra[24] = array_reg3[24] & array_reg4[25];
                                sum_Ra[25] = array_reg3[25] & array_reg4[26];
                                sum_Ra[26] = array_reg3[26] & array_reg4[27];
                                sum_Ra[27] = array_reg3[27] & array_reg4[28];
                                sum_Ra[28] = array_reg3[28] & array_reg4[29];
                                sum_Ra[29] = array_reg3[29] & array_reg4[30];
                                sum_Ra[30] = array_reg3[30] & array_reg4[31];
                                sum_Ra[31] = 0;
                             end
                         3'd3:begin  //xxx*xx
                                sum_Ra[0 ] = array_reg4[0 ] & array_reg5[1 ] ; 
                                sum_Ra[1 ] = array_reg4[1 ] & array_reg5[2 ] ; 
                                sum_Ra[2 ] = array_reg4[2 ] & array_reg5[3 ] ; 
                                sum_Ra[3 ] = array_reg4[3 ] & array_reg5[4 ] ;                  
                                sum_Ra[4 ] = array_reg4[4 ] & array_reg5[5 ] ; 
                                sum_Ra[5 ] = array_reg4[5 ] & array_reg5[6 ] ; 
                                sum_Ra[6 ] = array_reg4[6 ] & array_reg5[7 ] ; 
                                sum_Ra[7 ] = array_reg4[7 ] & array_reg5[8 ] ; 
                                sum_Ra[8 ] = array_reg4[8 ] & array_reg5[9 ] ; 
                                sum_Ra[9 ] = array_reg4[9 ] & array_reg5[10] ; 
                                sum_Ra[10] = array_reg4[10] & array_reg5[11] ; 
                                sum_Ra[11] = array_reg4[11] & array_reg5[12] ; 
                                sum_Ra[12] = array_reg4[12] & array_reg5[13] ; 
                                sum_Ra[13] = array_reg4[13] & array_reg5[14] ; 
                                sum_Ra[14] = array_reg4[14] & array_reg5[15] ; 
                                sum_Ra[15] = array_reg4[15] & array_reg5[16] ; 
                                sum_Ra[16] = array_reg4[16] & array_reg5[17] ; 
                                sum_Ra[17] = array_reg4[17] & array_reg5[18] ; 
                                sum_Ra[18] = array_reg4[18] & array_reg5[19] ; 
                                sum_Ra[19] = array_reg4[19] & array_reg5[20] ; 
                                sum_Ra[20] = array_reg4[20] & array_reg5[21] ; 
                                sum_Ra[21] = array_reg4[21] & array_reg5[22] ; 
                                sum_Ra[22] = array_reg4[22] & array_reg5[23] ; 
                                sum_Ra[23] = array_reg4[23] & array_reg5[24] ; 
                                sum_Ra[24] = array_reg4[24] & array_reg5[25] ; 
                                sum_Ra[25] = array_reg4[25] & array_reg5[26] ; 
                                sum_Ra[26] = array_reg4[26] & array_reg5[27] ; 
                                sum_Ra[27] = array_reg4[27] & array_reg5[28] ; 
                                sum_Ra[28] = array_reg4[28] & array_reg5[29] ; 
                                sum_Ra[29] = array_reg4[29] & array_reg5[30] ; 
                                sum_Ra[30] = array_reg4[30] & array_reg5[31] ; 
                                sum_Ra[31] = array_reg4[31] &   back_reg ;            
                             end
                        3'd4:begin  //xxxx*x
                                sum_Ra = array_reg5;
                             end  
                         3'd5:begin  //xxxxx*
                                sum_Ra = 32'hffff_ffff;
                             end  
                          default:begin
                                sum_Ra = 0;
                             end
                    endcase
            end
      3'd6:begin  //比對七個
                    case(star_location)
                        3'd0:begin  //*xxxxxx
                                sum_Ra[0 ] = array_reg1[0 ] & array_reg2[1 ];
                                sum_Ra[1 ] = array_reg1[1 ] & array_reg2[2 ];
                                sum_Ra[2 ] = array_reg1[2 ] & array_reg2[3 ];
                                sum_Ra[3 ] = array_reg1[3 ] & array_reg2[4 ];                        
                                sum_Ra[4 ] = array_reg1[4 ] & array_reg2[5 ];
                                sum_Ra[5 ] = array_reg1[5 ] & array_reg2[6 ];
                                sum_Ra[6 ] = array_reg1[6 ] & array_reg2[7 ];
                                sum_Ra[7 ] = array_reg1[7 ] & array_reg2[8 ];
                                sum_Ra[8 ] = array_reg1[8 ] & array_reg2[9 ];
                                sum_Ra[9 ] = array_reg1[9 ] & array_reg2[10];
                                sum_Ra[10] = array_reg1[10] & array_reg2[11];
                                sum_Ra[11] = array_reg1[11] & array_reg2[12];
                                sum_Ra[12] = array_reg1[12] & array_reg2[13];
                                sum_Ra[13] = array_reg1[13] & array_reg2[14];
                                sum_Ra[14] = array_reg1[14] & array_reg2[15];
                                sum_Ra[15] = array_reg1[15] & array_reg2[16];
                                sum_Ra[16] = array_reg1[16] & array_reg2[17];
                                sum_Ra[17] = array_reg1[17] & array_reg2[18];
                                sum_Ra[18] = array_reg1[18] & array_reg2[19];
                                sum_Ra[19] = array_reg1[19] & array_reg2[20];
                                sum_Ra[20] = array_reg1[20] & array_reg2[21];
                                sum_Ra[21] = array_reg1[21] & array_reg2[22];
                                sum_Ra[22] = array_reg1[22] & array_reg2[23];
                                sum_Ra[23] = array_reg1[23] & array_reg2[24];
                                sum_Ra[24] = array_reg1[24] & array_reg2[25];
                                sum_Ra[25] = array_reg1[25] & array_reg2[26];
                                sum_Ra[26] = array_reg1[26] & array_reg2[27];
                                sum_Ra[27] = array_reg1[27] & array_reg2[28];
                                sum_Ra[28] = 0;
                                sum_Ra[29] = 0;
                                sum_Ra[30] = 0;
                                sum_Ra[31] = 0;
                             end
                        3'd1:begin  //x*xxxxx
                                sum_Ra[0 ] = array_reg2[0 ] & array_reg3[1 ] ;
                                sum_Ra[1 ] = array_reg2[1 ] & array_reg3[2 ] ;
                                sum_Ra[2 ] = array_reg2[2 ] & array_reg3[3 ] ;
                                sum_Ra[3 ] = array_reg2[3 ] & array_reg3[4 ] ;                        
                                sum_Ra[4 ] = array_reg2[4 ] & array_reg3[5 ] ;
                                sum_Ra[5 ] = array_reg2[5 ] & array_reg3[6 ] ;
                                sum_Ra[6 ] = array_reg2[6 ] & array_reg3[7 ] ;
                                sum_Ra[7 ] = array_reg2[7 ] & array_reg3[8 ] ;
                                sum_Ra[8 ] = array_reg2[8 ] & array_reg3[9 ] ;
                                sum_Ra[9 ] = array_reg2[9 ] & array_reg3[10] ;
                                sum_Ra[10] = array_reg2[10] & array_reg3[11] ;
                                sum_Ra[11] = array_reg2[11] & array_reg3[12] ;
                                sum_Ra[12] = array_reg2[12] & array_reg3[13] ;
                                sum_Ra[13] = array_reg2[13] & array_reg3[14] ;
                                sum_Ra[14] = array_reg2[14] & array_reg3[15] ;
                                sum_Ra[15] = array_reg2[15] & array_reg3[16] ;
                                sum_Ra[16] = array_reg2[16] & array_reg3[17] ;
                                sum_Ra[17] = array_reg2[17] & array_reg3[18] ;
                                sum_Ra[18] = array_reg2[18] & array_reg3[19] ;
                                sum_Ra[19] = array_reg2[19] & array_reg3[20] ;
                                sum_Ra[20] = array_reg2[20] & array_reg3[21] ;
                                sum_Ra[21] = array_reg2[21] & array_reg3[22] ;
                                sum_Ra[22] = array_reg2[22] & array_reg3[23] ;
                                sum_Ra[23] = array_reg2[23] & array_reg3[24] ;
                                sum_Ra[24] = array_reg2[24] & array_reg3[25] ;
                                sum_Ra[25] = array_reg2[25] & array_reg3[26] ;
                                sum_Ra[26] = array_reg2[26] & array_reg3[27] ;
                                sum_Ra[27] = array_reg2[27] & array_reg3[28] ;
                                sum_Ra[28] = array_reg2[28] & array_reg3[29] ;
                                sum_Ra[29] = 0;
                                sum_Ra[30] = 0;
                                sum_Ra[31] = 0 ;
                             end
                        3'd2:begin  //xx*xxxx
                                sum_Ra[0 ] = array_reg3[0 ] & array_reg4[1 ] ;
                                sum_Ra[1 ] = array_reg3[1 ] & array_reg4[2 ] ;
                                sum_Ra[2 ] = array_reg3[2 ] & array_reg4[3 ] ;
                                sum_Ra[3 ] = array_reg3[3 ] & array_reg4[4 ] ;                
                                sum_Ra[4 ] = array_reg3[4 ] & array_reg4[5 ] ;
                                sum_Ra[5 ] = array_reg3[5 ] & array_reg4[6 ] ;
                                sum_Ra[6 ] = array_reg3[6 ] & array_reg4[7 ] ;
                                sum_Ra[7 ] = array_reg3[7 ] & array_reg4[8 ] ;
                                sum_Ra[8 ] = array_reg3[8 ] & array_reg4[9 ] ;
                                sum_Ra[9 ] = array_reg3[9 ] & array_reg4[10] ;
                                sum_Ra[10] = array_reg3[10] & array_reg4[11] ;
                                sum_Ra[11] = array_reg3[11] & array_reg4[12] ;
                                sum_Ra[12] = array_reg3[12] & array_reg4[13] ;
                                sum_Ra[13] = array_reg3[13] & array_reg4[14] ;
                                sum_Ra[14] = array_reg3[14] & array_reg4[15] ;
                                sum_Ra[15] = array_reg3[15] & array_reg4[16] ;
                                sum_Ra[16] = array_reg3[16] & array_reg4[17] ;
                                sum_Ra[17] = array_reg3[17] & array_reg4[18] ;
                                sum_Ra[18] = array_reg3[18] & array_reg4[19] ;
                                sum_Ra[19] = array_reg3[19] & array_reg4[20] ;
                                sum_Ra[20] = array_reg3[20] & array_reg4[21] ;
                                sum_Ra[21] = array_reg3[21] & array_reg4[22] ;
                                sum_Ra[22] = array_reg3[22] & array_reg4[23] ;
                                sum_Ra[23] = array_reg3[23] & array_reg4[24] ;
                                sum_Ra[24] = array_reg3[24] & array_reg4[25] ;
                                sum_Ra[25] = array_reg3[25] & array_reg4[26] ;
                                sum_Ra[26] = array_reg3[26] & array_reg4[27] ;
                                sum_Ra[27] = array_reg3[27] & array_reg4[28] ;
                                sum_Ra[28] = array_reg3[28] & array_reg4[29] ;
                                sum_Ra[29] = array_reg3[29] & array_reg4[30] ;
                                sum_Ra[30] = 0;
                                sum_Ra[31] = 0;
                             end
                         3'd3:begin  //xxx*xxx
                                sum_Ra[0 ] = array_reg4[0 ] & array_reg5[1 ]; 
                                sum_Ra[1 ] = array_reg4[1 ] & array_reg5[2 ]; 
                                sum_Ra[2 ] = array_reg4[2 ] & array_reg5[3 ]; 
                                sum_Ra[3 ] = array_reg4[3 ] & array_reg5[4 ];                  
                                sum_Ra[4 ] = array_reg4[4 ] & array_reg5[5 ]; 
                                sum_Ra[5 ] = array_reg4[5 ] & array_reg5[6 ]; 
                                sum_Ra[6 ] = array_reg4[6 ] & array_reg5[7 ]; 
                                sum_Ra[7 ] = array_reg4[7 ] & array_reg5[8 ]; 
                                sum_Ra[8 ] = array_reg4[8 ] & array_reg5[9 ]; 
                                sum_Ra[9 ] = array_reg4[9 ] & array_reg5[10]; 
                                sum_Ra[10] = array_reg4[10] & array_reg5[11]; 
                                sum_Ra[11] = array_reg4[11] & array_reg5[12]; 
                                sum_Ra[12] = array_reg4[12] & array_reg5[13]; 
                                sum_Ra[13] = array_reg4[13] & array_reg5[14]; 
                                sum_Ra[14] = array_reg4[14] & array_reg5[15]; 
                                sum_Ra[15] = array_reg4[15] & array_reg5[16]; 
                                sum_Ra[16] = array_reg4[16] & array_reg5[17]; 
                                sum_Ra[17] = array_reg4[17] & array_reg5[18]; 
                                sum_Ra[18] = array_reg4[18] & array_reg5[19]; 
                                sum_Ra[19] = array_reg4[19] & array_reg5[20]; 
                                sum_Ra[20] = array_reg4[20] & array_reg5[21]; 
                                sum_Ra[21] = array_reg4[21] & array_reg5[22]; 
                                sum_Ra[22] = array_reg4[22] & array_reg5[23]; 
                                sum_Ra[23] = array_reg4[23] & array_reg5[24]; 
                                sum_Ra[24] = array_reg4[24] & array_reg5[25]; 
                                sum_Ra[25] = array_reg4[25] & array_reg5[26]; 
                                sum_Ra[26] = array_reg4[26] & array_reg5[27]; 
                                sum_Ra[27] = array_reg4[27] & array_reg5[28]; 
                                sum_Ra[28] = array_reg4[28] & array_reg5[29]; 
                                sum_Ra[29] = array_reg4[29] & array_reg5[30]; 
                                sum_Ra[30] = array_reg4[30] & array_reg5[31]; 
                                sum_Ra[31] = 0 ;            
                             end
                        3'd4:begin  //xxxx*xx
                                sum_Ra[0 ] = array_reg5[0 ] & array_reg6[1 ] ;
                                sum_Ra[1 ] = array_reg5[1 ] & array_reg6[2 ] ;
                                sum_Ra[2 ] = array_reg5[2 ] & array_reg6[3 ] ;
                                sum_Ra[3 ] = array_reg5[3 ] & array_reg6[4 ] ;                  
                                sum_Ra[4 ] = array_reg5[4 ] & array_reg6[5 ] ;
                                sum_Ra[5 ] = array_reg5[5 ] & array_reg6[6 ] ;
                                sum_Ra[6 ] = array_reg5[6 ] & array_reg6[7 ] ;
                                sum_Ra[7 ] = array_reg5[7 ] & array_reg6[8 ] ;
                                sum_Ra[8 ] = array_reg5[8 ] & array_reg6[9 ] ;
                                sum_Ra[9 ] = array_reg5[9 ] & array_reg6[10] ;
                                sum_Ra[10] = array_reg5[10] & array_reg6[11] ;
                                sum_Ra[11] = array_reg5[11] & array_reg6[12] ;
                                sum_Ra[12] = array_reg5[12] & array_reg6[13] ;
                                sum_Ra[13] = array_reg5[13] & array_reg6[14] ;
                                sum_Ra[14] = array_reg5[14] & array_reg6[15] ;
                                sum_Ra[15] = array_reg5[15] & array_reg6[16] ;
                                sum_Ra[16] = array_reg5[16] & array_reg6[17] ;
                                sum_Ra[17] = array_reg5[17] & array_reg6[18] ;
                                sum_Ra[18] = array_reg5[18] & array_reg6[19] ;
                                sum_Ra[19] = array_reg5[19] & array_reg6[20] ;
                                sum_Ra[20] = array_reg5[20] & array_reg6[21] ;
                                sum_Ra[21] = array_reg5[21] & array_reg6[22] ;
                                sum_Ra[22] = array_reg5[22] & array_reg6[23] ;
                                sum_Ra[23] = array_reg5[23] & array_reg6[24] ;
                                sum_Ra[24] = array_reg5[24] & array_reg6[25] ;
                                sum_Ra[25] = array_reg5[25] & array_reg6[26] ;
                                sum_Ra[26] = array_reg5[26] & array_reg6[27] ;
                                sum_Ra[27] = array_reg5[27] & array_reg6[28] ;
                                sum_Ra[28] = array_reg5[28] & array_reg6[29] ;
                                sum_Ra[29] = array_reg5[29] & array_reg6[30] ;
                                sum_Ra[30] = array_reg5[30] & array_reg6[31] ;
                                sum_Ra[31] = array_reg5[31] &   back_reg ;     
                             end  
                         3'd5:begin  //xxxxx*x
                                sum_Ra = array_reg6;
                             end  
                         3'd6:begin  //xxxxxx*
                                sum_Ra = 32'hffff_ffff;
                             end  
                          default:begin
                                sum_Ra = 0;
                             end
                    endcase
            end
      3'd7:begin  //比對八個
                    case(star_location)
                        3'd0:begin  //*xxxxxxx
                                sum_Ra[0 ] = array_reg1[0 ] & array_reg2[1 ] & array_reg3[2 ];
                                sum_Ra[1 ] = array_reg1[1 ] & array_reg2[2 ] & array_reg3[3 ];
                                sum_Ra[2 ] = array_reg1[2 ] & array_reg2[3 ] & array_reg3[4 ];
                                sum_Ra[3 ] = array_reg1[3 ] & array_reg2[4 ] & array_reg3[5 ];                        
                                sum_Ra[4 ] = array_reg1[4 ] & array_reg2[5 ] & array_reg3[6 ];
                                sum_Ra[5 ] = array_reg1[5 ] & array_reg2[6 ] & array_reg3[7 ];
                                sum_Ra[6 ] = array_reg1[6 ] & array_reg2[7 ] & array_reg3[8 ];
                                sum_Ra[7 ] = array_reg1[7 ] & array_reg2[8 ] & array_reg3[9 ];
                                sum_Ra[8 ] = array_reg1[8 ] & array_reg2[9 ] & array_reg3[10];
                                sum_Ra[9 ] = array_reg1[9 ] & array_reg2[10] & array_reg3[11];
                                sum_Ra[10] = array_reg1[10] & array_reg2[11] & array_reg3[12];
                                sum_Ra[11] = array_reg1[11] & array_reg2[12] & array_reg3[13];
                                sum_Ra[12] = array_reg1[12] & array_reg2[13] & array_reg3[14];
                                sum_Ra[13] = array_reg1[13] & array_reg2[14] & array_reg3[15];
                                sum_Ra[14] = array_reg1[14] & array_reg2[15] & array_reg3[16];
                                sum_Ra[15] = array_reg1[15] & array_reg2[16] & array_reg3[17];
                                sum_Ra[16] = array_reg1[16] & array_reg2[17] & array_reg3[18];
                                sum_Ra[17] = array_reg1[17] & array_reg2[18] & array_reg3[19];
                                sum_Ra[18] = array_reg1[18] & array_reg2[19] & array_reg3[20];
                                sum_Ra[19] = array_reg1[19] & array_reg2[20] & array_reg3[21];
                                sum_Ra[20] = array_reg1[20] & array_reg2[21] & array_reg3[22];
                                sum_Ra[21] = array_reg1[21] & array_reg2[22] & array_reg3[23];
                                sum_Ra[22] = array_reg1[22] & array_reg2[23] & array_reg3[24];
                                sum_Ra[23] = array_reg1[23] & array_reg2[24] & array_reg3[25];
                                sum_Ra[24] = array_reg1[24] & array_reg2[25] & array_reg3[26];
                                sum_Ra[25] = array_reg1[25] & array_reg2[26] & array_reg3[27];
                                sum_Ra[26] = array_reg1[26] & array_reg2[27] & array_reg3[28];
                                sum_Ra[27] = 0;
                                sum_Ra[28] = 0;
                                sum_Ra[29] = 0;
                                sum_Ra[30] = 0;
                                sum_Ra[31] = 0;
                             end
                        3'd1:begin  //x*xxxxxx
                                sum_Ra[0 ] = array_reg2[0 ] & array_reg3[1 ];
                                sum_Ra[1 ] = array_reg2[1 ] & array_reg3[2 ];
                                sum_Ra[2 ] = array_reg2[2 ] & array_reg3[3 ];
                                sum_Ra[3 ] = array_reg2[3 ] & array_reg3[4 ];                        
                                sum_Ra[4 ] = array_reg2[4 ] & array_reg3[5 ];
                                sum_Ra[5 ] = array_reg2[5 ] & array_reg3[6 ];
                                sum_Ra[6 ] = array_reg2[6 ] & array_reg3[7 ];
                                sum_Ra[7 ] = array_reg2[7 ] & array_reg3[8 ];
                                sum_Ra[8 ] = array_reg2[8 ] & array_reg3[9 ];
                                sum_Ra[9 ] = array_reg2[9 ] & array_reg3[10];
                                sum_Ra[10] = array_reg2[10] & array_reg3[11];
                                sum_Ra[11] = array_reg2[11] & array_reg3[12];
                                sum_Ra[12] = array_reg2[12] & array_reg3[13];
                                sum_Ra[13] = array_reg2[13] & array_reg3[14];
                                sum_Ra[14] = array_reg2[14] & array_reg3[15];
                                sum_Ra[15] = array_reg2[15] & array_reg3[16];
                                sum_Ra[16] = array_reg2[16] & array_reg3[17];
                                sum_Ra[17] = array_reg2[17] & array_reg3[18];
                                sum_Ra[18] = array_reg2[18] & array_reg3[19];
                                sum_Ra[19] = array_reg2[19] & array_reg3[20];
                                sum_Ra[20] = array_reg2[20] & array_reg3[21];
                                sum_Ra[21] = array_reg2[21] & array_reg3[22];
                                sum_Ra[22] = array_reg2[22] & array_reg3[23];
                                sum_Ra[23] = array_reg2[23] & array_reg3[24];
                                sum_Ra[24] = array_reg2[24] & array_reg3[25];
                                sum_Ra[25] = array_reg2[25] & array_reg3[26];
                                sum_Ra[26] = array_reg2[26] & array_reg3[27];
                                sum_Ra[27] = array_reg2[27] & array_reg3[28];
                                sum_Ra[28] = 0;
                                sum_Ra[29] = 0;
                                sum_Ra[30] = 0;
                                sum_Ra[31] = 0 ;
                             end
                        3'd2:begin  //xx*xxxxx
                                sum_Ra[0 ] = array_reg3[0 ] & array_reg4[1 ] ;
                                sum_Ra[1 ] = array_reg3[1 ] & array_reg4[2 ] ;
                                sum_Ra[2 ] = array_reg3[2 ] & array_reg4[3 ] ;
                                sum_Ra[3 ] = array_reg3[3 ] & array_reg4[4 ] ;                
                                sum_Ra[4 ] = array_reg3[4 ] & array_reg4[5 ] ;
                                sum_Ra[5 ] = array_reg3[5 ] & array_reg4[6 ] ;
                                sum_Ra[6 ] = array_reg3[6 ] & array_reg4[7 ] ;
                                sum_Ra[7 ] = array_reg3[7 ] & array_reg4[8 ] ;
                                sum_Ra[8 ] = array_reg3[8 ] & array_reg4[9 ] ;
                                sum_Ra[9 ] = array_reg3[9 ] & array_reg4[10] ;
                                sum_Ra[10] = array_reg3[10] & array_reg4[11] ;
                                sum_Ra[11] = array_reg3[11] & array_reg4[12] ;
                                sum_Ra[12] = array_reg3[12] & array_reg4[13] ;
                                sum_Ra[13] = array_reg3[13] & array_reg4[14] ;
                                sum_Ra[14] = array_reg3[14] & array_reg4[15] ;
                                sum_Ra[15] = array_reg3[15] & array_reg4[16] ;
                                sum_Ra[16] = array_reg3[16] & array_reg4[17] ;
                                sum_Ra[17] = array_reg3[17] & array_reg4[18] ;
                                sum_Ra[18] = array_reg3[18] & array_reg4[19] ;
                                sum_Ra[19] = array_reg3[19] & array_reg4[20] ;
                                sum_Ra[20] = array_reg3[20] & array_reg4[21] ;
                                sum_Ra[21] = array_reg3[21] & array_reg4[22] ;
                                sum_Ra[22] = array_reg3[22] & array_reg4[23] ;
                                sum_Ra[23] = array_reg3[23] & array_reg4[24] ;
                                sum_Ra[24] = array_reg3[24] & array_reg4[25] ;
                                sum_Ra[25] = array_reg3[25] & array_reg4[26] ;
                                sum_Ra[26] = array_reg3[26] & array_reg4[27] ;
                                sum_Ra[27] = array_reg3[27] & array_reg4[28] ;
                                sum_Ra[28] = array_reg3[28] & array_reg4[29] ;
                                sum_Ra[29] = 0;
                                sum_Ra[30] = 0;
                                sum_Ra[31] = 0;
                             end
                         3'd3:begin  //xxx*xxxx
                                sum_Ra[0 ] = array_reg4[0 ] & array_reg5[1 ] ; 
                                sum_Ra[1 ] = array_reg4[1 ] & array_reg5[2 ] ; 
                                sum_Ra[2 ] = array_reg4[2 ] & array_reg5[3 ] ; 
                                sum_Ra[3 ] = array_reg4[3 ] & array_reg5[4 ] ;                  
                                sum_Ra[4 ] = array_reg4[4 ] & array_reg5[5 ] ; 
                                sum_Ra[5 ] = array_reg4[5 ] & array_reg5[6 ] ; 
                                sum_Ra[6 ] = array_reg4[6 ] & array_reg5[7 ] ; 
                                sum_Ra[7 ] = array_reg4[7 ] & array_reg5[8 ] ; 
                                sum_Ra[8 ] = array_reg4[8 ] & array_reg5[9 ] ; 
                                sum_Ra[9 ] = array_reg4[9 ] & array_reg5[10] ; 
                                sum_Ra[10] = array_reg4[10] & array_reg5[11] ; 
                                sum_Ra[11] = array_reg4[11] & array_reg5[12] ; 
                                sum_Ra[12] = array_reg4[12] & array_reg5[13] ; 
                                sum_Ra[13] = array_reg4[13] & array_reg5[14] ; 
                                sum_Ra[14] = array_reg4[14] & array_reg5[15] ; 
                                sum_Ra[15] = array_reg4[15] & array_reg5[16] ; 
                                sum_Ra[16] = array_reg4[16] & array_reg5[17] ; 
                                sum_Ra[17] = array_reg4[17] & array_reg5[18] ; 
                                sum_Ra[18] = array_reg4[18] & array_reg5[19] ; 
                                sum_Ra[19] = array_reg4[19] & array_reg5[20] ; 
                                sum_Ra[20] = array_reg4[20] & array_reg5[21] ; 
                                sum_Ra[21] = array_reg4[21] & array_reg5[22] ; 
                                sum_Ra[22] = array_reg4[22] & array_reg5[23] ; 
                                sum_Ra[23] = array_reg4[23] & array_reg5[24] ; 
                                sum_Ra[24] = array_reg4[24] & array_reg5[25] ; 
                                sum_Ra[25] = array_reg4[25] & array_reg5[26] ; 
                                sum_Ra[26] = array_reg4[26] & array_reg5[27] ; 
                                sum_Ra[27] = array_reg4[27] & array_reg5[28] ; 
                                sum_Ra[28] = array_reg4[28] & array_reg5[29] ; 
                                sum_Ra[29] = array_reg4[29] & array_reg5[30] ; 
                                sum_Ra[30] = 0 ; 
                                sum_Ra[31] = 0 ;            
                             end
                        3'd4:begin  //xxxx*xxx
                                sum_Ra[0 ] = array_reg5[0 ] & array_reg6[1 ] ;
                                sum_Ra[1 ] = array_reg5[1 ] & array_reg6[2 ] ;
                                sum_Ra[2 ] = array_reg5[2 ] & array_reg6[3 ] ;
                                sum_Ra[3 ] = array_reg5[3 ] & array_reg6[4 ] ;                  
                                sum_Ra[4 ] = array_reg5[4 ] & array_reg6[5 ] ;
                                sum_Ra[5 ] = array_reg5[5 ] & array_reg6[6 ] ;
                                sum_Ra[6 ] = array_reg5[6 ] & array_reg6[7 ] ;
                                sum_Ra[7 ] = array_reg5[7 ] & array_reg6[8 ] ;
                                sum_Ra[8 ] = array_reg5[8 ] & array_reg6[9 ] ;
                                sum_Ra[9 ] = array_reg5[9 ] & array_reg6[10] ;
                                sum_Ra[10] = array_reg5[10] & array_reg6[11] ;
                                sum_Ra[11] = array_reg5[11] & array_reg6[12] ;
                                sum_Ra[12] = array_reg5[12] & array_reg6[13] ;
                                sum_Ra[13] = array_reg5[13] & array_reg6[14] ;
                                sum_Ra[14] = array_reg5[14] & array_reg6[15] ;
                                sum_Ra[15] = array_reg5[15] & array_reg6[16] ;
                                sum_Ra[16] = array_reg5[16] & array_reg6[17] ;
                                sum_Ra[17] = array_reg5[17] & array_reg6[18] ;
                                sum_Ra[18] = array_reg5[18] & array_reg6[19] ;
                                sum_Ra[19] = array_reg5[19] & array_reg6[20] ;
                                sum_Ra[20] = array_reg5[20] & array_reg6[21] ;
                                sum_Ra[21] = array_reg5[21] & array_reg6[22] ;
                                sum_Ra[22] = array_reg5[22] & array_reg6[23] ;
                                sum_Ra[23] = array_reg5[23] & array_reg6[24] ;
                                sum_Ra[24] = array_reg5[24] & array_reg6[25] ;
                                sum_Ra[25] = array_reg5[25] & array_reg6[26] ;
                                sum_Ra[26] = array_reg5[26] & array_reg6[27] ;
                                sum_Ra[27] = array_reg5[27] & array_reg6[28] ;
                                sum_Ra[28] = array_reg5[28] & array_reg6[29] ;
                                sum_Ra[29] = array_reg5[29] & array_reg6[30] ;
                                sum_Ra[30] = array_reg5[30] & array_reg6[31] ;
                                sum_Ra[31] = 0;     
                             end  
                         3'd5:begin  //xxxxx*xx
                                sum_Ra[0 ] = array_reg6[0 ] & array_reg7[1 ] ;
                                sum_Ra[1 ] = array_reg6[1 ] & array_reg7[2 ] ;
                                sum_Ra[2 ] = array_reg6[2 ] & array_reg7[3 ] ;
                                sum_Ra[3 ] = array_reg6[3 ] & array_reg7[4 ] ;                   
                                sum_Ra[4 ] = array_reg6[4 ] & array_reg7[5 ] ;
                                sum_Ra[5 ] = array_reg6[5 ] & array_reg7[6 ] ;
                                sum_Ra[6 ] = array_reg6[6 ] & array_reg7[7 ] ;
                                sum_Ra[7 ] = array_reg6[7 ] & array_reg7[8 ] ;
                                sum_Ra[8 ] = array_reg6[8 ] & array_reg7[9 ] ;
                                sum_Ra[9 ] = array_reg6[9 ] & array_reg7[10] ;
                                sum_Ra[10] = array_reg6[10] & array_reg7[11] ;
                                sum_Ra[11] = array_reg6[11] & array_reg7[12] ;
                                sum_Ra[12] = array_reg6[12] & array_reg7[13] ;
                                sum_Ra[13] = array_reg6[13] & array_reg7[14] ;
                                sum_Ra[14] = array_reg6[14] & array_reg7[15] ;
                                sum_Ra[15] = array_reg6[15] & array_reg7[16] ;
                                sum_Ra[16] = array_reg6[16] & array_reg7[17] ;
                                sum_Ra[17] = array_reg6[17] & array_reg7[18] ;
                                sum_Ra[18] = array_reg6[18] & array_reg7[19] ;
                                sum_Ra[19] = array_reg6[19] & array_reg7[20] ;
                                sum_Ra[20] = array_reg6[20] & array_reg7[21] ;
                                sum_Ra[21] = array_reg6[21] & array_reg7[22] ;
                                sum_Ra[22] = array_reg6[22] & array_reg7[23] ;
                                sum_Ra[23] = array_reg6[23] & array_reg7[24] ;
                                sum_Ra[24] = array_reg6[24] & array_reg7[25] ;
                                sum_Ra[25] = array_reg6[25] & array_reg7[26] ;
                                sum_Ra[26] = array_reg6[26] & array_reg7[27] ;
                                sum_Ra[27] = array_reg6[27] & array_reg7[28] ;
                                sum_Ra[28] = array_reg6[28] & array_reg7[29] ;
                                sum_Ra[29] = array_reg6[29] & array_reg7[30] ;
                                sum_Ra[30] = array_reg6[30] & array_reg7[31] ;
                                sum_Ra[31] = array_reg6[31] &   back_reg ;
                             end  
                         3'd6:begin  //xxxxxx*x
                                sum_Ra = array_reg7;
                             end  
                         3'd7:begin  //xxxxxxx*
                                sum_Ra = 32'hffff_ffff;
                             end  
                    endcase
            end
   endcase
end
else begin
    sum_Ra = 0;
end
end

always @(*)
begin
    if(star_reg)begin
    case(last_pattern_place)
      3'd3:begin  //比對四個
                    case(star_location)
                        3'd0:begin  //*xxx
                                sum_Lb = 32'hffff_ffff;
                             end
                        3'd1:begin  //x*xx
                                sum_Lb = 32'hffff_ffff;
                             end
                        3'd2:begin  //xx*x
                                sum_Lb = 32'hffff_ffff;
                             end
                        3'd3:begin  //xxx*
                                sum_Lb[0 ] = array_reg2[1 ];
                                sum_Lb[1 ] = array_reg2[2 ];
                                sum_Lb[2 ] = array_reg2[3 ];
                                sum_Lb[3 ] = array_reg2[4 ];                        
                                sum_Lb[4 ] = array_reg2[5 ];
                                sum_Lb[5 ] = array_reg2[6 ];
                                sum_Lb[6 ] = array_reg2[7 ];
                                sum_Lb[7 ] = array_reg2[8 ];
                                sum_Lb[8 ] = array_reg2[9 ];
                                sum_Lb[9 ] = array_reg2[10];
                                sum_Lb[10] = array_reg2[11];
                                sum_Lb[11] = array_reg2[12];
                                sum_Lb[12] = array_reg2[13];
                                sum_Lb[13] = array_reg2[14];
                                sum_Lb[14] = array_reg2[15];
                                sum_Lb[15] = array_reg2[16];
                                sum_Lb[16] = array_reg2[17];
                                sum_Lb[17] = array_reg2[18];
                                sum_Lb[18] = array_reg2[19];
                                sum_Lb[19] = array_reg2[20];
                                sum_Lb[20] = array_reg2[21];
                                sum_Lb[21] = array_reg2[22];
                                sum_Lb[22] = array_reg2[23];
                                sum_Lb[23] = array_reg2[24];
                                sum_Lb[24] = array_reg2[25];
                                sum_Lb[25] = array_reg2[26];
                                sum_Lb[26] = array_reg2[27];
                                sum_Lb[27] = array_reg2[28];
                                sum_Lb[28] = array_reg2[29];
                                sum_Lb[29] = array_reg2[30];
                                sum_Lb[30] = array_reg2[31];
                                sum_Lb[31] = 0;
                             end
                        default:begin
                                sum_Lb = 0;
                             end
                    endcase
            end
      3'd4:begin  //比對五個
                    case(star_location)
                        3'd0:begin  //*xxxx
                                sum_Lb = 32'hffff_ffff;
                             end
                        3'd1:begin  //x*xxx
                                sum_Lb = 32'hffff_ffff;
                             end
                        3'd2:begin  //xx*xx
                                sum_Lb = 32'hffff_ffff;
                             end
                         3'd3:begin  //xxx*x
                                sum_Lb[0 ] = array_reg2[1 ];
                                sum_Lb[1 ] = array_reg2[2 ];
                                sum_Lb[2 ] = array_reg2[3 ];
                                sum_Lb[3 ] = array_reg2[4 ];                        
                                sum_Lb[4 ] = array_reg2[5 ];
                                sum_Lb[5 ] = array_reg2[6 ];
                                sum_Lb[6 ] = array_reg2[7 ];
                                sum_Lb[7 ] = array_reg2[8 ];
                                sum_Lb[8 ] = array_reg2[9 ];
                                sum_Lb[9 ] = array_reg2[10];
                                sum_Lb[10] = array_reg2[11];
                                sum_Lb[11] = array_reg2[12];
                                sum_Lb[12] = array_reg2[13];
                                sum_Lb[13] = array_reg2[14];
                                sum_Lb[14] = array_reg2[15];
                                sum_Lb[15] = array_reg2[16];
                                sum_Lb[16] = array_reg2[17];
                                sum_Lb[17] = array_reg2[18];
                                sum_Lb[18] = array_reg2[19];
                                sum_Lb[19] = array_reg2[20];
                                sum_Lb[20] = array_reg2[21];
                                sum_Lb[21] = array_reg2[22];
                                sum_Lb[22] = array_reg2[23];
                                sum_Lb[23] = array_reg2[24];
                                sum_Lb[24] = array_reg2[25];
                                sum_Lb[25] = array_reg2[26];
                                sum_Lb[26] = array_reg2[27];
                                sum_Lb[27] = array_reg2[28];
                                sum_Lb[28] = array_reg2[29];
                                sum_Lb[29] = array_reg2[30];
                                sum_Lb[30] = array_reg2[31];
                                sum_Lb[31] = 0;
                             end
                        3'd4:begin  //xxxx*
                                sum_Lb[0 ] = array_reg2[1 ] & array_reg3[2 ];
                                sum_Lb[1 ] = array_reg2[2 ] & array_reg3[3 ];
                                sum_Lb[2 ] = array_reg2[3 ] & array_reg3[4 ];
                                sum_Lb[3 ] = array_reg2[4 ] & array_reg3[5 ];                        
                                sum_Lb[4 ] = array_reg2[5 ] & array_reg3[6 ];
                                sum_Lb[5 ] = array_reg2[6 ] & array_reg3[7 ];
                                sum_Lb[6 ] = array_reg2[7 ] & array_reg3[8 ];
                                sum_Lb[7 ] = array_reg2[8 ] & array_reg3[9 ];
                                sum_Lb[8 ] = array_reg2[9 ] & array_reg3[10];
                                sum_Lb[9 ] = array_reg2[10] & array_reg3[11];
                                sum_Lb[10] = array_reg2[11] & array_reg3[12];
                                sum_Lb[11] = array_reg2[12] & array_reg3[13];
                                sum_Lb[12] = array_reg2[13] & array_reg3[14];
                                sum_Lb[13] = array_reg2[14] & array_reg3[15];
                                sum_Lb[14] = array_reg2[15] & array_reg3[16];
                                sum_Lb[15] = array_reg2[16] & array_reg3[17];
                                sum_Lb[16] = array_reg2[17] & array_reg3[18];
                                sum_Lb[17] = array_reg2[18] & array_reg3[19];
                                sum_Lb[18] = array_reg2[19] & array_reg3[20];
                                sum_Lb[19] = array_reg2[20] & array_reg3[21];
                                sum_Lb[20] = array_reg2[21] & array_reg3[22];
                                sum_Lb[21] = array_reg2[22] & array_reg3[23];
                                sum_Lb[22] = array_reg2[23] & array_reg3[24];
                                sum_Lb[23] = array_reg2[24] & array_reg3[25];
                                sum_Lb[24] = array_reg2[25] & array_reg3[26];
                                sum_Lb[25] = array_reg2[26] & array_reg3[27];
                                sum_Lb[26] = array_reg2[27] & array_reg3[28];
                                sum_Lb[27] = array_reg2[28] & array_reg3[29];
                                sum_Lb[28] = array_reg2[29] & array_reg3[30];
                                sum_Lb[29] = array_reg2[30] & array_reg3[31];
                                sum_Lb[30] = 0;
                                sum_Lb[31] = 0;
                             end  
                          default:begin
                                sum_Lb = 0;
                             end
                    endcase
            end
      3'd5:begin  //比對六個
                    case(star_location)
                        3'd0:begin  //*xxxxx
                                sum_Lb = 32'hffff_ffff;
                             end                                       
                        3'd1:begin  //x*xxxx
                                sum_Lb = 32'hffff_ffff;
                             end
                        3'd2:begin  //xx*xxx
                                sum_Lb = 32'hffff_ffff; 
                             end
                         3'd3:begin  //xxx*xx
                                sum_Lb[0 ] = array_reg2[1 ];       
                                sum_Lb[1 ] = array_reg2[2 ];       
                                sum_Lb[2 ] = array_reg2[3 ];       
                                sum_Lb[3 ] = array_reg2[4 ];                        
                                sum_Lb[4 ] = array_reg2[5 ];       
                                sum_Lb[5 ] = array_reg2[6 ];       
                                sum_Lb[6 ] = array_reg2[7 ];       
                                sum_Lb[7 ] = array_reg2[8 ];       
                                sum_Lb[8 ] = array_reg2[9 ];       
                                sum_Lb[9 ] = array_reg2[10];       
                                sum_Lb[10] = array_reg2[11];       
                                sum_Lb[11] = array_reg2[12];       
                                sum_Lb[12] = array_reg2[13];       
                                sum_Lb[13] = array_reg2[14];       
                                sum_Lb[14] = array_reg2[15];       
                                sum_Lb[15] = array_reg2[16];       
                                sum_Lb[16] = array_reg2[17];       
                                sum_Lb[17] = array_reg2[18];       
                                sum_Lb[18] = array_reg2[19];       
                                sum_Lb[19] = array_reg2[20];       
                                sum_Lb[20] = array_reg2[21];       
                                sum_Lb[21] = array_reg2[22];       
                                sum_Lb[22] = array_reg2[23];       
                                sum_Lb[23] = array_reg2[24];       
                                sum_Lb[24] = array_reg2[25];       
                                sum_Lb[25] = array_reg2[26];       
                                sum_Lb[26] = array_reg2[27];       
                                sum_Lb[27] = array_reg2[28];       
                                sum_Lb[28] = array_reg2[29];       
                                sum_Lb[29] = array_reg2[30];       
                                sum_Lb[30] = array_reg2[31];       
                                sum_Lb[31] = 0;            
                             end
                        3'd4:begin  //xxxx*x
                                sum_Lb[0 ] = array_reg2[1 ] & array_reg3[2 ];
                                sum_Lb[1 ] = array_reg2[2 ] & array_reg3[3 ];
                                sum_Lb[2 ] = array_reg2[3 ] & array_reg3[4 ];
                                sum_Lb[3 ] = array_reg2[4 ] & array_reg3[5 ];                        
                                sum_Lb[4 ] = array_reg2[5 ] & array_reg3[6 ];
                                sum_Lb[5 ] = array_reg2[6 ] & array_reg3[7 ];
                                sum_Lb[6 ] = array_reg2[7 ] & array_reg3[8 ];
                                sum_Lb[7 ] = array_reg2[8 ] & array_reg3[9 ];
                                sum_Lb[8 ] = array_reg2[9 ] & array_reg3[10];
                                sum_Lb[9 ] = array_reg2[10] & array_reg3[11];
                                sum_Lb[10] = array_reg2[11] & array_reg3[12];
                                sum_Lb[11] = array_reg2[12] & array_reg3[13];
                                sum_Lb[12] = array_reg2[13] & array_reg3[14];
                                sum_Lb[13] = array_reg2[14] & array_reg3[15];
                                sum_Lb[14] = array_reg2[15] & array_reg3[16];
                                sum_Lb[15] = array_reg2[16] & array_reg3[17];
                                sum_Lb[16] = array_reg2[17] & array_reg3[18];
                                sum_Lb[17] = array_reg2[18] & array_reg3[19];
                                sum_Lb[18] = array_reg2[19] & array_reg3[20];
                                sum_Lb[19] = array_reg2[20] & array_reg3[21];
                                sum_Lb[20] = array_reg2[21] & array_reg3[22];
                                sum_Lb[21] = array_reg2[22] & array_reg3[23];
                                sum_Lb[22] = array_reg2[23] & array_reg3[24];
                                sum_Lb[23] = array_reg2[24] & array_reg3[25];
                                sum_Lb[24] = array_reg2[25] & array_reg3[26];
                                sum_Lb[25] = array_reg2[26] & array_reg3[27];
                                sum_Lb[26] = array_reg2[27] & array_reg3[28];
                                sum_Lb[27] = array_reg2[28] & array_reg3[29];
                                sum_Lb[28] = array_reg2[29] & array_reg3[30];
                                sum_Lb[29] = array_reg2[30] & array_reg3[31];
                                sum_Lb[30] = 0;
                                sum_Lb[31] = 0;
                             end  
                         3'd5:begin  //xxxxx*
                                sum_Lb[0 ] = array_reg2[1 ] & array_reg3[2 ];
                                sum_Lb[1 ] = array_reg2[2 ] & array_reg3[3 ];
                                sum_Lb[2 ] = array_reg2[3 ] & array_reg3[4 ];
                                sum_Lb[3 ] = array_reg2[4 ] & array_reg3[5 ];                        
                                sum_Lb[4 ] = array_reg2[5 ] & array_reg3[6 ];
                                sum_Lb[5 ] = array_reg2[6 ] & array_reg3[7 ];
                                sum_Lb[6 ] = array_reg2[7 ] & array_reg3[8 ];
                                sum_Lb[7 ] = array_reg2[8 ] & array_reg3[9 ];
                                sum_Lb[8 ] = array_reg2[9 ] & array_reg3[10];
                                sum_Lb[9 ] = array_reg2[10] & array_reg3[11];
                                sum_Lb[10] = array_reg2[11] & array_reg3[12];
                                sum_Lb[11] = array_reg2[12] & array_reg3[13];
                                sum_Lb[12] = array_reg2[13] & array_reg3[14];
                                sum_Lb[13] = array_reg2[14] & array_reg3[15];
                                sum_Lb[14] = array_reg2[15] & array_reg3[16];
                                sum_Lb[15] = array_reg2[16] & array_reg3[17];
                                sum_Lb[16] = array_reg2[17] & array_reg3[18];
                                sum_Lb[17] = array_reg2[18] & array_reg3[19];
                                sum_Lb[18] = array_reg2[19] & array_reg3[20];
                                sum_Lb[19] = array_reg2[20] & array_reg3[21];
                                sum_Lb[20] = array_reg2[21] & array_reg3[22];
                                sum_Lb[21] = array_reg2[22] & array_reg3[23];
                                sum_Lb[22] = array_reg2[23] & array_reg3[24];
                                sum_Lb[23] = array_reg2[24] & array_reg3[25];
                                sum_Lb[24] = array_reg2[25] & array_reg3[26];
                                sum_Lb[25] = array_reg2[26] & array_reg3[27];
                                sum_Lb[26] = array_reg2[27] & array_reg3[28];
                                sum_Lb[27] = array_reg2[28] & array_reg3[29];
                                sum_Lb[28] = array_reg2[29] & array_reg3[30];
                                sum_Lb[29] = 0;
                                sum_Lb[30] = 0;
                                sum_Lb[31] = 0;
                             end  
                          default:begin
                                sum_Lb = 0;
                             end
                    endcase
            end
      3'd6:begin  //比對七個
                    case(star_location)
                        3'd0:begin  //*xxxxxx
                                sum_Lb = 32'hffff_ffff;
                             end
                        3'd1:begin  //x*xxxxx
                                sum_Lb = 32'hffff_ffff; 
                             end
                        3'd2:begin  //xx*xxxx
                                sum_Lb = 32'hffff_ffff; 
                             end
                         3'd3:begin  //xxx*xxx
                                sum_Lb[0 ] = array_reg2[1 ];      
                                sum_Lb[1 ] = array_reg2[2 ];      
                                sum_Lb[2 ] = array_reg2[3 ];      
                                sum_Lb[3 ] = array_reg2[4 ];                    
                                sum_Lb[4 ] = array_reg2[5 ];      
                                sum_Lb[5 ] = array_reg2[6 ];      
                                sum_Lb[6 ] = array_reg2[7 ];      
                                sum_Lb[7 ] = array_reg2[8 ];      
                                sum_Lb[8 ] = array_reg2[9 ];      
                                sum_Lb[9 ] = array_reg2[10];      
                                sum_Lb[10] = array_reg2[11];      
                                sum_Lb[11] = array_reg2[12];      
                                sum_Lb[12] = array_reg2[13];      
                                sum_Lb[13] = array_reg2[14];      
                                sum_Lb[14] = array_reg2[15];      
                                sum_Lb[15] = array_reg2[16];      
                                sum_Lb[16] = array_reg2[17];      
                                sum_Lb[17] = array_reg2[18];      
                                sum_Lb[18] = array_reg2[19];      
                                sum_Lb[19] = array_reg2[20];      
                                sum_Lb[20] = array_reg2[21];      
                                sum_Lb[21] = array_reg2[22];      
                                sum_Lb[22] = array_reg2[23];      
                                sum_Lb[23] = array_reg2[24];      
                                sum_Lb[24] = array_reg2[25];      
                                sum_Lb[25] = array_reg2[26];      
                                sum_Lb[26] = array_reg2[27];      
                                sum_Lb[27] = array_reg2[28];      
                                sum_Lb[28] = array_reg2[29];      
                                sum_Lb[29] = array_reg2[30];      
                                sum_Lb[30] = array_reg2[31];      
                                sum_Lb[31] = 0;                     
                             end
                        3'd4:begin  //xxxx*xx
                                sum_Lb[0 ] = array_reg2[1 ] & array_reg3[2 ]; 
                                sum_Lb[1 ] = array_reg2[2 ] & array_reg3[3 ]; 
                                sum_Lb[2 ] = array_reg2[3 ] & array_reg3[4 ]; 
                                sum_Lb[3 ] = array_reg2[4 ] & array_reg3[5 ];              
                                sum_Lb[4 ] = array_reg2[5 ] & array_reg3[6 ]; 
                                sum_Lb[5 ] = array_reg2[6 ] & array_reg3[7 ]; 
                                sum_Lb[6 ] = array_reg2[7 ] & array_reg3[8 ]; 
                                sum_Lb[7 ] = array_reg2[8 ] & array_reg3[9 ]; 
                                sum_Lb[8 ] = array_reg2[9 ] & array_reg3[10]; 
                                sum_Lb[9 ] = array_reg2[10] & array_reg3[11]; 
                                sum_Lb[10] = array_reg2[11] & array_reg3[12]; 
                                sum_Lb[11] = array_reg2[12] & array_reg3[13]; 
                                sum_Lb[12] = array_reg2[13] & array_reg3[14]; 
                                sum_Lb[13] = array_reg2[14] & array_reg3[15]; 
                                sum_Lb[14] = array_reg2[15] & array_reg3[16]; 
                                sum_Lb[15] = array_reg2[16] & array_reg3[17]; 
                                sum_Lb[16] = array_reg2[17] & array_reg3[18]; 
                                sum_Lb[17] = array_reg2[18] & array_reg3[19]; 
                                sum_Lb[18] = array_reg2[19] & array_reg3[20]; 
                                sum_Lb[19] = array_reg2[20] & array_reg3[21]; 
                                sum_Lb[20] = array_reg2[21] & array_reg3[22]; 
                                sum_Lb[21] = array_reg2[22] & array_reg3[23]; 
                                sum_Lb[22] = array_reg2[23] & array_reg3[24]; 
                                sum_Lb[23] = array_reg2[24] & array_reg3[25]; 
                                sum_Lb[24] = array_reg2[25] & array_reg3[26]; 
                                sum_Lb[25] = array_reg2[26] & array_reg3[27]; 
                                sum_Lb[26] = array_reg2[27] & array_reg3[28]; 
                                sum_Lb[27] = array_reg2[28] & array_reg3[29]; 
                                sum_Lb[28] = array_reg2[29] & array_reg3[30]; 
                                sum_Lb[29] = array_reg2[30] & array_reg3[31]; 
                                sum_Lb[30] = 0;                                                    
                                sum_Lb[31] = 0;                                               
                             end  
                         3'd5:begin  //xxxxx*x
                                sum_Lb[0 ] = array_reg2[1 ] & array_reg3[2 ];
                                sum_Lb[1 ] = array_reg2[2 ] & array_reg3[3 ];
                                sum_Lb[2 ] = array_reg2[3 ] & array_reg3[4 ];
                                sum_Lb[3 ] = array_reg2[4 ] & array_reg3[5 ];                        
                                sum_Lb[4 ] = array_reg2[5 ] & array_reg3[6 ];
                                sum_Lb[5 ] = array_reg2[6 ] & array_reg3[7 ];
                                sum_Lb[6 ] = array_reg2[7 ] & array_reg3[8 ];
                                sum_Lb[7 ] = array_reg2[8 ] & array_reg3[9 ];
                                sum_Lb[8 ] = array_reg2[9 ] & array_reg3[10];
                                sum_Lb[9 ] = array_reg2[10] & array_reg3[11];
                                sum_Lb[10] = array_reg2[11] & array_reg3[12];
                                sum_Lb[11] = array_reg2[12] & array_reg3[13];
                                sum_Lb[12] = array_reg2[13] & array_reg3[14];
                                sum_Lb[13] = array_reg2[14] & array_reg3[15];
                                sum_Lb[14] = array_reg2[15] & array_reg3[16];
                                sum_Lb[15] = array_reg2[16] & array_reg3[17];
                                sum_Lb[16] = array_reg2[17] & array_reg3[18];
                                sum_Lb[17] = array_reg2[18] & array_reg3[19];
                                sum_Lb[18] = array_reg2[19] & array_reg3[20];
                                sum_Lb[19] = array_reg2[20] & array_reg3[21];
                                sum_Lb[20] = array_reg2[21] & array_reg3[22];
                                sum_Lb[21] = array_reg2[22] & array_reg3[23];
                                sum_Lb[22] = array_reg2[23] & array_reg3[24];
                                sum_Lb[23] = array_reg2[24] & array_reg3[25];
                                sum_Lb[24] = array_reg2[25] & array_reg3[26];
                                sum_Lb[25] = array_reg2[26] & array_reg3[27];
                                sum_Lb[26] = array_reg2[27] & array_reg3[28];
                                sum_Lb[27] = array_reg2[28] & array_reg3[29];
                                sum_Lb[28] = array_reg2[29] & array_reg3[30];
                                sum_Lb[29] = 0;
                                sum_Lb[30] = 0;
                                sum_Lb[31] = 0;
                             end  
                         3'd6:begin  //xxxxxx*
                                sum_Lb[0 ] = array_reg2[1 ] & array_reg3[2 ];
                                sum_Lb[1 ] = array_reg2[2 ] & array_reg3[3 ];
                                sum_Lb[2 ] = array_reg2[3 ] & array_reg3[4 ];
                                sum_Lb[3 ] = array_reg2[4 ] & array_reg3[5 ];                        
                                sum_Lb[4 ] = array_reg2[5 ] & array_reg3[6 ];
                                sum_Lb[5 ] = array_reg2[6 ] & array_reg3[7 ];
                                sum_Lb[6 ] = array_reg2[7 ] & array_reg3[8 ];
                                sum_Lb[7 ] = array_reg2[8 ] & array_reg3[9 ];
                                sum_Lb[8 ] = array_reg2[9 ] & array_reg3[10];
                                sum_Lb[9 ] = array_reg2[10] & array_reg3[11];
                                sum_Lb[10] = array_reg2[11] & array_reg3[12];
                                sum_Lb[11] = array_reg2[12] & array_reg3[13];
                                sum_Lb[12] = array_reg2[13] & array_reg3[14];
                                sum_Lb[13] = array_reg2[14] & array_reg3[15];
                                sum_Lb[14] = array_reg2[15] & array_reg3[16];
                                sum_Lb[15] = array_reg2[16] & array_reg3[17];
                                sum_Lb[16] = array_reg2[17] & array_reg3[18];
                                sum_Lb[17] = array_reg2[18] & array_reg3[19];
                                sum_Lb[18] = array_reg2[19] & array_reg3[20];
                                sum_Lb[19] = array_reg2[20] & array_reg3[21];
                                sum_Lb[20] = array_reg2[21] & array_reg3[22];
                                sum_Lb[21] = array_reg2[22] & array_reg3[23];
                                sum_Lb[22] = array_reg2[23] & array_reg3[24];
                                sum_Lb[23] = array_reg2[24] & array_reg3[25];
                                sum_Lb[24] = array_reg2[25] & array_reg3[26];
                                sum_Lb[25] = array_reg2[26] & array_reg3[27];
                                sum_Lb[26] = array_reg2[27] & array_reg3[28];
                                sum_Lb[27] = array_reg2[28] & array_reg3[29];
                                sum_Lb[28] = 0;
                                sum_Lb[29] = 0;
                                sum_Lb[30] = 0;
                                sum_Lb[31] = 0;
                             end  
                          default:begin
                                sum_Lb = 0;
                             end
                    endcase
            end
      3'd7:begin  //比對八個
                    case(star_location)
                        3'd0:begin  //*xxxxxxx
                                sum_Lb = 32'hffff_ffff; 
                             end
                        3'd1:begin  //x*xxxxxx
                                sum_Lb = 32'hffff_ffff; 
                             end
                        3'd2:begin  //xx*xxxxx
                                sum_Lb = 32'hffff_ffff; 
                             end
                         3'd3:begin  //xxx*xxxx
                                sum_Lb[0 ] = array_reg2[1 ];     
                                sum_Lb[1 ] = array_reg2[2 ];     
                                sum_Lb[2 ] = array_reg2[3 ];     
                                sum_Lb[3 ] = array_reg2[4 ];               
                                sum_Lb[4 ] = array_reg2[5 ];     
                                sum_Lb[5 ] = array_reg2[6 ];     
                                sum_Lb[6 ] = array_reg2[7 ];     
                                sum_Lb[7 ] = array_reg2[8 ];     
                                sum_Lb[8 ] = array_reg2[9 ];     
                                sum_Lb[9 ] = array_reg2[10];     
                                sum_Lb[10] = array_reg2[11];     
                                sum_Lb[11] = array_reg2[12];     
                                sum_Lb[12] = array_reg2[13];     
                                sum_Lb[13] = array_reg2[14];     
                                sum_Lb[14] = array_reg2[15];     
                                sum_Lb[15] = array_reg2[16];     
                                sum_Lb[16] = array_reg2[17];     
                                sum_Lb[17] = array_reg2[18];     
                                sum_Lb[18] = array_reg2[19];     
                                sum_Lb[19] = array_reg2[20];     
                                sum_Lb[20] = array_reg2[21];     
                                sum_Lb[21] = array_reg2[22];     
                                sum_Lb[22] = array_reg2[23];     
                                sum_Lb[23] = array_reg2[24];     
                                sum_Lb[24] = array_reg2[25];     
                                sum_Lb[25] = array_reg2[26];     
                                sum_Lb[26] = array_reg2[27];     
                                sum_Lb[27] = array_reg2[28];     
                                sum_Lb[28] = array_reg2[29];     
                                sum_Lb[29] = array_reg2[30];     
                                sum_Lb[30] = array_reg2[31];     
                                sum_Lb[31] = 0;                    
                             end
                        3'd4:begin  //xxxx*xxx
                                sum_Lb[0 ] = array_reg2[1 ] & array_reg3[2 ];      
                                sum_Lb[1 ] = array_reg2[2 ] & array_reg3[3 ];      
                                sum_Lb[2 ] = array_reg2[3 ] & array_reg3[4 ];      
                                sum_Lb[3 ] = array_reg2[4 ] & array_reg3[5 ];                 
                                sum_Lb[4 ] = array_reg2[5 ] & array_reg3[6 ];      
                                sum_Lb[5 ] = array_reg2[6 ] & array_reg3[7 ];      
                                sum_Lb[6 ] = array_reg2[7 ] & array_reg3[8 ];      
                                sum_Lb[7 ] = array_reg2[8 ] & array_reg3[9 ];      
                                sum_Lb[8 ] = array_reg2[9 ] & array_reg3[10];      
                                sum_Lb[9 ] = array_reg2[10] & array_reg3[11];      
                                sum_Lb[10] = array_reg2[11] & array_reg3[12];      
                                sum_Lb[11] = array_reg2[12] & array_reg3[13];      
                                sum_Lb[12] = array_reg2[13] & array_reg3[14];      
                                sum_Lb[13] = array_reg2[14] & array_reg3[15];      
                                sum_Lb[14] = array_reg2[15] & array_reg3[16];      
                                sum_Lb[15] = array_reg2[16] & array_reg3[17];      
                                sum_Lb[16] = array_reg2[17] & array_reg3[18];      
                                sum_Lb[17] = array_reg2[18] & array_reg3[19];      
                                sum_Lb[18] = array_reg2[19] & array_reg3[20];      
                                sum_Lb[19] = array_reg2[20] & array_reg3[21];      
                                sum_Lb[20] = array_reg2[21] & array_reg3[22];      
                                sum_Lb[21] = array_reg2[22] & array_reg3[23];      
                                sum_Lb[22] = array_reg2[23] & array_reg3[24];      
                                sum_Lb[23] = array_reg2[24] & array_reg3[25];      
                                sum_Lb[24] = array_reg2[25] & array_reg3[26];      
                                sum_Lb[25] = array_reg2[26] & array_reg3[27];      
                                sum_Lb[26] = array_reg2[27] & array_reg3[28];      
                                sum_Lb[27] = array_reg2[28] & array_reg3[29];      
                                sum_Lb[28] = array_reg2[29] & array_reg3[30];      
                                sum_Lb[29] = array_reg2[30] & array_reg3[31];      
                                sum_Lb[30] = 0;                                        
                                sum_Lb[31] = 0;                                        
                             end  
                         3'd5:begin  //xxxxx*xx
                                sum_Lb[0 ] = array_reg2[1 ] & array_reg3[2 ];     
                                sum_Lb[1 ] = array_reg2[2 ] & array_reg3[3 ];     
                                sum_Lb[2 ] = array_reg2[3 ] & array_reg3[4 ];     
                                sum_Lb[3 ] = array_reg2[4 ] & array_reg3[5 ];                 
                                sum_Lb[4 ] = array_reg2[5 ] & array_reg3[6 ];     
                                sum_Lb[5 ] = array_reg2[6 ] & array_reg3[7 ];     
                                sum_Lb[6 ] = array_reg2[7 ] & array_reg3[8 ];     
                                sum_Lb[7 ] = array_reg2[8 ] & array_reg3[9 ];     
                                sum_Lb[8 ] = array_reg2[9 ] & array_reg3[10];     
                                sum_Lb[9 ] = array_reg2[10] & array_reg3[11];     
                                sum_Lb[10] = array_reg2[11] & array_reg3[12];     
                                sum_Lb[11] = array_reg2[12] & array_reg3[13];     
                                sum_Lb[12] = array_reg2[13] & array_reg3[14];     
                                sum_Lb[13] = array_reg2[14] & array_reg3[15];     
                                sum_Lb[14] = array_reg2[15] & array_reg3[16];     
                                sum_Lb[15] = array_reg2[16] & array_reg3[17];     
                                sum_Lb[16] = array_reg2[17] & array_reg3[18];     
                                sum_Lb[17] = array_reg2[18] & array_reg3[19];     
                                sum_Lb[18] = array_reg2[19] & array_reg3[20];     
                                sum_Lb[19] = array_reg2[20] & array_reg3[21];     
                                sum_Lb[20] = array_reg2[21] & array_reg3[22];     
                                sum_Lb[21] = array_reg2[22] & array_reg3[23];     
                                sum_Lb[22] = array_reg2[23] & array_reg3[24];     
                                sum_Lb[23] = array_reg2[24] & array_reg3[25];     
                                sum_Lb[24] = array_reg2[25] & array_reg3[26];     
                                sum_Lb[25] = array_reg2[26] & array_reg3[27];     
                                sum_Lb[26] = array_reg2[27] & array_reg3[28];     
                                sum_Lb[27] = array_reg2[28] & array_reg3[29];     
                                sum_Lb[28] = array_reg2[29] & array_reg3[30];     
                                sum_Lb[29] = 0;                                       
                                sum_Lb[30] = 0;                                       
                                sum_Lb[31] = 0;                                       
                             end  
                         3'd6:begin  //xxxxxx*x
                                sum_Lb[0 ] = array_reg2[1 ] & array_reg3[2 ];
                                sum_Lb[1 ] = array_reg2[2 ] & array_reg3[3 ];
                                sum_Lb[2 ] = array_reg2[3 ] & array_reg3[4 ];
                                sum_Lb[3 ] = array_reg2[4 ] & array_reg3[5 ];                        
                                sum_Lb[4 ] = array_reg2[5 ] & array_reg3[6 ];
                                sum_Lb[5 ] = array_reg2[6 ] & array_reg3[7 ];
                                sum_Lb[6 ] = array_reg2[7 ] & array_reg3[8 ];
                                sum_Lb[7 ] = array_reg2[8 ] & array_reg3[9 ];
                                sum_Lb[8 ] = array_reg2[9 ] & array_reg3[10];
                                sum_Lb[9 ] = array_reg2[10] & array_reg3[11];
                                sum_Lb[10] = array_reg2[11] & array_reg3[12];
                                sum_Lb[11] = array_reg2[12] & array_reg3[13];
                                sum_Lb[12] = array_reg2[13] & array_reg3[14];
                                sum_Lb[13] = array_reg2[14] & array_reg3[15];
                                sum_Lb[14] = array_reg2[15] & array_reg3[16];
                                sum_Lb[15] = array_reg2[16] & array_reg3[17];
                                sum_Lb[16] = array_reg2[17] & array_reg3[18];
                                sum_Lb[17] = array_reg2[18] & array_reg3[19];
                                sum_Lb[18] = array_reg2[19] & array_reg3[20];
                                sum_Lb[19] = array_reg2[20] & array_reg3[21];
                                sum_Lb[20] = array_reg2[21] & array_reg3[22];
                                sum_Lb[21] = array_reg2[22] & array_reg3[23];
                                sum_Lb[22] = array_reg2[23] & array_reg3[24];
                                sum_Lb[23] = array_reg2[24] & array_reg3[25];
                                sum_Lb[24] = array_reg2[25] & array_reg3[26];
                                sum_Lb[25] = array_reg2[26] & array_reg3[27];
                                sum_Lb[26] = array_reg2[27] & array_reg3[28];
                                sum_Lb[27] = array_reg2[28] & array_reg3[29];
                                sum_Lb[28] = 0;
                                sum_Lb[29] = 0;
                                sum_Lb[30] = 0;
                                sum_Lb[31] = 0; 
                             end  
                         3'd7:begin  //xxxxxxx*
                                sum_Lb[0 ] = array_reg3[2 ] & array_reg4[3 ];
                                sum_Lb[1 ] = array_reg3[3 ] & array_reg4[4 ];
                                sum_Lb[2 ] = array_reg3[4 ] & array_reg4[5 ];
                                sum_Lb[3 ] = array_reg3[5 ] & array_reg4[6 ];                        
                                sum_Lb[4 ] = array_reg3[6 ] & array_reg4[7 ];
                                sum_Lb[5 ] = array_reg3[7 ] & array_reg4[8 ];
                                sum_Lb[6 ] = array_reg3[8 ] & array_reg4[9 ];
                                sum_Lb[7 ] = array_reg3[9 ] & array_reg4[10];
                                sum_Lb[8 ] = array_reg3[10] & array_reg4[11];
                                sum_Lb[9 ] = array_reg3[11] & array_reg4[12];
                                sum_Lb[10] = array_reg3[12] & array_reg4[13];
                                sum_Lb[11] = array_reg3[13] & array_reg4[14];
                                sum_Lb[12] = array_reg3[14] & array_reg4[15];
                                sum_Lb[13] = array_reg3[15] & array_reg4[16];
                                sum_Lb[14] = array_reg3[16] & array_reg4[17];
                                sum_Lb[15] = array_reg3[17] & array_reg4[18];
                                sum_Lb[16] = array_reg3[18] & array_reg4[19];
                                sum_Lb[17] = array_reg3[19] & array_reg4[20];
                                sum_Lb[18] = array_reg3[20] & array_reg4[21];
                                sum_Lb[19] = array_reg3[21] & array_reg4[22];
                                sum_Lb[20] = array_reg3[22] & array_reg4[23];
                                sum_Lb[21] = array_reg3[23] & array_reg4[24];
                                sum_Lb[22] = array_reg3[24] & array_reg4[25];
                                sum_Lb[23] = array_reg3[25] & array_reg4[26];
                                sum_Lb[24] = array_reg3[26] & array_reg4[27];
                                sum_Lb[25] = array_reg3[27] & array_reg4[28];
                                sum_Lb[26] = array_reg3[28] & array_reg4[29];
                                sum_Lb[27] = 0;
                                sum_Lb[28] = 0;
                                sum_Lb[29] = 0;
                                sum_Lb[30] = 0;
                                sum_Lb[31] = 0;
                             end  
                    endcase
            end
            default:begin
            sum_Lb = 32'hffff_ffff;
            end
   endcase
end
else begin
    sum_Lb = 0;
end
end
always @(*)
begin
    if(star_reg)begin
    case(last_pattern_place)
      3'd3:begin  //比對四個
                    case(star_location)
                        3'd0:begin  //*xxx
                                sum_Rb[0 ] = array_reg3[2 ];
                                sum_Rb[1 ] = array_reg3[3 ];
                                sum_Rb[2 ] = array_reg3[4 ];
                                sum_Rb[3 ] = array_reg3[5 ];                        
                                sum_Rb[4 ] = array_reg3[6 ];
                                sum_Rb[5 ] = array_reg3[7 ];
                                sum_Rb[6 ] = array_reg3[8 ];
                                sum_Rb[7 ] = array_reg3[9 ];
                                sum_Rb[8 ] = array_reg3[10];
                                sum_Rb[9 ] = array_reg3[11];
                                sum_Rb[10] = array_reg3[12];
                                sum_Rb[11] = array_reg3[13];
                                sum_Rb[12] = array_reg3[14];
                                sum_Rb[13] = array_reg3[15];
                                sum_Rb[14] = array_reg3[16];
                                sum_Rb[15] = array_reg3[17];
                                sum_Rb[16] = array_reg3[18];
                                sum_Rb[17] = array_reg3[19];
                                sum_Rb[18] = array_reg3[20];
                                sum_Rb[19] = array_reg3[21];
                                sum_Rb[20] = array_reg3[22];
                                sum_Rb[21] = array_reg3[23];
                                sum_Rb[22] = array_reg3[24];
                                sum_Rb[23] = array_reg3[25];
                                sum_Rb[24] = array_reg3[26];
                                sum_Rb[25] = array_reg3[27];
                                sum_Rb[26] = array_reg3[28];
                                sum_Rb[27] = array_reg3[29];
                                sum_Rb[28] = array_reg3[30];
                                sum_Rb[29] = array_reg3[31];
                                sum_Rb[30] =   back_reg;
                                sum_Rb[31] = 0;
                             end
                        3'd1:begin  //x*xx
                                sum_Rb = 32'hffff_ffff;
                             end
                        3'd2:begin  //xx*x
                                sum_Rb = 32'hffff_ffff;
                             end
                        3'd3:begin  //xxx*
                                sum_Rb = 32'hffff_ffff;
                             end
                        default:begin
                                sum_Rb = 0;
                             end
                    endcase
            end
      3'd4:begin  //比對五個
                    case(star_location)
                        3'd0:begin  //*xxxx
                                sum_Rb[0 ] = array_reg3[2 ] & array_reg4[3 ];
                                sum_Rb[1 ] = array_reg3[3 ] & array_reg4[4 ];
                                sum_Rb[2 ] = array_reg3[4 ] & array_reg4[5 ];
                                sum_Rb[3 ] = array_reg3[5 ] & array_reg4[6 ];                        
                                sum_Rb[4 ] = array_reg3[6 ] & array_reg4[7 ];
                                sum_Rb[5 ] = array_reg3[7 ] & array_reg4[8 ];
                                sum_Rb[6 ] = array_reg3[8 ] & array_reg4[9 ];
                                sum_Rb[7 ] = array_reg3[9 ] & array_reg4[10];
                                sum_Rb[8 ] = array_reg3[10] & array_reg4[11];
                                sum_Rb[9 ] = array_reg3[11] & array_reg4[12];
                                sum_Rb[10] = array_reg3[12] & array_reg4[13];
                                sum_Rb[11] = array_reg3[13] & array_reg4[14];
                                sum_Rb[12] = array_reg3[14] & array_reg4[15];
                                sum_Rb[13] = array_reg3[15] & array_reg4[16];
                                sum_Rb[14] = array_reg3[16] & array_reg4[17];
                                sum_Rb[15] = array_reg3[17] & array_reg4[18];
                                sum_Rb[16] = array_reg3[18] & array_reg4[19];
                                sum_Rb[17] = array_reg3[19] & array_reg4[20];
                                sum_Rb[18] = array_reg3[20] & array_reg4[21];
                                sum_Rb[19] = array_reg3[21] & array_reg4[22];
                                sum_Rb[20] = array_reg3[22] & array_reg4[23];
                                sum_Rb[21] = array_reg3[23] & array_reg4[24];
                                sum_Rb[22] = array_reg3[24] & array_reg4[25];
                                sum_Rb[23] = array_reg3[25] & array_reg4[26];
                                sum_Rb[24] = array_reg3[26] & array_reg4[27];
                                sum_Rb[25] = array_reg3[27] & array_reg4[28];
                                sum_Rb[26] = array_reg3[28] & array_reg4[29];
                                sum_Rb[27] = array_reg3[29] & array_reg4[30];
                                sum_Rb[28] = array_reg3[30] & array_reg4[31];
                                sum_Rb[29] = array_reg3[31] &   back_reg;
                                sum_Rb[30] = 0;
                                sum_Rb[31] = 0;
                             end
                        3'd1:begin  //x*xxx
                                sum_Rb[0 ] = array_reg4[2 ];
                                sum_Rb[1 ] = array_reg4[3 ];
                                sum_Rb[2 ] = array_reg4[4 ];
                                sum_Rb[3 ] = array_reg4[5 ];                        
                                sum_Rb[4 ] = array_reg4[6 ];
                                sum_Rb[5 ] = array_reg4[7 ];
                                sum_Rb[6 ] = array_reg4[8 ];
                                sum_Rb[7 ] = array_reg4[9 ];
                                sum_Rb[8 ] = array_reg4[10];
                                sum_Rb[9 ] = array_reg4[11];
                                sum_Rb[10] = array_reg4[12];
                                sum_Rb[11] = array_reg4[13];
                                sum_Rb[12] = array_reg4[14];
                                sum_Rb[13] = array_reg4[15];
                                sum_Rb[14] = array_reg4[16];
                                sum_Rb[15] = array_reg4[17];
                                sum_Rb[16] = array_reg4[18];
                                sum_Rb[17] = array_reg4[19];
                                sum_Rb[18] = array_reg4[20];
                                sum_Rb[19] = array_reg4[21];
                                sum_Rb[20] = array_reg4[22];
                                sum_Rb[21] = array_reg4[23];
                                sum_Rb[22] = array_reg4[24];
                                sum_Rb[23] = array_reg4[25];
                                sum_Rb[24] = array_reg4[26];
                                sum_Rb[25] = array_reg4[27];
                                sum_Rb[26] = array_reg4[28];
                                sum_Rb[27] = array_reg4[29];
                                sum_Rb[28] = array_reg4[30];
                                sum_Rb[29] = array_reg4[31];
                                sum_Rb[30] =   back_reg;
                                sum_Rb[31] = 0 ;
                             end
                        3'd2:begin  //xx*xx
                                sum_Rb = 32'hffff_ffff;
                             end
                         3'd3:begin  //xxx*x
                                sum_Rb = 32'hffff_ffff;
                             end
                        3'd4:begin  //xxxx*
                                sum_Rb = 32'hffff_ffff;
                             end  
                          default:begin
                                sum_Rb = 0;
                             end
                    endcase
            end
      3'd5:begin  //比對六個
                    case(star_location)
                        3'd0:begin  //*xxxxx
                                sum_Rb[0 ] = array_reg3[2 ] & array_reg4[3 ];
                                sum_Rb[1 ] = array_reg3[3 ] & array_reg4[4 ];
                                sum_Rb[2 ] = array_reg3[4 ] & array_reg4[5 ];
                                sum_Rb[3 ] = array_reg3[5 ] & array_reg4[6 ];                        
                                sum_Rb[4 ] = array_reg3[6 ] & array_reg4[7 ];
                                sum_Rb[5 ] = array_reg3[7 ] & array_reg4[8 ];
                                sum_Rb[6 ] = array_reg3[8 ] & array_reg4[9 ];
                                sum_Rb[7 ] = array_reg3[9 ] & array_reg4[10];
                                sum_Rb[8 ] = array_reg3[10] & array_reg4[11];
                                sum_Rb[9 ] = array_reg3[11] & array_reg4[12];
                                sum_Rb[10] = array_reg3[12] & array_reg4[13];
                                sum_Rb[11] = array_reg3[13] & array_reg4[14];
                                sum_Rb[12] = array_reg3[14] & array_reg4[15];
                                sum_Rb[13] = array_reg3[15] & array_reg4[16];
                                sum_Rb[14] = array_reg3[16] & array_reg4[17];
                                sum_Rb[15] = array_reg3[17] & array_reg4[18];
                                sum_Rb[16] = array_reg3[18] & array_reg4[19];
                                sum_Rb[17] = array_reg3[19] & array_reg4[20];
                                sum_Rb[18] = array_reg3[20] & array_reg4[21];
                                sum_Rb[19] = array_reg3[21] & array_reg4[22];
                                sum_Rb[20] = array_reg3[22] & array_reg4[23];
                                sum_Rb[21] = array_reg3[23] & array_reg4[24];
                                sum_Rb[22] = array_reg3[24] & array_reg4[25];
                                sum_Rb[23] = array_reg3[25] & array_reg4[26];
                                sum_Rb[24] = array_reg3[26] & array_reg4[27];
                                sum_Rb[25] = array_reg3[27] & array_reg4[28];
                                sum_Rb[26] = array_reg3[28] & array_reg4[29];
                                sum_Rb[27] = array_reg3[29] & array_reg4[30];
                                sum_Rb[28] = array_reg3[30] & array_reg4[31];
                                sum_Rb[29] = 0;
                                sum_Rb[30] = 0;
                                sum_Rb[31] = 0;
                             end                                       
                        3'd1:begin  //x*xxxx
                                sum_Rb[0 ] = array_reg4[2 ] & array_reg5[3 ];
                                sum_Rb[1 ] = array_reg4[3 ] & array_reg5[4 ];
                                sum_Rb[2 ] = array_reg4[4 ] & array_reg5[5 ];
                                sum_Rb[3 ] = array_reg4[5 ] & array_reg5[6 ];                        
                                sum_Rb[4 ] = array_reg4[6 ] & array_reg5[7 ];
                                sum_Rb[5 ] = array_reg4[7 ] & array_reg5[8 ];
                                sum_Rb[6 ] = array_reg4[8 ] & array_reg5[9 ];
                                sum_Rb[7 ] = array_reg4[9 ] & array_reg5[10];
                                sum_Rb[8 ] = array_reg4[10] & array_reg5[11];
                                sum_Rb[9 ] = array_reg4[11] & array_reg5[12];
                                sum_Rb[10] = array_reg4[12] & array_reg5[13];
                                sum_Rb[11] = array_reg4[13] & array_reg5[14];
                                sum_Rb[12] = array_reg4[14] & array_reg5[15];
                                sum_Rb[13] = array_reg4[15] & array_reg5[16];
                                sum_Rb[14] = array_reg4[16] & array_reg5[17];
                                sum_Rb[15] = array_reg4[17] & array_reg5[18];
                                sum_Rb[16] = array_reg4[18] & array_reg5[19];
                                sum_Rb[17] = array_reg4[19] & array_reg5[20];
                                sum_Rb[18] = array_reg4[20] & array_reg5[21];
                                sum_Rb[19] = array_reg4[21] & array_reg5[22];
                                sum_Rb[20] = array_reg4[22] & array_reg5[23];
                                sum_Rb[21] = array_reg4[23] & array_reg5[24];
                                sum_Rb[22] = array_reg4[24] & array_reg5[25];
                                sum_Rb[23] = array_reg4[25] & array_reg5[26];
                                sum_Rb[24] = array_reg4[26] & array_reg5[27];
                                sum_Rb[25] = array_reg4[27] & array_reg5[28];
                                sum_Rb[26] = array_reg4[28] & array_reg5[29];
                                sum_Rb[27] = array_reg4[29] & array_reg5[30];
                                sum_Rb[28] = array_reg4[30] & array_reg5[31];
                                sum_Rb[29] = array_reg4[31] &   back_reg;
                                sum_Rb[30] = 0;
                                sum_Rb[31] = 0 ;
                             end
                        3'd2:begin  //xx*xxx
                                sum_Rb[0 ] = array_reg5[2 ] ;
                                sum_Rb[1 ] = array_reg5[3 ] ;
                                sum_Rb[2 ] = array_reg5[4 ] ;
                                sum_Rb[3 ] = array_reg5[5 ] ;                
                                sum_Rb[4 ] = array_reg5[6 ] ;
                                sum_Rb[5 ] = array_reg5[7 ] ;
                                sum_Rb[6 ] = array_reg5[8 ] ;
                                sum_Rb[7 ] = array_reg5[9 ] ;
                                sum_Rb[8 ] = array_reg5[10] ;
                                sum_Rb[9 ] = array_reg5[11] ;
                                sum_Rb[10] = array_reg5[12] ;
                                sum_Rb[11] = array_reg5[13] ;
                                sum_Rb[12] = array_reg5[14] ;
                                sum_Rb[13] = array_reg5[15] ;
                                sum_Rb[14] = array_reg5[16] ;
                                sum_Rb[15] = array_reg5[17] ;
                                sum_Rb[16] = array_reg5[18] ;
                                sum_Rb[17] = array_reg5[19] ;
                                sum_Rb[18] = array_reg5[20] ;
                                sum_Rb[19] = array_reg5[21] ;
                                sum_Rb[20] = array_reg5[22] ;
                                sum_Rb[21] = array_reg5[23] ;
                                sum_Rb[22] = array_reg5[24] ;
                                sum_Rb[23] = array_reg5[25] ;
                                sum_Rb[24] = array_reg5[26] ;
                                sum_Rb[25] = array_reg5[27] ;
                                sum_Rb[26] = array_reg5[28] ;
                                sum_Rb[27] = array_reg5[29] ;
                                sum_Rb[28] = array_reg5[30] ;
                                sum_Rb[29] = array_reg5[31] ;
                                sum_Rb[30] =   back_reg ;
                                sum_Rb[31] = 0;
                             end
                         3'd3:begin  //xxx*xx
                                sum_Rb = 32'hffff_ffff;                         
                             end
                        3'd4:begin  //xxxx*x
                                sum_Rb = 32'hffff_ffff; 
                             end  
                         3'd5:begin  //xxxxx*
                                sum_Rb = 32'hffff_ffff; 
                             end  
                          default:begin
                                sum_Rb = 0;
                             end
                    endcase
            end
      3'd6:begin  //比對七個
                    case(star_location)
                        3'd0:begin  //*xxxxxx
                                sum_Rb[0 ] = array_reg3[2 ] & array_reg4[3 ] ;
                                sum_Rb[1 ] = array_reg3[3 ] & array_reg4[4 ] ;
                                sum_Rb[2 ] = array_reg3[4 ] & array_reg4[5 ] ;
                                sum_Rb[3 ] = array_reg3[5 ] & array_reg4[6 ] ;                        
                                sum_Rb[4 ] = array_reg3[6 ] & array_reg4[7 ] ;
                                sum_Rb[5 ] = array_reg3[7 ] & array_reg4[8 ] ;
                                sum_Rb[6 ] = array_reg3[8 ] & array_reg4[9 ] ;
                                sum_Rb[7 ] = array_reg3[9 ] & array_reg4[10] ;
                                sum_Rb[8 ] = array_reg3[10] & array_reg4[11] ;
                                sum_Rb[9 ] = array_reg3[11] & array_reg4[12] ;
                                sum_Rb[10] = array_reg3[12] & array_reg4[13] ;
                                sum_Rb[11] = array_reg3[13] & array_reg4[14] ;
                                sum_Rb[12] = array_reg3[14] & array_reg4[15] ;
                                sum_Rb[13] = array_reg3[15] & array_reg4[16] ;
                                sum_Rb[14] = array_reg3[16] & array_reg4[17] ;
                                sum_Rb[15] = array_reg3[17] & array_reg4[18] ;
                                sum_Rb[16] = array_reg3[18] & array_reg4[19] ;
                                sum_Rb[17] = array_reg3[19] & array_reg4[20] ;
                                sum_Rb[18] = array_reg3[20] & array_reg4[21] ;
                                sum_Rb[19] = array_reg3[21] & array_reg4[22] ;
                                sum_Rb[20] = array_reg3[22] & array_reg4[23] ;
                                sum_Rb[21] = array_reg3[23] & array_reg4[24] ;
                                sum_Rb[22] = array_reg3[24] & array_reg4[25] ;
                                sum_Rb[23] = array_reg3[25] & array_reg4[26] ;
                                sum_Rb[24] = array_reg3[26] & array_reg4[27] ;
                                sum_Rb[25] = array_reg3[27] & array_reg4[28] ;
                                sum_Rb[26] = array_reg3[28] & array_reg4[29] ;
                                sum_Rb[27] = array_reg3[29] & array_reg4[30] ;
                                sum_Rb[31:28] = 0;
                             end
                        3'd1:begin  //x*xxxxx
                                sum_Rb[0 ] = array_reg4[2 ] & array_reg5[3 ];
                                sum_Rb[1 ] = array_reg4[3 ] & array_reg5[4 ];
                                sum_Rb[2 ] = array_reg4[4 ] & array_reg5[5 ];
                                sum_Rb[3 ] = array_reg4[5 ] & array_reg5[6 ];                        
                                sum_Rb[4 ] = array_reg4[6 ] & array_reg5[7 ];
                                sum_Rb[5 ] = array_reg4[7 ] & array_reg5[8 ];
                                sum_Rb[6 ] = array_reg4[8 ] & array_reg5[9 ];
                                sum_Rb[7 ] = array_reg4[9 ] & array_reg5[10];
                                sum_Rb[8 ] = array_reg4[10] & array_reg5[11];
                                sum_Rb[9 ] = array_reg4[11] & array_reg5[12];
                                sum_Rb[10] = array_reg4[12] & array_reg5[13];
                                sum_Rb[11] = array_reg4[13] & array_reg5[14];
                                sum_Rb[12] = array_reg4[14] & array_reg5[15];
                                sum_Rb[13] = array_reg4[15] & array_reg5[16];
                                sum_Rb[14] = array_reg4[16] & array_reg5[17];
                                sum_Rb[15] = array_reg4[17] & array_reg5[18];
                                sum_Rb[16] = array_reg4[18] & array_reg5[19];
                                sum_Rb[17] = array_reg4[19] & array_reg5[20];
                                sum_Rb[18] = array_reg4[20] & array_reg5[21];
                                sum_Rb[19] = array_reg4[21] & array_reg5[22];
                                sum_Rb[20] = array_reg4[22] & array_reg5[23];
                                sum_Rb[21] = array_reg4[23] & array_reg5[24];
                                sum_Rb[22] = array_reg4[24] & array_reg5[25];
                                sum_Rb[23] = array_reg4[25] & array_reg5[26];
                                sum_Rb[24] = array_reg4[26] & array_reg5[27];
                                sum_Rb[25] = array_reg4[27] & array_reg5[28];
                                sum_Rb[26] = array_reg4[28] & array_reg5[29];
                                sum_Rb[27] = array_reg4[29] & array_reg5[30];
                                sum_Rb[28] = array_reg4[30] & array_reg5[31];
                                sum_Rb[31:29] = 0;
                             end
                        3'd2:begin  //xx*xxxx
                                sum_Rb[0 ] = array_reg5[2 ] & array_reg6[3 ] ;
                                sum_Rb[1 ] = array_reg5[3 ] & array_reg6[4 ] ;
                                sum_Rb[2 ] = array_reg5[4 ] & array_reg6[5 ] ;
                                sum_Rb[3 ] = array_reg5[5 ] & array_reg6[6 ] ;                
                                sum_Rb[4 ] = array_reg5[6 ] & array_reg6[7 ] ;
                                sum_Rb[5 ] = array_reg5[7 ] & array_reg6[8 ] ;
                                sum_Rb[6 ] = array_reg5[8 ] & array_reg6[9 ] ;
                                sum_Rb[7 ] = array_reg5[9 ] & array_reg6[10] ;
                                sum_Rb[8 ] = array_reg5[10] & array_reg6[11] ;
                                sum_Rb[9 ] = array_reg5[11] & array_reg6[12] ;
                                sum_Rb[10] = array_reg5[12] & array_reg6[13] ;
                                sum_Rb[11] = array_reg5[13] & array_reg6[14] ;
                                sum_Rb[12] = array_reg5[14] & array_reg6[15] ;
                                sum_Rb[13] = array_reg5[15] & array_reg6[16] ;
                                sum_Rb[14] = array_reg5[16] & array_reg6[17] ;
                                sum_Rb[15] = array_reg5[17] & array_reg6[18] ;
                                sum_Rb[16] = array_reg5[18] & array_reg6[19] ;
                                sum_Rb[17] = array_reg5[19] & array_reg6[20] ;
                                sum_Rb[18] = array_reg5[20] & array_reg6[21] ;
                                sum_Rb[19] = array_reg5[21] & array_reg6[22] ;
                                sum_Rb[20] = array_reg5[22] & array_reg6[23] ;
                                sum_Rb[21] = array_reg5[23] & array_reg6[24] ;
                                sum_Rb[22] = array_reg5[24] & array_reg6[25] ;
                                sum_Rb[23] = array_reg5[25] & array_reg6[26] ;
                                sum_Rb[24] = array_reg5[26] & array_reg6[27] ;
                                sum_Rb[25] = array_reg5[27] & array_reg6[28] ;
                                sum_Rb[26] = array_reg5[28] & array_reg6[29] ;
                                sum_Rb[27] = array_reg5[29] & array_reg6[30] ;
                                sum_Rb[28] = array_reg5[30] & array_reg6[31] ;
                                sum_Rb[29] = array_reg5[31] &   back_reg ;
                                sum_Rb[31:30] = 0;
                             end
                         3'd3:begin  //xxx*xxx
                                sum_Rb[0 ] = array_reg6[2 ] ; 
                                sum_Rb[1 ] = array_reg6[3 ] ; 
                                sum_Rb[2 ] = array_reg6[4 ] ; 
                                sum_Rb[3 ] = array_reg6[5 ] ;                  
                                sum_Rb[4 ] = array_reg6[6 ] ; 
                                sum_Rb[5 ] = array_reg6[7 ] ; 
                                sum_Rb[6 ] = array_reg6[8 ] ; 
                                sum_Rb[7 ] = array_reg6[9 ] ; 
                                sum_Rb[8 ] = array_reg6[10] ; 
                                sum_Rb[9 ] = array_reg6[11] ; 
                                sum_Rb[10] = array_reg6[12] ; 
                                sum_Rb[11] = array_reg6[13] ; 
                                sum_Rb[12] = array_reg6[14] ; 
                                sum_Rb[13] = array_reg6[15] ; 
                                sum_Rb[14] = array_reg6[16] ; 
                                sum_Rb[15] = array_reg6[17] ; 
                                sum_Rb[16] = array_reg6[18] ; 
                                sum_Rb[17] = array_reg6[19] ; 
                                sum_Rb[18] = array_reg6[20] ; 
                                sum_Rb[19] = array_reg6[21] ; 
                                sum_Rb[20] = array_reg6[22] ; 
                                sum_Rb[21] = array_reg6[23] ; 
                                sum_Rb[22] = array_reg6[24] ; 
                                sum_Rb[23] = array_reg6[25] ; 
                                sum_Rb[24] = array_reg6[26] ; 
                                sum_Rb[25] = array_reg6[27] ; 
                                sum_Rb[26] = array_reg6[28] ; 
                                sum_Rb[27] = array_reg6[29] ; 
                                sum_Rb[28] = array_reg6[30] ; 
                                sum_Rb[29] = array_reg6[31] ; 
                                sum_Rb[30] =   back_reg ; 
                                sum_Rb[31] = 0 ;            
                             end
                        3'd4:begin  //xxxx*xx
                                sum_Rb = 32'hffff_ffff;                                              
                             end  
                         3'd5:begin  //xxxxx*x
                                sum_Rb = 32'hffff_ffff; 
                             end  
                         3'd6:begin  //xxxxxx*
                                sum_Rb = 32'hffff_ffff; 
                             end  
                          default:begin
                                sum_Rb = 0;
                             end
                    endcase
            end
      3'd7:begin  //比對八個
                    case(star_location)
                        3'd0:begin  //*xxxxxxx
                                sum_Rb[0 ] = array_reg4[3 ] & array_reg5[4 ];
                                sum_Rb[1 ] = array_reg4[4 ] & array_reg5[5 ];
                                sum_Rb[2 ] = array_reg4[5 ] & array_reg5[6 ];
                                sum_Rb[3 ] = array_reg4[6 ] & array_reg5[7 ];                        
                                sum_Rb[4 ] = array_reg4[7 ] & array_reg5[8 ];
                                sum_Rb[5 ] = array_reg4[8 ] & array_reg5[9 ];
                                sum_Rb[6 ] = array_reg4[9 ] & array_reg5[10];
                                sum_Rb[7 ] = array_reg4[10] & array_reg5[11];
                                sum_Rb[8 ] = array_reg4[11] & array_reg5[12];
                                sum_Rb[9 ] = array_reg4[12] & array_reg5[13];
                                sum_Rb[10] = array_reg4[13] & array_reg5[14];
                                sum_Rb[11] = array_reg4[14] & array_reg5[15];
                                sum_Rb[12] = array_reg4[15] & array_reg5[16];
                                sum_Rb[13] = array_reg4[16] & array_reg5[17];
                                sum_Rb[14] = array_reg4[17] & array_reg5[18];
                                sum_Rb[15] = array_reg4[18] & array_reg5[19];
                                sum_Rb[16] = array_reg4[19] & array_reg5[20];
                                sum_Rb[17] = array_reg4[20] & array_reg5[21];
                                sum_Rb[18] = array_reg4[21] & array_reg5[22];
                                sum_Rb[19] = array_reg4[22] & array_reg5[23];
                                sum_Rb[20] = array_reg4[23] & array_reg5[24];
                                sum_Rb[21] = array_reg4[24] & array_reg5[25];
                                sum_Rb[22] = array_reg4[25] & array_reg5[26];
                                sum_Rb[23] = array_reg4[26] & array_reg5[27];
                                sum_Rb[24] = array_reg4[27] & array_reg5[28];
                                sum_Rb[25] = array_reg4[28] & array_reg5[29];
                                sum_Rb[26] = array_reg4[29] & array_reg5[30];
                                sum_Rb[31:27] = 0;
                             end
                        3'd1:begin  //x*xxxxxx
                                sum_Rb[0 ] =  array_reg4[2 ] & array_reg5[3 ];
                                sum_Rb[1 ] =  array_reg4[3 ] & array_reg5[4 ];
                                sum_Rb[2 ] =  array_reg4[4 ] & array_reg5[5 ];
                                sum_Rb[3 ] =  array_reg4[5 ] & array_reg5[6 ];                        
                                sum_Rb[4 ] =  array_reg4[6 ] & array_reg5[7 ];
                                sum_Rb[5 ] =  array_reg4[7 ] & array_reg5[8 ];
                                sum_Rb[6 ] =  array_reg4[8 ] & array_reg5[9 ];
                                sum_Rb[7 ] =  array_reg4[9 ] & array_reg5[10];
                                sum_Rb[8 ] =  array_reg4[10] & array_reg5[11];
                                sum_Rb[9 ] =  array_reg4[11] & array_reg5[12];
                                sum_Rb[10] =  array_reg4[12] & array_reg5[13];
                                sum_Rb[11] =  array_reg4[13] & array_reg5[14];
                                sum_Rb[12] =  array_reg4[14] & array_reg5[15];
                                sum_Rb[13] =  array_reg4[15] & array_reg5[16];
                                sum_Rb[14] =  array_reg4[16] & array_reg5[17];
                                sum_Rb[15] =  array_reg4[17] & array_reg5[18];
                                sum_Rb[16] =  array_reg4[18] & array_reg5[19];
                                sum_Rb[17] =  array_reg4[19] & array_reg5[20];
                                sum_Rb[18] =  array_reg4[20] & array_reg5[21];
                                sum_Rb[19] =  array_reg4[21] & array_reg5[22];
                                sum_Rb[20] =  array_reg4[22] & array_reg5[23];
                                sum_Rb[21] =  array_reg4[23] & array_reg5[24];
                                sum_Rb[22] =  array_reg4[24] & array_reg5[25];
                                sum_Rb[23] =  array_reg4[25] & array_reg5[26];
                                sum_Rb[24] =  array_reg4[26] & array_reg5[27];
                                sum_Rb[25] =  array_reg4[27] & array_reg5[28];
                                sum_Rb[26] =  array_reg4[28] & array_reg5[29];
                                sum_Rb[27] =  array_reg4[29] & array_reg5[30];
                                sum_Rb[31:28] = 0;
                             end
                        3'd2:begin  //xx*xxxxx
                                sum_Rb[0 ] = array_reg5[2 ] & array_reg6[3 ];
                                sum_Rb[1 ] = array_reg5[3 ] & array_reg6[4 ];
                                sum_Rb[2 ] = array_reg5[4 ] & array_reg6[5 ];
                                sum_Rb[3 ] = array_reg5[5 ] & array_reg6[6 ];                
                                sum_Rb[4 ] = array_reg5[6 ] & array_reg6[7 ];
                                sum_Rb[5 ] = array_reg5[7 ] & array_reg6[8 ];
                                sum_Rb[6 ] = array_reg5[8 ] & array_reg6[9 ];
                                sum_Rb[7 ] = array_reg5[9 ] & array_reg6[10];
                                sum_Rb[8 ] = array_reg5[10] & array_reg6[11];
                                sum_Rb[9 ] = array_reg5[11] & array_reg6[12];
                                sum_Rb[10] = array_reg5[12] & array_reg6[13];
                                sum_Rb[11] = array_reg5[13] & array_reg6[14];
                                sum_Rb[12] = array_reg5[14] & array_reg6[15];
                                sum_Rb[13] = array_reg5[15] & array_reg6[16];
                                sum_Rb[14] = array_reg5[16] & array_reg6[17];
                                sum_Rb[15] = array_reg5[17] & array_reg6[18];
                                sum_Rb[16] = array_reg5[18] & array_reg6[19];
                                sum_Rb[17] = array_reg5[19] & array_reg6[20];
                                sum_Rb[18] = array_reg5[20] & array_reg6[21];
                                sum_Rb[19] = array_reg5[21] & array_reg6[22];
                                sum_Rb[20] = array_reg5[22] & array_reg6[23];
                                sum_Rb[21] = array_reg5[23] & array_reg6[24];
                                sum_Rb[22] = array_reg5[24] & array_reg6[25];
                                sum_Rb[23] = array_reg5[25] & array_reg6[26];
                                sum_Rb[24] = array_reg5[26] & array_reg6[27];
                                sum_Rb[25] = array_reg5[27] & array_reg6[28];
                                sum_Rb[26] = array_reg5[28] & array_reg6[29];
                                sum_Rb[27] = array_reg5[29] & array_reg6[30];
                                sum_Rb[28] = array_reg5[30] & array_reg6[31];
                                sum_Rb[31:29] = 0;
                             end
                         3'd3:begin  //xxx*xxxx
                                sum_Rb[0 ] = array_reg6[2 ] & array_reg7[3 ] ; 
                                sum_Rb[1 ] = array_reg6[3 ] & array_reg7[4 ] ; 
                                sum_Rb[2 ] = array_reg6[4 ] & array_reg7[5 ] ; 
                                sum_Rb[3 ] = array_reg6[5 ] & array_reg7[6 ] ;                  
                                sum_Rb[4 ] = array_reg6[6 ] & array_reg7[7 ] ; 
                                sum_Rb[5 ] = array_reg6[7 ] & array_reg7[8 ] ; 
                                sum_Rb[6 ] = array_reg6[8 ] & array_reg7[9 ] ; 
                                sum_Rb[7 ] = array_reg6[9 ] & array_reg7[10] ; 
                                sum_Rb[8 ] = array_reg6[10] & array_reg7[11] ; 
                                sum_Rb[9 ] = array_reg6[11] & array_reg7[12] ; 
                                sum_Rb[10] = array_reg6[12] & array_reg7[13] ; 
                                sum_Rb[11] = array_reg6[13] & array_reg7[14] ; 
                                sum_Rb[12] = array_reg6[14] & array_reg7[15] ; 
                                sum_Rb[13] = array_reg6[15] & array_reg7[16] ; 
                                sum_Rb[14] = array_reg6[16] & array_reg7[17] ; 
                                sum_Rb[15] = array_reg6[17] & array_reg7[18] ; 
                                sum_Rb[16] = array_reg6[18] & array_reg7[19] ; 
                                sum_Rb[17] = array_reg6[19] & array_reg7[20] ; 
                                sum_Rb[18] = array_reg6[20] & array_reg7[21] ; 
                                sum_Rb[19] = array_reg6[21] & array_reg7[22] ; 
                                sum_Rb[20] = array_reg6[22] & array_reg7[23] ; 
                                sum_Rb[21] = array_reg6[23] & array_reg7[24] ; 
                                sum_Rb[22] = array_reg6[24] & array_reg7[25] ; 
                                sum_Rb[23] = array_reg6[25] & array_reg7[26] ; 
                                sum_Rb[24] = array_reg6[26] & array_reg7[27] ; 
                                sum_Rb[25] = array_reg6[27] & array_reg7[28] ; 
                                sum_Rb[26] = array_reg6[28] & array_reg7[29] ; 
                                sum_Rb[27] = array_reg6[29] & array_reg7[30] ; 
                                sum_Rb[28] = array_reg6[30] & array_reg7[31] ; 
                                sum_Rb[29] = array_reg6[31] &   back_reg ; 
                                sum_Rb[31:30] = 0 ;           
                             end
                        3'd4:begin  //xxxx*xxx
                                sum_Rb[0 ] = array_reg7[2 ] ;
                                sum_Rb[1 ] = array_reg7[3 ] ;
                                sum_Rb[2 ] = array_reg7[4 ] ;
                                sum_Rb[3 ] = array_reg7[5 ] ;                  
                                sum_Rb[4 ] = array_reg7[6 ] ;
                                sum_Rb[5 ] = array_reg7[7 ] ;
                                sum_Rb[6 ] = array_reg7[8 ] ;
                                sum_Rb[7 ] = array_reg7[9 ] ;
                                sum_Rb[8 ] = array_reg7[10] ;
                                sum_Rb[9 ] = array_reg7[11] ;
                                sum_Rb[10] = array_reg7[12] ;
                                sum_Rb[11] = array_reg7[13] ;
                                sum_Rb[12] = array_reg7[14] ;
                                sum_Rb[13] = array_reg7[15] ;
                                sum_Rb[14] = array_reg7[16] ;
                                sum_Rb[15] = array_reg7[17] ;
                                sum_Rb[16] = array_reg7[18] ;
                                sum_Rb[17] = array_reg7[19] ;
                                sum_Rb[18] = array_reg7[20] ;
                                sum_Rb[19] = array_reg7[21] ;
                                sum_Rb[20] = array_reg7[22] ;
                                sum_Rb[21] = array_reg7[23] ;
                                sum_Rb[22] = array_reg7[24] ;
                                sum_Rb[23] = array_reg7[25] ;
                                sum_Rb[24] = array_reg7[26] ;
                                sum_Rb[25] = array_reg7[27] ;
                                sum_Rb[26] = array_reg7[28] ;
                                sum_Rb[27] = array_reg7[29] ;
                                sum_Rb[28] = array_reg7[30] ;
                                sum_Rb[29] = array_reg7[31] ;
                                sum_Rb[30] =   back_reg ;
                                sum_Rb[31] = 0;     
                             end  
                         3'd5:begin  //xxxxx*xx
                                sum_Rb[0 ] = array_reg6[0 ] & array_reg7[1 ] ;
                                sum_Rb[1 ] = array_reg6[1 ] & array_reg7[2 ] ;
                                sum_Rb[2 ] = array_reg6[2 ] & array_reg7[3 ] ;
                                sum_Rb[3 ] = array_reg6[3 ] & array_reg7[4 ] ;                   
                                sum_Rb[4 ] = array_reg6[4 ] & array_reg7[5 ] ;
                                sum_Rb[5 ] = array_reg6[5 ] & array_reg7[6 ] ;
                                sum_Rb[6 ] = array_reg6[6 ] & array_reg7[7 ] ;
                                sum_Rb[7 ] = array_reg6[7 ] & array_reg7[8 ] ;
                                sum_Rb[8 ] = array_reg6[8 ] & array_reg7[9 ] ;
                                sum_Rb[9 ] = array_reg6[9 ] & array_reg7[10] ;
                                sum_Rb[10] = array_reg6[10] & array_reg7[11] ;
                                sum_Rb[11] = array_reg6[11] & array_reg7[12] ;
                                sum_Rb[12] = array_reg6[12] & array_reg7[13] ;
                                sum_Rb[13] = array_reg6[13] & array_reg7[14] ;
                                sum_Rb[14] = array_reg6[14] & array_reg7[15] ;
                                sum_Rb[15] = array_reg6[15] & array_reg7[16] ;
                                sum_Rb[16] = array_reg6[16] & array_reg7[17] ;
                                sum_Rb[17] = array_reg6[17] & array_reg7[18] ;
                                sum_Rb[18] = array_reg6[18] & array_reg7[19] ;
                                sum_Rb[19] = array_reg6[19] & array_reg7[20] ;
                                sum_Rb[20] = array_reg6[20] & array_reg7[21] ;
                                sum_Rb[21] = array_reg6[21] & array_reg7[22] ;
                                sum_Rb[22] = array_reg6[22] & array_reg7[23] ;
                                sum_Rb[23] = array_reg6[23] & array_reg7[24] ;
                                sum_Rb[24] = array_reg6[24] & array_reg7[25] ;
                                sum_Rb[25] = array_reg6[25] & array_reg7[26] ;
                                sum_Rb[26] = array_reg6[26] & array_reg7[27] ;
                                sum_Rb[27] = array_reg6[27] & array_reg7[28] ;
                                sum_Rb[28] = array_reg6[28] & array_reg7[29] ;
                                sum_Rb[29] = array_reg6[29] & array_reg7[30] ;
                                sum_Rb[30] = array_reg6[30] & array_reg7[31] ;
                                sum_Rb[31] = array_reg6[31] &   back_reg ;
                             end  
                         default:begin  //xxxxxx*x
                                sum_Rb = 32'hffff_ffff; 
                             end  
                    endcase
            end
            default:begin
            sum_Rb = 32'hffff_ffff;
            end
   endcase
end
else begin
    sum_Rb = 0;
end
end
always @(*)
begin
    if(star_reg)begin
    case(last_pattern_place)
      3'd5:begin  //比對六個
                    case(star_location)
                        3'd0:begin  //*xxxxx
                                sum_Rc[0 ] = array_reg5[4 ];
                                sum_Rc[1 ] = array_reg5[5 ];
                                sum_Rc[2 ] = array_reg5[6 ];
                                sum_Rc[3 ] = array_reg5[7 ];                        
                                sum_Rc[4 ] = array_reg5[8 ];
                                sum_Rc[5 ] = array_reg5[9 ];
                                sum_Rc[6 ] = array_reg5[10];
                                sum_Rc[7 ] = array_reg5[11];
                                sum_Rc[8 ] = array_reg5[12];
                                sum_Rc[9 ] = array_reg5[13];
                                sum_Rc[10] = array_reg5[14];
                                sum_Rc[11] = array_reg5[15];
                                sum_Rc[12] = array_reg5[16];
                                sum_Rc[13] = array_reg5[17];
                                sum_Rc[14] = array_reg5[18];
                                sum_Rc[15] = array_reg5[19];
                                sum_Rc[16] = array_reg5[20];
                                sum_Rc[17] = array_reg5[21];
                                sum_Rc[18] = array_reg5[22];
                                sum_Rc[19] = array_reg5[23];
                                sum_Rc[20] = array_reg5[24];
                                sum_Rc[21] = array_reg5[25];
                                sum_Rc[22] = array_reg5[26];
                                sum_Rc[23] = array_reg5[27];
                                sum_Rc[24] = array_reg5[28];
                                sum_Rc[25] = array_reg5[29];
                                sum_Rc[26] = array_reg5[30];
                                sum_Rc[27] = array_reg5[31];
                                sum_Rc[28] =   back_reg;
                                sum_Rc[31:29] = 0;
                                sum_Lc = 32'hffff_ffff;
                             end
                        3'd1:begin  //x*xxxx
                                sum_Lc = 32'hffff_ffff; sum_Rc =  32'hffff_ffff;
                             end
                        3'd2:begin  //xx*xxx
                                sum_Lc = 32'hffff_ffff; sum_Rc =  32'hffff_ffff;
                             end
                         3'd3:begin  //xxx*xx
                                sum_Lc = 32'hffff_ffff; sum_Rc =  32'hffff_ffff;          
                             end
                        3'd4:begin  //xxxx*x
                                sum_Lc = 32'hffff_ffff; sum_Rc =  32'hffff_ffff;
                             end  
                         3'd5:begin  //xxxxx*
                                sum_Lc[0 ] = array_reg4[3 ];
                                sum_Lc[1 ] = array_reg4[4 ];
                                sum_Lc[2 ] = array_reg4[5 ];
                                sum_Lc[3 ] = array_reg4[6 ];                        
                                sum_Lc[4 ] = array_reg4[7 ];
                                sum_Lc[5 ] = array_reg4[8 ];
                                sum_Lc[6 ] = array_reg4[9 ];
                                sum_Lc[7 ] = array_reg4[10];
                                sum_Lc[8 ] = array_reg4[11];
                                sum_Lc[9 ] = array_reg4[12];
                                sum_Lc[10] = array_reg4[13];
                                sum_Lc[11] = array_reg4[14];
                                sum_Lc[12] = array_reg4[15];
                                sum_Lc[13] = array_reg4[16];
                                sum_Lc[14] = array_reg4[17];
                                sum_Lc[15] = array_reg4[18];
                                sum_Lc[16] = array_reg4[19];
                                sum_Lc[17] = array_reg4[20];
                                sum_Lc[18] = array_reg4[21];
                                sum_Lc[19] = array_reg4[22];
                                sum_Lc[20] = array_reg4[23];
                                sum_Lc[21] = array_reg4[24];
                                sum_Lc[22] = array_reg4[25];
                                sum_Lc[23] = array_reg4[26];
                                sum_Lc[24] = array_reg4[27];
                                sum_Lc[25] = array_reg4[28];
                                sum_Lc[26] = array_reg4[29];
                                sum_Lc[27] = array_reg4[30];
                                sum_Lc[28] = array_reg4[31];
                                sum_Lc[31:29] = 0;
                                sum_Rc =  32'hffff_ffff;
                             end  
                          default:begin
                                sum_Rc = 0;
                                sum_Lc = 0;
                             end
                    endcase
            end
      3'd6:begin  //比對七個
                    case(star_location)
                        3'd0:begin  //*xxxxxx
                                sum_Rc[0 ] = array_reg5[4 ] & array_reg6[5 ];
                                sum_Rc[1 ] = array_reg5[5 ] & array_reg6[6 ];
                                sum_Rc[2 ] = array_reg5[6 ] & array_reg6[7 ];
                                sum_Rc[3 ] = array_reg5[7 ] & array_reg6[8 ];                        
                                sum_Rc[4 ] = array_reg5[8 ] & array_reg6[9 ];
                                sum_Rc[5 ] = array_reg5[9 ] & array_reg6[10];
                                sum_Rc[6 ] = array_reg5[10] & array_reg6[11];
                                sum_Rc[7 ] = array_reg5[11] & array_reg6[12];
                                sum_Rc[8 ] = array_reg5[12] & array_reg6[13];
                                sum_Rc[9 ] = array_reg5[13] & array_reg6[14];
                                sum_Rc[10] = array_reg5[14] & array_reg6[15];
                                sum_Rc[11] = array_reg5[15] & array_reg6[16];
                                sum_Rc[12] = array_reg5[16] & array_reg6[17];
                                sum_Rc[13] = array_reg5[17] & array_reg6[18];
                                sum_Rc[14] = array_reg5[18] & array_reg6[19];
                                sum_Rc[15] = array_reg5[19] & array_reg6[20];
                                sum_Rc[16] = array_reg5[20] & array_reg6[21];
                                sum_Rc[17] = array_reg5[21] & array_reg6[22];
                                sum_Rc[18] = array_reg5[22] & array_reg6[23];
                                sum_Rc[19] = array_reg5[23] & array_reg6[24];
                                sum_Rc[20] = array_reg5[24] & array_reg6[25];
                                sum_Rc[21] = array_reg5[25] & array_reg6[26];
                                sum_Rc[22] = array_reg5[26] & array_reg6[27];
                                sum_Rc[23] = array_reg5[27] & array_reg6[28];
                                sum_Rc[24] = array_reg5[28] & array_reg6[29];
                                sum_Rc[25] = array_reg5[29] & array_reg6[30];
                                sum_Rc[26] = array_reg5[30] & array_reg6[31];
                                sum_Rc[27] = array_reg5[31] &   back_reg;
                                sum_Rc[31:28] = 0;
                                sum_Lc = 32'hffff_ffff;
                             end
                        3'd1:begin  //x*xxxxx
                                sum_Rc[0 ] = array_reg6[4 ];
                                sum_Rc[1 ] = array_reg6[5 ];
                                sum_Rc[2 ] = array_reg6[6 ];
                                sum_Rc[3 ] = array_reg6[7 ];                        
                                sum_Rc[4 ] = array_reg6[8 ];
                                sum_Rc[5 ] = array_reg6[9 ];
                                sum_Rc[6 ] = array_reg6[10];
                                sum_Rc[7 ] = array_reg6[11];
                                sum_Rc[8 ] = array_reg6[12];
                                sum_Rc[9 ] = array_reg6[13];
                                sum_Rc[10] = array_reg6[14];
                                sum_Rc[11] = array_reg6[15];
                                sum_Rc[12] = array_reg6[16];
                                sum_Rc[13] = array_reg6[17];
                                sum_Rc[14] = array_reg6[18];
                                sum_Rc[15] = array_reg6[19];
                                sum_Rc[16] = array_reg6[20];
                                sum_Rc[17] = array_reg6[21];
                                sum_Rc[18] = array_reg6[22];
                                sum_Rc[19] = array_reg6[23];
                                sum_Rc[20] = array_reg6[24];
                                sum_Rc[21] = array_reg6[25];
                                sum_Rc[22] = array_reg6[26];
                                sum_Rc[23] = array_reg6[27];
                                sum_Rc[24] = array_reg6[28];
                                sum_Rc[25] = array_reg6[29];
                                sum_Rc[26] = array_reg6[30];
                                sum_Rc[27] = array_reg6[31];
                                sum_Rc[28] =   back_reg;
                                sum_Rc[31:29] = 0;
                                sum_Lc = 32'hffff_ffff; 
                             end
                        3'd2:begin  //xx*xxxx
                                sum_Lc = 32'hffff_ffff; sum_Rc =  32'hffff_ffff;
                             end
                         3'd3:begin  //xxx*xxx
                                sum_Lc = 32'hffff_ffff; sum_Rc =  32'hffff_ffff;         
                             end
                        3'd4:begin  //xxxx*xx
                                sum_Lc = 32'hffff_ffff; sum_Rc =  32'hffff_ffff;     
                             end  
                         3'd5:begin  //xxxxx*x
                                sum_Lc[0 ] = array_reg4[3 ];
                                sum_Lc[1 ] = array_reg4[4 ];
                                sum_Lc[2 ] = array_reg4[5 ];
                                sum_Lc[3 ] = array_reg4[6 ];                        
                                sum_Lc[4 ] = array_reg4[7 ];
                                sum_Lc[5 ] = array_reg4[8 ];
                                sum_Lc[6 ] = array_reg4[9 ];
                                sum_Lc[7 ] = array_reg4[10];
                                sum_Lc[8 ] = array_reg4[11];
                                sum_Lc[9 ] = array_reg4[12];
                                sum_Lc[10] = array_reg4[13];
                                sum_Lc[11] = array_reg4[14];
                                sum_Lc[12] = array_reg4[15];
                                sum_Lc[13] = array_reg4[16];
                                sum_Lc[14] = array_reg4[17];
                                sum_Lc[15] = array_reg4[18];
                                sum_Lc[16] = array_reg4[19];
                                sum_Lc[17] = array_reg4[20];
                                sum_Lc[18] = array_reg4[21];
                                sum_Lc[19] = array_reg4[22];
                                sum_Lc[20] = array_reg4[23];
                                sum_Lc[21] = array_reg4[24];
                                sum_Lc[22] = array_reg4[25];
                                sum_Lc[23] = array_reg4[26];
                                sum_Lc[24] = array_reg4[27];
                                sum_Lc[25] = array_reg4[28];
                                sum_Lc[26] = array_reg4[29];
                                sum_Lc[27] = array_reg4[30];
                                sum_Lc[28] = array_reg4[31];
                                sum_Lc[31:29] = 0;
                                sum_Rc =  32'hffff_ffff;
                             end  
                         3'd6:begin  //xxxxxx*
                                sum_Lc[0 ] = array_reg4[3 ] & array_reg5[4 ];
                                sum_Lc[1 ] = array_reg4[4 ] & array_reg5[5 ];
                                sum_Lc[2 ] = array_reg4[5 ] & array_reg5[6 ];
                                sum_Lc[3 ] = array_reg4[6 ] & array_reg5[7 ];                        
                                sum_Lc[4 ] = array_reg4[7 ] & array_reg5[8 ];
                                sum_Lc[5 ] = array_reg4[8 ] & array_reg5[9 ];
                                sum_Lc[6 ] = array_reg4[9 ] & array_reg5[10];
                                sum_Lc[7 ] = array_reg4[10] & array_reg5[11];
                                sum_Lc[8 ] = array_reg4[11] & array_reg5[12];
                                sum_Lc[9 ] = array_reg4[12] & array_reg5[13];
                                sum_Lc[10] = array_reg4[13] & array_reg5[14];
                                sum_Lc[11] = array_reg4[14] & array_reg5[15];
                                sum_Lc[12] = array_reg4[15] & array_reg5[16];
                                sum_Lc[13] = array_reg4[16] & array_reg5[17];
                                sum_Lc[14] = array_reg4[17] & array_reg5[18];
                                sum_Lc[15] = array_reg4[18] & array_reg5[19];
                                sum_Lc[16] = array_reg4[19] & array_reg5[20];
                                sum_Lc[17] = array_reg4[20] & array_reg5[21];
                                sum_Lc[18] = array_reg4[21] & array_reg5[22];
                                sum_Lc[19] = array_reg4[22] & array_reg5[23];
                                sum_Lc[20] = array_reg4[23] & array_reg5[24];
                                sum_Lc[21] = array_reg4[24] & array_reg5[25];
                                sum_Lc[22] = array_reg4[25] & array_reg5[26];
                                sum_Lc[23] = array_reg4[26] & array_reg5[27];
                                sum_Lc[24] = array_reg4[27] & array_reg5[28];
                                sum_Lc[25] = array_reg4[28] & array_reg5[29];
                                sum_Lc[26] = array_reg4[29] & array_reg5[30];
                                sum_Lc[27] = array_reg4[30] & array_reg5[31];
                                sum_Lc[31:28] = 0;
                                sum_Rc =  32'hffff_ffff;
                             end  
                          default:begin
                                sum_Rc = 0;
                                sum_Lc = 0;
                             end
                    endcase
            end
      3'd7:begin  //比對八個
                    case(star_location)
                        3'd0:begin  //*xxxxxxx
                                sum_Rc[0 ] = array_reg6[5 ] & array_reg7[6 ];
                                sum_Rc[1 ] = array_reg6[6 ] & array_reg7[7 ];
                                sum_Rc[2 ] = array_reg6[7 ] & array_reg7[8 ];
                                sum_Rc[3 ] = array_reg6[8 ] & array_reg7[9 ];                        
                                sum_Rc[4 ] = array_reg6[9 ] & array_reg7[10];
                                sum_Rc[5 ] = array_reg6[10] & array_reg7[11];
                                sum_Rc[6 ] = array_reg6[11] & array_reg7[12];
                                sum_Rc[7 ] = array_reg6[12] & array_reg7[13];
                                sum_Rc[8 ] = array_reg6[13] & array_reg7[14];
                                sum_Rc[9 ] = array_reg6[14] & array_reg7[15];
                                sum_Rc[10] = array_reg6[15] & array_reg7[16];
                                sum_Rc[11] = array_reg6[16] & array_reg7[17];
                                sum_Rc[12] = array_reg6[17] & array_reg7[18];
                                sum_Rc[13] = array_reg6[18] & array_reg7[19];
                                sum_Rc[14] = array_reg6[19] & array_reg7[20];
                                sum_Rc[15] = array_reg6[20] & array_reg7[21];
                                sum_Rc[16] = array_reg6[21] & array_reg7[22];
                                sum_Rc[17] = array_reg6[22] & array_reg7[23];
                                sum_Rc[18] = array_reg6[23] & array_reg7[24];
                                sum_Rc[19] = array_reg6[24] & array_reg7[25];
                                sum_Rc[20] = array_reg6[25] & array_reg7[26];
                                sum_Rc[21] = array_reg6[26] & array_reg7[27];
                                sum_Rc[22] = array_reg6[27] & array_reg7[28];
                                sum_Rc[23] = array_reg6[28] & array_reg7[29];
                                sum_Rc[24] = array_reg6[29] & array_reg7[30];
                                sum_Rc[25] = array_reg6[30] & array_reg7[31];
                                sum_Rc[26] = array_reg6[31] &   back_reg;
                                sum_Rc[31:27] = 0;
                                sum_Lc = 32'hffff_ffff;
                             end
                        3'd1:begin  //x*xxxxxx
                                sum_Rc[0 ] = array_reg6[4 ] & array_reg7[5 ];
                                sum_Rc[1 ] = array_reg6[5 ] & array_reg7[6 ];
                                sum_Rc[2 ] = array_reg6[6 ] & array_reg7[7 ];
                                sum_Rc[3 ] = array_reg6[7 ] & array_reg7[8 ];                        
                                sum_Rc[4 ] = array_reg6[8 ] & array_reg7[9 ];
                                sum_Rc[5 ] = array_reg6[9 ] & array_reg7[10];
                                sum_Rc[6 ] = array_reg6[10] & array_reg7[11];
                                sum_Rc[7 ] = array_reg6[11] & array_reg7[12];
                                sum_Rc[8 ] = array_reg6[12] & array_reg7[13];
                                sum_Rc[9 ] = array_reg6[13] & array_reg7[14];
                                sum_Rc[10] = array_reg6[14] & array_reg7[15];
                                sum_Rc[11] = array_reg6[15] & array_reg7[16];
                                sum_Rc[12] = array_reg6[16] & array_reg7[17];
                                sum_Rc[13] = array_reg6[17] & array_reg7[18];
                                sum_Rc[14] = array_reg6[18] & array_reg7[19];
                                sum_Rc[15] = array_reg6[19] & array_reg7[20];
                                sum_Rc[16] = array_reg6[20] & array_reg7[21];
                                sum_Rc[17] = array_reg6[21] & array_reg7[22];
                                sum_Rc[18] = array_reg6[22] & array_reg7[23];
                                sum_Rc[19] = array_reg6[23] & array_reg7[24];
                                sum_Rc[20] = array_reg6[24] & array_reg7[25];
                                sum_Rc[21] = array_reg6[25] & array_reg7[26];
                                sum_Rc[22] = array_reg6[26] & array_reg7[27];
                                sum_Rc[23] = array_reg6[27] & array_reg7[28];
                                sum_Rc[24] = array_reg6[28] & array_reg7[29];
                                sum_Rc[25] = array_reg6[29] & array_reg7[30];
                                sum_Rc[26] = array_reg6[30] & array_reg7[31];
                                sum_Rc[27] = array_reg6[31] &   back_reg;
                                sum_Rc[31:28] = 0;
                                sum_Lc = 32'hffff_ffff; 
                             end
                        3'd2:begin  //xx*xxxxx
                                sum_Rc[0 ] = array_reg7[4 ] ;
                                sum_Rc[1 ] = array_reg7[5 ] ;
                                sum_Rc[2 ] = array_reg7[6 ] ;
                                sum_Rc[3 ] = array_reg7[7 ] ;                
                                sum_Rc[4 ] = array_reg7[8 ] ;
                                sum_Rc[5 ] = array_reg7[9 ] ;
                                sum_Rc[6 ] = array_reg7[10] ;
                                sum_Rc[7 ] = array_reg7[11] ;
                                sum_Rc[8 ] = array_reg7[12] ;
                                sum_Rc[9 ] = array_reg7[13] ;
                                sum_Rc[10] = array_reg7[14] ;
                                sum_Rc[11] = array_reg7[15] ;
                                sum_Rc[12] = array_reg7[16] ;
                                sum_Rc[13] = array_reg7[17] ;
                                sum_Rc[14] = array_reg7[18] ;
                                sum_Rc[15] = array_reg7[19] ;
                                sum_Rc[16] = array_reg7[20] ;
                                sum_Rc[17] = array_reg7[21] ;
                                sum_Rc[18] = array_reg7[22] ;
                                sum_Rc[19] = array_reg7[23] ;
                                sum_Rc[20] = array_reg7[24] ;
                                sum_Rc[21] = array_reg7[25] ;
                                sum_Rc[22] = array_reg7[26] ;
                                sum_Rc[23] = array_reg7[27] ;
                                sum_Rc[24] = array_reg7[28] ;
                                sum_Rc[25] = array_reg7[29] ;
                                sum_Rc[26] = array_reg7[30] ;
                                sum_Rc[27] = array_reg7[31] ;
                                sum_Rc[28] =   back_reg ;
                                sum_Rc[31:29] = 0;
                                sum_Lc = 32'hffff_ffff;
                             end
                         3'd3:begin  //xxx*xxxx
                                sum_Lc = 32'hffff_ffff; sum_Rc =  32'hffff_ffff;
                             end
                        3'd4:begin  //xxxx*xxx
                                sum_Lc = 32'hffff_ffff; sum_Rc =  32'hffff_ffff;
                             end  
                         3'd5:begin  //xxxxx*xx
                                sum_Lc[0 ] = array_reg4[3 ];     
                                sum_Lc[1 ] = array_reg4[4 ];     
                                sum_Lc[2 ] = array_reg4[5 ];     
                                sum_Lc[3 ] = array_reg4[6 ];     
                                sum_Lc[4 ] = array_reg4[7 ];     
                                sum_Lc[5 ] = array_reg4[8 ];     
                                sum_Lc[6 ] = array_reg4[9 ];     
                                sum_Lc[7 ] = array_reg4[10];     
                                sum_Lc[8 ] = array_reg4[11];     
                                sum_Lc[9 ] = array_reg4[12];     
                                sum_Lc[10] = array_reg4[13];     
                                sum_Lc[11] = array_reg4[14];     
                                sum_Lc[12] = array_reg4[15];     
                                sum_Lc[13] = array_reg4[16];     
                                sum_Lc[14] = array_reg4[17];     
                                sum_Lc[15] = array_reg4[18];     
                                sum_Lc[16] = array_reg4[19];     
                                sum_Lc[17] = array_reg4[20];     
                                sum_Lc[18] = array_reg4[21];     
                                sum_Lc[19] = array_reg4[22];     
                                sum_Lc[20] = array_reg4[23];     
                                sum_Lc[21] = array_reg4[24];     
                                sum_Lc[22] = array_reg4[25];     
                                sum_Lc[23] = array_reg4[26];     
                                sum_Lc[24] = array_reg4[27];     
                                sum_Lc[25] = array_reg4[28];     
                                sum_Lc[26] = array_reg4[29];     
                                sum_Lc[27] = array_reg4[30];     
                                sum_Lc[28] = array_reg4[31];     
                                sum_Lc[31:29] = 0;       
                                sum_Rc =  32'hffff_ffff;                 
                             end  
                         3'd6:begin  //xxxxxx*x
                                sum_Lc[0 ] = array_reg4[3 ] & array_reg5[4 ];
                                sum_Lc[1 ] = array_reg4[4 ] & array_reg5[5 ];
                                sum_Lc[2 ] = array_reg4[5 ] & array_reg5[6 ];
                                sum_Lc[3 ] = array_reg4[6 ] & array_reg5[7 ];                        
                                sum_Lc[4 ] = array_reg4[7 ] & array_reg5[8 ];
                                sum_Lc[5 ] = array_reg4[8 ] & array_reg5[9 ];
                                sum_Lc[6 ] = array_reg4[9 ] & array_reg5[10];
                                sum_Lc[7 ] = array_reg4[10] & array_reg5[11];
                                sum_Lc[8 ] = array_reg4[11] & array_reg5[12];
                                sum_Lc[9 ] = array_reg4[12] & array_reg5[13];
                                sum_Lc[10] = array_reg4[13] & array_reg5[14];
                                sum_Lc[11] = array_reg4[14] & array_reg5[15];
                                sum_Lc[12] = array_reg4[15] & array_reg5[16];
                                sum_Lc[13] = array_reg4[16] & array_reg5[17];
                                sum_Lc[14] = array_reg4[17] & array_reg5[18];
                                sum_Lc[15] = array_reg4[18] & array_reg5[19];
                                sum_Lc[16] = array_reg4[19] & array_reg5[20];
                                sum_Lc[17] = array_reg4[20] & array_reg5[21];
                                sum_Lc[18] = array_reg4[21] & array_reg5[22];
                                sum_Lc[19] = array_reg4[22] & array_reg5[23];
                                sum_Lc[20] = array_reg4[23] & array_reg5[24];
                                sum_Lc[21] = array_reg4[24] & array_reg5[25];
                                sum_Lc[22] = array_reg4[25] & array_reg5[26];
                                sum_Lc[23] = array_reg4[26] & array_reg5[27];
                                sum_Lc[24] = array_reg4[27] & array_reg5[28];
                                sum_Lc[25] = array_reg4[28] & array_reg5[29];
                                sum_Lc[26] = array_reg4[29] & array_reg5[30];
                                sum_Lc[27] = array_reg4[30] & array_reg5[31];
                                sum_Lc[31:28] = 0;
                                sum_Rc =  32'hffff_ffff;
                             end  
                         3'd7:begin  //xxxxxxx*
                                sum_Lc[0 ] = array_reg5[4 ] & array_reg6[5 ];
                                sum_Lc[1 ] = array_reg5[5 ] & array_reg6[6 ];
                                sum_Lc[2 ] = array_reg5[6 ] & array_reg6[7 ];
                                sum_Lc[3 ] = array_reg5[7 ] & array_reg6[8 ];                        
                                sum_Lc[4 ] = array_reg5[8 ] & array_reg6[9 ];
                                sum_Lc[5 ] = array_reg5[9 ] & array_reg6[10];
                                sum_Lc[6 ] = array_reg5[10] & array_reg6[11];
                                sum_Lc[7 ] = array_reg5[11] & array_reg6[12];
                                sum_Lc[8 ] = array_reg5[12] & array_reg6[13];
                                sum_Lc[9 ] = array_reg5[13] & array_reg6[14];
                                sum_Lc[10] = array_reg5[14] & array_reg6[15];
                                sum_Lc[11] = array_reg5[15] & array_reg6[16];
                                sum_Lc[12] = array_reg5[16] & array_reg6[17];
                                sum_Lc[13] = array_reg5[17] & array_reg6[18];
                                sum_Lc[14] = array_reg5[18] & array_reg6[19];
                                sum_Lc[15] = array_reg5[19] & array_reg6[20];
                                sum_Lc[16] = array_reg5[20] & array_reg6[21];
                                sum_Lc[17] = array_reg5[21] & array_reg6[22];
                                sum_Lc[18] = array_reg5[22] & array_reg6[23];
                                sum_Lc[19] = array_reg5[23] & array_reg6[24];
                                sum_Lc[20] = array_reg5[24] & array_reg6[25];
                                sum_Lc[21] = array_reg5[25] & array_reg6[26];
                                sum_Lc[22] = array_reg5[26] & array_reg6[27];
                                sum_Lc[23] = array_reg5[27] & array_reg6[28];
                                sum_Lc[24] = array_reg5[28] & array_reg6[29];
                                sum_Lc[25] = array_reg5[29] & array_reg6[30];
                                sum_Lc[26] = array_reg5[30] & array_reg6[31];
                                sum_Lc[31:27] = 0;
                                sum_Rc =  32'hffff_ffff;
                             end  
                    endcase
            end
            default:begin
            sum_Lc = 32'hffff_ffff; sum_Rc =  32'hffff_ffff;
            end
   endcase
end
else begin
    sum_Lc = 0; sum_Rc = 0;
end
end



always @(*)
begin
    if (star_reg == 0)begin
    case(last_pattern_place)
       3'd0:begin  //只比對一個
                suma  = array_reg0;
            end
       3'd1:begin  //比對兩個
                case(mode)
                2'd0:begin
                suma[0 ] =     front_reg  & array_reg1[0 ];
                suma[1 ] = array_reg0[0 ] & array_reg1[1 ];
                suma[2 ] = array_reg0[1 ] & array_reg1[2 ];
                suma[3 ] = array_reg0[2 ] & array_reg1[3 ];                        
                suma[4 ] = array_reg0[3 ] & array_reg1[4 ];
                suma[5 ] = array_reg0[4 ] & array_reg1[5 ];
                suma[6 ] = array_reg0[5 ] & array_reg1[6 ];
                suma[7 ] = array_reg0[6 ] & array_reg1[7 ];
                suma[8 ] = array_reg0[7 ] & array_reg1[8 ];
                suma[9 ] = array_reg0[8 ] & array_reg1[9 ];
                suma[10] = array_reg0[9 ] & array_reg1[10];
                suma[11] = array_reg0[10] & array_reg1[11];
                suma[12] = array_reg0[11] & array_reg1[12];
                suma[13] = array_reg0[12] & array_reg1[13];
                suma[14] = array_reg0[13] & array_reg1[14];
                suma[15] = array_reg0[14] & array_reg1[15];
                suma[16] = array_reg0[15] & array_reg1[16];
                suma[17] = array_reg0[16] & array_reg1[17];
                suma[18] = array_reg0[17] & array_reg1[18];
                suma[19] = array_reg0[18] & array_reg1[19];
                suma[20] = array_reg0[19] & array_reg1[20];
                suma[21] = array_reg0[20] & array_reg1[21];
                suma[22] = array_reg0[21] & array_reg1[22];
                suma[23] = array_reg0[22] & array_reg1[23];
                suma[24] = array_reg0[23] & array_reg1[24];
                suma[25] = array_reg0[24] & array_reg1[25];
                suma[26] = array_reg0[25] & array_reg1[26];
                suma[27] = array_reg0[26] & array_reg1[27];
                suma[28] = array_reg0[27] & array_reg1[28];
                suma[29] = array_reg0[28] & array_reg1[29];
                suma[30] = array_reg0[29] & array_reg1[30];
                suma[31] = array_reg0[30] & array_reg1[31];
                end
                2'd1:begin
                suma[0 ] = array_reg0[0 ] & array_reg1[1 ];
                suma[1 ] = array_reg0[1 ] & array_reg1[2 ];
                suma[2 ] = array_reg0[2 ] & array_reg1[3 ];
                suma[3 ] = array_reg0[3 ] & array_reg1[4 ];                        
                suma[4 ] = array_reg0[4 ] & array_reg1[5 ];
                suma[5 ] = array_reg0[5 ] & array_reg1[6 ];
                suma[6 ] = array_reg0[6 ] & array_reg1[7 ];
                suma[7 ] = array_reg0[7 ] & array_reg1[8 ];
                suma[8 ] = array_reg0[8 ] & array_reg1[9 ];
                suma[9 ] = array_reg0[9 ] & array_reg1[10];
                suma[10] = array_reg0[10] & array_reg1[11];
                suma[11] = array_reg0[11] & array_reg1[12];
                suma[12] = array_reg0[12] & array_reg1[13];
                suma[13] = array_reg0[13] & array_reg1[14];
                suma[14] = array_reg0[14] & array_reg1[15];
                suma[15] = array_reg0[15] & array_reg1[16];
                suma[16] = array_reg0[16] & array_reg1[17];
                suma[17] = array_reg0[17] & array_reg1[18];
                suma[18] = array_reg0[18] & array_reg1[19];
                suma[19] = array_reg0[19] & array_reg1[20];
                suma[20] = array_reg0[20] & array_reg1[21];
                suma[21] = array_reg0[21] & array_reg1[22];
                suma[22] = array_reg0[22] & array_reg1[23];
                suma[23] = array_reg0[23] & array_reg1[24];
                suma[24] = array_reg0[24] & array_reg1[25];
                suma[25] = array_reg0[25] & array_reg1[26];
                suma[26] = array_reg0[26] & array_reg1[27];
                suma[27] = array_reg0[27] & array_reg1[28];
                suma[28] = array_reg0[28] & array_reg1[29];
                suma[29] = array_reg0[29] & array_reg1[30];
                suma[30] = array_reg0[30] & array_reg1[31];
                suma[31] = array_reg0[31] & back_reg;
                end
                default: begin
                suma[0 ] = array_reg0[0 ] & array_reg1[1 ];
                suma[1 ] = array_reg0[1 ] & array_reg1[2 ];
                suma[2 ] = array_reg0[2 ] & array_reg1[3 ];
                suma[3 ] = array_reg0[3 ] & array_reg1[4 ];                        
                suma[4 ] = array_reg0[4 ] & array_reg1[5 ];
                suma[5 ] = array_reg0[5 ] & array_reg1[6 ];
                suma[6 ] = array_reg0[6 ] & array_reg1[7 ];
                suma[7 ] = array_reg0[7 ] & array_reg1[8 ];
                suma[8 ] = array_reg0[8 ] & array_reg1[9 ];
                suma[9 ] = array_reg0[9 ] & array_reg1[10];
                suma[10] = array_reg0[10] & array_reg1[11];
                suma[11] = array_reg0[11] & array_reg1[12];
                suma[12] = array_reg0[12] & array_reg1[13];
                suma[13] = array_reg0[13] & array_reg1[14];
                suma[14] = array_reg0[14] & array_reg1[15];
                suma[15] = array_reg0[15] & array_reg1[16];
                suma[16] = array_reg0[16] & array_reg1[17];
                suma[17] = array_reg0[17] & array_reg1[18];
                suma[18] = array_reg0[18] & array_reg1[19];
                suma[19] = array_reg0[19] & array_reg1[20];
                suma[20] = array_reg0[20] & array_reg1[21];
                suma[21] = array_reg0[21] & array_reg1[22];
                suma[22] = array_reg0[22] & array_reg1[23];
                suma[23] = array_reg0[23] & array_reg1[24];
                suma[24] = array_reg0[24] & array_reg1[25];
                suma[25] = array_reg0[25] & array_reg1[26];
                suma[26] = array_reg0[26] & array_reg1[27];
                suma[27] = array_reg0[27] & array_reg1[28];
                suma[28] = array_reg0[28] & array_reg1[29];
                suma[29] = array_reg0[29] & array_reg1[30];
                suma[30] = array_reg0[30] & array_reg1[31];
                suma[31] = 0;
                end
                endcase
            end
      3'd2:begin  //比對三個
                suma[0 ] = front_reg      & array_reg1[0 ];
                suma[1 ] = array_reg0[0 ] & array_reg1[1 ];
                suma[2 ] = array_reg0[1 ] & array_reg1[2 ];
                suma[3 ] = array_reg0[2 ] & array_reg1[3 ];                        
                suma[4 ] = array_reg0[3 ] & array_reg1[4 ];
                suma[5 ] = array_reg0[4 ] & array_reg1[5 ];
                suma[6 ] = array_reg0[5 ] & array_reg1[6 ];
                suma[7 ] = array_reg0[6 ] & array_reg1[7 ];
                suma[8 ] = array_reg0[7 ] & array_reg1[8 ];
                suma[9 ] = array_reg0[8 ] & array_reg1[9 ];
                suma[10] = array_reg0[9 ] & array_reg1[10];
                suma[11] = array_reg0[10] & array_reg1[11];
                suma[12] = array_reg0[11] & array_reg1[12];
                suma[13] = array_reg0[12] & array_reg1[13];
                suma[14] = array_reg0[13] & array_reg1[14];
                suma[15] = array_reg0[14] & array_reg1[15];
                suma[16] = array_reg0[15] & array_reg1[16];
                suma[17] = array_reg0[16] & array_reg1[17];
                suma[18] = array_reg0[17] & array_reg1[18];
                suma[19] = array_reg0[18] & array_reg1[19];
                suma[20] = array_reg0[19] & array_reg1[20];
                suma[21] = array_reg0[20] & array_reg1[21];
                suma[22] = array_reg0[21] & array_reg1[22];
                suma[23] = array_reg0[22] & array_reg1[23];
                suma[24] = array_reg0[23] & array_reg1[24];
                suma[25] = array_reg0[24] & array_reg1[25];
                suma[26] = array_reg0[25] & array_reg1[26];
                suma[27] = array_reg0[26] & array_reg1[27];
                suma[28] = array_reg0[27] & array_reg1[28];
                suma[29] = array_reg0[28] & array_reg1[29];
                suma[30] = array_reg0[29] & array_reg1[30];
                suma[31] = array_reg0[30] & array_reg1[31];
            end    
      3'd3:begin  //比對四個
                suma[0 ] = front_reg      & array_reg1[0 ];
                suma[1 ] = array_reg0[0 ] & array_reg1[1 ];
                suma[2 ] = array_reg0[1 ] & array_reg1[2 ];
                suma[3 ] = array_reg0[2 ] & array_reg1[3 ];
                suma[4 ] = array_reg0[3 ] & array_reg1[4 ];                        
                suma[5 ] = array_reg0[4 ] & array_reg1[5 ];
                suma[6 ] = array_reg0[5 ] & array_reg1[6 ];
                suma[7 ] = array_reg0[6 ] & array_reg1[7 ];
                suma[8 ] = array_reg0[7 ] & array_reg1[8 ];
                suma[9 ] = array_reg0[8 ] & array_reg1[9 ];
                suma[10] = array_reg0[9 ] & array_reg1[10];
                suma[11] = array_reg0[10] & array_reg1[11];
                suma[12] = array_reg0[11] & array_reg1[12];
                suma[13] = array_reg0[12] & array_reg1[13];
                suma[14] = array_reg0[13] & array_reg1[14];
                suma[15] = array_reg0[14] & array_reg1[15];
                suma[16] = array_reg0[15] & array_reg1[16];
                suma[17] = array_reg0[16] & array_reg1[17];
                suma[18] = array_reg0[17] & array_reg1[18];
                suma[19] = array_reg0[18] & array_reg1[19];
                suma[20] = array_reg0[19] & array_reg1[20];
                suma[21] = array_reg0[20] & array_reg1[21];
                suma[22] = array_reg0[21] & array_reg1[22];
                suma[23] = array_reg0[22] & array_reg1[23];
                suma[24] = array_reg0[23] & array_reg1[24];
                suma[25] = array_reg0[24] & array_reg1[25];
                suma[26] = array_reg0[25] & array_reg1[26];
                suma[27] = array_reg0[26] & array_reg1[27];
                suma[28] = array_reg0[27] & array_reg1[28];
                suma[29] = array_reg0[28] & array_reg1[29];
                suma[30] = array_reg0[29] & array_reg1[30];
                suma[31] = 0;
            end
      3'd4:begin  //比對五個
                suma[0 ] =  front_reg      & array_reg1[0 ];
                suma[1 ] =  array_reg0[0 ] & array_reg1[1 ];
                suma[2 ] =  array_reg0[1 ] & array_reg1[2 ];
                suma[3 ] =  array_reg0[2 ] & array_reg1[3 ];
                suma[4 ] =  array_reg0[3 ] & array_reg1[4 ];                        
                suma[5 ] =  array_reg0[4 ] & array_reg1[5 ];
                suma[6 ] =  array_reg0[5 ] & array_reg1[6 ];
                suma[7 ] =  array_reg0[6 ] & array_reg1[7 ];
                suma[8 ] =  array_reg0[7 ] & array_reg1[8 ];
                suma[9 ] =  array_reg0[8 ] & array_reg1[9 ];
                suma[10] =  array_reg0[9 ] & array_reg1[10];
                suma[11] =  array_reg0[10] & array_reg1[11];
                suma[12] =  array_reg0[11] & array_reg1[12];
                suma[13] =  array_reg0[12] & array_reg1[13];
                suma[14] =  array_reg0[13] & array_reg1[14];
                suma[15] =  array_reg0[14] & array_reg1[15];
                suma[16] =  array_reg0[15] & array_reg1[16];
                suma[17] =  array_reg0[16] & array_reg1[17];
                suma[18] =  array_reg0[17] & array_reg1[18];
                suma[19] =  array_reg0[18] & array_reg1[19];
                suma[20] =  array_reg0[19] & array_reg1[20];
                suma[21] =  array_reg0[20] & array_reg1[21];
                suma[22] =  array_reg0[21] & array_reg1[22];
                suma[23] =  array_reg0[22] & array_reg1[23];
                suma[24] =  array_reg0[23] & array_reg1[24];
                suma[25] =  array_reg0[24] & array_reg1[25];
                suma[26] =  array_reg0[25] & array_reg1[26];
                suma[27] =  array_reg0[26] & array_reg1[27];
                suma[28] =  array_reg0[27] & array_reg1[28];
                suma[29] =  array_reg0[28] & array_reg1[29];
                suma[30] =  0;
                suma[31] =  0;
            end
      3'd5:begin  //比對六個
                suma[0 ] =  front_reg      & array_reg1[0 ];
                suma[1 ] =  array_reg0[0 ] & array_reg1[1 ];
                suma[2 ] =  array_reg0[1 ] & array_reg1[2 ];
                suma[3 ] =  array_reg0[2 ] & array_reg1[3 ];
                suma[4 ] =  array_reg0[3 ] & array_reg1[4 ];                     
                suma[5 ] =  array_reg0[4 ] & array_reg1[5 ];
                suma[6 ] =  array_reg0[5 ] & array_reg1[6 ];
                suma[7 ] =  array_reg0[6 ] & array_reg1[7 ];
                suma[8 ] =  array_reg0[7 ] & array_reg1[8 ];
                suma[9 ] =  array_reg0[8 ] & array_reg1[9 ];
                suma[10] =  array_reg0[9 ] & array_reg1[10];
                suma[11] =  array_reg0[10] & array_reg1[11];
                suma[12] =  array_reg0[11] & array_reg1[12];
                suma[13] =  array_reg0[12] & array_reg1[13];
                suma[14] =  array_reg0[13] & array_reg1[14];
                suma[15] =  array_reg0[14] & array_reg1[15];
                suma[16] =  array_reg0[15] & array_reg1[16];
                suma[17] =  array_reg0[16] & array_reg1[17];
                suma[18] =  array_reg0[17] & array_reg1[18];
                suma[19] =  array_reg0[18] & array_reg1[19];
                suma[20] =  array_reg0[19] & array_reg1[20];
                suma[21] =  array_reg0[20] & array_reg1[21];
                suma[22] =  array_reg0[21] & array_reg1[22];
                suma[23] =  array_reg0[22] & array_reg1[23];
                suma[24] =  array_reg0[23] & array_reg1[24];
                suma[25] =  array_reg0[24] & array_reg1[25];
                suma[26] =  array_reg0[25] & array_reg1[26];
                suma[27] =  array_reg0[26] & array_reg1[27];
                suma[28] =  array_reg0[27] & array_reg1[28];
                suma[29] =  0;
                suma[30] =  0;
                suma[31] =  0;
            end
      3'd6:begin  //比對七個
                suma[0 ] =      front_reg  & array_reg1[0 ] & array_reg2[1 ];
                suma[1 ] =  array_reg0[0 ] & array_reg1[1 ] & array_reg2[2 ];
                suma[2 ] =  array_reg0[1 ] & array_reg1[2 ] & array_reg2[3 ];
                suma[3 ] =  array_reg0[2 ] & array_reg1[3 ] & array_reg2[4 ];
                suma[4 ] =  array_reg0[3 ] & array_reg1[4 ] & array_reg2[5 ];                        
                suma[5 ] =  array_reg0[4 ] & array_reg1[5 ] & array_reg2[6 ];
                suma[6 ] =  array_reg0[5 ] & array_reg1[6 ] & array_reg2[7 ];
                suma[7 ] =  array_reg0[6 ] & array_reg1[7 ] & array_reg2[8 ];
                suma[8 ] =  array_reg0[7 ] & array_reg1[8 ] & array_reg2[9 ];
                suma[9 ] =  array_reg0[8 ] & array_reg1[9 ] & array_reg2[10];
                suma[10] =  array_reg0[9 ] & array_reg1[10] & array_reg2[11];
                suma[11] =  array_reg0[10] & array_reg1[11] & array_reg2[12];
                suma[12] =  array_reg0[11] & array_reg1[12] & array_reg2[13];
                suma[13] =  array_reg0[12] & array_reg1[13] & array_reg2[14];
                suma[14] =  array_reg0[13] & array_reg1[14] & array_reg2[15];
                suma[15] =  array_reg0[14] & array_reg1[15] & array_reg2[16];
                suma[16] =  array_reg0[15] & array_reg1[16] & array_reg2[17];
                suma[17] =  array_reg0[16] & array_reg1[17] & array_reg2[18];
                suma[18] =  array_reg0[17] & array_reg1[18] & array_reg2[19];
                suma[19] =  array_reg0[18] & array_reg1[19] & array_reg2[20];
                suma[20] =  array_reg0[19] & array_reg1[20] & array_reg2[21];
                suma[21] =  array_reg0[20] & array_reg1[21] & array_reg2[22];
                suma[22] =  array_reg0[21] & array_reg1[22] & array_reg2[23];
                suma[23] =  array_reg0[22] & array_reg1[23] & array_reg2[24];
                suma[24] =  array_reg0[23] & array_reg1[24] & array_reg2[25];
                suma[25] =  array_reg0[24] & array_reg1[25] & array_reg2[26];
                suma[26] =  array_reg0[25] & array_reg1[26] & array_reg2[27];
                suma[27] =  array_reg0[26] & array_reg1[27] & array_reg2[28];
                suma[28] =  0;
                suma[29] =  0;
                suma[30] =  0;
                suma[31] =  0;
            end
      3'd7:begin  //比對八個
                suma[0 ] =      front_reg  & array_reg1[0 ] & array_reg2[1 ];
                suma[1 ] =  array_reg0[0 ] & array_reg1[1 ] & array_reg2[2 ];
                suma[2 ] =  array_reg0[1 ] & array_reg1[2 ] & array_reg2[3 ];
                suma[3 ] =  array_reg0[2 ] & array_reg1[3 ] & array_reg2[4 ];
                suma[4 ] =  array_reg0[3 ] & array_reg1[4 ] & array_reg2[5 ];                        
                suma[5 ] =  array_reg0[4 ] & array_reg1[5 ] & array_reg2[6 ];
                suma[6 ] =  array_reg0[5 ] & array_reg1[6 ] & array_reg2[7 ];
                suma[7 ] =  array_reg0[6 ] & array_reg1[7 ] & array_reg2[8 ];
                suma[8 ] =  array_reg0[7 ] & array_reg1[8 ] & array_reg2[9 ];
                suma[9 ] =  array_reg0[8 ] & array_reg1[9 ] & array_reg2[10];
                suma[10] =  array_reg0[9 ] & array_reg1[10] & array_reg2[11];
                suma[11] =  array_reg0[10] & array_reg1[11] & array_reg2[12];
                suma[12] =  array_reg0[11] & array_reg1[12] & array_reg2[13];
                suma[13] =  array_reg0[12] & array_reg1[13] & array_reg2[14];
                suma[14] =  array_reg0[13] & array_reg1[14] & array_reg2[15];
                suma[15] =  array_reg0[14] & array_reg1[15] & array_reg2[16];
                suma[16] =  array_reg0[15] & array_reg1[16] & array_reg2[17];
                suma[17] =  array_reg0[16] & array_reg1[17] & array_reg2[18];
                suma[18] =  array_reg0[17] & array_reg1[18] & array_reg2[19];
                suma[19] =  array_reg0[18] & array_reg1[19] & array_reg2[20];
                suma[20] =  array_reg0[19] & array_reg1[20] & array_reg2[21];
                suma[21] =  array_reg0[20] & array_reg1[21] & array_reg2[22];
                suma[22] =  array_reg0[21] & array_reg1[22] & array_reg2[23];
                suma[23] =  array_reg0[22] & array_reg1[23] & array_reg2[24];
                suma[24] =  array_reg0[23] & array_reg1[24] & array_reg2[25];
                suma[25] =  array_reg0[24] & array_reg1[25] & array_reg2[26];
                suma[26] =  array_reg0[25] & array_reg1[26] & array_reg2[27];     
                suma[27] =  0; 
                suma[28] =  0;
                suma[29] =  0;
                suma[30] =  0;
                suma[31] =  0;
            end
   endcase
   end
   else begin
        suma = 0;
   end
end

always @(*)
begin
    if (star_reg == 0)begin
    case(last_pattern_place)
       3'd2:begin  //比對三個
                sumb[0 ] =  array_reg2[1 ];
                sumb[1 ] =  array_reg2[2 ];
                sumb[2 ] =  array_reg2[3 ];
                sumb[3 ] =  array_reg2[4 ];                        
                sumb[4 ] =  array_reg2[5 ];
                sumb[5 ] =  array_reg2[6 ];
                sumb[6 ] =  array_reg2[7 ];
                sumb[7 ] =  array_reg2[8 ];
                sumb[8 ] =  array_reg2[9 ];
                sumb[9 ] =  array_reg2[10];
                sumb[10] =  array_reg2[11];
                sumb[11] =  array_reg2[12];
                sumb[12] =  array_reg2[13];
                sumb[13] =  array_reg2[14];
                sumb[14] =  array_reg2[15];
                sumb[15] =  array_reg2[16];
                sumb[16] =  array_reg2[17];
                sumb[17] =  array_reg2[18];
                sumb[18] =  array_reg2[19];
                sumb[19] =  array_reg2[20];
                sumb[20] =  array_reg2[21];
                sumb[21] =  array_reg2[22];
                sumb[22] =  array_reg2[23];
                sumb[23] =  array_reg2[24];
                sumb[24] =  array_reg2[25];
                sumb[25] =  array_reg2[26];
                sumb[26] =  array_reg2[27];
                sumb[27] =  array_reg2[28];
                sumb[28] =  array_reg2[29];
                sumb[29] =  array_reg2[30];
                sumb[30] =  array_reg2[31];
                sumb[31] =  back_reg;
            end    
      3'd3:begin  //比對四個
                sumb[0 ] =  array_reg2[1 ] & array_reg3[2 ];
                sumb[1 ] =  array_reg2[2 ] & array_reg3[3 ];
                sumb[2 ] =  array_reg2[3 ] & array_reg3[4 ];
                sumb[3 ] =  array_reg2[4 ] & array_reg3[5 ];
                sumb[4 ] =  array_reg2[5 ] & array_reg3[6 ];                        
                sumb[5 ] =  array_reg2[6 ] & array_reg3[7 ];
                sumb[6 ] =  array_reg2[7 ] & array_reg3[8 ];
                sumb[7 ] =  array_reg2[8 ] & array_reg3[9 ];
                sumb[8 ] =  array_reg2[9 ] & array_reg3[10];
                sumb[9 ] =  array_reg2[10] & array_reg3[11];
                sumb[10] =  array_reg2[11] & array_reg3[12];
                sumb[11] =  array_reg2[12] & array_reg3[13];
                sumb[12] =  array_reg2[13] & array_reg3[14];
                sumb[13] =  array_reg2[14] & array_reg3[15];
                sumb[14] =  array_reg2[15] & array_reg3[16];
                sumb[15] =  array_reg2[16] & array_reg3[17];
                sumb[16] =  array_reg2[17] & array_reg3[18];
                sumb[17] =  array_reg2[18] & array_reg3[19];
                sumb[18] =  array_reg2[19] & array_reg3[20];
                sumb[19] =  array_reg2[20] & array_reg3[21];
                sumb[20] =  array_reg2[21] & array_reg3[22];
                sumb[21] =  array_reg2[22] & array_reg3[23];
                sumb[22] =  array_reg2[23] & array_reg3[24];
                sumb[23] =  array_reg2[24] & array_reg3[25];
                sumb[24] =  array_reg2[25] & array_reg3[26];
                sumb[25] =  array_reg2[26] & array_reg3[27];
                sumb[26] =  array_reg2[27] & array_reg3[28];
                sumb[27] =  array_reg2[28] & array_reg3[29];
                sumb[28] =  array_reg2[29] & array_reg3[30];
                sumb[29] =  array_reg2[30] & array_reg3[31];
                sumb[30] =  array_reg2[31] & back_reg;
                sumb[31] =  0;
            end
      3'd4:begin  //比對五個
                sumb[0 ] =   array_reg2[1 ] & array_reg3[2 ] ;
                sumb[1 ] =   array_reg2[2 ] & array_reg3[3 ] ;
                sumb[2 ] =   array_reg2[3 ] & array_reg3[4 ] ;
                sumb[3 ] =   array_reg2[4 ] & array_reg3[5 ] ;
                sumb[4 ] =   array_reg2[5 ] & array_reg3[6 ] ;                        
                sumb[5 ] =   array_reg2[6 ] & array_reg3[7 ] ;
                sumb[6 ] =   array_reg2[7 ] & array_reg3[8 ] ;
                sumb[7 ] =   array_reg2[8 ] & array_reg3[9 ] ;
                sumb[8 ] =   array_reg2[9 ] & array_reg3[10] ;
                sumb[9 ] =   array_reg2[10] & array_reg3[11] ;
                sumb[10] =   array_reg2[11] & array_reg3[12] ;
                sumb[11] =   array_reg2[12] & array_reg3[13] ;
                sumb[12] =   array_reg2[13] & array_reg3[14] ;
                sumb[13] =   array_reg2[14] & array_reg3[15] ;
                sumb[14] =   array_reg2[15] & array_reg3[16] ;
                sumb[15] =   array_reg2[16] & array_reg3[17] ;
                sumb[16] =   array_reg2[17] & array_reg3[18] ;
                sumb[17] =   array_reg2[18] & array_reg3[19] ;
                sumb[18] =   array_reg2[19] & array_reg3[20] ;
                sumb[19] =   array_reg2[20] & array_reg3[21] ;
                sumb[20] =   array_reg2[21] & array_reg3[22] ;
                sumb[21] =   array_reg2[22] & array_reg3[23] ;
                sumb[22] =   array_reg2[23] & array_reg3[24] ;
                sumb[23] =   array_reg2[24] & array_reg3[25] ;
                sumb[24] =   array_reg2[25] & array_reg3[26] ;
                sumb[25] =   array_reg2[26] & array_reg3[27] ;
                sumb[26] =   array_reg2[27] & array_reg3[28] ;
                sumb[27] =   array_reg2[28] & array_reg3[29] ;
                sumb[28] =   array_reg2[29] & array_reg3[30] ;
                sumb[29] =   array_reg2[30] & array_reg3[31] ;
                sumb[31:30] =  0;
            end
      3'd5:begin  //比對六個
                sumb[0 ] =   array_reg2[1 ] & array_reg3[2 ] ;
                sumb[1 ] =   array_reg2[2 ] & array_reg3[3 ] ;
                sumb[2 ] =   array_reg2[3 ] & array_reg3[4 ] ;
                sumb[3 ] =   array_reg2[4 ] & array_reg3[5 ] ;
                sumb[4 ] =   array_reg2[5 ] & array_reg3[6 ] ;                     
                sumb[5 ] =   array_reg2[6 ] & array_reg3[7 ] ;
                sumb[6 ] =   array_reg2[7 ] & array_reg3[8 ] ;
                sumb[7 ] =   array_reg2[8 ] & array_reg3[9 ] ;
                sumb[8 ] =   array_reg2[9 ] & array_reg3[10] ;
                sumb[9 ] =   array_reg2[10] & array_reg3[11] ;
                sumb[10] =   array_reg2[11] & array_reg3[12] ;
                sumb[11] =   array_reg2[12] & array_reg3[13] ;
                sumb[12] =   array_reg2[13] & array_reg3[14] ;
                sumb[13] =   array_reg2[14] & array_reg3[15] ;
                sumb[14] =   array_reg2[15] & array_reg3[16] ;
                sumb[15] =   array_reg2[16] & array_reg3[17] ;
                sumb[16] =   array_reg2[17] & array_reg3[18] ;
                sumb[17] =   array_reg2[18] & array_reg3[19] ;
                sumb[18] =   array_reg2[19] & array_reg3[20] ;
                sumb[19] =   array_reg2[20] & array_reg3[21] ;
                sumb[20] =   array_reg2[21] & array_reg3[22] ;
                sumb[21] =   array_reg2[22] & array_reg3[23] ;
                sumb[22] =   array_reg2[23] & array_reg3[24] ;
                sumb[23] =   array_reg2[24] & array_reg3[25] ;
                sumb[24] =   array_reg2[25] & array_reg3[26] ;
                sumb[25] =   array_reg2[26] & array_reg3[27] ;
                sumb[26] =   array_reg2[27] & array_reg3[28] ;
                sumb[27] =   array_reg2[28] & array_reg3[29] ;
                sumb[28] =   array_reg2[29] & array_reg3[30] ;
                sumb[31:29] =  0;
            end
      3'd6:begin  //比對七個
                sumb[0 ] =  array_reg3[2 ] & array_reg4[3 ];
                sumb[1 ] =  array_reg3[3 ] & array_reg4[4 ];
                sumb[2 ] =  array_reg3[4 ] & array_reg4[5 ];
                sumb[3 ] =  array_reg3[5 ] & array_reg4[6 ];
                sumb[4 ] =  array_reg3[6 ] & array_reg4[7 ];                        
                sumb[5 ] =  array_reg3[7 ] & array_reg4[8 ];
                sumb[6 ] =  array_reg3[8 ] & array_reg4[9 ];
                sumb[7 ] =  array_reg3[9 ] & array_reg4[10];
                sumb[8 ] =  array_reg3[10] & array_reg4[11];
                sumb[9 ] =  array_reg3[11] & array_reg4[12];
                sumb[10] =  array_reg3[12] & array_reg4[13];
                sumb[11] =  array_reg3[13] & array_reg4[14];
                sumb[12] =  array_reg3[14] & array_reg4[15];
                sumb[13] =  array_reg3[15] & array_reg4[16];
                sumb[14] =  array_reg3[16] & array_reg4[17];
                sumb[15] =  array_reg3[17] & array_reg4[18];
                sumb[16] =  array_reg3[18] & array_reg4[19];
                sumb[17] =  array_reg3[19] & array_reg4[20];
                sumb[18] =  array_reg3[20] & array_reg4[21];
                sumb[19] =  array_reg3[21] & array_reg4[22];
                sumb[20] =  array_reg3[22] & array_reg4[23];
                sumb[21] =  array_reg3[23] & array_reg4[24];
                sumb[22] =  array_reg3[24] & array_reg4[25];
                sumb[23] =  array_reg3[25] & array_reg4[26];
                sumb[24] =  array_reg3[26] & array_reg4[27];
                sumb[25] =  array_reg3[27] & array_reg4[28];
                sumb[26] =  array_reg3[28] & array_reg4[29];
                sumb[27] =  array_reg3[29] & array_reg4[30];
                sumb[31:28] =  0;
            end
      3'd7:begin  //比對八個
                sumb[0 ] =  array_reg3[2 ] & array_reg4[3 ] & array_reg5[4 ];
                sumb[1 ] =  array_reg3[3 ] & array_reg4[4 ] & array_reg5[5 ];
                sumb[2 ] =  array_reg3[4 ] & array_reg4[5 ] & array_reg5[6 ];
                sumb[3 ] =  array_reg3[5 ] & array_reg4[6 ] & array_reg5[7 ];
                sumb[4 ] =  array_reg3[6 ] & array_reg4[7 ] & array_reg5[8 ];                        
                sumb[5 ] =  array_reg3[7 ] & array_reg4[8 ] & array_reg5[9 ];
                sumb[6 ] =  array_reg3[8 ] & array_reg4[9 ] & array_reg5[10];
                sumb[7 ] =  array_reg3[9 ] & array_reg4[10] & array_reg5[11];
                sumb[8 ] =  array_reg3[10] & array_reg4[11] & array_reg5[12];
                sumb[9 ] =  array_reg3[11] & array_reg4[12] & array_reg5[13];
                sumb[10] =  array_reg3[12] & array_reg4[13] & array_reg5[14];
                sumb[11] =  array_reg3[13] & array_reg4[14] & array_reg5[15];
                sumb[12] =  array_reg3[14] & array_reg4[15] & array_reg5[16];
                sumb[13] =  array_reg3[15] & array_reg4[16] & array_reg5[17];
                sumb[14] =  array_reg3[16] & array_reg4[17] & array_reg5[18];
                sumb[15] =  array_reg3[17] & array_reg4[18] & array_reg5[19];
                sumb[16] =  array_reg3[18] & array_reg4[19] & array_reg5[20];
                sumb[17] =  array_reg3[19] & array_reg4[20] & array_reg5[21];
                sumb[18] =  array_reg3[20] & array_reg4[21] & array_reg5[22];
                sumb[19] =  array_reg3[21] & array_reg4[22] & array_reg5[23];
                sumb[20] =  array_reg3[22] & array_reg4[23] & array_reg5[24];
                sumb[21] =  array_reg3[23] & array_reg4[24] & array_reg5[25];
                sumb[22] =  array_reg3[24] & array_reg4[25] & array_reg5[26];
                sumb[23] =  array_reg3[25] & array_reg4[26] & array_reg5[27];
                sumb[24] =  array_reg3[26] & array_reg4[27] & array_reg5[28];
                sumb[25] =  array_reg3[27] & array_reg4[28] & array_reg5[29];
                sumb[26] =  array_reg3[28] & array_reg4[29] & array_reg5[30];     
                sumb[31:27] =  0;     
            end
            default:begin
            sumb = 32'hffff_ffff;
            end
   endcase
   end
   else begin
        sumb = 0;
   end
end

always @(*)
begin
    if (star_reg == 0)begin
    case(last_pattern_place)
      3'd4:begin  //比對五個
                sumc[0 ] =  array_reg4[3 ];
                sumc[1 ] =  array_reg4[4 ];
                sumc[2 ] =  array_reg4[5 ];
                sumc[3 ] =  array_reg4[6 ];
                sumc[4 ] =  array_reg4[7 ];                        
                sumc[5 ] =  array_reg4[8 ];
                sumc[6 ] =  array_reg4[9 ];
                sumc[7 ] =  array_reg4[10];
                sumc[8 ] =  array_reg4[11];
                sumc[9 ] =  array_reg4[12];
                sumc[10] =  array_reg4[13];
                sumc[11] =  array_reg4[14];
                sumc[12] =  array_reg4[15];
                sumc[13] =  array_reg4[16];
                sumc[14] =  array_reg4[17];
                sumc[15] =  array_reg4[18];
                sumc[16] =  array_reg4[19];
                sumc[17] =  array_reg4[20];
                sumc[18] =  array_reg4[21];
                sumc[19] =  array_reg4[22];
                sumc[20] =  array_reg4[23];
                sumc[21] =  array_reg4[24];
                sumc[22] =  array_reg4[25];
                sumc[23] =  array_reg4[26];
                sumc[24] =  array_reg4[27];
                sumc[25] =  array_reg4[28];
                sumc[26] =  array_reg4[29];
                sumc[27] =  array_reg4[30];
                sumc[28] =  array_reg4[31];
                sumc[29] =  back_reg;
                sumc[31:30] =  0;
            end
      3'd5:begin  //比對六個
                sumc[0 ] =  array_reg4[3 ] & array_reg5[4 ];
                sumc[1 ] =  array_reg4[4 ] & array_reg5[5 ];
                sumc[2 ] =  array_reg4[5 ] & array_reg5[6 ];
                sumc[3 ] =  array_reg4[6 ] & array_reg5[7 ];
                sumc[4 ] =  array_reg4[7 ] & array_reg5[8 ];                     
                sumc[5 ] =  array_reg4[8 ] & array_reg5[9 ];
                sumc[6 ] =  array_reg4[9 ] & array_reg5[10];
                sumc[7 ] =  array_reg4[10] & array_reg5[11];
                sumc[8 ] =  array_reg4[11] & array_reg5[12];
                sumc[9 ] =  array_reg4[12] & array_reg5[13];
                sumc[10] =  array_reg4[13] & array_reg5[14];
                sumc[11] =  array_reg4[14] & array_reg5[15];
                sumc[12] =  array_reg4[15] & array_reg5[16];
                sumc[13] =  array_reg4[16] & array_reg5[17];
                sumc[14] =  array_reg4[17] & array_reg5[18];
                sumc[15] =  array_reg4[18] & array_reg5[19];
                sumc[16] =  array_reg4[19] & array_reg5[20];
                sumc[17] =  array_reg4[20] & array_reg5[21];
                sumc[18] =  array_reg4[21] & array_reg5[22];
                sumc[19] =  array_reg4[22] & array_reg5[23];
                sumc[20] =  array_reg4[23] & array_reg5[24];
                sumc[21] =  array_reg4[24] & array_reg5[25];
                sumc[22] =  array_reg4[25] & array_reg5[26];
                sumc[23] =  array_reg4[26] & array_reg5[27];
                sumc[24] =  array_reg4[27] & array_reg5[28];
                sumc[25] =  array_reg4[28] & array_reg5[29];
                sumc[26] =  array_reg4[29] & array_reg5[30];
                sumc[27] =  array_reg4[30] & array_reg5[31];
                sumc[28] =  array_reg4[31] & back_reg;
                sumc[31:29] =  0;
            end
      3'd6:begin  //比對七個
                sumc[0 ] =  array_reg5[4 ] & array_reg6[5 ];
                sumc[1 ] =  array_reg5[5 ] & array_reg6[6 ];
                sumc[2 ] =  array_reg5[6 ] & array_reg6[7 ];
                sumc[3 ] =  array_reg5[7 ] & array_reg6[8 ];
                sumc[4 ] =  array_reg5[8 ] & array_reg6[9 ];                        
                sumc[5 ] =  array_reg5[9 ] & array_reg6[10];
                sumc[6 ] =  array_reg5[10] & array_reg6[11];
                sumc[7 ] =  array_reg5[11] & array_reg6[12];
                sumc[8 ] =  array_reg5[12] & array_reg6[13];
                sumc[9 ] =  array_reg5[13] & array_reg6[14];
                sumc[10] =  array_reg5[14] & array_reg6[15];
                sumc[11] =  array_reg5[15] & array_reg6[16];
                sumc[12] =  array_reg5[16] & array_reg6[17];
                sumc[13] =  array_reg5[17] & array_reg6[18];
                sumc[14] =  array_reg5[18] & array_reg6[19];
                sumc[15] =  array_reg5[19] & array_reg6[20];
                sumc[16] =  array_reg5[20] & array_reg6[21];
                sumc[17] =  array_reg5[21] & array_reg6[22];
                sumc[18] =  array_reg5[22] & array_reg6[23];
                sumc[19] =  array_reg5[23] & array_reg6[24];
                sumc[20] =  array_reg5[24] & array_reg6[25];
                sumc[21] =  array_reg5[25] & array_reg6[26];
                sumc[22] =  array_reg5[26] & array_reg6[27];
                sumc[23] =  array_reg5[27] & array_reg6[28];
                sumc[24] =  array_reg5[28] & array_reg6[29];
                sumc[25] =  array_reg5[29] & array_reg6[30];
                sumc[26] =  array_reg5[30] & array_reg6[31];
                sumc[27] =  array_reg5[31] & back_reg;
                sumc[31:28] =  0;
            end
      3'd7:begin  //比對八個
                sumc[0 ] =  array_reg6[5 ] & array_reg7[6 ];
                sumc[1 ] =  array_reg6[6 ] & array_reg7[7 ];
                sumc[2 ] =  array_reg6[7 ] & array_reg7[8 ];
                sumc[3 ] =  array_reg6[8 ] & array_reg7[9 ];
                sumc[4 ] =  array_reg6[9 ] & array_reg7[10];                        
                sumc[5 ] =  array_reg6[10] & array_reg7[11];
                sumc[6 ] =  array_reg6[11] & array_reg7[12];
                sumc[7 ] =  array_reg6[12] & array_reg7[13];
                sumc[8 ] =  array_reg6[13] & array_reg7[14];
                sumc[9 ] =  array_reg6[14] & array_reg7[15];
                sumc[10] =  array_reg6[15] & array_reg7[16];
                sumc[11] =  array_reg6[16] & array_reg7[17];
                sumc[12] =  array_reg6[17] & array_reg7[18];
                sumc[13] =  array_reg6[18] & array_reg7[19];
                sumc[14] =  array_reg6[19] & array_reg7[20];
                sumc[15] =  array_reg6[20] & array_reg7[21];
                sumc[16] =  array_reg6[21] & array_reg7[22];
                sumc[17] =  array_reg6[22] & array_reg7[23];
                sumc[18] =  array_reg6[23] & array_reg7[24];
                sumc[19] =  array_reg6[24] & array_reg7[25];
                sumc[20] =  array_reg6[25] & array_reg7[26];
                sumc[21] =  array_reg6[26] & array_reg7[27];
                sumc[22] =  array_reg6[27] & array_reg7[28];
                sumc[23] =  array_reg6[28] & array_reg7[29];
                sumc[24] =  array_reg6[29] & array_reg7[30];
                sumc[25] =  array_reg6[30] & array_reg7[31];
                sumc[26] =  array_reg6[31] & back_reg;     
                sumc[31:27] =  0; 
            end
            default:begin
                sumc = 32'hffff_ffff;
            end
   endcase
   end
   else begin
        sumc = 0;
   end
end

endmodule






module Compare(string31,string30,string29,string28,string27,string26,string25,string24,string23,string22,string21,string20,
               string19,string18,string17,string16,string15,string14,string13,string12,string11,string10,
               string9 ,string8 ,string7 ,string6 ,string5 ,string4 ,string3 ,string2 ,string1 ,string0,
               pattern,array,front,back,string_len,star);

input [5:0] string_len;           
input [7:0] string31,string30,string29,string28,string27,string26,string25,string24,string23,string22,string21,
            string20,string19,string18,string17,string16,string15,string14,string13,string12,string11,
            string10,string9 ,string8 ,string7 ,string6 ,string5 ,string4 ,string3 ,string2 ,string1 ,string0;
input [7:0] pattern;
output reg [31:0] array=0;
output reg front=0,back=0,star=0;
wire [31:0] a, b;
assign a[0 ] = (string0  == 8'h20) ? 1'b1:1'b0;         assign b[0 ] = (string_len == 6'd0 ) ? 1'b1:1'b0;     
assign a[1 ] = (string1  == 8'h20) ? 1'b1:1'b0;         assign b[1 ] = (string_len == 6'd1 ) ? 1'b1:1'b0;     
assign a[2 ] = (string2  == 8'h20) ? 1'b1:1'b0;         assign b[2 ] = (string_len == 6'd2 ) ? 1'b1:1'b0;     
assign a[3 ] = (string3  == 8'h20) ? 1'b1:1'b0;         assign b[3 ] = (string_len == 6'd3 ) ? 1'b1:1'b0;     
assign a[4 ] = (string4  == 8'h20) ? 1'b1:1'b0;         assign b[4 ] = (string_len == 6'd4 ) ? 1'b1:1'b0;     
assign a[5 ] = (string5  == 8'h20) ? 1'b1:1'b0;         assign b[5 ] = (string_len == 6'd5 ) ? 1'b1:1'b0;     
assign a[6 ] = (string6  == 8'h20) ? 1'b1:1'b0;         assign b[6 ] = (string_len == 6'd6 ) ? 1'b1:1'b0;     
assign a[7 ] = (string7  == 8'h20) ? 1'b1:1'b0;         assign b[7 ] = (string_len == 6'd7 ) ? 1'b1:1'b0;     
assign a[8 ] = (string8  == 8'h20) ? 1'b1:1'b0;         assign b[8 ] = (string_len == 6'd8 ) ? 1'b1:1'b0;     
assign a[9 ] = (string9  == 8'h20) ? 1'b1:1'b0;         assign b[9 ] = (string_len == 6'd9 ) ? 1'b1:1'b0;     
assign a[10] = (string10 == 8'h20) ? 1'b1:1'b0;         assign b[10] = (string_len == 6'd10) ? 1'b1:1'b0;     
assign a[11] = (string11 == 8'h20) ? 1'b1:1'b0;         assign b[11] = (string_len == 6'd11) ? 1'b1:1'b0;     
assign a[12] = (string12 == 8'h20) ? 1'b1:1'b0;         assign b[12] = (string_len == 6'd12) ? 1'b1:1'b0;     
assign a[13] = (string13 == 8'h20) ? 1'b1:1'b0;         assign b[13] = (string_len == 6'd13) ? 1'b1:1'b0;     
assign a[14] = (string14 == 8'h20) ? 1'b1:1'b0;         assign b[14] = (string_len == 6'd14) ? 1'b1:1'b0;     
assign a[15] = (string15 == 8'h20) ? 1'b1:1'b0;         assign b[15] = (string_len == 6'd15) ? 1'b1:1'b0;     
assign a[16] = (string16 == 8'h20) ? 1'b1:1'b0;         assign b[16] = (string_len == 6'd16) ? 1'b1:1'b0;     
assign a[17] = (string17 == 8'h20) ? 1'b1:1'b0;         assign b[17] = (string_len == 6'd17) ? 1'b1:1'b0;     
assign a[18] = (string18 == 8'h20) ? 1'b1:1'b0;         assign b[18] = (string_len == 6'd18) ? 1'b1:1'b0;     
assign a[19] = (string19 == 8'h20) ? 1'b1:1'b0;         assign b[19] = (string_len == 6'd19) ? 1'b1:1'b0;     
assign a[20] = (string20 == 8'h20) ? 1'b1:1'b0;         assign b[20] = (string_len == 6'd20) ? 1'b1:1'b0;     
assign a[21] = (string21 == 8'h20) ? 1'b1:1'b0;         assign b[21] = (string_len == 6'd21) ? 1'b1:1'b0;     
assign a[22] = (string22 == 8'h20) ? 1'b1:1'b0;         assign b[22] = (string_len == 6'd22) ? 1'b1:1'b0;     
assign a[23] = (string23 == 8'h20) ? 1'b1:1'b0;         assign b[23] = (string_len == 6'd23) ? 1'b1:1'b0;     
assign a[24] = (string24 == 8'h20) ? 1'b1:1'b0;         assign b[24] = (string_len == 6'd24) ? 1'b1:1'b0;     
assign a[25] = (string25 == 8'h20) ? 1'b1:1'b0;         assign b[25] = (string_len == 6'd25) ? 1'b1:1'b0;     
assign a[26] = (string26 == 8'h20) ? 1'b1:1'b0;         assign b[26] = (string_len == 6'd26) ? 1'b1:1'b0;     
assign a[27] = (string27 == 8'h20) ? 1'b1:1'b0;         assign b[27] = (string_len == 6'd27) ? 1'b1:1'b0;     
assign a[28] = (string28 == 8'h20) ? 1'b1:1'b0;         assign b[28] = (string_len == 6'd28) ? 1'b1:1'b0;     
assign a[29] = (string29 == 8'h20) ? 1'b1:1'b0;         assign b[29] = (string_len == 6'd29) ? 1'b1:1'b0;     
assign a[30] = (string30 == 8'h20) ? 1'b1:1'b0;         assign b[30] = (string_len == 6'd30) ? 1'b1:1'b0;     
assign a[31] = (string31 == 8'h20) ? 1'b1:1'b0;         assign b[31] = (string_len == 6'd31) ? 1'b1:1'b0;     
                                                                                                                                           
always @(*)                                                                                                                                
begin                                                                                                                                 
        case(pattern)                                                                                                                      
        8'h5e:begin                                                                                                                        
              front = 1;                                                                                                                   
              back = 0;                                                                                                                    
              star = 0;                                                                                                                    
              array =  a;                                                                                                                  
              end                                                                                                                          
        8'h24:begin                                                                                                                        
              front = 0;                                                                                                                   
              back = 1;                                                                                                                    
              star = 0;                                                                                                                    
              array = a | b;                                                                                                               
              end                                                                                                                          
        8'h2e:begin                                                                                                                        
              front = 0;                                                                                                                   
              back = 0;                                                                                                                    
              star = 0;                                                                                                                    
              array[0 ] = (string_len > 6'd0 ) ? 1'b1:1'b0;
              array[1 ] = (string_len > 6'd1 ) ? 1'b1:1'b0;
              array[2 ] = (string_len > 6'd2 ) ? 1'b1:1'b0;
              array[3 ] = (string_len > 6'd3 ) ? 1'b1:1'b0;
              array[4 ] = (string_len > 6'd4 ) ? 1'b1:1'b0;
              array[5 ] = (string_len > 6'd5 ) ? 1'b1:1'b0;
              array[6 ] = (string_len > 6'd6 ) ? 1'b1:1'b0;
              array[7 ] = (string_len > 6'd7 ) ? 1'b1:1'b0;
              array[8 ] = (string_len > 6'd8 ) ? 1'b1:1'b0;
              array[9 ] = (string_len > 6'd9 ) ? 1'b1:1'b0;
              array[10] = (string_len > 6'd10) ? 1'b1:1'b0;
              array[11] = (string_len > 6'd11) ? 1'b1:1'b0;
              array[12] = (string_len > 6'd12) ? 1'b1:1'b0;
              array[13] = (string_len > 6'd13) ? 1'b1:1'b0;
              array[14] = (string_len > 6'd14) ? 1'b1:1'b0;
              array[15] = (string_len > 6'd15) ? 1'b1:1'b0;
              array[16] = (string_len > 6'd16) ? 1'b1:1'b0;
              array[17] = (string_len > 6'd17) ? 1'b1:1'b0;
              array[18] = (string_len > 6'd18) ? 1'b1:1'b0;
              array[19] = (string_len > 6'd19) ? 1'b1:1'b0;
              array[20] = (string_len > 6'd20) ? 1'b1:1'b0;
              array[21] = (string_len > 6'd21) ? 1'b1:1'b0;
              array[22] = (string_len > 6'd22) ? 1'b1:1'b0;
              array[23] = (string_len > 6'd23) ? 1'b1:1'b0;
              array[24] = (string_len > 6'd24) ? 1'b1:1'b0;
              array[25] = (string_len > 6'd25) ? 1'b1:1'b0;
              array[26] = (string_len > 6'd26) ? 1'b1:1'b0;
              array[27] = (string_len > 6'd27) ? 1'b1:1'b0;
              array[28] = (string_len > 6'd28) ? 1'b1:1'b0;
              array[29] = (string_len > 6'd29) ? 1'b1:1'b0;
              array[30] = (string_len > 6'd30) ? 1'b1:1'b0;
              array[31] = (string_len > 6'd31) ? 1'b1:1'b0;                                                                                                                   
              end                                                                                                                          
        8'h2a:begin                                                                                                                        
                front = 0;
                back = 0;
                star = 1;
                array = 32'hffff_ffff;
              end
      default:begin
              front = 0;
              back = 0;
              star = 0;
              array[0 ] =  (string0 == pattern) ? 1'b1:1'b0;
              array[1 ] =  (string1 == pattern) ? 1'b1:1'b0;
              array[2 ] =  (string2 == pattern) ? 1'b1:1'b0;
              array[3 ] =  (string3 == pattern) ? 1'b1:1'b0;
              array[4 ] =  (string4 == pattern) ? 1'b1:1'b0;
              array[5 ] =  (string5 == pattern) ? 1'b1:1'b0;
              array[6 ] =  (string6 == pattern) ? 1'b1:1'b0;
              array[7 ] =  (string7 == pattern) ? 1'b1:1'b0;
              array[8 ] =  (string8  == pattern) ? 1'b1:1'b0;
              array[9 ] =  (string9  == pattern) ? 1'b1:1'b0;
              array[10] =  (string10 == pattern) ? 1'b1:1'b0;
              array[11] =  (string11 == pattern) ? 1'b1:1'b0;
              array[12] =  (string12 == pattern) ? 1'b1:1'b0;
              array[13] =  (string13 == pattern) ? 1'b1:1'b0;
              array[14] =  (string14 == pattern) ? 1'b1:1'b0;
              array[15] =  (string15 == pattern) ? 1'b1:1'b0;
              array[16] =  (string16 == pattern) ? 1'b1:1'b0;
              array[17] =  (string17 == pattern) ? 1'b1:1'b0;
              array[18] =  (string18 == pattern) ? 1'b1:1'b0;
              array[19] =  (string19 == pattern) ? 1'b1:1'b0;
              array[20] =  (string20 == pattern) ? 1'b1:1'b0;
              array[21] =  (string21 == pattern) ? 1'b1:1'b0;
              array[22] =  (string22 == pattern) ? 1'b1:1'b0;
              array[23] =  (string23 == pattern) ? 1'b1:1'b0;
              array[24] =  (string24 == pattern) ? 1'b1:1'b0;
              array[25] =  (string25 == pattern) ? 1'b1:1'b0;
              array[26] =  (string26 == pattern) ? 1'b1:1'b0;
              array[27] =  (string27 == pattern) ? 1'b1:1'b0;
              array[28] =  (string28 == pattern) ? 1'b1:1'b0;
              array[29] =  (string29 == pattern) ? 1'b1:1'b0;
              array[30] =  (string30 == pattern) ? 1'b1:1'b0;
              array[31] =  (string31 == pattern) ? 1'b1:1'b0;
              end
    endcase
end

endmodule

module First(in,out);
input [31:0] in;
output wire [4:0] out;
wire [15:0] data1 ;
wire [7:0] data2 ;
wire [3:0] data3 ;
wire [1:0] data4 ;

assign {data1,out[4]} = (in[15:0] == 0)   ? {in[31:16]  ,1'b1} :{in[15:0]  ,1'b0};
assign {data2,out[3]} = (data1[7:0] == 0) ? {data1[15:8],1'b1} :{data1[7:0],1'b0};
assign {data3,out[2]} = (data2[3:0] == 0)  ? {data2[7:4],1'b1} :{data2[3:0] ,1'b0};
assign {data4,out[1]} = (data3[1:0] == 0)  ? {data3[3:2],1'b1} :{data3[1:0] ,1'b0};
assign out[0] =  (data4[0] == 0) ? 1'b1 :1'b0;

endmodule

module Last(in,out);
input [31:0] in;
output wire [4:0] out;
wire [15:0] data1 ;
wire [7:0] data2 ;
wire [3:0] data3 ;
wire [1:0] data4 ;

assign {data1,out[4]} = (in[31:16] == 0)   ? {in[15:0]  ,1'b0} :{in[31:16]  ,1'b1};
assign {data2,out[3]} = (data1[15:8] == 0) ? {data1[7:0],1'b0} :{data1[15:8],1'b1};
assign {data3,out[2]} = (data2[7:4] == 0)  ? {data2[3:0],1'b0} :{data2[7:4] ,1'b1};
assign {data4,out[1]} = (data3[3:2] == 0)  ? {data3[1:0],1'b0} :{data3[3:2] ,1'b1};
assign out[0] =  (data4[1] == 0) ? 1'b0 :1'b1;

endmodule

module ClkDiv(clk,clk2,rst_n);
input clk,rst_n;
output wire clk2;
reg counter2;

always @(posedge clk or negedge rst_n)
begin
if (!rst_n)
counter2<=0;
else
counter2 <= counter2+1'b1;
end
assign clk2 = counter2; //100Hz clock
endmodule
