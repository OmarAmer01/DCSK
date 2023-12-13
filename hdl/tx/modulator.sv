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
module modulator (
    input  i_clk,
    input  i_arst_n,
    input  i_chaos_bit,
    input  i_msg_bit,
    input  i_frame_half, // First half  (0) => Chaos
                         // Second half (1) => Modulated Chaos

    input [1:0] i_sf,

    output logic o_modulated_bit

);

logic [15:0] chaos_sipo;
always_ff @(posedge i_clk, negedge i_arst_n) begin: SIPO
  if(~i_arst_n) chaos_sipo <= '0;
  else chaos_sipo <= {chaos_sipo[14:0], i_chaos_bit};
end

logic [3:0] delay_tap_location;

always_comb begin: get_delay_tap_location
  case (i_sf)
    SF4:     delay_tap_location = 4'd1;
    SF8:     delay_tap_location = 4'd3;
    SF16:     delay_tap_location = 4'd7;
    SF32:    delay_tap_location = 4'd15;
    default: delay_tap_location = 4'dx; //! Invalid Spreading Factor.
  endcase
end

logic delayed_chaos;
assign delayed_chaos = chaos_sipo[delay_tap_location];

logic modulated_chaos;
assign modulated_chaos = delayed_chaos ^ (~i_msg_bit);


always_comb begin: serializer
  o_modulated_bit = i_frame_half ? modulated_chaos : i_chaos_bit;
end

endmodule

