`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/05 16:01:59
// Design Name: 
// Module Name: Usertype_PKG
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
module farm(input clk, INF.farm_inf inf);
import usertype::*;
state_f state,nextstate;
/*----------------------------------------------------------------*/
//    REG DECLARATION                                           //
/*----------------------------------------------------------------*/
logic [7:0] land_id;
Crop_cat land_cat;
Crop_sta land_sta;
Action action;
logic [15:0] water_amnt;
logic counter;
logic [31:0] money;
logic act_ctrl,cat_ctrl,amnt_ctrl;
logic new_id;
logic first;
logic act_valid_delay;
logic [15:0] new_water;
logic [23:0] past_info;
/*----------------------------------------------------------------*/
//    ID ALGORITHM                                                  //
/*----------------------------------------------------------------*/
always_ff @(posedge clk, negedge inf.rst_n) begin: ID_REG_LOGIC
    if(!inf.rst_n) begin
        land_id <= 0;
    end
    else if(inf.id_valid)begin      // IN
        land_id <= inf.D.d_id[0];
    end
    else begin
        land_id <= land_id;
    end
end: ID_REG_LOGIC
/*----------------------------------------------------------------*/
//    ACTION ALGORITHM                                         //
/*----------------------------------------------------------------*/
always_ff @(posedge clk,negedge inf.rst_n)begin
    if(!inf.rst_n)begin
        act_valid_delay <= 0;
    end
    else if(inf.act_valid)begin
        act_valid_delay <= 1;
    end
    else begin
        act_valid_delay <= 0;
    end
end
always_ff @(posedge clk, negedge inf.rst_n) begin: ACT_INPU_REG_LOGIC
    if(!inf.rst_n) begin
        action <= No_action;
    end
    else if(state == OUT/* && nextstate == IDLE*/)begin
        action <= No_action;
    end
    else if(inf.act_valid)begin  // IN
        action <= inf.D.d_act[0];
    end
    else begin
        action <= action;
    end
end: ACT_INPU_REG_LOGIC
/*----------------------------------------------------------------*/
//    STATUS ALGORITHM                                         //
/*----------------------------------------------------------------*/
always_ff @(posedge clk, negedge inf.rst_n) begin: CAT_REG_LOGIC
    if(!inf.rst_n) begin
        land_cat <= No_cat;
    end
    else if(inf.id_valid)begin  // RESET WHEN NEW ID COMES
        land_cat <= No_cat;
    end 
    else if(inf.cat_valid && inf.complete)begin
        land_cat <= inf.D.d_cat[0];
    end
    else if(inf.C_out_valid && state == BRIDGE_READ) begin    // IF WE HAVE A NEW ID AND NEED TO DO BRIDGE READ
        if(action == Seed && inf.C_data_r[11:8] == No_cat)begin
            land_cat <= land_cat;
        end
        else begin  // ERR
            case(inf.C_data_r[11:8])
                Potato:begin land_cat <= Potato; end
                Corn  :begin land_cat <= Corn  ; end
                Tomato:begin land_cat <= Tomato; end
                Wheat :begin land_cat <= Wheat ; end
                default:begin land_cat <= No_cat;end
            endcase
        end               
    end
    else if(inf.complete && state == COMPUTE && counter == 2'd1)begin
        if(action == Reap || action == Steal)begin
            land_cat <= No_cat;
        end
        else begin
            land_cat <= land_cat;
        end
    end
    else begin
        land_cat <= land_cat;
    end
end: CAT_REG_LOGIC
always_ff @(posedge clk, negedge inf.rst_n) begin: STA_REG_LOGIC
    if(!inf.rst_n) begin
        land_sta <= No_sta;
    end
    else if(inf.id_valid)begin  // RESET WHEN NEW ID COMES
        land_sta <= No_sta;
    end 
    else if(inf.cat_valid && inf.complete)begin
        land_sta <= Zer_sta;
    end
    else if(inf.C_out_valid && state == BRIDGE_READ) begin    // IF WE HAVE A NEW ID AND NEED TO DO BRIDGE READ
        if(action == Seed && inf.C_data_r[11:8] == No_cat)begin
            land_sta <= land_sta;
        end
        else begin  // ERR
            case(inf.C_data_r[15:12])
                Zer_sta:begin land_sta <= Zer_sta;   end
                Fst_sta:begin land_sta <= Fst_sta;   end
                Snd_sta:begin land_sta <= Snd_sta;   end
                default:begin land_sta <= No_sta;    end
            endcase
        end               
    end
    else if(state == COMPUTE && counter == 0)begin
        case(land_cat)
            Potato: begin
                if(water_amnt < 16'h0010)   // Zer_sta
                    land_sta <= Zer_sta;    
                else if(water_amnt >= 16'h0080)
                    land_sta <= Snd_sta;    
                else
                    land_sta <= Fst_sta;    
            end
            Corn:   begin  
                if(water_amnt < 16'h0040)   // Zer_sta
                    land_sta <= Zer_sta;    
                else if(water_amnt >= 16'h0200)
                    land_sta <= Snd_sta;    
                else
                    land_sta <= Fst_sta;
            end
            Tomato: begin  
                if(water_amnt < 16'h0100)   // Zer_sta
                    land_sta <= Zer_sta;    
                else if(water_amnt >= 16'h0800)
                    land_sta <= Snd_sta;    
                else
                    land_sta <= Fst_sta;    
            end
            Wheat:  begin  
                if(water_amnt < 16'h0400)   // Zer_sta
                    land_sta <= Zer_sta;
                else if(water_amnt >= 16'h2000)
                    land_sta <= Snd_sta;    
                else
                    land_sta <= Fst_sta;    
            end
            default:begin  
                land_sta <= land_sta;    
            end
        endcase
    end
    else if(inf.complete && state == COMPUTE && counter == 2'd1)begin
        if(action == Reap || action == Steal)begin
            land_sta <= No_sta;
        end
        else begin
            land_sta <= land_sta;
        end
    end
    else begin
        land_sta <= land_sta;
    end
end: STA_REG_LOGIC
/*----------------------------------------------------------------*/
//    WATER ALGORITHM                                         //
/*----------------------------------------------------------------*/

always_ff @(posedge clk, negedge inf.rst_n) begin: AMNT_REG_LOGIC
    if(!inf.rst_n) begin
        water_amnt <= 0;
    end
    else if(inf.id_valid)begin  // RESET WHEN NEW ID COMES
        water_amnt <= 0;
    end
    else if(inf.complete && inf.amnt_valid)begin
        water_amnt <= water_amnt + inf.D.d_amnt;
    end
    else if(state == BRIDGE_READ && inf.C_out_valid) begin    // IF WE HAVE A NEW ID AND NEED TO DO BRIDGE READ
        if(action == Seed && inf.C_data_r[11:8] == No_cat)begin
                water_amnt <= water_amnt;
        end
        else if(action == Water && inf.C_data_r[11:8] != No_cat && inf.C_data_r[15:12] != Snd_sta)begin
            water_amnt <= water_amnt + {inf.C_data_r[23:16],inf.C_data_r[31:24]};
        end
        else begin
            water_amnt <= {inf.C_data_r[23:16],inf.C_data_r[31:24]};
        end
    end
    else if(inf.complete && state == COMPUTE && counter == 2'd1)begin
        if(action == Reap || action == Steal)begin
            water_amnt <= 0;
        end
        else begin
            water_amnt <= water_amnt;
        end
    end
    else begin
        water_amnt <= water_amnt;
    end
end: AMNT_REG_LOGIC
/*----------------------------------------------------------------*/
//    MONEY ALGORITHM                                         //
/*----------------------------------------------------------------*/
always_ff @(posedge clk, negedge inf.rst_n) begin:DEP_REG_LOGIC
    if(!inf.rst_n) begin
        money <= 0;
    end
    else if(state == BRIDGE_READ_M && inf.C_out_valid)begin
        money <= {inf.C_data_r[7:0],inf.C_data_r[15:8],inf.C_data_r[23:16],inf.C_data_r[31:24]};
    end
    else if(state == COMPUTE && inf.complete && counter == 2'd0) begin  // NO NEW ID
        if(action == Seed)begin
            if(land_cat == No_cat)             money <= money;
            else if(land_cat == Potato)        money <= money - 5'd5;
            else if(land_cat == Corn)          money <= money - 5'd10;
            else if(land_cat == Tomato)        money <= money - 5'd15;
            else if(land_cat == Wheat)         money <= money - 5'd20;
        end
        else
                money <= money;
    end
    else if(state == COMPUTE && inf.complete && counter == 2'd1) begin
        if(action == Reap)begin
            if(land_sta == Fst_sta)begin
                if(land_cat == Potato)      money <= money + 32'd10;
                else if(land_cat == Corn)   money <= money + 32'd20;
                else if(land_cat == Tomato) money <= money + 32'd30;
                else if(land_cat == Wheat)  money <= money + 32'd40;
            end
            else if(land_sta == Snd_sta)begin
                if(land_cat == Potato)      money <= money + 32'd25;
                else if(land_cat == Corn)   money <= money + 32'd50;
                else if(land_cat == Tomato) money <= money + 32'd75;
                else if(land_cat == Wheat)  money <= money + 32'd100;
            end
            else
                money <= money;
        end
    end
    else begin
        money <= money;
    end
end:DEP_REG_LOGIC
/*----------------------------------------------------------------*/
//    PAST STATUS ALGORITHM                                //
/*----------------------------------------------------------------*/
always_ff @(posedge clk,negedge inf.rst_n)begin
    if(!inf.rst_n)begin
        past_info <= 0;
    end
    else if(state == COMPUTE && counter == 1)begin
        past_info <= {land_sta,land_cat,water_amnt};
    end
    else begin
        past_info <= past_info;
    end
end
/*----------------------------------------------------------------*/
//    OUTPUT ALGORITHM                                        //
/*----------------------------------------------------------------*/
always_ff @(posedge clk,negedge inf.rst_n)begin
    if(!inf.rst_n)begin
        inf.out_valid <= 0;
    end
    else if(state == OUT)begin
        inf.out_valid <= 1;
    end
    else begin
        inf.out_valid <= 0;
    end
end
always_ff @(posedge clk,negedge inf.rst_n)begin
    if(!inf.rst_n)begin
        inf.out_info <= 0;
    end
    else if(state == OUT && inf.complete && action != Check_dep)begin
        inf.out_info <= (action == Reap || action == Steal) ? {land_id,past_info} :{land_id,land_sta,land_cat,water_amnt};
    end
    else begin
        inf.out_info <= 0;
    end
end
always_ff @(posedge clk,negedge inf.rst_n)begin
    if(!inf.rst_n)begin
        inf.out_deposit <= 0;
    end
    else if(state == OUT && action == Check_dep)begin
        inf.out_deposit <= money;
    end
    else begin
        inf.out_deposit <= 0;
    end
end
/*----------------------------------------------------------------*/
//    BRIDGE TRANSFER ALGORITHM                       //
/*----------------------------------------------------------------*/
always_ff @(posedge clk, negedge inf.rst_n) begin
    if(!inf.rst_n) begin
        inf.C_addr <= 0;
        inf.C_r_wb <= 0;
        inf.C_in_valid <= 0;
        inf.C_data_w <= 0;
    end
    else if(state == BRIDGE_READ_M && counter == 0)begin  // READ REQUEST
        inf.C_addr <= 8'd255;
        inf.C_r_wb <= 1'b1;
        inf.C_in_valid <= 1'b1;
        inf.C_data_w <= 0;
    end
    else if(state == BRIDGE_READ && counter == 0)begin  // READ REQUEST
        inf.C_addr <= land_id;
        inf.C_r_wb <= 1'b1;
        inf.C_in_valid <= 1'b1;
        inf.C_data_w <= 0;
    end
    else if(state == BRIDGE_WRITE && counter == 0)begin  // WRITE REQUEST
        inf.C_addr <= land_id;
        inf.C_r_wb <= 1'b0;
        inf.C_in_valid <= 1'b1;
        inf.C_data_w <= {water_amnt[7:0],water_amnt[15:8],land_sta,land_cat,land_id};
    end
    else begin
        inf.C_addr <= 0;
        inf.C_r_wb <= 0;
        inf.C_in_valid <= 0;
        inf.C_data_w <= 0;
    end
end

/*----------------------------------------------------------------*/
//    ERR DETECTION ALGORITHM                           //
/*----------------------------------------------------------------*/

always_ff @(posedge clk or negedge inf.rst_n) begin
    if(!inf.rst_n) begin
        inf.err_msg <= No_Err;
        inf.complete <= 0;
    end
    else if(state == IDLE/* && nextstate == IDLE*/) begin
        inf.err_msg <= No_Err;
        inf.complete <= 1;
    end
    else if(state == IN && new_id == 0 && act_valid_delay) begin  // NO NEW ID
        case(action)
            Seed:begin
                if(land_cat == No_cat)begin
                    inf.err_msg <= No_Err;
                    inf.complete <= 1;
                end
                else begin
                    inf.err_msg <= Not_Empty;
                    inf.complete <= 0;
                end                 
            end
            Water:begin
                if(land_cat == No_cat)begin
                    inf.err_msg <= Is_Empty;
                    inf.complete <= 0;
                end
                else if(land_sta == Snd_sta)begin
                    inf.err_msg <= Has_Grown;
                    inf.complete <= 0;
                end
                else begin
                    inf.err_msg <= No_Err;
                    inf.complete <= 1;
                end      
            end
            Reap:begin
                if(land_cat == No_cat)begin
                    inf.err_msg <= Is_Empty;
                    inf.complete <= 0;
                end
                else if(land_sta == Zer_sta)begin
                    inf.err_msg <= Not_Grown;
                    inf.complete <= 0;
                end
                else begin
                    inf.err_msg <= No_Err;
                    inf.complete <= 1;
                end      
            end
            Steal:begin
                if(land_cat == No_cat)begin
                    inf.err_msg <= Is_Empty;
                    inf.complete <= 0;
                end
                else if(land_sta == Zer_sta)begin
                    inf.err_msg <= Not_Grown;
                    inf.complete <= 0;
                end
                else begin
                    inf.err_msg <= No_Err;
                    inf.complete <= 1;
                end   
            end
        endcase
    end
    else if(new_id && inf.C_out_valid && state == BRIDGE_READ) begin
        case(action)
            Seed:begin
                if(inf.C_data_r[11:8] == No_cat)begin
                    inf.err_msg <= No_Err;
                    inf.complete <= 1;
                end
                else begin
                    inf.err_msg <= Not_Empty;
                    inf.complete <= 0;
                end                 
            end
            Water:begin
                if(inf.C_data_r[11:8] == No_cat)begin
                    inf.err_msg <= Is_Empty;
                    inf.complete <= 0;
                end
                else if(inf.C_data_r[15:12] == Snd_sta)begin
                    inf.err_msg <= Has_Grown;
                    inf.complete <= 0;
                end
                else begin
                    inf.err_msg <= No_Err;
                    inf.complete <= 1;
                end      
            end
            Reap:begin
                if(inf.C_data_r[11:8] == No_cat)begin
                    inf.err_msg <= Is_Empty;
                    inf.complete <= 0;
                end
                else if(inf.C_data_r[15:12] == Zer_sta)begin
                    inf.err_msg <= Not_Grown;
                    inf.complete <= 0;
                end
                else begin
                    inf.err_msg <= No_Err;
                    inf.complete <= 1;
                end      
            end
            Steal:begin
                if(inf.C_data_r[11:8] == No_cat)begin
                    inf.err_msg <= Is_Empty;
                    inf.complete <= 0;
                end
                else if(inf.C_data_r[15:12] == Zer_sta)begin
                    inf.err_msg <= Not_Grown;
                    inf.complete <= 0;
                end
                else begin
                    inf.err_msg <= No_Err;
                    inf.complete <= 1;
                end   
            end
        endcase
    end
    else begin
        inf.err_msg <= inf.err_msg;
        inf.complete <= inf.complete;
    end
end
/*----------------------------------------------------------------*/
//    COUNTER DECLARATION                                  //
/*----------------------------------------------------------------*/
always_ff @(posedge clk, negedge inf.rst_n) begin
    if(!inf.rst_n) begin
        counter <= 0;
    end
    else if(state == IDLE && nextstate == state)begin
        counter <= (counter == 1) ? 1:counter + 1;
    end
    else if(state == BRIDGE_READ_M && nextstate == state)begin
        counter <= (counter == 1) ? 1:counter + 1;
    end
    else if(state == BRIDGE_READ && nextstate == state)begin
        counter <= (counter == 1) ? 1:counter + 1;
    end
    else if(state == COMPUTE && nextstate == state) begin
        counter <= (counter == 1) ? 1:counter + 1;
    end
    else if(state == BRIDGE_WRITE && nextstate == state)begin
        counter <= (counter == 1) ? 1:counter + 1;
    end
    else begin
        counter <= 0;
    end
end
/*----------------------------------------------------------------*/
//    COUNTROL SIGNAL DECLARATION                  //
/*----------------------------------------------------------------*/
always_ff @(posedge clk, negedge inf.rst_n) begin
    if(!inf.rst_n) begin
        new_id <= 0;
    end
    else if(inf.id_valid) begin
        new_id <= 1;
    end
    else if(state == IDLE) begin
        new_id <= 0;
    end
    else begin
        new_id <= new_id;
    end
end
always_ff @(posedge clk, negedge inf.rst_n) begin
    if(!inf.rst_n) begin
        first <= 1;
    end
    else if(state == OUT) begin
        first <= 0;
    end
    else begin
        first <= first;
    end
end
always_ff @(posedge clk, negedge inf.rst_n) begin
    if(!inf.rst_n) begin
        act_ctrl <= 0;
        cat_ctrl <= 0;
        amnt_ctrl <= 0;
    end
    else if(state == IN/* || nextstate == IN*/) begin
        act_ctrl <= (inf.act_valid) ? 1:act_ctrl;
        cat_ctrl <= (inf.cat_valid || action != Seed) ? 1:cat_ctrl;
        amnt_ctrl <= ((inf.amnt_valid && (action == Seed || action == Water)) || (action == Reap || action == Steal || action == Check_dep)) ? 1:amnt_ctrl;
    end
    else begin
        act_ctrl <= 0;
        cat_ctrl <= 0;
        amnt_ctrl <= 0;
    end
end
/*----------------------------------------------------------------*/
//    FSM DECLARATION                                           //
/*----------------------------------------------------------------*/
always_ff @(posedge clk, negedge inf.rst_n) begin
    if(!inf.rst_n) begin
        state <= IDLE;
    end
    else begin
        state <= nextstate;
    end
end
always_comb begin
    case(state)
        IDLE: begin
            if(counter == 1) nextstate = IN;
            else             nextstate = state;
        end
        IN:begin
            if(act_ctrl && cat_ctrl && amnt_ctrl && first)   nextstate = BRIDGE_READ_M;
            else if(act_ctrl && cat_ctrl && amnt_ctrl && !first && action != Check_dep) nextstate = (new_id) ? BRIDGE_READ:COMPUTE;
            else if(act_ctrl && cat_ctrl && amnt_ctrl && !first && action == Check_dep) nextstate = OUT;
            else    nextstate = state;
        end
        BRIDGE_READ_M:begin
            if(inf.C_out_valid) nextstate = (new_id) ? BRIDGE_READ:COMPUTE;
            else                nextstate = state;
        end
        BRIDGE_READ:begin
            if(inf.C_out_valid) nextstate = COMPUTE;
            else                nextstate = state;
        end
        COMPUTE:begin
            if(counter == 1 && action != Check_dep) nextstate = (inf.complete) ? BRIDGE_WRITE:OUT;
            else if(counter == 1 && action == Check_dep) nextstate = OUT;
            else        nextstate = state;
        end
        BRIDGE_WRITE:begin
            if(inf.C_out_valid) nextstate = OUT;
            else                nextstate = state;
        end
        OUT:begin
            nextstate = IDLE;
        end
        default:begin
            nextstate = IDLE;
        end
    endcase
end
endmodule