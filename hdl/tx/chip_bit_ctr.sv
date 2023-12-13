/*
================================================================================
* Chip Counter
* This module counts the indicies of the chips and bits sent.

* Authors:
*    1. Omar Tarek Amer
*    2. Menna Tullah Ahmed

* Date: 12/02/2023
=================================================================================
*/

import spreading_factors_pkg::*;
module chip_bit_ctr (
    input  logic       i_clk,
    input              i_arst_n,
    input              i_en,
    input        [1:0] i_sf,
    output logic [9:0] o_bit_index,
    output logic [4:0] o_chip_index,
    output logic       o_chip_index_msb,
    output logic [9:0] o_wrap_around
);

  logic wrap_around;
  always_comb begin : get_ctr_wrap_around_val
    case (i_sf)
      SF4:     o_wrap_around = 10'd127;
      SF8:     o_wrap_around = 10'd255;
      SF16:     o_wrap_around = 10'd511;
      SF32:    o_wrap_around = 10'd1023;
      default: o_wrap_around = 'X;
    endcase
  end


  always_ff @(posedge i_clk, negedge i_arst_n) begin : count_bits
    if (~i_arst_n) begin
      o_bit_index <= '0;
    end else begin
      o_bit_index <= o_bit_index == o_wrap_around ? '0 : o_bit_index + i_en;
    end
  end

  always_comb begin : count_chips
    case (i_sf)
      SF4:  o_chip_index = 5'(o_bit_index[1:0]);  //* From 0 => 3
      SF8:  o_chip_index = 5'(o_bit_index[2:0]);  //* From 0 => 7
      SF16:  o_chip_index = 5'(o_bit_index[3:0]);  //* From 0 => 15
      SF32: o_chip_index = 5'(o_bit_index[4:0]);  //* From 0 => 31

      default: o_chip_index = 'X;  //! Invalid Spreading Factor.
    endcase
  end

  always_comb begin : get_chip_idx_msb
    case (i_sf)
      SF4:  o_chip_index_msb = o_bit_index[1];  //* From 0 => 3
      SF8:  o_chip_index_msb = o_bit_index[2];  //* From 0 => 7
      SF16:  o_chip_index_msb = o_bit_index[3];  //* From 0 => 15
      SF32: o_chip_index_msb = o_bit_index[4];  //* From 0 => 31

      default: o_chip_index_msb = 'X;  //! Invalid Spreading Factor.
    endcase
  end

endmodule
