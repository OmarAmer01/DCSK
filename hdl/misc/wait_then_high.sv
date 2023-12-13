/*
================================================================================
* Signal Tap Trigger.
* Author: Omar Tarek Amer
* Date: 12/13/2023
=================================================================================
*/

module st_trigger #(parameter WRAP = 100000000)(
    input i_clk,
    input i_arst_n,
    output logic o_out
);

logic [26:0] ctr;


always_ff @( posedge i_clk, negedge i_arst_n ) begin
    if(~i_arst_n) ctr <= '0;
    else ctr <= (ctr == WRAP) ? '0 : ctr + 1;
end

always_ff @(posedge i_clk, negedge i_arst_n)
    if(~i_arst_n) o_out <= 1'b0;
    else begin
        if (ctr == WRAP) o_out <= 1'b1; // Stay at HIGH
    end

endmodule
