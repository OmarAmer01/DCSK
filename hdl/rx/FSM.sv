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
    output logic       STP_Out_Reg_Load,
    output logic       STP_Out_Reg_Re,
    output logic [4:0] STP_Out_Reg_Addr,
    output logic       Demod_Bit,
    output logic       Valid_Data //? output signal that indicates that the output data has been demodulated successfully and ready to be read
);

logic       Var_Del_Reg_Addr_Inc;
logic       Var_Del_Reg_Addr_Clr;
logic       STP_Out_Reg_Addr_Inc;
logic       Ones_Count_Inc;
logic       Zeros_Count_Inc;
logic       Ones_Count_Clr;
logic       Zeros_Count_Clr;
logic [3:0] Ones_Count;
logic [3:0] Zeros_Count;

typedef enum logic [1:0] 
{ 
    Idle,
    Store_Chaos_Seq,
    Correlation,
    Store_Demod_Bit
}FSM;

FSM CS; //*MEALY FSM
FSM NS;

//*state transition
always@(posedge Clk or negedge N_Rst)begin
    if(~N_Rst)begin
        CS                   <= Idle;
        NS                   <= Idle;
        Var_Del_Reg_Load     <= 0;
        Var_Del_Reg_Re       <= 0;
        Var_Del_Reg_Addr_Inc <= 0;
        Var_Del_Reg_Addr_Clr <= 0;
        STP_Out_Reg_Load     <= 0;
        STP_Out_Reg_Re       <= 0;
        STP_Out_Reg_Addr_Inc <= 0;
        Ones_Count_Inc       <= 0;
        Zeros_Count_Inc      <= 0;
        Ones_Count_Clr       <= 0;
        Zeros_Count_Clr      <= 0;
        Demod_Bit            <= 0;
        Valid_Data           <= 0; 
    end
    else
        CS <= NS;
end
//*nest state logic
always@(*)begin
    case(CS)
        Idle:begin
            if(Valid)begin
                NS                   <= Store_Chaos_Seq;
                Var_Del_Reg_Load     <= 1;
                Var_Del_Reg_Re       <= 0;
                Var_Del_Reg_Addr_Inc <= 1;
                Var_Del_Reg_Addr_Clr <= 0;
                STP_Out_Reg_Load     <= 0;
                STP_Out_Reg_Re       <= 0;
                STP_Out_Reg_Addr_Inc <= 0;
                Ones_Count_Inc       <= 0;
                Zeros_Count_Inc      <= 0;
                Ones_Count_Clr       <= 0;
                Zeros_Count_Clr      <= 0;
                Demod_Bit            <= 0;
                Valid_Data           <= 0;         
            end
            else begin
                NS                   <= Idle;
                Var_Del_Reg_Load     <= 0;
                Var_Del_Reg_Re       <= 0;
                Var_Del_Reg_Addr_Inc <= 0;
                Var_Del_Reg_Addr_Clr <= 0;
                STP_Out_Reg_Load     <= 0;
                STP_Out_Reg_Re       <= 0;
                STP_Out_Reg_Addr_Inc <= 0;
                Ones_Count_Inc       <= 0;
                Zeros_Count_Inc      <= 0;
                Ones_Count_Clr       <= 0;
                Zeros_Count_Clr      <= 0;
                Demod_Bit            <= 0;
                Valid_Data           <= 0;
            end
        end
        Store_Chaos_Seq:begin
            if(~Valid)begin
                NS                   <= Idle;
                Var_Del_Reg_Load     <= 0;
                Var_Del_Reg_Re       <= 0;
                Var_Del_Reg_Addr_Inc <= 0;
                Var_Del_Reg_Addr_Clr <= 1;
                STP_Out_Reg_Load     <= 0;
                STP_Out_Reg_Re       <= 0;
                STP_Out_Reg_Addr_Inc <= 0;
                Ones_Count_Inc       <= 0;
                Zeros_Count_Inc      <= 0;
                Ones_Count_Clr       <= 0;
                Zeros_Count_Clr      <= 0;
                Demod_Bit            <= 0;
                Valid_Data           <= 0;
            end
            else if(Var_Del_Reg_Addr == Spread_Factor-1)begin
                NS                   <= Correlation;
                Var_Del_Reg_Load     <= 1;
                Var_Del_Reg_Re       <= 0;
                Var_Del_Reg_Addr_Inc <= 0;
                Var_Del_Reg_Addr_Clr <= 1;
                STP_Out_Reg_Load     <= 0;
                STP_Out_Reg_Re       <= 0;
                STP_Out_Reg_Addr_Inc <= 0;
                Ones_Count_Inc       <= 0;
                Zeros_Count_Inc      <= 0;
                Ones_Count_Clr       <= 0;
                Zeros_Count_Clr      <= 0;
                Demod_Bit            <= 0;
                Valid_Data           <= 0;
            end
            else begin
                NS                   <= Store_Chaos_Seq;
                Var_Del_Reg_Load     <= 1;
                Var_Del_Reg_Re       <= 0;
                Var_Del_Reg_Addr_Inc <= 1;
                Var_Del_Reg_Addr_Clr <= 0;
                STP_Out_Reg_Load     <= 0;
                STP_Out_Reg_Re       <= 0;
                STP_Out_Reg_Addr_Inc <= 0;
                Ones_Count_Inc       <= 0;
                Zeros_Count_Inc      <= 0;
                Ones_Count_Clr       <= 0;
                Zeros_Count_Clr      <= 0;
                Demod_Bit            <= 0;
                Valid_Data           <= 0;
            end

        end
        Correlation:begin
            if(Var_Del_Reg_Addr == Spread_Factor-1)begin
                NS                   <= Store_Demod_Bit;
                Var_Del_Reg_Load     <= 1;
                Var_Del_Reg_Re       <= 0;
                Var_Del_Reg_Addr_Inc <= 0;
                Var_Del_Reg_Addr_Clr <= 1;
                STP_Out_Reg_Load     <= 1;
                STP_Out_Reg_Re       <= 0;
                STP_Out_Reg_Addr_Inc <= 1;
                Ones_Count_Inc       <= 0;
                Zeros_Count_Inc      <= 0;
                Ones_Count_Clr       <= 1;
                Zeros_Count_Clr      <= 1;
                Valid_Data           <= 0;
                if(Ones_Count > Zeros_Count)
                    Demod_Bit        <= 1;
                else
                    Demod_Bit        <= 0;   
            end
            else begin
                NS                   <= Correlation;
                Var_Del_Reg_Load     <= 1;
                Var_Del_Reg_Re       <= 1;
                Var_Del_Reg_Addr_Inc <= 1;
                Var_Del_Reg_Addr_Clr <= 0;
                STP_Out_Reg_Load     <= 0;
                STP_Out_Reg_Re       <= 0;
                STP_Out_Reg_Addr_Inc <= 0;
                if(Correlated_Bit)begin
                    Ones_Count_Inc   <= 1;
                    Zeros_Count_Inc  <= 0;
                end
                else begin
                    Ones_Count_Inc   <= 0;
                    Zeros_Count_Inc  <= 1;
                end
                Ones_Count_Clr       <= 0;
                Zeros_Count_Clr      <= 0;
                Demod_Bit            <= 0;
                Valid_Data           <= 0;
            end
        end
        Store_Demod_Bit:begin
                if(Valid)begin
                    NS                   <= Store_Chaos_Seq;
                    Var_Del_Reg_Load     <= 1;
                    Var_Del_Reg_Re       <= 0;
                    Var_Del_Reg_Addr_Inc <= 1;
                    Var_Del_Reg_Addr_Clr <= 0;
                    STP_Out_Reg_Load     <= 0;
                    STP_Out_Reg_Addr_Inc <= 0;
                    Ones_Count_Inc       <= 0;
                    Zeros_Count_Inc      <= 0;
                    Ones_Count_Clr       <= 0;
                    Zeros_Count_Clr      <= 0;
                    Demod_Bit            <= 0;
                    if(STP_Out_Reg_Addr == 0)begin
                        STP_Out_Reg_Re   <= 1;
                        Valid_Data       <= 1;
                    end
                    else begin
                        STP_Out_Reg_Re   <= 0;
                        Valid_Data       <= 0;
                    end
                end
                else begin
                    NS                   <= Idle;
                    Var_Del_Reg_Load     <= 0;
                    Var_Del_Reg_Re       <= 0;
                    Var_Del_Reg_Addr_Inc <= 0;
                    Var_Del_Reg_Addr_Clr <= 1;
                    STP_Out_Reg_Load     <= 0;
                    STP_Out_Reg_Addr_Inc <= 0;
                    Ones_Count_Inc       <= 0;
                    Zeros_Count_Inc      <= 0;
                    Ones_Count_Clr       <= 0;
                    Zeros_Count_Clr      <= 0;
                    Demod_Bit            <= 0;
                    if(STP_Out_Reg_Addr == 0)begin
                        STP_Out_Reg_Re   <= 1;
                        Valid_Data       <= 1;
                    end
                    else begin
                        STP_Out_Reg_Re   <= 0;
                        Valid_Data       <= 0;
                    end
                end
        end
    endcase
end


//*input register address counter
always@(posedge Clk or negedge N_Rst)begin
    if(~N_Rst)begin
        Var_Del_Reg_Addr <= 0;
    end
    else if(Var_Del_Reg_Addr_Clr)begin
        Var_Del_Reg_Addr <= 0;
    end
    else if(Var_Del_Reg_Addr_Inc)begin
        Var_Del_Reg_Addr <= Var_Del_Reg_Addr + 1'b1;
    end
end

//*serial to parallel output register address counter
always@(posedge Clk or negedge N_Rst)begin
    if(~N_Rst)begin
        STP_Out_Reg_Addr <= 0;
    end
    else if(STP_Out_Reg_Addr_Inc)begin
        STP_Out_Reg_Addr <= STP_Out_Reg_Addr + 1'b1;
    end
end

//*ones counter
always@(posedge Clk or negedge N_Rst)begin
    if(~N_Rst)begin
        Ones_Count <= 0;
    end
    else if(Ones_Count_Clr)begin
        Ones_Count <= 0;
    end
    else if(Ones_Count_Inc)begin
        Ones_Count <= Ones_Count + 1'b1;
    end
end

//*zeros counter
always@(posedge Clk or negedge N_Rst)begin
    if(~N_Rst)begin
        Zeros_Count <= 0;
    end
    else if(Zeros_Count_Clr)begin
        Zeros_Count <= 0;
    end
    else if(Zeros_Count_Inc)begin
        Zeros_Count <= Zeros_Count + 1'b1;
    end
end


endmodule