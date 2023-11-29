/*
==============================================================
* Calculate Booth Partial Product

* This module takes three bits of the input
* multiplier and calculates the corresponding
* value of the multiplicand.

! The output is sign extended to a length = 2*WORD_LEN.

* Author: Omar Tarek Amer
* Date: 11/26/2023
==============================================================
*/

module calc_partial_product #(parameter WORD_LEN = 8) (
    input  [WORD_LEN-1:0]  i_multiplicand,
    input  [2:0]  i_opcode,
    output [(2*WORD_LEN)-1:0] o_result
);

/*
!   The radix 4 encoding is as follows:
    =======================================
       b+1   b   b-1       Recoded Value
    =======================================
        0    0    0            Zero
        0    0    1            One
        0    1    0            One
        0    1    1            Two
        1    0    0            -Two
        1    0    1            -One
        1    1    0            -One
        1    1    1            Zero
    =======================================

    * It can be seen that the b+1 bit controls the
    * sign of the encoded value.

    * Notice that the encoded values are mirrored
    * about the middle value. When the b+1 bit is
    * one, the mirroring starts. This can be used
    * to minimize the hardware from a 8-to-1 MUX
    * to a 4-to-1 MUX.
*/

logic [1:0] selector; // If the b+1 bit is HIGH then we are in the
                      // 2nd half of the table. This can be done
                      // by inverting the b and b-1 bits.

assign selector = {i_opcode[2], i_opcode[2]} ^ {i_opcode[1], i_opcode[0]};
//! XOR with a zero = buffer, with a one = inverter.

logic signed [(2*WORD_LEN)-1:0] result_sign, result_opposite_sign;
assign result_opposite_sign = 'd1 + ~result_sign;
always_comb begin : calc_product
    case (selector)
        2'b00:   result_sign   = '0;                     // Multiply by 0
        default: result_sign   =  (2*WORD_LEN)'(signed'(i_multiplicand));        // Multiply by 1 (Preserve Sign)
        2'b11:   result_sign   =  (2*WORD_LEN)'(signed'({i_multiplicand, 1'b0})); // Multiply by 2
    endcase
end

assign o_result = i_opcode[2] ? signed'(result_opposite_sign) : signed'(result_sign);

endmodule

