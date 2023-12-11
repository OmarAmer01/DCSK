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
module modulator #(
    parameter MSG_WIDTH = 32
) (
    input                        i_clk,
    input                        i_arst_n,
    input                        i_en,
    input                        i_chaos_bit,
    input  logic [          1:0] i_spreading_factor,
    input  logic [MSG_WIDTH-1:0] i_msg,
    input                        i_load_msg,
    input                        i_chip_idx_msb,
    input                        i_is_sending,
    output                       o_ready_to_send,
    output                       o_serial
);

  logic msg_piso_empty;
  logic msg_piso_output_serial;

  logic chip_idx_pulse, chip_idx_msb_delayed;
  assign chip_idx_pulse = ~chip_idx_msb_delayed & i_chip_idx_msb;
  always_ff @(posedge i_clk or negedge i_arst_n) begin : level_to_pulse_conv
    if (~i_arst_n) chip_idx_msb_delayed <= 1'b0;
    else begin
      chip_idx_msb_delayed <= i_chip_idx_msb;
    end
  end

  logic delayed_msb;
  logic pulse_on_negedge_chip_idx_msb;
  assign pulse_on_negedge_chip_idx_msb = delayed_msb & ~i_chip_idx_msb;
  always_ff @(posedge i_clk or negedge i_arst_n) begin
    if (~i_arst_n) delayed_msb <= 1'b0;
    else delayed_msb <= i_chip_idx_msb;
  end

  logic disable_sending;
  always_ff @(posedge i_clk or negedge i_arst_n) begin
    if (~i_arst_n) disable_sending <= '0;
    else begin
      if (msg_piso_empty) disable_sending <= 1'b1;
      if (chip_idx_pulse) disable_sending <= 1'b0;
    end
  end

  logic delayed_is_sending;
  piso #(MSG_WIDTH) U_piso (
      .i_clk   (i_clk),
      .i_arst_n(i_arst_n),
      .i_data  (i_msg),
      .i_load  (i_load_msg),
      .i_shift (o_ready_to_send & pulse_on_negedge_chip_idx_msb & delayed_is_sending),
      .o_empty (msg_piso_empty),
      .o_bit   (msg_piso_output_serial)
  );

  logic [15:0] delay_buffer;
  always_ff @(posedge i_clk, negedge i_arst_n) begin : delay_by_spreading_factor
    if (~i_arst_n) delay_buffer <= '0;
    else delay_buffer <= {delay_buffer[14:0], i_chaos_bit};
  end

  always_ff @(posedge i_clk or negedge i_arst_n) begin
    if (~i_arst_n) begin
      delayed_is_sending <= '0;
    end else delayed_is_sending <= i_is_sending;
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
      SF2: delayed_bit = delay_by_2_tap;
      SF4: delayed_bit = delay_by_4_tap;
      SF8: delayed_bit = delay_by_8_tap;
      SF16: delayed_bit = delay_by_16_tap;
      default: delayed_bit = 'x;
    endcase
  end


  logic modulated_chaos;
  assign modulated_chaos = delayed_bit ^ (!msg_piso_output_serial);
  assign o_serial = i_chip_idx_msb ? modulated_chaos : i_chaos_bit;
  assign o_ready_to_send = ~msg_piso_empty;

endmodule
