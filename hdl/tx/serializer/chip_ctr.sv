import spreading_factors_pkg::*;
module chip_ctr (
    input  logic       i_clk,
    input              i_arst_n,
    input              i_chaos_empty,
    input              i_send,
    input  logic [1:0] i_spreading_factor,
    output logic       o_sending,
    output logic       o_load_bit,
    output logic [4:0] o_chip_index,
    output logic       o_msb

);

  logic en;

  always_ff @(posedge i_clk, negedge i_arst_n) begin : enable_ctr_logic
    if (~i_arst_n) en <= 1'b0;
    else begin
      if (i_send | ~i_chaos_empty) en <= 1'b1;
      else if (i_chaos_empty) en <= 1'b0;
    end
  end

  logic [4:0] chip_ctr_wrap_around_val;
  logic [9:0] bit_ctr_wrap_around_val;

  always_comb begin : get_ctr_wrap_around_vals
    case (i_spreading_factor)
      SF2: begin
        chip_ctr_wrap_around_val = 5'd3;
        bit_ctr_wrap_around_val  = 10'd127;
      end
      SF4: begin
        chip_ctr_wrap_around_val = 5'd7;
        bit_ctr_wrap_around_val  = 10'd255;
      end
      SF8: begin
        chip_ctr_wrap_around_val = 5'd15;
        bit_ctr_wrap_around_val  = 10'd511;
      end
      SF16: begin
        chip_ctr_wrap_around_val = 5'd31;
        bit_ctr_wrap_around_val  = 10'd1023;
      end
      default: begin
        chip_ctr_wrap_around_val = 'X;
        bit_ctr_wrap_around_val  = 'X;
      end
    endcase
  end

  assign o_load_bit = o_chip_index == chip_ctr_wrap_around_val;  // No delay.


  always_comb begin : chip_idx_msb_selector
    case (i_spreading_factor)
      SF2:  o_msb = o_chip_index[1];
      SF4:  o_msb = o_chip_index[2];
      SF8:  o_msb = o_chip_index[3];
      SF16: o_msb = o_chip_index[4];

      default: o_msb = 'x;
    endcase
  end

  always_ff @(posedge i_clk, negedge i_arst_n) begin : count_chips
    if (~i_arst_n) o_chip_index <= '0;
    else
      o_chip_index <= i_send | (o_chip_index == chip_ctr_wrap_around_val) ? '0 : o_chip_index + 5'(en);
  end



  logic [9:0] bit_index;
  always_ff @(posedge i_clk, negedge i_arst_n) begin : sending_status_logic
    if (~i_arst_n) o_sending <= '0;
    else if (i_send) o_sending <= 1'b1;
    else if ((bit_index == bit_ctr_wrap_around_val)) o_sending <= 1'b0;
  end

  //assign o_sending = i_send | bit_index != '0;

  always_ff @(posedge i_clk, negedge i_arst_n) begin : count_bits
    if (~i_arst_n) bit_index <= '0;
    else begin
      bit_index <= (bit_index == bit_ctr_wrap_around_val) ? '0 : bit_index + o_sending;
    end
  end

  // always_ff @(posedge i_clk or negedge i_arst_n) begin : count_bits
  //   if (~i_arst_n) bit_index <= '0;
  //   else begin
  //     if (bit_index == bit_ctr_wrap_around_val) bit_index <= '0;
  //     else begin
  //       bit_index <= bit_index + (o_chip_index == chip_ctr_wrap_around_val);
  //     end
  //   end





endmodule
