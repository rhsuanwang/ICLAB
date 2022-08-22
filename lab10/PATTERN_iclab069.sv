
`include "../00_TESTBED/pseudo_DRAM.sv"
`include "Usertype_PKG.sv"
`include "success.sv"
program automatic PATTERN(input clk, INF.PATTERN inf);
import usertype::*;
parameter DRAM_p_r = "../00_TESTBED/DRAM/dram.dat";

/////********** CLEAR *********/////
integer     PatternNumber = 2610;

integer     i,k;
integer     gap;
//****  GOLDEN   ****//
logic [7:0]     golden_DRAM[(65536+256*4)-1:65536+0];
logic [31:0]    golden_out_info;	//32
logic [31:0]    golden_out_deposit; //32
Error_Msg       golden_err_msg;		//4
logic           golden_complete;	//1
/*
logic [3:0]     golden_user_pw;		//4
logic [7:0]     golden_user_pw_en;	//8
*/
logic [31:0]    golden_money;
logic [7:0]     golden_id;//8
logic [3:0]     golden_act;
logic [7:0]     golden_sta;
logic [3:0]     golden_cat;
logic [15:0]    golden_wat;
logic [15:0]    new_wat;
integer         pat_file_in;
integer         counter;
integer         lat,total_latency;
integer         n;
integer         counter_in;
//================================================================
// initial
//================================================================
//random_new_id r_new_id = new();
//random_id     r_id     = new();
//random_act    r_act    = new();
//random_cat 	  r_cat    = new();
//random_amnt   r_amnt   = new();
initial begin
	$readmemh(DRAM_p_r, golden_DRAM);
	inf.rst_n=1;
	reset_signal_task;
    pat_file_in = $fopen("../00_TESTBED/input.txt", "r");
    
    golden_money = {golden_DRAM[65536+255*4+0]
                   ,golden_DRAM[65536+255*4+1]
                   ,golden_DRAM[65536+255*4+2]
                   ,golden_DRAM[65536+255*4+3]};
    @(negedge clk)
	for (counter=0; counter < PatternNumber; counter=counter+1)begin
		//$display("Pattern = %d",counter);
		if(counter == PatternNumber - 1)begin
		  input_task;
		  wait_out_valid;
		  check_ans_task;
		end
		else begin
		  input_task;
		  wait_out_valid;
		  check_ans_task;
		  delay_out_task;
		end
	end
    congratulations;

	$finish;
end

task reset_signal_task; begin
	#(5); 
	inf.rst_n          =0;
	inf.id_valid       =0;
	inf.act_valid      =0;
	inf.amnt_valid     =0;
	inf.cat_valid      =0;
	inf.D              =0;
	#(10);
	#(5);inf.rst_n =1;

	release clk;
end
endtask

task delay_task ; begin
	gap = $urandom_range(1,1);
	repeat(gap)@(negedge clk);
end endtask

task delay_out_task ; begin
	gap = $urandom_range(1,9);
	repeat(gap)@(negedge clk);
end endtask

task input_task; begin
    //$display("----- input ------ ");
	inf.D         = 'bx;
	golden_complete = 'b1;
	golden_err_msg = No_Err;
	$fscanf(pat_file_in,"%d",golden_id);
	$fscanf(pat_file_in,"%d",golden_act);
	//$display("actnumber = %d \n",r_act.ran_act);
	case(golden_act)
		4'd1:seed_task;
		4'd3:water_task;
		4'd2:reap_task;
		4'd4:steal_task;
		4'd8:check_deposit_task;
	endcase
end
endtask

task give_id_task;begin
    //$display("------ id ");
    
	inf.id_valid    =  'b1;
	inf.D       = {8'b0, golden_id};
	golden_sta = golden_DRAM[65536 + golden_id *4 + 1];
	golden_wat = {golden_DRAM[65536 + golden_id *4 + 2],golden_DRAM[65536 + golden_id *4 + 3]};
	golden_out_deposit = 0;
    repeat(1) @(negedge clk);
	inf.id_valid    =  'b0;
	inf.D           =  'dx;
    //$display("------ id finish");
end
endtask

task seed_task;begin
    give_id_task ;
    //$display("------ seed ");
	delay_task;
	inf.act_valid = 'b1;
	inf.D         = {12'b0,golden_act};
	@(negedge clk);
	inf.act_valid = 'b0;
	inf.D         = 'bx;

	delay_task;
	$fscanf(pat_file_in,"%d",golden_cat);
	inf.cat_valid = 'b1;
	inf.D         = {12'b0,golden_cat};
	@(negedge clk);
	inf.cat_valid = 'b0;
	inf.D         = 'bx;
    
    delay_task;
    $fscanf(pat_file_in,"%d",new_wat);
	inf.amnt_valid = 'b1;
	inf.D         = new_wat;
	@(negedge clk);
	inf.amnt_valid = 'b0;
	inf.D         = 'bx;
	
	if(golden_sta[3:0] == No_cat)begin
	   golden_sta =  {Zer_sta,golden_cat};
	   golden_wat = golden_wat + new_wat;
	   golden_complete = 1;
	   golden_err_msg = No_Err;
	   if(golden_cat == Potato)begin
	       golden_money = golden_money - 'd5;
	       if(golden_wat >= 16'h80)begin
	               golden_sta[7:4] = Snd_sta;
	           end
	           else if(golden_wat < 16'h10)
	               golden_sta[7:4] = Zer_sta;
	           else
	               golden_sta[7:4] = Fst_sta;
	   end
	   else if(golden_cat == Corn)begin
	       golden_money = golden_money - 'd10;
	       if(golden_wat >= 16'h200)begin
	               golden_sta[7:4] = Snd_sta;
	           end
	           else if(golden_wat < 16'h40)
	               golden_sta[7:4] = Zer_sta;
	           else
	               golden_sta[7:4] = Fst_sta;
	   end
	   else if(golden_cat == Tomato)begin
	       golden_money = golden_money - 'd15;
	       if(golden_wat >= 16'h800)begin
	               golden_sta[7:4] = Snd_sta;
	           end
	           else if(golden_wat < 16'h100)
	               golden_sta[7:4] = Zer_sta;
	           else
	               golden_sta[7:4] = Fst_sta;
	   end
	   else if(golden_cat == Wheat)begin
	       golden_money = golden_money - 'd20;
	       if(golden_wat >= 16'h2000)begin
	               golden_sta[7:4] = Snd_sta;
	           end
	           else if(golden_wat < 16'h400)
	               golden_sta[7:4] = Zer_sta;
	           else
	               golden_sta[7:4] = Fst_sta;
	   end
	   golden_out_info = {golden_id,golden_sta,golden_wat};
	end
	else begin
	   golden_sta = golden_sta;
	   golden_wat = golden_wat;
	   golden_complete = 0;
	   golden_err_msg = Not_Empty;
	   golden_money = golden_money;
	   golden_out_info = 0;
	end
	
	
	{golden_DRAM[65536 + golden_id*4 + 0]
	,golden_DRAM[65536 + golden_id*4 + 1]
	,golden_DRAM[65536 + golden_id*4 + 2]
	,golden_DRAM[65536 + golden_id*4 + 3]} = {golden_id,golden_sta,golden_wat};
   // $display("------ seed finish ");
end
endtask

task water_task;begin
    give_id_task ;
    //$display("------ water ");
	delay_task;
	inf.act_valid = 'b1;
	inf.D         = {12'b0,golden_act};
	@(negedge clk);
	inf.act_valid = 'b0;
	inf.D         = 'bx;
   
	delay_task;
	$fscanf(pat_file_in,"%d",new_wat);
	inf.amnt_valid = 'b1;
	inf.D = new_wat;
	 @(negedge clk);
	inf.amnt_valid = 'b0;
	inf.D         = 'bx;
	
	if(golden_sta[7:4] == Snd_sta)begin
	   golden_wat = golden_wat;
	   golden_err_msg = Has_Grown;
	   golden_complete = 0;
	   golden_out_info = 0;
	end
	else if(golden_sta[3:0] == No_cat) begin
	   golden_wat = golden_wat;
	   golden_err_msg = Is_Empty;
	   golden_complete = 0;
	   golden_out_info = 0;
	end
	else begin
	   golden_wat = new_wat + golden_wat;
	   golden_err_msg = No_Err;
	   golden_complete = 1;
	   @(negedge clk);
	       if(golden_sta[3:0] == Potato)begin
	           if(golden_wat >= 16'h80)begin
	               golden_sta[7:4] = Snd_sta;
	           end
	           else if(golden_wat < 16'h10)
	               golden_sta[7:4] = Zer_sta;
	           else
	               golden_sta[7:4] = Fst_sta;
	       end
	       else if(golden_sta[3:0] == Corn)begin
	           if(golden_wat >= 16'h200)begin
	               golden_sta[7:4] = Snd_sta;
	           end
	           else if(golden_wat < 16'h40)
	               golden_sta[7:4] = Zer_sta;
	           else
	               golden_sta[7:4] = Fst_sta;
	       end
	       else if(golden_sta[3:0] == Tomato)begin
	           if(golden_wat >= 16'h800)begin
	               golden_sta[7:4] = Snd_sta;
	           end
	           else if(golden_wat < 16'h100)
	               golden_sta[7:4] = Zer_sta;
	           else
	               golden_sta[7:4] = Fst_sta;
	       end
	       else if(golden_sta[3:0] == Wheat)begin
	           if(golden_wat >= 16'h2000)begin
	               golden_sta[7:4] = Snd_sta;
	           end
	           else if(golden_wat < 16'h400)
	               golden_sta[7:4] = Zer_sta;
	           else
	               golden_sta[7:4] = Fst_sta;
	       end
	   @(negedge clk);
	   golden_out_info = {golden_id,golden_sta,golden_wat};
	end

	
	
    {golden_DRAM[65536+golden_id*4 + 1],golden_DRAM[65536+golden_id*4 + 2],golden_DRAM[65536+golden_id*4 + 3]} = {golden_sta,golden_wat};
    
    //$display("------ water finish ");
end
endtask

task reap_task;begin
    give_id_task ;
    //$display("------ reap ");
    delay_task;
	inf.act_valid = 'b1;
	inf.D         = {12'b0,golden_act};
	@(negedge clk);
	inf.act_valid = 'b0;
	inf.D         = 'bx;
	
	if(golden_sta[7:4] == Zer_sta)begin
	   golden_sta = golden_sta;
	   golden_wat = golden_wat;
	   golden_err_msg = Not_Grown;
	   golden_complete = 0;
	   golden_money = golden_money;
	   golden_out_info = 0;
	   @(negedge clk);
	   {golden_DRAM[65536 + golden_id *4 + 0]
	   ,golden_DRAM[65536 + golden_id *4 + 1]
	   ,golden_DRAM[65536 + golden_id *4 + 2]
	   ,golden_DRAM[65536 + golden_id *4 + 3]} = {golden_id,golden_sta,golden_wat};
	end
	else if(golden_sta[3:0] == No_cat) begin
	   golden_sta = golden_sta;
	   golden_wat = golden_wat;
	   golden_err_msg = Is_Empty;
	   golden_complete = 0;
	   golden_money = golden_money;
	   golden_out_info = 0;
	   @(negedge clk);
	   {golden_DRAM[65536 + golden_id *4 + 0]
	   ,golden_DRAM[65536 + golden_id *4 + 1]
	   ,golden_DRAM[65536 + golden_id *4 + 2]
	   ,golden_DRAM[65536 + golden_id *4 + 3]} = {golden_id,golden_sta,golden_wat};
	end
	else begin
	   if(golden_sta[7:4] == Fst_sta) begin
	       if(golden_sta[3:0] == Potato)begin
	           golden_money = golden_money + 'd10;
	       end
	       else if(golden_sta[3:0] == Corn)begin
	           golden_money = golden_money + 'd20;
	       end
	       else if(golden_sta[3:0] == Tomato)begin
	           golden_money = golden_money + 'd30;
	       end
	       else if(golden_sta[3:0] == Wheat)begin
	           golden_money = golden_money + 'd40;
	       end
	   end
	   else if(golden_sta[7:4] == Snd_sta) begin
	       if(golden_sta[3:0] == Potato)begin
	           golden_money = golden_money + 'd25;
	       end
	       else if(golden_sta[3:0] == Corn)begin
	           golden_money = golden_money + 'd50;
	       end
	       else if(golden_sta[3:0] == Tomato)begin
	           golden_money = golden_money + 'd75;
	       end
	       else if(golden_sta[3:0] == Wheat)begin
	           golden_money = golden_money + 'd100;
	       end
	   end
	   @(negedge clk);
	   golden_out_info = {golden_id,golden_sta,golden_wat};
	   golden_DRAM[65536 + golden_id *4 + 1] = {No_sta,No_cat};
	   {golden_DRAM[65536 + golden_id *4 + 2]
	   ,golden_DRAM[65536 + golden_id *4 + 3]} = 0;
	end
	
	
	
	//$display("------ reap finish  ");
end
endtask

task steal_task;begin//
    give_id_task ;
    //$display("------ steal  ");
	delay_task;
	inf.act_valid = 'b1;
	inf.D         = {12'b0,golden_act};
	@(negedge clk);
	inf.act_valid = 'b0;
	inf.D         = 'bx;
	
	if(golden_sta[7:4] == Zer_sta)begin
	   golden_sta = golden_sta;
	   golden_wat = golden_wat;
	   golden_err_msg = Not_Grown;
	   golden_complete = 0;
	   golden_money = golden_money;
	   golden_out_info = 0;
	   @(negedge clk);
	   {golden_DRAM[65536 + golden_id *4 + 0]
	   ,golden_DRAM[65536 + golden_id *4 + 1]
	   ,golden_DRAM[65536 + golden_id *4 + 2]
	   ,golden_DRAM[65536 + golden_id *4 + 3]} = {golden_id,golden_sta,golden_wat};
	end
	else if(golden_sta[3:0] == No_cat) begin
	   golden_sta = golden_sta;
	   golden_wat = golden_wat;
	   golden_err_msg = Is_Empty;
	   golden_complete = 0;
	   golden_money = golden_money;
	   golden_out_info = 0;
	   @(negedge clk);
	   {golden_DRAM[65536 + golden_id *4 + 0]
	   ,golden_DRAM[65536 + golden_id *4 + 1]
	   ,golden_DRAM[65536 + golden_id *4 + 2]
	   ,golden_DRAM[65536 + golden_id *4 + 3]} = {golden_id,golden_sta,golden_wat};
	end
	else begin
	   golden_sta = golden_sta;
	   golden_wat = golden_wat;
	   golden_err_msg = No_Err;
	   golden_complete = 1;
	   golden_money = golden_money;
	   @(negedge clk);
	   golden_out_info = {golden_id,golden_sta,golden_wat};
	   golden_DRAM[65536 + golden_id *4 + 1] = {No_sta,No_cat};
	   {golden_DRAM[65536 + golden_id *4 + 2]
	   ,golden_DRAM[65536 + golden_id *4 + 3]} = 0;
	end
	
	
	
	//$display("------ steal finish  ");
end
endtask

task check_deposit_task;begin//
    //$display("------ deposit  ");
	inf.act_valid = 'b1;
	inf.D         = {12'b0,golden_act};
	@(negedge clk);
	inf.act_valid = 'b0;
	inf.D         = 'bx;
	
	golden_out_info = 0;
	golden_complete=1;
	golden_err_msg=No_Err;
	golden_out_deposit=golden_money;
	golden_out_info = 0;
	
	//$display("------ deposit finish  ");
end
endtask

task wait_out_valid; begin
    lat=-1;
    while(inf.out_valid!==1) begin
	lat=lat+1;
      if(lat==1200)begin//lat==max+1
//          $display("********************************************************");     
//          $display("*  The execution latency are over 1200 cycles  at %8t   *",$time);//over max
//          $display("********************************************************");
	    repeat(2)@(negedge clk);
	    $finish;
      end
     @(negedge clk);
	end
	total_latency = total_latency + lat;
end endtask

task check_ans_task; begin
		if(inf.out_valid)begin
		    //@(negedge clk);
			if(lat === -1)begin
//				$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
//				$display ("                                                                        FAIL!                                                               ");
//				$display ("                                                           Invalid and Outvalid are overlapped                                              ");
//				$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
				repeat(9) @(negedge clk);
				$finish;
			end	
			if((inf.complete    !== golden_complete   ) ||
			   (inf.err_msg     !== golden_err_msg    ) ||
			   (inf.out_deposit !== golden_out_deposit) ||
			   (inf.out_info    !== golden_out_info   )  )begin
//				$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
//				$display ("                                                                   	FAIL                                         					   ");
//				$display ("                                                      your complete:   %d  golden_complete:   %d                                          ",inf.complete,golden_complete);
//				$display ("                                                      your err_msg:   %d  golden_err_msg:   %d                                          ",inf.err_msg,golden_err_msg);
//				$display ("                                                      your deposit:%d  golden_deposit:%d                                 		   ",inf.out_deposit,golden_out_deposit);
//				$display ("                                                      your info:%h  golden_info:%h                                  		   ",inf.out_info,golden_out_info);
//				$display ("                                                      golden_id:%h                                  		   ",golden_id);
//				$display ("                                                      golden_sta:%h                                  		   ",golden_sta[7:4]);
//				$display ("                                                      golden_cat:%h                                  		   ",golden_sta[3:0]);
//				$display ("                                                      golden_wat:%h                                  		   ",golden_wat);
//				$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
				repeat(2) @(negedge clk);
				$finish;
			end
//            else begin
//				if(golden_err_msg === No_Err)
//					$display("\033[0;38;5;111mPASS PATTERN NO:%d \033[m latency: %3d", counter, lat);
//				else
//					$display("\033[0;38;5;111mPASS PATTERN NO:%d \033[m latency: %3d", counter, lat);
//			end			
		end
		n=0;
		while(inf.out_valid) begin
			if(n>0)
			begin
//				$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
//				$display ("                                                                        FAIL!                                                               ");
//				$display ("                                                           Outvalid is more than 1 cycle                                                  ");//than max
//				$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
				repeat(9) @(negedge clk);
				$finish;
			end
			@(negedge clk);		
			n=n+1;
		end
end endtask



task congratulations; begin
    $display("********************************************************************");
    $display("                        \033[0;38;5;219mCongratulations!\033[m      ");
    $display("                 \033[0;38;5;219mYou have passed all patterns!\033[m");
    $display("                 \033[0;38;5;219mTotal time: %d \033[m",$time);
    $display("********************************************************************");
    image_.success;
	repeat(2) @(negedge clk);
    $finish;
end
endtask

endprogram