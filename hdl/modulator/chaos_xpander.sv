/*
=======================================
* Chaos Expander.
* Expands a 16-bit sequence into a
* 256-Bit sequence.

* Author: Omar Tarek Amer
* Date: 11/22/2023
=======================================
*/

import wire_shuffler_pkg::*;
module chaos_xpander (
    input  [15:0]  i_chaos,
    output [255:0] o_xpanded_chaos
);



logic [15:0] [15:0] xpanded_unshuffled;
logic [255:0] vector_xpanded;
assign vector_xpanded = xpanded_unshuffled;

//! Modulate i_chaos with i_chaos.
generate
    for (genvar i = 0; i < 15; i++) begin : gen_xpand
        assign xpanded_unshuffled[i] = i_chaos[i] ? i_chaos : ~i_chaos;
    end

    for (genvar j = 0; j < 255; j++) begin : gen_shuffle
        assign o_xpanded_chaos[wire_shuffler_pkg::SHUFFLE_MATRIX[j]] = vector_xpanded[j];
    end

endgenerate



endmodule
