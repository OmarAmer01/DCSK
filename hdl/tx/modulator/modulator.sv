/*
================================================================================
* Modulator Top Module.
* This module serialls modulates a message with a chaos bit.

* Authors: Omar Tarek Amer
*          Yahia Ahmed Hatem

* Date: 12/07/2023
=================================================================================
*/
import spreading_factors_pkg::*;
module modulator #(parameter MSG_WIDTH = 32) (
    input                       i_clk,
    input                       i_arst_n,
    input                       i_chaos_bit,
    input logic [1:0]           i_spreading_factor,
    input logic [MSG_WIDTH-1:0] i_msg,
    input                       i_load_msg,
    input                       i_chip_idx_msb,
    output                      o_ready_to_send,
    output                      o_serial
);

logic msg_piso_empty;
logic msg_piso_output_serial;

piso #(MSG_WIDTH) U_piso(
    .i_clk    (i_clk),
    .i_arst_n (i_arst_n),
    .i_data   (i_msg),
    .i_load   (i_load_msg),
    .i_shift  (i_chip_idx_msb & o_ready_to_send),
    .o_empty  (msg_piso_empty),
    .o_bit    (msg_piso_output_serial)
);

logic [15:0] delay_buffer;
always_ff @(posedge i_clk, negedge i_arst_n) begin: delay_by_spreading_factor
    if (~i_arst_n) delay_buffer <= '0;
    else delay_buffer <= {msg_piso_output_serial, delay_buffer[14:0]};
end

// Taps into the delay buffer, to select the delays:

logic delay_by_2_tap, delay_by_4_tap, delay_by_8_tap, delay_by_16_tap;
logic delayed_bit;


assign delay_by_2_tap  = delay_buffer[1];
assign delay_by_4_tap  = delay_buffer[3];
assign delay_by_8_tap  = delay_buffer[7];
assign delay_by_16_tap = delay_buffer[15];

always_comb begin : delay_selector
    case (i_spreading_factor)
        SF2:  delayed_bit = delay_by_2_tap;
        SF4:  delayed_bit = delay_by_4_tap;
        SF8:  delayed_bit = delay_by_8_tap;
        SF16: delayed_bit = delay_by_16_tap;

        default: delayed_bit = 'x;
    endcase
end

assign o_serial = delayed_bit ^ msg_piso_output_serial;
assign o_ready_to_send = ~msg_piso_empty;

endmodule
