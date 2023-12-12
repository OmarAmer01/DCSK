module Demod_TB();
localparam WORDLEN = 32;
logic              In_Mod_Data;
logic              Clk;
logic              N_Rst;
logic              Valid;
logic [1:0]        Spread_Factor_Sel;
logic [31:0]       Out_Data;
logic              Valid_Data;

//*reading files that model the received data and the true information bits that must be the result of our demodulator
//*then check if our demodulator output is the same as in these model files
logic [31:0] Input_Data_Seq_Beta_16 [0:319];
logic [15:0] Input_Data_Seq_Beta_8  [0:319];
logic [7:0]  Input_Data_Seq_Beta_4  [0:319];
logic [3:0]  Input_Data_Seq_Beta_2  [0:319];

logic [31:0] Information_Bits [0:9];

initial begin
    $readmemb("E:/AUC_projects/DCSK-main/DCSK-main/hdl/demodulator/Information_Data.txt",Information_Bits);

    $readmemb("E:/AUC_projects/DCSK-main/DCSK-main/hdl/demodulator/Input_Data_Beta_16.txt",Input_Data_Seq_Beta_16);
    $readmemb("E:/AUC_projects/DCSK-main/DCSK-main/hdl/demodulator/Input_Data_Beta_8.txt",Input_Data_Seq_Beta_8);
    $readmemb("E:/AUC_projects/DCSK-main/DCSK-main/hdl/demodulator/Input_Data_Beta_4.txt",Input_Data_Seq_Beta_4);
    $readmemb("E:/AUC_projects/DCSK-main/DCSK-main/hdl/demodulator/Input_Data_Beta_2.txt",Input_Data_Seq_Beta_2);
end

Demod_Top DUT
(
    .In_Mod_Data(In_Mod_Data),
    .Clk(Clk),
    .N_Rst(N_Rst),
    .Valid(Valid),
    .Spread_Factor_Sel(Spread_Factor_Sel),
    .Out_Data(Out_Data),
    .Valid_Data(Valid_Data)
);
//*controling the Input_Data according to the current spreading factor
integer j = 0; //?frame select variable
integer i = 0; //?bit select variable
always@(posedge Clk or negedge N_Rst) begin
    if(~N_Rst)
        In_Mod_Data <= 0;
    else if(Spread_Factor_Sel == 2'b00)begin
        In_Mod_Data <= Input_Data_Seq_Beta_2[j][i];
        i <= i+1;
        if(i == 3)begin
            i <= 0;
            j <= j+1;
        end
    end
    else if(Spread_Factor_Sel == 2'b01)begin
        In_Mod_Data <= Input_Data_Seq_Beta_4[j][i];
        i <= i+1;
        if(i == 7)begin
            i <= 0;
            j <= j+1;
        end
    end
    else if(Spread_Factor_Sel == 2'b10)begin
        In_Mod_Data <= Input_Data_Seq_Beta_8[j][i];
        i <= i+1;
        if(i == 15)begin
            i <= 0;
            j <= j+1;
        end
    end
    else if(Spread_Factor_Sel == 2'b11)begin
        In_Mod_Data <= Input_Data_Seq_Beta_16[j][i];
        i <= i+1;
        if(i == 31)begin
            i <= 0;
            j <= j+1;
        end
    end
end


//* Clock Generation block
initial begin
    Clk = 0;
    forever begin
        #1 Clk = ~Clk;
    end
end

//*Test Flow Control
initial begin
    N_Rst = 0;
    Valid = 0;
    Spread_Factor_Sel = 3;
    #10
    //*test that block will not take any of the input bits if Valid signal is zero
    N_Rst = 1;
    wait(j==WORDLEN);//?wait until second word
    //*test the normal sequence at spreading factor = 16
    Valid = 1;
    wait(j==2*WORDLEN)//?wait until third word
    //*test the normal sequence at spreading factor = 8
    Spread_Factor_Sel = 3;
    wait(j==3*WORDLEN)
    //*test the normal sequence at spreading factor = 4
    Spread_Factor_Sel = 1;
    wait(j==4*WORDLEN)
    //*test the normal sequence at spreading factor = 2
    Spread_Factor_Sel = 0;
    wait(j==5*WORDLEN);
    //*test that when valid goes to zero during the receiving operation it will stop and go to idle state
    wait(j==5*WORDLEN + 10);
    Valid = 0;
    Spread_Factor_Sel = 16;
    //*continue normal operation and check the results
    wait(j==6*WORDLEN)
    Valid = 1;
    wait(j==10*WORDLEN)
    $finish;
end

endmodule