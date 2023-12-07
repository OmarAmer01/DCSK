import spreading_factors_pkg::*;
module chip_ctr (
    input  logic        i_clk,
                        i_arst_n,
                        i_chaos_empty,
                        i_send,
           logic  [1:0] i_spreading_factor,
    output logic [31:0] o_chip_index

);

logic en;
assign en = i_chaos_empty & i_send;
logic [31:0] ctr_wrap_around_val;
always_comb begin: get_ctr_wrap_around_val
  case (i_spreading_factor)
    SF2:     ctr_wrap_around_val = 32'd3;
    SF4:     ctr_wrap_around_val = 32'd7;
    SF8:     ctr_wrap_around_val = 32'd15;
    SF16:    ctr_wrap_around_val = 32'd31;
    default: ctr_wrap_around_val = 'X;
  endcase
end

always_ff @(posedge i_clk, negedge i_arst_n) begin: count_chips
  if (~i_arst_n) o_chip_index <= '0;
  else o_chip_index <= o_chip_index == ctr_wrap_around_val ?
                                       '0 : o_chip_index + 32'(en);
end

endmodule
