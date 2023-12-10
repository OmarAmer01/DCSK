/*
================================================================================
* TX Top Module Interface

* Authors:
*    1. Omar Tarek Amer
*    2. Yahia Hatem
*    3. Mostafa Darwish
*    4. Menna Tullah Ahmed

* Date: 12/02/2023
=================================================================================
*/

interface tx_if(input logic i_clk);

    logic        i_arst_n;

    logic [31:0] i_msg;
    logic        i_send;

    logic [7:0]  i_seed; // Chaos generator seed.
    logic        i_load_seed;

    logic [1:0]  i_sf; // Spreading Factor ID
    logic o_tx;

    logic is_sending;


    modport tx (
        input i_arst_n, i_clk, i_msg, i_seed, i_load_seed, i_sf, i_send,
        output o_tx
    );

    default clocking cb @(posedge i_clk);
        output i_arst_n, i_clk, i_msg, i_seed, i_load_seed, i_sf, i_send;
        input o_tx;
        input is_sending;
    endclocking

endinterface
