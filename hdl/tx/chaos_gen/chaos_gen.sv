/*
================================================================================
* Chaos Generator Top Module
* Generates 256 Bits of chaos.

* Authors: Omar Tarek Amer

* Date: 12/02/2023
=================================================================================
*/

module chaos_gen (
    input       i_clk,
    input       i_arst_n,
    input       i_en,
    input [7:0] i_seed,
    input       i_load_seed,
    input       i_chip_idx_msb,
    output      o_chaos_empty,
    output      o_chaos_bit
);

logic [15:0] lmap_out;
logic piso_empty;
logistic_map U_logistic_map (
    .i_clk(i_clk),
    .i_arst_n(i_arst_n),
    .i_en(i_en & (piso_empty | i_load_seed)),
    .i_seed(i_seed),
    .i_load_seed(i_load_seed),
    .o_next_val(lmap_out)
);

logic [255:0] xpanded_chaos;
chaos_xpander U_chaos_xpander(
    .i_chaos(lmap_out),
    .o_xpanded_chaos(xpanded_chaos)
);

logic load_piso;
piso #(.WIDTH(256)) U_chaos_piso (
    .i_clk(i_clk),
    .i_arst_n(i_arst_n),
    .i_data(xpanded_chaos),
    .i_load(load_piso),
    .i_shift(~i_chip_idx_msb &~load_piso),
    //.i_shift(~load_piso),
    .o_empty(piso_empty),
    .o_bit(o_chaos_bit)
);

assign o_chaos_empty = piso_empty;

always_ff @(posedge i_clk, negedge i_arst_n) begin: delay_piso_load
    if (~i_arst_n) load_piso <= 0;
    else load_piso <= piso_empty & i_en;
end

endmodule
