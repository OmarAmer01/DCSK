/*
================================================================================
* Demodulator data path Module.

* Authors: Mostafa Mahmoud Darwish

* Date: 12/08/2023
=================================================================================
*/
module Demod_DP
(
    input  logic        In_Mod_Data,      //? input modulated data
    input  logic [1:0]  Spread_Factor_Sel,
    input  logic        N_Rst,
    input  logic        Clk,
    input  logic [3:0]  Var_Del_Reg_Addr, //? number of a certain bit in the input register
    input  logic        Var_Del_Reg_Re,   //? read enable signal to the register
    input  logic        Var_Del_Reg_Load, //? load signal to the input register
    input  logic        Ones_Count_Inc,   //? register that stores the number of ones came from the correlator
    input  logic        Zeros_Count_Inc,  //? register that stores the number of zeros came from the correlator, then we will use a comparator to decide if the input bit was zero or one
    input  logic        Ones_Zeros_Count_Clr, //? used to clear the two accumlators after frame has been demodulated to be ready to deal with a new frame
    input  logic        STP_Out_Reg_Load, //? Serial to parallel output register load signal
    input  logic        STP_Out_Reg_Re,   //? Serial to parallel output register read enable signal
    input  logic [4:0]  STP_Out_Reg_Addr, //? Serial to parallel output register bit number that we will write current bit in
    output logic [4:0]  Spread_Factor,
    output logic        Correlated_Bit,   //? send this bit to FSM to send a control signal to the accumelator of ones or zeros
    output logic [31:0] Out_Data          //? Output demodulated data can be (2,4,8,16)bits according to the spread factor 
);

logic        Var_Del_Reg_Out_Data;
logic [15:0] Var_Del_Reg;
logic [4:0]  Ones_Count;
logic [4:0]  Zeros_Count;
logic        Demod_Bit;
logic [31:0] STP_Out_Reg;

//?================= Spread Factor select and send it to FSM =================
always@(*)begin
    case(Spread_Factor_Sel)
        2'b00: Spread_Factor = 2;
        2'b01: Spread_Factor = 4;
        2'b10: Spread_Factor = 8;
        2'b11: Spread_Factor = 16;
    endcase
end
//?========================== Variable Delay Register ==========================
always@(posedge Clk or negedge N_Rst)begin
    if(~N_Rst) 
        Var_Del_Reg <= 0;
    else if(Var_Del_Reg_Load) 
        Var_Del_Reg[Var_Del_Reg_Addr] <= In_Mod_Data; 
end
assign Var_Del_Reg_Out_Data = Var_Del_Reg_Re ? Var_Del_Reg[Var_Del_Reg_Addr] : 1'b0;

//?================================= Correlator =================================
always @(posedge Clk or negedge N_Rst) begin
    if(~N_Rst)begin
        Ones_Count  <= 0;
        Zeros_Count <= 0;
    end
    else if(Ones_Zeros_Count_Clr)begin
        Ones_Count  <= 0;
        Zeros_Count <= 0;
    end
    else if(Ones_Count_Inc)
        Ones_Count <= Ones_Count + 1'b1;
    else if(Zeros_Count_Inc)
        Zeros_Count <= Zeros_Count + 1'b1;
end
assign Correlated_Bit = ~(Var_Del_Reg_Out_Data ^ In_Mod_Data);
assign Demod_Bit = (Ones_Count > Zeros_Count) ? 1'b1 : 1'b0;

//?====================== Serial To Parallel Output Register =====================
always@(posedge Clk or negedge N_Rst)begin
    if(~N_Rst)
        STP_Out_Reg <= 0;
    else if(STP_Out_Reg_Load)
        STP_Out_Reg[STP_Out_Reg_Addr] <= Demod_Bit;
end
assign Out_Data = STP_Out_Reg_Re ? STP_Out_Reg : 32'b0;

endmodule