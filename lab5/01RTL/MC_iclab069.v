`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/01 18:36:01
// Design Name: 
// Module Name: MC
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


module MC(clk,rst_n,in_valid,in_data,size,action,out_valid,out_data);
input clk,rst_n;
input in_valid;
input [30:0] in_data;
input [1:0] size;
input [2:0] action;
output reg out_valid;
output reg [30:0] out_data;
/*------------------------------------------------------------*/
//                REGISTER PARAMETER                    //
/*-----------------------------------------------------------*/
reg [30:0] data[255:0] ;
reg [2:0] act;
reg [3:0] length;
reg [7:0] word_number;
reg [11:0] mult_number;
reg [30:0] sram_array[15:0][15:0];
reg [61:0] mult_out;
reg [65:0] add_out;
reg [35:0] mod_out;
reg [30:0] array [15:0][15:0];
reg [3:0] col_cal2,row_cal2,row_in,col_in,col_cal,row_out,col_out,col_cal_not_mult,row_cal_not_mult;
reg [4:0] changed_col,changed_col2,changed_row2;
parameter p = 31'h7fff_ffff;
integer i,j;
/*------------------------------------------------------------*/
//                     FSM PARAMETER                        //
/*-----------------------------------------------------------*/
reg [1:0] state,nextstate;
reg [7:0] counter_in,cal_number,cal_number2;
reg [8:0] counter_out,counter_cal_not_mult;
reg [12:0] counter_cal;
reg [11:0] counter_cal2;
parameter IDLE = 2'd0,IN = 2'd1, CAL = 2'd2, OUT = 2'd3;
/*------------------------------------------------------------*/
//                    SRAM PARAMETER                      //
/*-----------------------------------------------------------*/
reg wen;
reg [30:0] sram_in;
reg [7:0] address;
wire [30:0] sram_out;
RA1SH C(.Q(sram_out),.CLK(clk),.CEN(1'b0),.WEN(wen),.A(address),.D(sram_in),.OEN(1'b0));

/*------------------------------------------------------------*/
//                         IN  ALGORITHM                      //
/*-----------------------------------------------------------*/
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i=0;i<256;i=i+1)
            data[i] <= 0;
    end
    else if(in_valid)begin
        data[address] <= in_data;
    end
    else begin
        for(i=0;i<256;i=i+1)
            data[i] <= data[i];
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        act <= 0;
    end
    else if(state == IDLE && nextstate == IN)begin
        case(action)
            3'b000: act <= 3'b000;
            3'b001: act <= 3'b001;
            3'b010: act <= 3'b010;
            3'b011: act <= 3'b011;
            3'b100: act <= 3'b100;
            3'b101: act <= 3'b101;
            default:act <= act;
        endcase
    end
    else act <= act;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        mult_number <= 0;
    end
    else if(state == IDLE && nextstate == IN && action == 0)begin
        case(size)
            2'b00: mult_number <= 12'd7;
            2'b01: mult_number <= 12'd63;
            2'b10: mult_number <= 12'd511;
            2'b11: mult_number <= 12'd4095;
            default:mult_number <= mult_number;
        endcase
    end
    else begin
        mult_number <= mult_number;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        word_number <= 0;
    end
    else if(state == IDLE && nextstate == IN && action == 0)begin
        case(size)
            2'b00: word_number <= 8'd3;
            2'b01: word_number <= 8'd15;
            2'b10: word_number <= 8'd63;
            2'b11: word_number <= 8'd255;
            default:word_number <= word_number;
        endcase
    end
    else begin
        word_number <= word_number;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        length <= 0;
    end
    else if(state == IDLE && nextstate == IN && action == 0)begin
        case(size)
            2'b00: length <= 4'd1;
            2'b01: length <= 4'd3;
            2'b10: length <= 4'd7;
            2'b11: length <= 4'd15;
            default:length<=length;
        endcase
    end
    else begin
        length <= length;
    end
end

always @(*) begin
    if(!rst_n) begin
        row_in = 0;
        col_in = 0;
    end
    else begin
        case(length)
            4'd1 : begin row_in = counter_in / 5'd2;  col_in = counter_in % 5'd2;   end
            4'd3 : begin row_in = counter_in / 5'd4;  col_in = counter_in % 5'd4;   end
            4'd7 : begin row_in = counter_in / 5'd8;  col_in = counter_in % 5'd8;   end
            4'd15: begin row_in = counter_in / 5'd16; col_in = counter_in % 5'd16;  end
            default:begin
                    row_in = 0;
                    col_in = 0;
                    end
        endcase
    end
end

always @(*) begin
    if(!rst_n) begin
        row_cal_not_mult = 0;
        col_cal_not_mult = 0;
    end
    else begin
        case(length)
            4'd1 : begin row_cal_not_mult = counter_cal_not_mult / 5'd2;  col_cal_not_mult = counter_cal_not_mult % 5'd2;   end
            4'd3 : begin row_cal_not_mult = counter_cal_not_mult / 5'd4;  col_cal_not_mult = counter_cal_not_mult % 5'd4;   end
            4'd7 : begin row_cal_not_mult = counter_cal_not_mult / 5'd8;  col_cal_not_mult = counter_cal_not_mult % 5'd8;   end
            4'd15: begin row_cal_not_mult = counter_cal_not_mult / 5'd16; col_cal_not_mult = counter_cal_not_mult % 5'd16;  end
            default:begin
                    row_cal_not_mult = 0;
                    col_cal_not_mult = 0;
                    end
        endcase
    end
end
always @(*) begin
    if(!rst_n) begin
        col_cal = 0;
    end
    else begin
        case(length)
            4'd1 : begin col_cal = counter_cal % 5'd2;   end
            4'd3 : begin col_cal = counter_cal % 5'd4;   end
            4'd7 : begin col_cal = counter_cal % 5'd8;   end
            4'd15: begin col_cal = counter_cal % 5'd16;  end
            default:begin
                    col_cal = 0;
                    end
        endcase
    end
end

always @(*) begin
    if(!rst_n) begin
        row_cal2 = 0;
        col_cal2 = 0;
    end
    else begin
        case(length)
            4'd1 : begin row_cal2 = counter_cal2 / 5'd2;  col_cal2 = counter_cal2 % 5'd2;   end
            4'd3 : begin row_cal2 = counter_cal2 / 5'd4;  col_cal2 = counter_cal2 % 5'd4;   end
            4'd7 : begin row_cal2 = counter_cal2 / 5'd8;  col_cal2 = counter_cal2 % 5'd8;   end
            4'd15: begin row_cal2 = counter_cal2 / 5'd16; col_cal2 = counter_cal2 % 5'd16;  end
            default:begin
                    row_cal2 = 0;
                    col_cal2 = 0;
                    end
        endcase
    end
end
always @(*) begin
    if(!rst_n) begin
        row_out = 0;
        col_out = 0;
    end
    else begin
        case(length)
            4'd1 : begin row_out = counter_out / 5'd2;  col_out = counter_out % 5'd2;   end
            4'd3 : begin row_out = counter_out / 5'd4;  col_out = counter_out % 5'd4;   end
            4'd7 : begin row_out = counter_out / 5'd8;  col_out = counter_out % 5'd8;   end
            4'd15: begin row_out = counter_out / 5'd16; col_out = counter_out % 5'd16;  end
            default:begin
                    row_out = 0;
                    col_out = 0;
                    end
        endcase
    end
end
always @(*) begin
    if(!rst_n) begin
        cal_number  = 0;
        cal_number2 = 0;
    end
    else begin
        case(length)
            4'd1 : begin cal_number = counter_cal % 9'd4  ;  cal_number2 = counter_cal2 % 9'd4  ;  end
            4'd3 : begin cal_number = counter_cal % 9'd16 ;  cal_number2 = counter_cal2 % 9'd16 ;  end
            4'd7 : begin cal_number = counter_cal % 9'd64 ;  cal_number2 = counter_cal2 % 9'd64 ;  end
            4'd15: begin cal_number = counter_cal % 9'd256;  cal_number2 = counter_cal2 % 9'd256;  end
            default:begin
                    cal_number  = 0;
                    cal_number2 = 0;
                    end
        endcase
    end
end
/*------------------------------------------------------------*/
//                     SRAM ALGORITHM                      //
/*-----------------------------------------------------------*/
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        wen <= 1'b1;       //READ
    end
    else if(state == OUT && counter_out <= word_number)
        wen <= 1'b0;       //WRITE
    else 
        wen <= 1'b1;       //READ
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        address <= 0;                    
    end
    else if(state == IDLE && nextstate == IN)
        address <= address + 1'b1;       //READ
    else if(state == IN && counter_in < word_number)
        address <= address + 1'b1;       //READ
    else if(state == OUT && counter_out > 0)
        address <= address + 1'b1;       //WRITE
    else
        address <= 0;
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        for(i = 0; i < 16; i = i +1)
            for(j = 0; j < 16; j = j + 1)
                sram_array[i][j] <= 31'd0;    
    end
    else if(state == IN)begin
        sram_array[row_in][col_in] <= sram_out;
    end
    else begin
        for(i = 0; i < 16; i = i +1)
            for(j = 0; j < 16; j = j + 1)
                sram_array[i][j] <= sram_array[i][j]; 
    end
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        changed_col <= 0;
    end
    else if(cal_number == word_number)begin
        changed_col <= changed_col + 1;
    end
    else if(state == IDLE)begin
        changed_col <= 0;
    end
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        changed_col2 <= 0;
    end
    else if(cal_number2 == word_number - 1)begin
        changed_col2 <= changed_col2 + 1;
    end
    else if(state == IDLE)begin
        changed_col2 <= 0;
    end
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        changed_row2 <= 0;
    end
    else if(state == CAL && counter_cal > 3 && col_cal2 == length - 1)begin
        if(cal_number2 == word_number - 1)
            changed_row2 <= 0;
        else 
            changed_row2 <= changed_row2 + 1;
    end
    else if(state == IDLE)begin
        changed_row2 <= 0;
    end
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        mult_out <= 62'd0;
    end
    else if(state == CAL && act == 3'd2)begin
        mult_out <= data[cal_number]*sram_array[col_cal][changed_col];
    end
    else
        mult_out <= 0;
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        add_out <= 66'd0;
    end
    else if(state == CAL && act == 3'd1) begin
        add_out <= sram_array[row_cal_not_mult][col_cal_not_mult] + data[counter_cal_not_mult];
    end
    else if(state == CAL && act == 3'd2)begin
        if(col_cal == 1)
            add_out <= mult_out;
        else
            add_out <= add_out + mult_out;
    end
    else
        add_out <= 0;
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        mod_out <= 35'd0;
    end
    else if(state == CAL)begin
        mod_out <= add_out[65:31] + add_out[30:0];
    end
    else
        mod_out <= 0;
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i = 0; i < 16; i = i +1)
            for(j = 0; j < 16; j = j + 1)
                array[i][j] <= 62'd0;    
    end
    else if(state == IN)begin
        for(i = 0; i < 16; i = i +1)
            for(j = 0; j < 16; j = j + 1)
                array[i][j] <= 62'd0;  
    end
    else if(state == CAL)
        case(act)
            3'b000: array[row_cal_not_mult][col_cal_not_mult] <= data[counter_cal_not_mult];                               //SETUP 
            3'b001: array[row_cal2][col_cal2] <= mod_out[35:31] + mod_out[30:0];                                                              //ADDITON 
            3'b010: array[changed_row2][changed_col2] <= mod_out[35:31] + mod_out[30:0];                                                      //MULTIPLICATION 
            3'b011: array[col_cal_not_mult][row_cal_not_mult] <= sram_array[row_cal_not_mult][col_cal_not_mult];           //TRANSPOSE 
            3'b100: array[row_cal_not_mult][length - col_cal_not_mult] <= sram_array[row_cal_not_mult][col_cal_not_mult];  //MIRROR 
            3'b101: array[length - col_cal_not_mult][row_cal_not_mult] <= sram_array[row_cal_not_mult][col_cal_not_mult];  //ROTATE 
        endcase
    else
        for(i = 0; i < 16; i = i +1)
            for(j = 0; j < 16; j = j + 1)
                array[i][j] <= array[i][j]; 
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        sram_in <= 0;                     
    end
    else if(state == OUT)
        sram_in <= array[row_out][col_out];       //WRITE
    else
        sram_in <= 0;
end
/*------------------------------------------------------------*/
//                        OUT  ALGORITHM                    //
/*-----------------------------------------------------------*/
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_valid <= 0;
    end
    else if(state == OUT && act < 3'b011 && counter_out <= word_number) begin
        out_valid <= 1;
    end
    else if(state == OUT && act >= 3'b011 && counter_out > word_number) begin
        out_valid <= 1;
    end
    else begin
        out_valid <= 0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_data <= 31'd0;
    end
    else if(state == OUT && act < 3'b011 && counter_out <= word_number) begin
        out_data <= array[row_out][col_out];
    end
    else if(state == OUT && act >= 3'b011 && counter_out > word_number) begin
        out_data <= 31'd0;
    end
    else begin
        out_data <= 31'd0;
    end
end
/*------------------------------------------------------------*/
//                      FSM  ALGORITHM                      //
/*-----------------------------------------------------------*/
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
                if(in_valid) nextstate = IN;
                else nextstate = state;
            end
        IN:begin
                if(counter_in == word_number) nextstate = CAL;
                else nextstate = state;
            end
        CAL:begin
                if(act == 3'd1 && counter_cal2 == word_number) nextstate = OUT;
                else if(act == 3'd2 && counter_cal2 == mult_number) nextstate = OUT;
                else if(act != 3'd2 &&act != 3'd1 && counter_cal_not_mult == word_number) nextstate = OUT;
                else nextstate = state;
            end
        OUT:begin
                if(counter_out == word_number + 1) nextstate = IDLE;
                else nextstate = state;
            end
        default:nextstate = state;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        counter_in <= 0;
    end
    else if(state == IN)begin
        counter_in <= counter_in + 1;
    end
    else begin
        counter_in <= 0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        counter_cal_not_mult <= 0;
    end
    else if(state == CAL)begin
        counter_cal_not_mult <= counter_cal_not_mult + 1;
    end
    else begin
        counter_cal_not_mult <= 0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        counter_cal <= 0;
    end
    else if(state == CAL)begin
        counter_cal <= counter_cal + 1;
    end
    else begin
        counter_cal <= 0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        counter_cal2 <= 0;
    end
    else if(act == 3'd1 && counter_cal > 1)begin
        counter_cal2 <= counter_cal2 + 1;
    end
    else if(act == 3'd2 && counter_cal > 3)begin
        counter_cal2 <= counter_cal2 + 1;
    end
    else begin
        counter_cal2 <= 0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        counter_out <= 0;
    end
    else if(state == OUT)begin
        counter_out <= counter_out + 1;
    end
    else begin
        counter_out <= 0;
    end
end
endmodule
