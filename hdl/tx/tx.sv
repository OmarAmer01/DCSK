/*
================================================================================
* TX Top Module

* Authors:
*    1. Omar Tarek Amer
*    2. Mostafa Darwish
*    3. Yahia Hatem
*    4. Menna Tullah Ahmed

* Date: 12/02/2023
=================================================================================
*/

module tx (
    tx_if tx_if
);


logic chaos_bits_depleted;
logic chaos_bit;
chaos_gen U_chaos_gen (
    .i_clk        (tx_if.i_clk),
    .i_arst_n     (tx_if.i_arst_n),
    .i_seed       (tx_if.i_seed),
    .i_load_seed  (tx_if.i_load_seed),
    .o_chaos_empty(chaos_bits_depleted),
    .o_chaos_bit  (chaos_bit)
);


logic [31:0] chip_idx;
chip_ctr U_chip_ctr(
    .i_clk              (tx_if.i_clk),
    .i_arst_n           (tx_if.i_arst_n),
    .i_chaos_empty      (chaos_bits_depleted),
    .i_send             (tx_if.i_send),
    .i_spreading_factor (tx_if.i_sf),
    .o_chip_index       (chip_idx)
);

logic modulator_ready;
logic modulated_bit;
modulator #(32) U_modulator(
    .i_clk   (tx_if.i_clk),
    .i_arst_n(tx_if.i_arst_n),
    .i_chaos_bit(chaos_bit),
    .i_spreading_factor(tx_if.i_sf),
    .i_msg(tx_if.i_msg),
    .i_load_msg(tx_if.i_send),
    .i_chip_idx_msb(chip_idx[31]),
    .o_ready_to_send(modulator_ready),
    .o_serial(tx_if.o_tx)
);

endmodule