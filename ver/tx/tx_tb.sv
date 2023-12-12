/*
================================================================================
* Transmitter Testbench
* Author: Omar Tarek Amer

* Date: 12/08/2023
* Command:
vsim tx_tb -debugDB=+ACC -do "./ver/tx/tx.do" -msgmode both -displaymsgmode both
=================================================================================
*/

`timescale 1ns / 100ps

import modem_pkg::*;
import spreading_factors_pkg::*;

module tx_tb;

  //! Clock
  logic i_clk;
  localparam int PERIOD = 100;
  always #(PERIOD / 2) i_clk = ~i_clk;

  localparam TEST_ITERATIONS = 10000;

  //! UUT
  tx_if intf (i_clk);
  tx UUT (intf.tx);

  //! Utility functions
  modem modem = new(intf);

  //! Variable declarations
  logic [31:0] msg_to_send;
  sf_t spreading_factors[4] = {SF2, SF4, SF8, SF16};
  int  sf_report[4] = {0, 0, 0, 0};
  int silence_report = 0;
  int sf;  // Spreading Factor
  logic [31:0] tx[$];
  int pass_count = 0;
  int silence_len;

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
      if ($urandom_range(4, 0) == 0) begin: random_silence
        silence_len = $urandom_range(9, 0);
        repeat(silence_len) @(intf.cb);
        $display("End of Burst. Silence for %0d Cycles.", silence_len);
        silence_report++;
      end

    end

    @(intf.cb);
    @(intf.cb);
    $display("============= Statistics =============");
    $display("[Total Tests]  %0d", TEST_ITERATIONS);
    $display("[Tests PASSED] %0d", pass_count);
    $display("[Tests FAILED] %0d\n", TEST_ITERATIONS-pass_count);
    $display("          *** Tests Ran ***");
    $display("Number of Messages Sent with SF2:  %0d", sf_report[0]);
    $display("Number of Messages Sent with SF4:  %0d", sf_report[1]);
    $display("Number of Messages Sent with SF8:  %0d", sf_report[2]);
    $display("Number of Messages Sent with SF16: %0d", sf_report[3]);
    $display("          *** Number of Bursts ***");
    $display("[Bursts] %0d", silence_report);
    $display("======================================\n");
    $finish();

  end

  logic rx[$];
  logic [31:0] recv_msg, expected;
  int bit_idx;
  int no_bits;

  always @(intf.i_send) begin : recv_loop
    no_bits = 64 * 2 ** (intf.i_sf + 1);
    if (intf.o_is_sending) begin
      repeat (no_bits) begin
        @(intf.cb);
        rx.push_back(intf.cb.o_tx);
      end

      modem.demod_msg(rx, 1'b0, recv_msg);

      expected = tx.pop_front();
      assert (recv_msg == expected) begin
        pass_count++;
        $display("[PASS] MSG (ID-%0d) Received Successfully.", modem.msg_id - 1);
        $displayh("EXPECTED = %p", expected);
      end else

        $error(
            "[FAIL] MSG (ID-%0d) Found: 0x%8H Expected 0x%8H.", modem.msg_id - 1, recv_msg, expected
        );
      rx.delete();
      $display("\n");

    end
  end

endmodule
