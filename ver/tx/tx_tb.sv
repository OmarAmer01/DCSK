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

module tx_tb ();

  //! Clock
  logic i_clk;
  localparam int PERIOD = 100;
  always #(PERIOD / 2) i_clk = ~i_clk;

  localparam TEST_ITERATIONS = 100;

  //! UUT
  tx_if intf (i_clk);
  tx UUT (intf.tx);

  //! Utility functions
  modem modem = new(intf);

  //! Variable declarations
  logic [31:0] msg_to_send;
  sf_t spreading_factors[4] = {SF2, SF4, SF8, SF16};
  int sf;  // Spreading Factor
  logic [31:0] tx[$];

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
    @(intf.cb) intf.cb.i_seed <= 8'hfb;
    @(intf.cb) intf.cb.i_load_seed <= 1;
    @(intf.cb) intf.cb.i_load_seed <= 0;

    for (int i = 0; i < TEST_ITERATIONS; i++) begin
      msg_to_send = $urandom();
      tx.push_back(msg_to_send);

      sf = spreading_factors[$urandom_range(1,1)];
      modem.send_msg(msg_to_send, sf);
      //@(intf.cb);
    end

    @(intf.cb);
    @(intf.cb);
    @(intf.cb);
    @(intf.cb);

    $finish();

  end

  logic rx[$];
  logic [31:0] recv_msg, expected;
  int bit_idx;

  always @(*) begin : recv_loop
    if (intf.cb.is_sending) begin : read_bits
      bit_idx = 0;
      repeat (2 * 32 * 2 ** (intf.i_sf + 1)) begin
        if (intf.cb.is_sending) begin
          //$display("[%0t] Bit (%0d) : %0b", $time, bit_idx++, intf.cb.o_tx);
          rx.push_back(intf.cb.o_tx);
          @(intf.cb);
        end else $error("Early Deassertion of is_sending!!!");
      end
      modem.demod_msg(rx, 1'b0, recv_msg);
      // $display("===========================");
      // $display("NUMBER OF BITS RECV'd = %0d", rx.size());
      // $display("[RECV] MSG (ID-%0d) : = 0x%8H", modem.msg_id - 1, recv_msg);
      // $display("===========================\n");
      expected = tx.pop_front();

      assert (recv_msg == expected) begin
        $display("[PASS] MSG (ID-%0d) Received Successfully.", modem.msg_id - 1);
        $displayh("EXPECTED = %p", expected);
      end
      else
        $error(
            "[FAIL] MSG (ID-%0d) Found: 0x%8H Expected 0x%8H.", modem.msg_id - 1, recv_msg, expected
        );
      rx.delete();
    end

  end

endmodule
