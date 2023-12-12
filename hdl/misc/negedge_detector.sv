/*
================================================================================
* Falling Edge detector.
* This module generates a pulse whenever a negative edge was detected.

* Author: Omar Tarek Amer
* Date: 12/11/2023
=================================================================================
*/

module negedge_detector(
    input  i_clk,
    input  i_arst_n,
    input  i_signal,
    output negedge_detected
);

logic delayed_signal;
always_ff @(posedge i_clk, negedge i_arst_n) begin: delay_signal
    if (~i_arst_n) delayed_signal <= 1'b0;
    else delayed_signal <= i_signal;
end

assign negedge_detected = delayed_signal & ~i_signal;


endmodule
