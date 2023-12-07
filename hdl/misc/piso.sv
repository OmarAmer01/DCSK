/*
================================================================================
* Parallel In Serial Out Shift Register
* Authors: Omar Tarek Amer
* Date: 12/03/2023
=================================================================================
*/

module piso #(parameter WIDTH = 16) (
    input             i_clk,
    input             i_arst_n,
    input [WIDTH-1:0] i_data,
    input             i_load,
    input             i_shift,
    output            o_empty,
    output            o_bit
);

logic [WIDTH-1:0] buffer;
always_ff @(posedge i_clk or negedge i_arst_n) begin
    if (~i_arst_n) begin
        buffer <= '0;
    end else begin
        if (i_load) buffer <= i_data;
    end
end

logic [$clog2(WIDTH)-1:0] counter;
always_ff @(posedge i_clk or negedge i_arst_n) begin
    if (~i_arst_n) counter <= (2**WIDTH)-1;
    else begin
        if (i_load) counter <= '0;
        else
        if (i_shift) counter <= counter + 1;
    end
end

assign o_empty = counter == $clog2(WIDTH)'((2**WIDTH)-1);
assign o_bit = buffer[counter];

endmodule
