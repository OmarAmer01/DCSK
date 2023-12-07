/*
================================================================================
* Logistic Map.
* Generates 16-bits of chaos.

* Author: Omar Tarek Amer

* Date: 12/02/2023
=================================================================================
*/

module logistic_map(
    input         i_clk,
    input         i_arst_n,
    input         i_en,
    input  [7: 0] i_seed,
    input         i_load_seed,
    output [15:0] o_next_val
);

logic [15:0] mul_res;
logic [7:0] value, one_minus_value, fixed_value;

booth_mul #(.WORD_LEN(8)) U_booth_mul(
    .i_clk(i_clk),
    .i_arst_n(i_arst_n),
    .i_multiplier(one_minus_value),
    .i_multiplicand(fixed_value), // changes in port probs consume less power than the multiplier port.
    .o_result(mul_res)
);

logic [15:0] reg_mul_res;
always_ff @(posedge i_clk or negedge i_arst_n) begin : keep_old_output
    if (~i_arst_n) reg_mul_res <= '0;
    else reg_mul_res <= i_en ? mul_res : reg_mul_res;
end

localparam logic [7:0] ONE_Q0_8 = 8'hff;
assign one_minus_value = ONE_Q0_8 - fixed_value;

assign value = i_load_seed ? i_seed : o_next_val[15:8];

assign fixed_value = (value == 8'h00 || value == 8'hff) ? 8'haa : value;
assign o_next_val = reg_mul_res << 2; // Multiply by four.

endmodule
