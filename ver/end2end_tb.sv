/*
================================================================================
* End-to-End Testbench
* Authors:
*    1. Omar Tarek Amer
*    2. Moustafa Darwish

* Date: 12/08/2023
* Command:
vsim end2end_tb -debugDB=+ACC -do "./ver/end_to_end.do" -msgmode both -displaymsgmode both
=================================================================================
*/

`timescale 1ns / 100ps

import modem_pkg::*;
import spreading_factors_pkg::*;

module end2end_tb;

  //! Clock
  logic i_clk;
  localparam int PERIOD = 100;
  always #(PERIOD / 2) i_clk = ~i_clk;


  localparam TEST_ITERATIONS = 10000;


  //! Variable declarations
  logic [31:0] msg_to_send, expected;
  sf_t spreading_factors[4] = {SF4, SF8, SF16, SF32};
  int sf_report[4] = {0, 0, 0, 0};
  int silence_report = 0;
  int sf;  // Spreading Factor
  logic [31:0] tx[$];
  int pass_count = 0;
  int silence_len;

  logic [31:0] word_recv;
  logic word_recv_valid;

  //! UUTs
  tx_if intf (i_clk);
  tx UUT_TX (intf.tx);

  Demod_Top UUT_RX (
      .Clk(i_clk),
      .N_Rst(intf.i_arst_n),
      .In_Mod_Data(intf.o_tx),
      .Valid(intf.o_is_sending),
      .Spread_Factor_Sel(intf.i_sf),
      .Out_Data(word_recv),
      .Valid_Data(word_recv_valid)
  );


  //! Utility functions
  modem modem = new(intf);


  initial begin : sender_loop

    //* Init signals
    i_clk = 0;
    intf.i_arst_n = 1;
    intf.i_seed = '0;
    intf.i_load_seed = '0;
    intf.i_send = '0;
    intf.i_msg = '0;
    intf.i_sf = '0;

    //* Reset
    @(intf.cb) intf.cb.i_arst_n <= 0;
    @(intf.cb) intf.cb.i_arst_n <= 1;

    //* Load Seed
    @(intf.cb) intf.cb.i_seed <= $urandom();
    @(intf.cb) intf.cb.i_load_seed <= 1;
    @(intf.cb) intf.cb.i_load_seed <= 0;

    for (int i = 0; i < TEST_ITERATIONS; i++) begin
      msg_to_send = $urandom();
      tx.push_back(msg_to_send);

      sf = $urandom_range(3, 0);
      modem.send_msg(msg_to_send, spreading_factors[sf]);
      sf_report[sf]++;

      /*
        Add random periods of silence to
        simulate communication in bursts.
      */

      // 20% chance of a burst ending.
      if ($urandom_range(4, 0) == 0) begin : random_silence
        silence_len = $urandom_range(9, 1);
        repeat (silence_len) @(intf.cb);
        $display("End of Burst. Silence for %0d Cycles.", silence_len);
        silence_report++;
      end

    end

    @(intf.cb);
    @(intf.cb);
    @(intf.cb);

    $display("============= Statistics =============");
    $display("[Total Tests]  %0d", TEST_ITERATIONS);
    $display("[Tests PASSED] %0d", pass_count);
    $display("[Tests FAILED] %0d\n", TEST_ITERATIONS - pass_count);
    $display("          *** Tests Ran ***");
    $display("Number of Messages Sent with SF4:  %0d", sf_report[0]);
    $display("Number of Messages Sent with SF8:  %0d", sf_report[1]);
    $display("Number of Messages Sent with SF16: %0d", sf_report[2]);
    $display("Number of Messages Sent with SF32: %0d", sf_report[3]);
    $display("          *** Number of Bursts ***");
    $display("[Bursts] %0d", silence_report);
    $display("======================================\n");
    $finish();

  end

  always @(posedge word_recv_valid) begin: monitor_loop
    expected = tx.pop_front();
    assert (word_recv == expected) begin
      $display("[PASS] Msg-ID%0d", modem.msg_id-1);
      pass_count++;
    end
    else $error("[FAIL] Msg-ID%0d: Found %8h Expected %8h", modem.msg_id-1, word_recv, expected);
  end


endmodule
