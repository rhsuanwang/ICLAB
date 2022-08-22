module SP(
	// Input signals
	clk,
	rst_n,
	in_valid,
	in_data,
	in_mode,
	// Output signals
	out_valid,
	out_data
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input clk, rst_n, in_valid;
input [2:0] in_mode;
input [8:0] in_data;
output reg out_valid;
output reg [8:0] out_data;
//---------------------------------------------------------------------
//   REG DECLARATION                         
//---------------------------------------------------------------------
reg [2:0] mode;
reg [8:0] a[5:0],b[5:0],c[5:0],d[5:0],e[5:0];
reg [17:0] temp[1:0];
reg [2:0] state,nextstate;
reg [5:0] counter;  // max = 216
reg [2:0] count;
parameter IDLE=3'd0,IN=3'd1,INV=3'd2,MUL=3'd3,SORT=3'd4,SUM=3'd5,OUT=3'd6;
//---------------------------------------------------------------------
//   STATE IN DECLARATION                         
//---------------------------------------------------------------------
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        a[0] <= 0;
        a[1] <= 0;
        a[2] <= 0;
        a[3] <= 0;
        a[4] <= 0;
        a[5] <= 0;
    end
    else if(in_valid && (state == IDLE || state == IN)) begin
        a[0] <= a[1];
        a[1] <= a[2];
        a[2] <= a[3];
        a[3] <= a[4];
        a[4] <= a[5];
        a[5] <= in_data;
    end
    else begin
        a[0] <= a[0];
        a[1] <= a[1];
        a[2] <= a[2];
        a[3] <= a[3];
        a[4] <= a[4];
        a[5] <= a[5];
    end
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        mode <= 0;
    end
    else if(in_valid && counter == 0 && (state == IDLE || state == IN)) begin
        mode <= in_mode;
    end
    else begin
        mode <= mode;
    end
end
//---------------------------------------------------------------------
//   STATE INV DECLARATION                         
//---------------------------------------------------------------------
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        b[0] <= 0;
        b[1] <= 0;
        b[2] <= 0;
        b[3] <= 0;
        b[4] <= 0;
        b[5] <= 0;
    end
    else if(state == INV && mode[0] == 0) begin
        b[0] <= a[0];
        b[1] <= a[1];
        b[2] <= a[2];
        b[3] <= a[3];
        b[4] <= a[4];
        b[5] <= a[5];
    end
    else if(state == INV && mode[0] == 1) begin
        if(counter != 6'd36) begin   // counter != 35
            b[count] <= temp[1];
        end
        else if(counter == 6'd36) begin   // counter = 35
            b[count] <= temp[0];
        end
    end
    else begin
        b[0] <= b[0];
        b[1] <= b[1];
        b[2] <= b[2];
        b[3] <= b[3];
        b[4] <= b[4];
        b[5] <= b[5];
    end
end

//---------------------------------------------------------------------
//   STATE MUL DECLARATION                         
//---------------------------------------------------------------------
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        c[0] <= 0;
        c[1] <= 0;
        c[2] <= 0;
        c[3] <= 0;
        c[4] <= 0;
        c[5] <= 0;
    end
    else if(state == MUL && mode[1] == 0) begin
        c[0] <= b[0];
        c[1] <= b[1];
        c[2] <= b[2];
        c[3] <= b[3];
        c[4] <= b[4];
        c[5] <= b[5];
    end
    else if(state == MUL && mode[1] == 1) begin
        if(counter == 8'd4) begin   // counter = 35
            c[0] <= temp[0];
            c[1] <= temp[0];
            c[2] <= temp[1];
            c[3] <= temp[1];
            c[4] <= c[4];
            c[5] <= c[5];
        end
        else if(counter == 8'd8) begin   // counter != 35
            c[0] <= c[0];
            c[1] <= c[1];
            c[2] <= c[2];
            c[3] <= c[3];
            c[4] <= temp[0];
            c[5] <= temp[0];
        end
        else if(counter == 8'd12) begin   // counter = 35
            c[0] <= temp[1];
            c[1] <= temp[1];
            c[2] <= temp[0];
            c[3] <= temp[0];
            c[4] <= c[4];
            c[5] <= c[5];
        end
        else if(counter == 8'd16) begin   // counter = 35
            c[0] <= temp[0];
            c[1] <= temp[1];
            c[2] <= c[2];
            c[3] <= c[3];
            c[4] <= c[4];
            c[5] <= c[5];
        end
        else if(counter == 8'd20) begin   // counter = 35
            c[0] <= c[0];
            c[1] <= c[1];
            c[2] <= temp[0];
            c[3] <= temp[1];
            c[4] <= c[4];
            c[5] <= c[5];
        end
        else if(counter == 8'd24) begin   // counter = 35
            c[0] <= c[0];
            c[1] <= c[1];
            c[2] <= c[2];
            c[3] <= c[3];
            c[4] <= temp[0];
            c[5] <= temp[1];
        end
    end
    else begin
        c[0] <= c[0];
        c[1] <= c[1];
        c[2] <= c[2];
        c[3] <= c[3];
        c[4] <= c[4];
        c[5] <= c[5];
    end
end
//---------------------------------------------------------------------
//   STATE SORT DECLARATION                         
//---------------------------------------------------------------------
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        d[0] <= 0;
        d[1] <= 0;
        d[2] <= 0;
        d[3] <= 0;
        d[4] <= 0;
        d[5] <= 0;
    end
    else if(state == SORT && mode[2] == 0) begin
        d[0] <= c[0];
        d[1] <= c[1];
        d[2] <= c[2];
        d[3] <= c[3];
        d[4] <= c[4];
        d[5] <= c[5];
    end
    else if(state == SORT && mode[2] == 1) begin
        if(counter == 8'd0) begin   // counter != 35
            d[0] <= (c[0] > c[1]) ? c[1]:c[0];  // small
            d[1] <= (c[0] > c[1]) ? c[0]:c[1];  // big 
            d[2] <= (c[2] > c[3]) ? c[3]:c[2];  // small
            d[3] <= (c[2] > c[3]) ? c[2]:c[3];  // big 
            d[4] <= (c[4] > c[5]) ? c[5]:c[4];  //small
            d[5] <= (c[4] > c[5]) ? c[4]:c[5];  // big
        end
        else if(counter == 8'd1) begin   // counter = 35
            d[0] <= (d[0] > d[2]) ? d[2]:d[0];  // small
            d[1] <= d[1];                       // pass
            d[2] <= (d[0] > d[2]) ? d[0]:d[2];  // big
            d[3] <= (d[5] > d[3]) ? d[3]:d[5];  // small
            d[4] <= d[4];                       // pass
            d[5] <= (d[5] > d[3]) ? d[5]:d[3];  // big
        end
        else if(counter == 8'd2) begin   // counter = 35
            d[0] <= (d[4] > d[0]) ? d[0]:d[4];  // smallest
            d[1] <= (d[4] > d[0]) ? d[4]:d[0];  // big
            d[2] <= d[2];                       // pass
            d[3] <= d[3];                       // pass
            d[4] <= (d[5] > d[1]) ? d[1]:d[5];  // small
            d[5] <= (d[5] > d[1]) ? d[5]:d[1];  // biggest
        end
        else if(counter == 8'd3) begin   // counter = 35
            d[0] <= d[0];                       //  smallest
            d[1] <= (d[1] > d[2]) ? d[2]:d[1];  //  small
            d[2] <= (d[1] > d[2]) ? d[1]:d[2];  //  big
            d[3] <= (d[3] > d[4]) ? d[4]:d[3];  //  small
            d[4] <= (d[3] > d[4]) ? d[3]:d[4];  //  big
            d[5] <= d[5];                       //  biggest
        end
        else if(counter == 8'd4) begin   // counter = 35
            d[0] <= d[0];                       // smallest
            d[1] <= (d[1] > d[3]) ? d[3]:d[1];  // smaller   
            d[2] <= (d[2] > d[4]) ? d[4]:d[2];  // big     
            d[3] <= (d[1] > d[3]) ? d[1]:d[3];  // small   
            d[4] <= (d[2] > d[4]) ? d[2]:d[4];  // bigger     
            d[5] <= d[5];                       // biggest 
        end
        else if(counter == 8'd5) begin   // counter = 35
            d[0] <= d[0];                       // smallest
            d[1] <= d[1];                       // smaller   
            d[2] <= (d[2] > d[3]) ? d[3]:d[2];  // small   
            d[3] <= (d[2] > d[3]) ? d[2]:d[3];  // big
            d[4] <= d[4];                       // bigger     
            d[5] <= d[5];                       // biggest 
        end
    end
    else begin
        d[0] <= d[0];
        d[1] <= d[1];
        d[2] <= d[2];
        d[3] <= d[3];
        d[4] <= d[4];
        d[5] <= d[5];
    end
end
//---------------------------------------------------------------------
//   STATE SUM DECLARATION                         
//---------------------------------------------------------------------
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        e[0] <= 0;
        e[1] <= 0;
        e[2] <= 0;
        e[3] <= 0;
        e[4] <= 0;
        e[5] <= 0;
    end
    else if(state == SUM && counter == 4'd4) begin  
        e[0] <= temp[0];
        e[1] <= temp[1];
        e[2] <= e[2];
        e[3] <= e[3];
        e[4] <= e[4];
        e[5] <= e[5];
    end
    else if(state == SUM && counter == 4'd8) begin  
        e[0] <= e[0];
        e[1] <= e[1];
        e[2] <= temp[0];
        e[3] <= temp[1];
        e[4] <= e[4];
        e[5] <= e[5];
    end
    else if(state == SUM && counter == 4'd12) begin  
        e[0] <= e[0];
        e[1] <= e[1];
        e[2] <= e[2];
        e[3] <= e[3];
        e[4] <= temp[0];
        e[5] <= temp[1];
    end
    else begin
        e[0] <= e[0];
        e[1] <= e[1];
        e[2] <= e[2];
        e[3] <= e[3];
        e[4] <= e[4];
        e[5] <= e[5];
    end
end
//---------------------------------------------------------------------
//   CAL ALGORITHM                         
//---------------------------------------------------------------------
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        counter <= 0;
    end
    else if(in_valid) begin
        counter <= counter + 1;
    end
    else if(state >= INV && nextstate == state)begin
        counter <= (counter == 6'd36) ? 0:counter + 1;
    end
    else begin
        counter <= 0;
    end
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        count <= 0;
    end
    else if(counter == 6'd36)begin
        count <= count + 1;
    end
    else begin
        count <= count;
    end
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        temp[0] <= 18'b00_0000_0000_0000_0001;
        temp[1] <= 18'b00_0000_0000_0000_0001;
    end
    else if(state == INV && counter == 6'd0) begin  // counter != 8 = 0 4 12 16...
        temp[0] <= a[count];                           // A*B
        temp[1] <= a[count] * a[count];                // B*B
    end
    else if(state == INV && counter[1:0] == 2'b00 && counter != 6'd0) begin  // counter != 8 = 0 4 12 16...
        temp[0] <= (counter == 8'd8) ? temp[0] : temp[0] * temp[1]; // A*B
        temp[1] <= temp[1] * temp[1];                               // B*B
    end
    else if((state == INV || state == MUL || state == SUM) && counter[1:0] == 2'b01) begin    // counter  = 1
        temp[0] <= temp[0][17:9] + {temp[0][17:9],1'b0} + temp[0][8:0];  // first step of mod 
        temp[1] <= temp[1][17:9] + {temp[1][17:9],1'b0} + temp[1][8:0];  // first step of mod 
    end
    else if((state == INV || state == MUL || state == SUM) && counter[1:0] == 2'b10) begin    // counter = 2
        temp[0] <= temp[0][11:9] + {temp[0][11:9],1'b0} + temp[0][8:0];  // second step of mod 
        temp[1] <= temp[1][11:9] + {temp[1][11:9],1'b0} + temp[1][8:0];  // second step of mod
    end
    else if((state == INV || state == MUL || state == SUM) && counter[1:0] == 2'b11) begin    // counter = 3
        if(temp[0] > 9'd508 && temp[1] > 9'd508) begin
            temp[0] <= temp[0] - 9'd509;  // third step of mod      
            temp[1] <= temp[1] - 9'd509;  // third step of mod 
        end
        else if(temp[0] > 9'd508 && temp[1] <= 9'd508) begin
            temp[0] <= temp[0] - 9'd509;  // third step of mod      
            temp[1] <= temp[1];               // third step of mod 
        end
        else if(temp[0] <= 9'd508 && temp[1] > 9'd508) begin
            temp[0] <= temp[0];               // third step of mod      
            temp[1] <= temp[1] - 9'd509;  // third step of mod 
        end
        else begin
            temp[0] <= temp[0];
            temp[1] <= temp[1];  
        end
    end
    else if(state == MUL && counter == 0)begin
        temp[0] <= b[0] * b[1];
        temp[1] <= b[2] * b[3];
    end
    else if(state == MUL && counter == 4)begin
        temp[0] <= temp[0] * temp[1];
        temp[1] <= b[4] * b[5];
    end
    else if(state == MUL && counter == 8)begin
        temp[0] <= c[0] * temp[1];
        temp[1] <= c[2] * temp[1];
    end
    else if(state == MUL && counter == 12)begin
        temp[0] <= b[1] * temp[1];
        temp[1] <= b[0] * temp[1];
    end
    else if(state == MUL && counter == 16)begin
        temp[0] <= b[3] * c[2];
        temp[1] <= b[2] * c[2];
    end
    else if(state == MUL && counter == 20)begin
        temp[0] <= b[5] * c[4];
        temp[1] <= b[4] * c[4];
    end
    else if(state == SUM && counter[1:0] == 2'b00)begin
        temp[0] <= a[counter[3:1]] + b[counter[3:1]] + c[counter[3:1]] + d[counter[3:1]];
        temp[1] <= a[counter[3:1] + 1] + b[counter[3:1] + 1] + c[counter[3:1] + 1] + d[counter[3:1] + 1];
    end
    else begin
        temp[0] <= temp[0];
        temp[1] <= temp[1];
    end
end
//---------------------------------------------------------------------
//   STATE OUT DECLARATION                         
//---------------------------------------------------------------------
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
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_data <= 0;
    end
    else if(state == OUT) begin
        out_data <= e[counter];
    end
    else begin
        out_data <= 0;
    end
end
//---------------------------------------------------------------------
//   FSM DECLARATION                         
//---------------------------------------------------------------------
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
            if(!in_valid)   nextstate = INV;
            else            nextstate = state;
        end
        INV:begin
            if(mode[0] == 0)                                            nextstate = MUL;
            else if(mode[0] == 1 && count == 3'd5 && counter == 6'd36)  nextstate = MUL;
            else                                                        nextstate = state;
        end
        MUL:begin
            if(mode[1] == 0)                            nextstate = SORT;
            else if(mode[1] == 1 && counter == 8'd24)   nextstate = SORT;
            else                                        nextstate = state;
        end
        SORT:begin
            if(mode[2] == 0)                            nextstate = SUM;
            else if(mode[2] == 1 && counter == 8'd5)    nextstate = SUM;
            else                                        nextstate = state;
        end
        SUM:begin
            if(counter == 8'd12)   nextstate = OUT;
            else                  nextstate = state;
        end
        OUT:begin
            if(counter == 3'd5) nextstate = IDLE;
            else                    nextstate = state;
        end
        default:begin
            nextstate = IDLE;
        end
    endcase
end


endmodule


