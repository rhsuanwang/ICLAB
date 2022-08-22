//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//
//   File Name   : CHECKER.sv
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################
//`include "Usertype_PKG.sv"

module Checker(input clk, INF.CHECKER inf);
import usertype::*;

covergroup Spec1 @(posedge clk && inf.amnt_valid == 1);
    option.per_instance = 1;
	coverpoint inf.D.d_amnt{bins amnt1 = {[0:12000]};
	                        bins amnt2 = {[12001:24000]};
	                        bins amnt3 = {[24001:36000]};
	                        bins amnt4 = {[36001:48000]};
	                        bins amnt5 = {[48001:60000]};
	                        ignore_bins amnt6 = {[60001:$]};
	                        option.at_least = 100;
	                       }
endgroup
covergroup Spec2 @(posedge clk && inf.id_valid == 1);
    option.per_instance = 1;
	coverpoint inf.D.d_id[0]{bins id1 = {[0:254]};
	                         ignore_bins id2 = {255};
	                         option.at_least = 10;
	                         option.auto_bin_max = 255;
	                        }
endgroup
covergroup Spec3 @(posedge clk && inf.act_valid == 1);
    option.per_instance = 1;
	coverpoint inf.D.d_act[0]{
	                          bins act01 = (Seed => Seed);
	                          bins act02 = (Seed => Water);
	                          bins act03 = (Seed => Reap);     
	                          bins act04 = (Seed => Steal);    
	                          bins act05 = (Seed => Check_dep);
	                          bins act06 = (Water => Seed);     
	                          bins act07 = (Water => Water);    
	                          bins act08 = (Water => Reap);     
	                          bins act09 = (Water => Steal);    
	                          bins act10 = (Water => Check_dep);
	                          bins act11 = (Reap => Seed);     
	                          bins act12 = (Reap => Water);    
	                          bins act13 = (Reap => Reap);     
	                          bins act14 = (Reap => Steal);    
	                          bins act15 = (Reap => Check_dep);
	                          bins act16 = (Steal => Seed);     
	                          bins act17 = (Steal => Water);    
	                          bins act18 = (Steal => Reap);     
	                          bins act19 = (Steal => Steal);    
	                          bins act20 = (Steal => Check_dep);
	                          bins act21 = (Check_dep => Seed);     
	                          bins act22 = (Check_dep => Water);    
	                          bins act23 = (Check_dep => Reap);     
	                          bins act24 = (Check_dep => Steal);    
	                          bins act25 = (Check_dep => Check_dep);
	                          option.at_least = 10;
	                         }
endgroup
covergroup Spec4 @(negedge clk && inf.out_valid == 1);
    option.per_instance = 1;
	coverpoint inf.err_msg{bins err1 = {Is_Empty };
	                       bins err2 = {Not_Empty};
	                       bins err3 = {Has_Grown};
	                       bins err4 = {Not_Grown};
	                       ignore_bins err5 = {No_Err};
	                       option.at_least = 100;
	                      }
endgroup

//declare the cover group 
Spec1 cov_inst_1 = new();
Spec2 cov_inst_2 = new();
Spec3 cov_inst_3 = new();
Spec4 cov_inst_4 = new();




//************************************ below assertion is to check your pattern ***************************************** 
//                                          Please finish and hand in it
// This is an example assertion given by TA, please write other assertions at the below
property rst_signals;
        @(posedge inf.rst_n) (!inf.rst_n |-> ((inf.out_valid  == 0)  
                                           && (inf.out_info   == 0)
                                           && (inf.out_deposit== 0)
                                           && (inf.err_msg    == 0)
                                           && (inf.complete   == 0)
));
endproperty:rst_signals
assert_1 : assert property (rst_signals)
    else
    begin
    	$display("Assertion 1 is violated");
    	$fatal; 
    end
    
property err_in_complete;
        @(posedge clk)  
            ((inf.out_valid == 1 && inf.complete == 1) |-> (inf.err_msg == No_Err));
endproperty:err_in_complete    
assert_2 : assert property (err_in_complete)
    else
    begin
    	$display("Assertion 2 is violated");
    	$fatal; 
    end
    

property check_deposit_info;
        @(posedge clk)
            first_match((inf.act_valid && inf.D.d_act[0] == Check_dep) ##[1:1199] (inf.out_valid)) |-> inf.out_info == 0;
endproperty 
assert_3 : assert property (check_deposit_info)
    else
    begin
    	$display("Assertion 3 is violated");
    	$fatal; 
    end

property check_deposit_depo1;
        @(posedge clk)
            first_match((inf.act_valid && inf.D.d_act[0] == Seed) ##[1:1199] (inf.out_valid)) |-> inf.out_deposit == 0;
endproperty                                                   
property check_deposit_depo2;                                  
        @(posedge clk)
            first_match((inf.act_valid && inf.D.d_act[0] == Water) ##[1:1199] (inf.out_valid)) |-> inf.out_deposit == 0;
endproperty                                                     
property check_deposit_depo3;                                    
        @(posedge clk)
            first_match((inf.act_valid && inf.D.d_act[0] == Reap) ##[1:1199] (inf.out_valid)) |-> inf.out_deposit == 0;
endproperty                                                  
property check_deposit_depo4;                                 
        @(posedge clk)
            first_match((inf.act_valid && inf.D.d_act[0] == Steal) ##[1:1199] (inf.out_valid)) |-> inf.out_deposit == 0;
endproperty
assert_41 : assert property (check_deposit_depo1 )
   else
   begin
   	    $display("Assertion 4 is violated");
   	    $fatal; 
   end
assert_42 : assert property (check_deposit_depo2 )
   else
   begin
   	    $display("Assertion 4 is violated");
   	    $fatal; 
   end
assert_43 : assert property (check_deposit_depo3 )
   else
   begin
   	    $display("Assertion 4 is violated");
   	    $fatal; 
   end
assert_44 : assert property (check_deposit_depo4 )
   else
   begin
   	    $display("Assertion 4 is violated");
   	    $fatal; 
   end
   
property out_valid_latency;
        @(posedge clk)  
            ((inf.out_valid == 1) |=> ( inf.out_valid == 0));
endproperty:out_valid_latency 
assert_5 : assert property ( out_valid_latency )
    else
    begin
    	$display("Assertion 5 is violated");
    	$fatal; 
    end
    
property gap_length_id_act;
        @(posedge clk)  
            (inf.id_valid==1 && inf.act_valid == 0) |=> (inf.id_valid == 0 && inf.act_valid == 0);
endproperty:gap_length_id_act     
assert_6 : assert property (gap_length_id_act)
    else
    begin
    	$display("Assertion 6 is violated");
    	$fatal; 
    end

property gap_length_cat_amnt;
        @(posedge clk)  
            (inf.cat_valid==1 && inf.amnt_valid == 0) |=> (inf.cat_valid == 0 && inf.amnt_valid == 0);
endproperty:gap_length_cat_amnt    
assert_7 : assert property (gap_length_cat_amnt)
    else
    begin
    	$display("Assertion 7 is violated");
    	$fatal; 
    end

property not_overlap_valid1;
        @(posedge clk)  
            (inf.id_valid == 1 |-> (inf.act_valid == 0));
endproperty   
property not_overlap_valid2;
        @(posedge clk)  
            (inf.id_valid == 1 |-> (inf.cat_valid == 0));
endproperty  
property not_overlap_valid3;
        @(posedge clk)  
            (inf.id_valid == 1 |-> (inf.amnt_valid == 0));
endproperty 
property not_overlap_valid4;
        @(posedge clk)  
            (inf.act_valid == 1 |-> (inf.cat_valid == 0));
endproperty   
property not_overlap_valid5;
        @(posedge clk)  
            (inf.act_valid == 1 |-> (inf.amnt_valid == 0));
endproperty   
property not_overlap_valid6;
        @(posedge clk)  
            (inf.cat_valid == 1 |-> (inf.amnt_valid == 0));
endproperty  
assert_81 : assert property (not_overlap_valid1)
    else
    begin
    	$display("Assertion 8 is violated");
    	$fatal; 
    end
assert_82 : assert property (not_overlap_valid2)
    else
    begin
    	$display("Assertion 8 is violated");
    	$fatal; 
    end
assert_83 : assert property (not_overlap_valid3)
    else
    begin
    	$display("Assertion 8 is violated");
    	$fatal; 
    end    
assert_84 : assert property (not_overlap_valid4)
    else
    begin
    	$display("Assertion 8 is violated");
    	$fatal; 
    end
assert_85 : assert property (not_overlap_valid5)
    else
    begin
    	$display("Assertion 8 is violated");
    	$fatal; 
    end
assert_86 : assert property (not_overlap_valid6)
    else
    begin
    	$display("Assertion 8 is violated");
    	$fatal; 
    end    
property next_id;
        @(posedge clk)  
            (inf.out_valid == 1) |-> ##[2:10](inf.id_valid == 1 || inf.act_valid == 1);
endproperty:next_id
assert_9 : assert property (next_id)
    else
    begin
    	$display("Assertion 9 is violated");
    	$fatal; 
    end
property total_latency;
        @(posedge clk)  
            ((inf.act_valid == 1 && (inf.D.d_act[0] == Reap || inf.D.d_act[0] == Steal || inf.D.d_act[0] == Check_dep)) || inf.amnt_valid == 1)  |=>  ##[1:1199](inf.out_valid == 1);
endproperty:total_latency
assert_10 : assert property (total_latency)
    else
    begin
    	$display("Assertion 10 is violated");
    	$fatal; 
    end

endmodule