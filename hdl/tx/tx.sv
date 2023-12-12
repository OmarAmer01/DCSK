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

module tx (tx_if tx_if);

//! ============== Nets

//* ======= Chip/Bit Counter Signals
logic [9:0] bit_ctr;
logic [4:0] chip_ctr;
logic       chip_ctr_msb;
logic [9:0] wrap_around;
logic       en_bit_chip_ctr;

//* ======= Chaos Generator Signals
logic shift_chaos_bit;
logic chaos_bit;

//* ======= Chaos Generator Signals
logic load_msg;
logic shift_msg_bit;
logic msg_bit;

//! ============== FSM
tx_fsm U_tx_fsm (
    .i_clk             (tx_if.i_clk),
    .i_arst_n          (tx_if.i_arst_n),
    .i_send            (tx_if.i_send),
    .i_bit_ctr         (bit_ctr),
    .i_chip_ctr        (chip_ctr),
    .i_chip_ctr_msb    (chip_ctr_msb),
    .i_wrap_around     (wrap_around),
    .o_shift_chaos_bit (shift_chaos_bit),
    .o_shift_msg_bit   (shift_msg_bit),
    .o_load_msg        (load_msg),
    .o_en_bit_chip_ctr (en_bit_chip_ctr),
    .o_is_sending      (tx_if.o_is_sending)
);

//! ============== Chaos Generator
chaos_gen U_chaos_gen (
    .i_clk             (tx_if.i_clk),
    .i_arst_n          (tx_if.i_arst_n),
    .i_seed            (tx_if.i_seed),
    .i_load_seed       (tx_if.i_load_seed),
    .i_shift_chaos_bit (shift_chaos_bit),
    .o_chaos_bit       (chaos_bit)
);

//! ============== Chip/Bit Counter
chip_bit_ctr U_chip_bit_ctr (
    .i_clk            (tx_if.i_clk),
    .i_arst_n         (tx_if.i_arst_n),
    .i_en             (en_bit_chip_ctr),
    .i_sf             (intf.i_sf),
    .o_bit_index      (bit_ctr),
    .o_chip_index     (chip_ctr),
    .o_chip_index_msb (chip_ctr_msb),
    .o_wrap_around    (wrap_around)
);

//! ============== Message Buffer
piso #(32) U_msg_buffer(
    .i_clk    (tx_if.i_clk),
    .i_arst_n (tx_if.i_arst_n),
    .i_data   (tx_if.i_msg),
    .i_load   (load_msg),
    .i_shift  (shift_msg_bit),
    .o_empty  (/*!NC!*/),
    .o_bit    (msg_bit)
);

//! ============== Modulator
modulator U_modulator(
    .i_clk           (tx_if.i_clk),
    .i_arst_n        (tx_if.i_arst_n),
    .i_chaos_bit     (chaos_bit),
    .i_msg_bit       (msg_bit),
    .i_frame_half    (chip_ctr_msb),
    .i_sf            (tx_if.i_sf),
    .o_modulated_bit (tx_if.o_tx)
);

endmodule
