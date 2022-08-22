module CLK_1_MODULE(// Input signals
			clk_1,
			clk_2,
			rst_n,
			in_valid,
			in,
			mode,
			operator,
			// Output signals,
			clk1_in_0, clk1_in_1, clk1_in_2, clk1_in_3, clk1_in_4, clk1_in_5, clk1_in_6, clk1_in_7, clk1_in_8, clk1_in_9, 
			clk1_in_10, clk1_in_11, clk1_in_12, clk1_in_13, clk1_in_14, clk1_in_15, clk1_in_16, clk1_in_17, clk1_in_18, clk1_in_19,
			clk1_op_0, clk1_op_1, clk1_op_2, clk1_op_3, clk1_op_4, clk1_op_5, clk1_op_6, clk1_op_7, clk1_op_8, clk1_op_9, 
			clk1_op_10, clk1_op_11, clk1_op_12, clk1_op_13, clk1_op_14, clk1_op_15, clk1_op_16, clk1_op_17, clk1_op_18, clk1_op_19,
			clk1_expression_0, clk1_expression_1, clk1_expression_2,
			clk1_operators_0, clk1_operators_1, clk1_operators_2,
			clk1_mode,
			clk1_control_signal,
			clk1_flag_0, clk1_flag_1, clk1_flag_2, clk1_flag_3, clk1_flag_4, clk1_flag_5, clk1_flag_6, clk1_flag_7, 
			clk1_flag_8, clk1_flag_9, clk1_flag_10, clk1_flag_11, clk1_flag_12, clk1_flag_13, clk1_flag_14, 
			clk1_flag_15, clk1_flag_16, clk1_flag_17, clk1_flag_18, clk1_flag_19
			);
//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------			
input clk_1, clk_2, rst_n, in_valid, operator, mode;
input [2:0] in;

output reg [2:0] clk1_in_0, clk1_in_1, clk1_in_2, clk1_in_3, clk1_in_4, clk1_in_5, clk1_in_6, clk1_in_7, clk1_in_8, clk1_in_9, 
				 clk1_in_10, clk1_in_11, clk1_in_12, clk1_in_13, clk1_in_14, clk1_in_15, clk1_in_16, clk1_in_17, clk1_in_18, clk1_in_19;
output reg clk1_op_0, clk1_op_1, clk1_op_2, clk1_op_3, clk1_op_4, clk1_op_5, clk1_op_6, clk1_op_7, clk1_op_8, clk1_op_9, 
		   clk1_op_10, clk1_op_11, clk1_op_12, clk1_op_13, clk1_op_14, clk1_op_15, clk1_op_16, clk1_op_17, clk1_op_18, clk1_op_19;
output reg [59:0] clk1_expression_0, clk1_expression_1, clk1_expression_2;
output reg [19:0] clk1_operators_0, clk1_operators_1, clk1_operators_2;
output reg clk1_mode;
output reg [19 :0] clk1_control_signal;
output clk1_flag_0, clk1_flag_1, clk1_flag_2, clk1_flag_3, clk1_flag_4, clk1_flag_5, clk1_flag_6, clk1_flag_7, 
	   clk1_flag_8, clk1_flag_9, clk1_flag_10, clk1_flag_11, clk1_flag_12, clk1_flag_13, clk1_flag_14, 
	   clk1_flag_15, clk1_flag_16, clk1_flag_17, clk1_flag_18, clk1_flag_19;
//---------------------------------------------------------------------
//   REG DRCLARATION
//---------------------------------------------------------------------
reg done1;
reg [4:0] counter_in;
reg [2:0] counter;
reg [1:0] state,nextstate;
parameter IDLE=2'd0,IN=2'd1,OUT=2'd2;
//---------------------------------------------------------------------
//   DESIGN
//---------------------------------------------------------------------
always @(posedge clk_1 or negedge rst_n) begin
    if(!rst_n) begin
        counter_in <= 0;
    end
    else if(in_valid) begin
        counter_in <= counter_in + 1;
    end
    else begin
        counter_in <= 0;
    end
end
always @(posedge clk_1 or negedge rst_n) begin
    if(!rst_n) begin
        counter <= 0;
    end
    else if(state == OUT) begin
        counter <= counter + 1;
    end
    else begin
        counter <= 0;
    end
end
always @(posedge clk_1 or negedge rst_n) begin
    if(!rst_n) begin
        clk1_expression_0 <= 60'd0;
    end
    else if(in_valid) begin
        clk1_expression_0[3*counter_in+2 -: 3] <= in;
    end
    else if(state == IDLE) begin
        clk1_expression_0 <= 0;
    end
    else begin
        clk1_expression_0 <= clk1_expression_0;
    end
end
always @(posedge clk_1 or negedge rst_n) begin
    if(!rst_n) begin
        clk1_operators_0 <= 20'd0;
    end
    else if(in_valid) begin
        clk1_operators_0[counter_in] <= operator;
    end
    else if(state == IDLE) begin
        clk1_operators_0 <= 0;
    end
    else begin
        clk1_operators_0 <= clk1_operators_0;
    end
end
always @(posedge clk_1 or negedge rst_n) begin
    if(!rst_n) begin
        clk1_operators_1 <= 20'd0;
    end
    else if(in_valid) begin
        if(counter_in == 0 && operator == 0)
            clk1_operators_1 <= 0;
        else if(counter_in == 0 && operator == 1)
            clk1_operators_1 <= 1;
        else if(counter_in !=0 && operator)begin
            clk1_operators_1 <= clk1_operators_1 + 1;
        end
        else begin
            clk1_operators_1 <= clk1_operators_1;
        end
    end
    else begin
        clk1_operators_1 <= clk1_operators_1;
    end
end

always @(posedge clk_1 or negedge rst_n) begin
    if(!rst_n) begin
        clk1_operators_2 <= 20'd0;
    end
    else if(state == IN) begin
        clk1_operators_2 <= counter_in;
    end
    else begin
        clk1_operators_2 <= clk1_operators_2;
    end
end

always @(posedge clk_1 or negedge rst_n) begin
    if(!rst_n) begin
        clk1_mode <= 0;
    end
    else if(in_valid && counter_in == 0) begin
        clk1_mode <= mode;
    end
    else begin
        clk1_mode <= clk1_mode;
    end
end

always @(posedge clk_1 or negedge rst_n) begin
    if(!rst_n) begin
        done1 <= 0;
    end
    else if(state == OUT && counter == 0) begin
        done1 <= 1;
    end
    else begin
        done1 <= 0;
    end
end
always @(posedge clk_1 or negedge rst_n) begin
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
        OUT:begin
            if(counter == 4'd7) nextstate = IDLE;
            else                nextstate = state;
        end
        default:            nextstate = IDLE;
    endcase
end
//---------------------------------------------------------------------
//   TA hint:
//	  Please write a synchroniser using syn_XOR or doubole flop synchronizer design in CLK_1_MODULE to generate a flag signal to inform CLK_2_MODULE that it can read input signal from CLK_1_MODULE.
//	  You don't need to include syn_XOR.v file or synchronizer.v file by yourself, we have already done that in top module CDC.v
//	  example:
//   syn_XOR syn_1(.IN(inflag_clk1),.OUT(clk1_flag_0),.TX_CLK(clk_1),.RX_CLK(clk_2),.RST_N(rst_n));             
//---------------------------------------------------------------------	

syn_XOR syn_1(.IN(done1),.OUT(clk1_flag_0),.TX_CLK(clk_1),.RX_CLK(clk_2),.RST_N(rst_n));       

endmodule







module CLK_2_MODULE(// Input signals
			clk_2,
			clk_3,
			rst_n,
			clk1_in_0, clk1_in_1, clk1_in_2, clk1_in_3, clk1_in_4, clk1_in_5, clk1_in_6, clk1_in_7, clk1_in_8, clk1_in_9, 
			clk1_in_10, clk1_in_11, clk1_in_12, clk1_in_13, clk1_in_14, clk1_in_15, clk1_in_16, clk1_in_17, clk1_in_18, clk1_in_19,
			clk1_op_0, clk1_op_1, clk1_op_2, clk1_op_3, clk1_op_4, clk1_op_5, clk1_op_6, clk1_op_7, clk1_op_8, clk1_op_9, 
			clk1_op_10, clk1_op_11, clk1_op_12, clk1_op_13, clk1_op_14, clk1_op_15, clk1_op_16, clk1_op_17, clk1_op_18, clk1_op_19,
			clk1_expression_0, clk1_expression_1, clk1_expression_2,
			clk1_operators_0, clk1_operators_1, clk1_operators_2,
			clk1_mode,
			clk1_control_signal,
			clk1_flag_0, clk1_flag_1, clk1_flag_2, clk1_flag_3, clk1_flag_4, clk1_flag_5, clk1_flag_6, clk1_flag_7, 
			clk1_flag_8, clk1_flag_9, clk1_flag_10, clk1_flag_11, clk1_flag_12, clk1_flag_13, clk1_flag_14, 
			clk1_flag_15, clk1_flag_16, clk1_flag_17, clk1_flag_18, clk1_flag_19,
			
			// output signals
			clk2_out_0, clk2_out_1, clk2_out_2, clk2_out_3,
			clk2_mode,
			clk2_control_signal,
			clk2_flag_0, clk2_flag_1, clk2_flag_2, clk2_flag_3, clk2_flag_4, clk2_flag_5, clk2_flag_6, clk2_flag_7
			);
//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------			
input clk_2, clk_3, rst_n;

input [2:0] clk1_in_0, clk1_in_1, clk1_in_2, clk1_in_3, clk1_in_4, clk1_in_5, clk1_in_6, clk1_in_7, clk1_in_8, clk1_in_9, 
	 	    clk1_in_10, clk1_in_11, clk1_in_12, clk1_in_13, clk1_in_14, clk1_in_15, clk1_in_16, clk1_in_17, clk1_in_18, clk1_in_19;
input clk1_op_0, clk1_op_1, clk1_op_2, clk1_op_3, clk1_op_4, clk1_op_5, clk1_op_6, clk1_op_7, clk1_op_8, clk1_op_9, 
  	  clk1_op_10, clk1_op_11, clk1_op_12, clk1_op_13, clk1_op_14, clk1_op_15, clk1_op_16, clk1_op_17, clk1_op_18, clk1_op_19;
input [59:0] clk1_expression_0, clk1_expression_1, clk1_expression_2;
input [19:0] clk1_operators_0, clk1_operators_1, clk1_operators_2;
input clk1_mode;
input [19 :0] clk1_control_signal;
input clk1_flag_0, clk1_flag_1, clk1_flag_2, clk1_flag_3, clk1_flag_4, clk1_flag_5, clk1_flag_6, clk1_flag_7, 
	  clk1_flag_8, clk1_flag_9, clk1_flag_10, clk1_flag_11, clk1_flag_12, clk1_flag_13, clk1_flag_14, 
	  clk1_flag_15, clk1_flag_16, clk1_flag_17, clk1_flag_18, clk1_flag_19;


output reg [63:0] clk2_out_0, clk2_out_1, clk2_out_2, clk2_out_3;
output reg clk2_mode;
output reg [8:0] clk2_control_signal;
output clk2_flag_0, clk2_flag_1, clk2_flag_2, clk2_flag_3, clk2_flag_4, clk2_flag_5, clk2_flag_6, clk2_flag_7;
//---------------------------------------------------------------------
//   REG DRCLARATION
//---------------------------------------------------------------------
reg done2;
reg [2:0] state,nextstate;
parameter IDLE=4'd0,IN=4'd1,READY=4'd2,OP=4'd3,CAL1=4'd4,CAL2=4'd5,SHIFT=4'd6,OUT=4'd7;
reg [4:0] pointer;
reg [19:0] op;
reg signed [29:0] result [19:0];
reg [2:0] operator;
reg [3:0] counter_op;
reg [4:0] counter_shift;
reg [3:0] sum_op;
reg [2:0] counter_out;
reg [4:0] length;
reg [4:0] count_op;
integer i;
//---------------------------------------------------------------------
// DESIGN
//---------------------------------------------------------------------
//---------------------------------------------------------------------
// INPUT
//---------------------------------------------------------------------
always @(posedge clk_2 or negedge rst_n) begin
    if(!rst_n) begin
        clk2_mode <= 0;
    end
    else if(clk1_flag_0) begin
        clk2_mode <= clk1_mode;
    end
    else begin
        clk2_mode <= clk2_mode;
    end
end


always @(posedge clk_2 or negedge rst_n) begin
    if(!rst_n) begin
        result[0] <= 0;    result[5] <= 0;    result[10] <= 0;    result[15] <= 0; 
        result[1] <= 0;    result[6] <= 0;    result[11] <= 0;    result[16] <= 0; 
        result[2] <= 0;    result[7] <= 0;    result[12] <= 0;    result[17] <= 0; 
        result[3] <= 0;    result[8] <= 0;    result[13] <= 0;    result[18] <= 0; 
        result[4] <= 0;    result[9] <= 0;    result[14] <= 0;    result[19] <= 0; 
    end
    else if(clk1_flag_0 ) begin
        result[0]  <= {27'd0,clk1_expression_0[2:0]};       result[5] <= {27'd0,clk1_expression_0[17:15]};    
        result[1]  <= {27'd0,clk1_expression_0[5:3]};       result[6] <= {27'd0,clk1_expression_0[20:18]};    
        result[2]  <= {27'd0,clk1_expression_0[8:6]};       result[7] <= {27'd0,clk1_expression_0[23:21]};    
        result[3]  <= {27'd0,clk1_expression_0[11:9]};      result[8] <= {27'd0,clk1_expression_0[26:24]};    
        result[4]  <= {27'd0,clk1_expression_0[14:12]};     result[9] <= {27'd0,clk1_expression_0[29:27]};
        result[10] <= {27'd0,clk1_expression_0[32:30]};    result[15] <= {27'd0,clk1_expression_0[47:45]};    
        result[11] <= {27'd0,clk1_expression_0[35:33]};    result[16] <= {27'd0,clk1_expression_0[50:48]};    
        result[12] <= {27'd0,clk1_expression_0[38:36]};    result[17] <= {27'd0,clk1_expression_0[53:51]};    
        result[13] <= {27'd0,clk1_expression_0[41:39]};    result[18] <= {27'd0,clk1_expression_0[56:54]};    
        result[14] <= {27'd0,clk1_expression_0[44:42]};    result[19] <= {27'd0,clk1_expression_0[59:57]};       
    end
    else if(state == CAL1 && clk2_mode == 0)begin    // PREFIX
        case(operator)
                3'b000: result[pointer] <= result[pointer+1] + result[pointer+2];
                3'b001: result[pointer] <= result[pointer+1] - result[pointer+2];
                3'b010: result[pointer] <= result[pointer+1] * result[pointer+2];
                3'b011: result[pointer] <= result[pointer+1] + result[pointer+2];
                3'b100: result[pointer] <= (result[pointer+1] - result[pointer+2]) << 1;
        endcase
    end
    else if(state == CAL1 && clk2_mode == 1)begin    // POSTFIX        
         case(operator)
             3'b000: result[pointer] <= result[pointer-2] + result[pointer-1];
             3'b001: result[pointer] <= result[pointer-2] - result[pointer-1];
             3'b010: result[pointer] <= result[pointer-2] * result[pointer-1];
             3'b011: result[pointer] <= result[pointer-2] + result[pointer-1];
             3'b100: result[pointer] <= (result[pointer-2] - result[pointer-1]) << 1;
         endcase
    end
    else if(state == CAL2 && clk2_mode == 0) begin // PREFIX
        if(result[pointer][27] == 1 && operator == 3'b011) begin
            result[pointer] <= 1+(~result[pointer]);
        end
        else
            result[pointer+1] <= result[pointer+1];
    end
    else if(state == CAL2 && clk2_mode == 1) begin // POSTFIX
        if(result[pointer][27] == 1 && operator == 3'b011) begin
            result[pointer] <= 1+(~result[pointer]);
        end
        else
            result[pointer] <= result[pointer];
    end
    else if(state == SHIFT && clk2_mode == 0)begin
        if(counter_shift < 17) begin
            result[counter_shift] <= result[counter_shift+2];
        end
        else begin
            result[counter_shift] <= 0;
        end
    end
    else if(state == SHIFT && clk2_mode == 1)begin
        if(counter_shift > 1) begin
            result[counter_shift] <= result[counter_shift-2];
        end
        else begin
            result[counter_shift] <= 0;
        end
    end
end

always @(posedge clk_2 or negedge rst_n) begin
    if(!rst_n) begin
        operator <= 0;
    end
    else if(state == OP && op[pointer] == 1) begin
        operator <= result[pointer];     
    end
    else begin
        operator <= operator;
    end
end


always @(posedge clk_2 or negedge rst_n) begin
    if(!rst_n) begin
        op <= 0;
    end
    else if(clk1_flag_0) begin
        op <= clk1_operators_0;
    end
    else begin
        op <= op;
    end
end
always @(posedge clk_2 or negedge rst_n) begin
    if(!rst_n) begin
        sum_op <= 0;
    end
    else if(clk1_flag_0) begin
        sum_op <= clk1_operators_1[3:0];
    end
    else begin
        sum_op <= sum_op;
    end
end
always @(posedge clk_2 or negedge rst_n) begin
    if(!rst_n) begin
        length <= 0;
    end
    else if(clk1_flag_0) begin
        length <= clk1_operators_2[4:0];
    end
    else begin
        length <= length;
    end
end
//---------------------------------------------------------------------
// DESIGN
//---------------------------------------------------------------------
always @(posedge clk_2 or negedge rst_n) begin
    if(!rst_n) begin
        pointer <= 0;
    end
    else if(clk2_mode == 0) begin     // PREFIX
        if(state == READY)
            pointer <= length - 1;
        else if((state == OP && nextstate == OP)||(state == SHIFT && nextstate != SHIFT))
            pointer <= pointer - 1;
        else
            pointer <= pointer;
    end
    else if(clk2_mode == 1) begin     // POSTFIX
        if(state == READY)
            pointer <= 5'd0;
        else if((state == OP && nextstate == OP)||(state == SHIFT && nextstate != SHIFT))
            pointer <= pointer + 1;
        else
            pointer <= pointer;
    end
end
//---------------------------------------------------------------------
// COUNTER
//---------------------------------------------------------------------
always @(posedge clk_2 or negedge rst_n) begin
    if(!rst_n) begin
        counter_op <= 0;
    end
    else if(state == IDLE)
        counter_op <= 0;
    else if(state != OP && nextstate == OP)begin
        counter_op <= counter_op + 1;
    end
    else begin
        counter_op <= counter_op;
    end
end

always @(posedge clk_2 or negedge rst_n) begin
    if(!rst_n) begin
        counter_shift <= 0;
    end
    else if(nextstate == CAL1 && clk2_mode == 0)begin
        counter_shift <= pointer + 1;
    end
    else if(nextstate == CAL1 && clk2_mode == 1)begin
        counter_shift <= pointer - 1;
    end
    else if(state == SHIFT && clk2_mode == 0)begin
        counter_shift <= counter_shift + 1;
    end
    else if(state == SHIFT && clk2_mode == 1)begin
        counter_shift <= counter_shift - 1;
    end
    else begin
        counter_shift <= counter_shift;
    end
end

always @(posedge clk_2 or negedge rst_n) begin
    if(!rst_n) begin
        counter_out <= 0;
    end
    else if(state == IDLE)
        counter_out <= 0;
    else if(state == OUT)begin
        counter_out <= counter_out + 1;
    end
    else begin
        counter_out <= counter_out;
    end
end
//---------------------------------------------------------------------
// FSM
//---------------------------------------------------------------------
always @(posedge clk_2 or negedge rst_n) begin
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
            if(clk1_flag_0) nextstate = IN;
            else            nextstate = state;
        end
        IN:begin
            if(!clk1_flag_0)    nextstate = READY;
            else                nextstate = state;
        end
        READY:begin
            if(sum_op == 0) nextstate = OUT;
            else            nextstate = OP;
        end
        OP:begin
            if(op[pointer] == 1) nextstate = CAL1;
            else                 nextstate = state;
        end
        CAL1:begin
            nextstate = CAL2;
        end
        CAL2:begin
            nextstate = SHIFT;
        end
        SHIFT:begin
            if(counter_op == sum_op &&((counter_shift == 5'd19 && clk2_mode== 0)||(counter_shift == 5'd0 && clk2_mode== 1)))  nextstate = OUT;
            else if((counter_shift == 5'd19  && clk2_mode== 0)||(counter_shift == 5'd0 && clk2_mode== 1))                     nextstate = OP;
            else    nextstate = state;
        end
        OUT:begin
            if(counter_out == 3'd2)    nextstate = IDLE;
            else                       nextstate = state;
        end
        default:begin
            nextstate = IDLE;
        end
    endcase
end
//---------------------------------------------------------------------
// OUT
//---------------------------------------------------------------------
always @(posedge clk_2 or negedge rst_n) begin
    if(!rst_n) begin
        clk2_out_0 <= 0;
    end
    else if(clk2_mode == 0) begin       //PREFIX
        clk2_out_0 <= {{34{result[0][29]}},result[0]};
    end
    else if(clk2_mode == 1) begin       //PISTFIX
        clk2_out_0 <= {{34{result[length - 1][29]}},result[length - 1]};
    end
    else
        clk2_out_0 <= 0;
end
always @(posedge clk_2 or negedge rst_n) begin
    if(!rst_n) begin
        done2 <= 0;
    end
    else if(state == OUT) begin       
        done2 <= 1;
    end
    else
        done2 <= 0;
end
//---------------------------------------------------------------------
//   TA hint:
//	  Please write a synchroniser using syn_XOR or doubole flop synchronizer design in CLK_2_MODULE to generate a flag signal to inform CLK_3_MODULE that it can read input signal from CLK_2_MODULE.
//	  You don't need to include syn_XOR.v file or synchronizer.v file by yourself, we have already done that in top module CDC.v
//	  example:
//   syn_XOR syn_2(.IN(inflag_clk2),.OUT(clk2_flag_0),.TX_CLK(clk_2),.RX_CLK(clk_3),.RST_N(rst_n));             
//---------------------------------------------------------------------	
syn_XOR syn_2(.IN(done2),.OUT(clk2_flag_0),.TX_CLK(clk_2),.RX_CLK(clk_3),.RST_N(rst_n));       
endmodule



module CLK_3_MODULE(// Input signals
			clk_3,
			rst_n,
			clk2_out_0, clk2_out_1, clk2_out_2, clk2_out_3,
			clk2_mode,
			clk2_control_signal,
			clk2_flag_0, clk2_flag_1, clk2_flag_2, clk2_flag_3, clk2_flag_4, clk2_flag_5, clk2_flag_6, clk2_flag_7,
			
			// Output signals
			out_valid,
			out
		  
			);
//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------			
input clk_3, rst_n;


input [63:0] clk2_out_0, clk2_out_1, clk2_out_2, clk2_out_3;
input clk2_mode;
input [8:0] clk2_control_signal;
input clk2_flag_0, clk2_flag_1, clk2_flag_2, clk2_flag_3, clk2_flag_4, clk2_flag_5, clk2_flag_6, clk2_flag_7;

output reg out_valid;
output reg [63:0] out; 		
reg state,nextstate;
parameter IDLE=1'd0,OUT=1'd1;
//---------------------------------------------------------------------
//  DESIGN
//---------------------------------------------------------------------
always @(posedge clk_3 or negedge rst_n) begin
    if(!rst_n) begin
        out <= 0;
    end
    else if(state == IDLE && clk2_flag_0)begin
        out <= clk2_out_0;
    end
    else begin  
        out <= 0;
    end
end
always @(posedge clk_3 or negedge rst_n) begin
    if(!rst_n) begin
        out_valid <= 0;
    end
    else if(state == IDLE && clk2_flag_0)begin
        out_valid <= 1;
    end
    else begin  
        out_valid <= 0;
    end
end
always @(posedge clk_3 or negedge rst_n) begin
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
            if(clk2_flag_0) nextstate = OUT;
            else            nextstate = state;
        end
        OUT:begin
            if(!clk2_flag_0) nextstate = IDLE;
            else            nextstate = state;
        end
    endcase
end
endmodule


