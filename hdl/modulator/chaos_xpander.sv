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
    input        [15:0]  i_chaos,
    output logic [255:0] o_xpanded_chaos
);



logic [15:0] [15:0] unshuffled_chaos;
logic [255:0] unpacked;
assign unpacked = unshuffled_chaos;
//! Modulate i_chaos with i_chaos.
always_comb begin : xpand_and_shuffle
    for (int i = 0; i < 16; i++) begin : gen_xpand
        unshuffled_chaos[i] = i_chaos[i] ? i_chaos : ~i_chaos;
    end

    for (int j = 0; j < 256; j++) begin : gen_shuffle
        o_xpanded_chaos[SHUFFLE_MATRIX[j]] = unpacked[j];
    end
end




endmodule
