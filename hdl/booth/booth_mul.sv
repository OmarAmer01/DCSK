/*
==============================================================
* Radix-4 Booth Multiplier

* Multiplies two numbers using the radix-4 booth algorithm.


* Author: Omar Tarek Amer
* Date: 11/27/2023
==============================================================
*/

module booth_mul #(parameter WORD_LEN = 8) (
    input                           i_clk, i_arst_n,
    input        [WORD_LEN-1:0]     i_multiplier,
    input        [WORD_LEN-1:0]     i_multiplicand,
    output logic [(2*WORD_LEN)-1:0] o_result
);

logic  [WORD_LEN-1:0]     reg_multiplier;
logic  [WORD_LEN-1:0]     reg_multiplicand;
logic  [(2*WORD_LEN)-1:0] result;

// always_ff @(posedge i_clk, negedge i_arst_n) begin : register_IOs
//     if(~i_arst_n) begin
//         reg_multiplier   <= '0;
//         reg_multiplicand <= '0;
//         o_reg_result     <= '0;

//     end else begin
//         reg_multiplier   <= i_multiplier;
//         reg_multiplicand <= i_multiplicand;
//         o_reg_result     <= result;
//     end
// end


genvar i;
logic [(2*WORD_LEN)-1:0] partial_products [WORD_LEN/2];
generate
    for (i = 0; i <(WORD_LEN/2); i++) begin : gen_partial_products
        calc_partial_product #(WORD_LEN) U_partial_product (
            .i_multiplicand(i_multiplicand),
            .i_opcode(
                {i_multiplier[(i*2)+1], //! MSB
                 i_multiplier[(i*2)],
                 i == 0 ? 1'b0 : i_multiplier[(i*2)-1]} //! LSB
            ),
            .o_result(partial_products[i])
        );
    end
endgenerate

// This is the critical path of the module.
// ! Use a better adder if frequency improvents are required.
always_comb begin : sum_partial_products
    result = '0;
    for (int i = 0; i < WORD_LEN/2; i++) begin
        result += partial_products[i] << (2*i);
    end
end

assign o_result = result;

endmodule
