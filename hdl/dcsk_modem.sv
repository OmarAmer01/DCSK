/*
================================================================================
* DCSK Modem. The RX and TX Top modules.

* Authors:
*    1. Omar Tarek Amer
*    2. Mostafa Darwish
*    3. Yahia Hatem
*    4. Menna Tullah Ahmed

* Date: 12/14/2023
=================================================================================
*/

module dcsk_modem(
    tx_if         tx_if,
    input         In_Mod_Data,
    input         Clk,
    input         N_Rst,
    input         Valid,
    input  [1:0]  Spread_Factor_Sel,
    inout  [31:0] Out_Data,
    output        Valid_Data
);

tx        U_TX(.*);
Demod_Top U_RX (.*);

endmodule
