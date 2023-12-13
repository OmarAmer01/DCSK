/*
================================================================================
* Demodulator Top Module.
* This module reconstruct the information bits from the modulated chaos data.

* Authors: Mostafa Mahmoud Darwish

* Date: 12/08/2023
=================================================================================
*/
module Demod_Top
(
    input  logic        In_Mod_Data,
    input  logic        Clk,
    input  logic        N_Rst,
    input  logic        Valid,
    input  logic [1:0]  Spread_Factor_Sel,
    output logic [31:0] Out_Data,
    output logic        Valid_Data
);

logic [4:0] Spread_Factor;
logic [3:0] Var_Del_Reg_Addr;
logic       Var_Del_Reg_Re;
logic       Var_Del_Reg_Load;
logic       STP_Out_Reg_Load;
logic       STP_Out_Reg_Re;
logic [4:0] STP_Out_Reg_Addr;
logic       Correlated_Bit;
logic       Demod_Bit;

Demod_DP Demod
(
    .In_Mod_Data(In_Mod_Data),      
    .Spread_Factor_Sel(Spread_Factor_Sel),
    .N_Rst(N_Rst),
    .Clk(Clk),
    .Var_Del_Reg_Addr(Var_Del_Reg_Addr), 
    .Var_Del_Reg_Re(Var_Del_Reg_Re),   
    .Var_Del_Reg_Load(Var_Del_Reg_Load), 
    .STP_Out_Reg_Load(STP_Out_Reg_Load), 
    .STP_Out_Reg_Re(STP_Out_Reg_Re),   
    .STP_Out_Reg_Addr(STP_Out_Reg_Addr), 
    .Demod_Bit(Demod_Bit),
    .Spread_Factor(Spread_Factor),
    .Correlated_Bit(Correlated_Bit),   
    .Out_Data(Out_Data)           
);

FSM FSM
(
    .Valid(Valid),
    .Correlated_Bit(Correlated_Bit),
    .Spread_Factor(Spread_Factor),
    .Clk(Clk),
    .N_Rst(N_Rst),
    .Var_Del_Reg_Addr(Var_Del_Reg_Addr),
    .Var_Del_Reg_Re(Var_Del_Reg_Re),
    .Var_Del_Reg_Load(Var_Del_Reg_Load),
    .STP_Out_Reg_Load(STP_Out_Reg_Load),
    .STP_Out_Reg_Re(STP_Out_Reg_Re),
    .STP_Out_Reg_Addr(STP_Out_Reg_Addr),
    .Demod_Bit(Demod_Bit),
    .Valid_Data(Valid_Data)
);

endmodule