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


  logic i_clk;
  localparam PERIOD = 100;
  always #(PERIOD / 2) i_clk = ~i_clk;

  tx_if intf (i_clk);
  tx UUT (intf.tx);

  modem modem = new(intf);

  initial begin : sender_loop
    i_clk = 0;
    intf.i_arst_n = 1;
    intf.i_seed = '0;
    intf.i_load_seed = '0;
    intf.i_send = '0;
    intf.i_msg = '0;
    intf.i_sf = '0;

    // Reset
    @(intf.cb) intf.cb.i_arst_n <= 0;
    @(intf.cb) intf.cb.i_arst_n <= 1;

    // Load Seed
    @(intf.cb) intf.cb.i_seed <= 8'h15;
    @(intf.cb) intf.cb.i_load_seed <= 1;
    @(intf.cb) intf.cb.i_load_seed <= 0;

    @(intf.cb) modem.send_msg(32'hFaceB00c, SF16);
    @(intf.cb) modem.send_msg(32'h66DEAD66, SF16);
    @(intf.cb);
    $finish();

  end

  logic rx[$];
  logic [31:0] recv_msg;
  int bit_idx;
  always @(posedge intf.cb.is_sending, negedge intf.cb.is_sending) begin : recv_loop
    if (intf.cb.is_sending) begin: read_bits
      bit_idx = 0;
      repeat (2 * 32 * 2 ** (SF16 + 1)) begin
        if (intf.cb.is_sending) begin
        //$display("[%0t] Bit (%0d) : %0b", $time, bit_idx++, intf.cb.o_tx);
        rx.push_back(intf.cb.o_tx);
        @(intf.cb);
        end
      end
    end

    if (~intf.cb.is_sending) begin : demod_loop
      $display("===========================");
      modem.demod_msg(rx, 1'b0, recv_msg);
      $display("NUMBER OF BITS RECV'd = %0d", rx.size());
      $display("MSG: = %0h",recv_msg);
      $display("===========================");
      rx.delete();
    end
  end

endmodule
