/*
================================================================================
* Modem Package
* Has modulation/demodulation functions that are used in testing.

* Author: Omar Tarek Amer

* Date: 12/08/2023
=================================================================================
*/

package modem_pkg;
  import spreading_factors_pkg::*;
  typedef logic logic_q[$];
  class modem;
    virtual tx_if intf;
    static int msg_id = 0;

    function new(virtual tx_if tx_intf);
      intf = tx_intf;
    endfunction

    function automatic logic_q demod(int spreading_factor, logic [31:0] rx);
      logic_q dmod;
      int dmod_ctr = 0;
      logic chaos_bit, mod_bit;

      for (int i = 0; i < 32 / spreading_factor; i += spreading_factor) begin : demod
        for (int j = i; j < spreading_factor; j++) begin : multiply_and_accumulate
          chaos_bit = rx[j];
          mod_bit   = rx[j+(spreading_factor/2)];
          dmod_ctr  = (chaos_bit && mod_bit) ? dmod_ctr++ : dmod_ctr--;
        end

        if (dmod_ctr >= 0) dmod.push_back(1'b1);
        else dmod.push_back(1'b0);
      end

      return dmod;
    endfunction

    task automatic send_msg(logic [31:0] msg, logic [1:0] sf_id /*,logic last*/);
      intf.cb.i_msg  <= msg;
      intf.cb.i_sf   <= sf_id;
      @(intf.cb) intf.cb.i_send <= 1;
      //intf.cb.i_send <= 1;
    
      $display("\n======== Sending Msg (ID-%0d) =======", msg_id);
      $display("Current Time; %0d ns.", $time);
      $display("Data: 0x%8H", msg);
      $display("Spreading Factor: SF%0d", 2 ** (sf_id + 1));
      //$display("Last: %s", last ? "Y" : "No.");

      //intf.cb.i_send <= 0;
      @(intf.cb) intf.cb.i_send <= 0;
      case (sf_id)
        SF2: repeat  ((2 * 2  * 32)) @(intf.cb);
        SF4: repeat  ((2 * 4  * 32)) @(intf.cb);
        SF8: repeat  ((2 * 8  * 32)) @(intf.cb);
        SF16: repeat ((2 * 16 * 32)) @(intf.cb);
        default: $fatal(1, "INVALID SPREADING FACTOR");
      endcase
      $display("MSG (ID-%0d) Fully Sent @ %0t ns.", msg_id++, $time);
      $display("===================================\n");
    endtask

    task automatic demod_msg(logic bit_q[$], logic verbose = 1'b0, ref logic [31:0] msg);
      // Infer spreading factor from the number of received bits.
      int num_recv_bits = bit_q.size();
      int sf = (num_recv_bits / (32 * 2));
      logic chaos[$], modualted_chaos[$];
      int dmod_ctr = 0;
      int bit_ctr = 0;

      while (bit_q.size() != 0) begin
        repeat (sf) begin : get_chaos
          chaos.push_back(bit_q.pop_front());
        end

        repeat (sf) begin : get_modulated_chaos
          modualted_chaos.push_back(bit_q.pop_front());
        end

        if (verbose) $display("     Chaos (%0d): %0p", bit_ctr, chaos);
        if (verbose) $display("Mod. Chaos (%0d): %0p\n", bit_ctr, modualted_chaos);

        dmod_ctr = 0;
        repeat (sf) begin : demod
          if (chaos.pop_front() == modualted_chaos.pop_front()) begin
            dmod_ctr++;
          end else begin
            dmod_ctr--;
          end
        end

        msg[bit_ctr++] = dmod_ctr >= 0;
      end

    endtask

  endclass
endpackage
