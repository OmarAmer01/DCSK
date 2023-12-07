import spreading_factors_pkg::*;
module chaos_mod_mux(
    input [31:0] i_chip_idx,
    input  [1:0] i_spreading_factor,
    input        i_chaos_bit,
    input        i_mod_bit,
    output logic o_tx
);

logic msb;
logic [31:0] msb_idx;
assign msb = i_chip_idx[msb_idx];
assign o_tx = msb ? i_mod_bit : i_chaos_bit;

always_comb begin: calc_idx
    case (i_spreading_factor)
        SF2:  msb_idx = 32'(3);
        SF4:  msb_idx = 32'(7);
        SF8:  msb_idx = 32'(15);
        SF16: msb_idx = 32'(31);

        default: msb_idx = 'X;
    endcase
end

endmodule
