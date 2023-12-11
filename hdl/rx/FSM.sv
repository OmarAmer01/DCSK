/*
================================================================================
* FSM Module.
* This module controls the demodulation process by changing the control signals in the design.

* Authors: Mostafa Mahmoud Darwish

* Date: 12/08/2023
=================================================================================
*/
module FSM
(
    input  logic       Valid, //? Valid signal that make the demodulator to start demodulation
    input  logic       Correlated_Bit,
    input  logic [4:0] Spread_Factor,
    input  logic       Clk,
    input  logic       N_Rst,
    output logic [3:0] Var_Del_Reg_Addr,
    output logic       Var_Del_Reg_Re,
    output logic       Var_Del_Reg_Load,
    output logic       Ones_Count_Inc,
    output logic       Zeros_Count_Inc,
    output logic       Ones_Zeros_Count_Clr,
    output logic       STP_Out_Reg_Load,
    output logic       STP_Out_Reg_Re,
    output logic [4:0] STP_Out_Reg_Addr,
    output logic       Valid_Data //? output signal that indicates that the output data has been demodulated successfully and ready to be read
);
typedef enum logic [1:0] 
{ 
    Idle,
    Store_Chaos_Seq,
    Correlation,
    Store_Demod_Bit
}FSM;

FSM State; //*Mealy FSM

//?==================== FSM in single always block statment ====================
always@(posedge Clk or negedge N_Rst)begin
    if(~N_Rst)begin
        State <= Idle;
        Var_Del_Reg_Addr     <= 0;
        Var_Del_Reg_Re       <= 0;
        Var_Del_Reg_Load     <= 0;
        Ones_Count_Inc       <= 0;
        Zeros_Count_Inc      <= 0;
        Ones_Zeros_Count_Clr <= 0;
        STP_Out_Reg_Load     <= 0;
        STP_Out_Reg_Re       <= 0;
        STP_Out_Reg_Addr     <= 0;
    end
    else begin
        case(State)
            Idle:begin
                if(Valid)begin
                    State            <= Store_Chaos_Seq;
                    Var_Del_Reg_Load <= 1;
                    Valid_Data       <= 0;
                end
            end
            Store_Chaos_Seq:begin
                if(~Valid)begin
                    State <= Idle;
                    Var_Del_Reg_Addr <= 0;
                    Var_Del_Reg_Load <= 0;
                    Valid_Data       <= 0;
                end
                else begin
                    Var_Del_Reg_Addr <= Var_Del_Reg_Addr + 1'b1;
                    if(Var_Del_Reg_Addr == Spread_Factor-1)begin
                        State               <= Correlation;
                        Var_Del_Reg_Addr    <= 0;
                        Var_Del_Reg_Re      <= 1;
                        Var_Del_Reg_Load    <= 0;
                        if(Correlated_Bit)begin
                            Ones_Count_Inc  <= 1;
                            Zeros_Count_Inc <= 0;  
                        end
                        else begin
                            Ones_Count_Inc  <= 0;
                            Zeros_Count_Inc <= 1;
                        end
                    end
                end
            end
            Correlation:begin
                Var_Del_Reg_Addr <= Var_Del_Reg_Addr + 1'b1;
                if(Var_Del_Reg_Addr == Spread_Factor-1)begin
                    State                <= Store_Demod_Bit;
                    Var_Del_Reg_Addr     <= 0;
                    Var_Del_Reg_Re       <= 0;
                    Var_Del_Reg_Load     <= 1'b1;
                    Ones_Count_Inc       <= 0;
                    Zeros_Count_Inc      <= 0;
                    Ones_Zeros_Count_Clr <= 1'b1;
                    STP_Out_Reg_Load     <= 1'b1;
                end
                else if(~Valid)begin
                    State <= Idle;
                    Var_Del_Reg_Addr <= 0;
                    Var_Del_Reg_Re   <= 0;
                    Ones_Count_Inc   <= 0;
                    Zeros_Count_Inc  <= 0;
                end
                else if(Correlated_Bit)begin
                    Ones_Count_Inc  <= 1;
                    Zeros_Count_Inc <= 0;  
                end
                else begin
                    Ones_Count_Inc  <= 0;
                    Zeros_Count_Inc <= 1;
                end
            end
            Store_Demod_Bit:begin
                Var_Del_Reg_Addr <= Var_Del_Reg_Addr + 1'b1;
                STP_Out_Reg_Addr <= STP_Out_Reg_Addr + 1'b1;
                if(STP_Out_Reg_Addr == 31)begin
                    STP_Out_Reg_Re <= 1'b1;
                    Valid_Data     <= 1;
                end
                if(~Valid)begin
                    State                <= Idle;
                    Var_Del_Reg_Addr     <= 0;
                    Var_Del_Reg_Load     <= 0;
                    Ones_Zeros_Count_Clr <= 0;
                    STP_Out_Reg_Load     <= 0;
                    STP_Out_Reg_Addr     <= 0;
                end
                else begin
                    State                <= Store_Chaos_Seq;
                    Ones_Zeros_Count_Clr <= 0;
                    STP_Out_Reg_Load     <= 0;
                end
            end
        endcase 
    end
end

endmodule