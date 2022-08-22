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


//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   2020 ICLAB Fall Course
//   Lab09      : HF
//   Author     : Lien-Feng Hsu
//                
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : Usertype_PKG.sv
//   Module Name : usertype
//   Release version : v1.0 (Release Date: May-2020)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

`ifndef USERTYPE
`define USERTYPE

package usertype;

typedef enum logic  [3:0] { No_action  = 4'd0 ,
                            Seed       = 4'd1 ,
							Water      = 4'd3 ,
						    Reap       = 4'd2 , 
							Steal      = 4'd4 ,
							Check_dep  = 4'd8  
							}  Action ;
							
typedef enum logic  [3:0] { No_Err       = 4'd0 ,
                            Is_Empty     = 4'd1 ,
							Not_Empty    = 4'd2 ,
							Has_Grown    = 4'd3 ,
						    Not_Grown    = 4'd4 
							}  Error_Msg ;

typedef enum logic  [3:0] { No_cat		 = 4'd0 ,
							Potato	     = 4'd1 ,
                            Corn	     = 4'd2 , 
							Tomato       = 4'd4 ,
						    Wheat        = 4'd8   
							}  Crop_cat ;
							
typedef enum logic  [3:0] { No_sta       = 4'd1 ,
							Zer_sta      = 4'd2 ,
							Fst_sta	     = 4'd4 ,
                            Snd_sta	     = 4'd8
							}  Crop_sta ;

typedef logic [7:0]  Land;
typedef logic [15:0] Water_amnt;

typedef struct packed {
	Land  land_id, land_status;
	Water_amnt water_amnt; 
} Land_Info; 

typedef union packed{ 
    Action       [3:0]d_act;
	Land         [1:0]d_id;
	Crop_cat     [3:0]d_cat;
	Water_amnt        d_amnt;
} DATA;

//################################################## Don't revise code above
typedef enum logic [2:0] {IDLE,IN,BRIDGE_READ_M,BRIDGE_READ,COMPUTE,BRIDGE_WRITE,OUT} state_f;
typedef enum logic [2:0] {START,DRAM_R_ADD,DRAM_R_DATA,DRAM_W_ADD,DRAM_W_DATA} state_b;
endpackage

import usertype::*; //import usertype into $unit

`endif

