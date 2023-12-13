/*
================================================================================
* Ring Oscillator
* Captures entropy from phase noise.

* Author: Omar Tarek Amer
* Date: 12/13/2023
=================================================================================
*/

module ring_oscillator #(
    parameter int NO_INVERTERS = 5
) (
    input  i_clk,
    input  i_arst_n,
    input  i_en,
    output o_rand_bit
);

  logic [NO_INVERTERS-1:0] latch_arr, enable_serial;
  assign o_rand_bit = latch_arr[NO_INVERTERS-1];


  always_latch begin : inverting_latches
    for (int i = 0; i < NO_INVERTERS-1; i++) begin
      if (enable_serial[i]) latch_arr[i] = ~latch_arr[i+1];
    end

    if (enable_serial[NO_INVERTERS-1]) latch_arr[NO_INVERTERS-1] = ~latch_arr[0];

  end


  always_ff @(posedge i_clk or negedge i_arst_n) begin
    if (~i_arst_n) enable_serial <= '0;
    else enable_serial <= {enable_serial[NO_INVERTERS-2:0], i_en};
  end

endmodule
