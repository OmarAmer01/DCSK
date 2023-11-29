/*
==============================================================
* Radix-4 Booth Multiplier Testbench

* Author: Omar Tarek Amer
* Date: 11/27/2023

* Command:
! vsim booth_mul_tb -do ./ver/booth/booth_mul.do -debugDB=+ACC -displaymsgmode both -msgmode both
==============================================================
*/
`timescale 1ns/100ps
module booth_mul_tb();
    localparam WORD_LEN = 8;
    localparam TEST_ITERATIONS = 1000;
    logic                            i_clk, i_rstn;
    logic signed  [WORD_LEN-1:0]     i_multiplier;
    logic signed  [WORD_LEN-1:0]     i_multiplicand;
    logic signed  [(2*WORD_LEN)-1:0] o_reg_result;

    booth_mul #(WORD_LEN) UUT (.*);

    localparam PERIOD = 100;
    always #(PERIOD/2) i_clk = ~i_clk;


    task automatic report_fail();
        $error("[FAIL] %0d * %0d\n    Found: %0d\n    Expected: %0d", i_multiplier,
                                                                      i_multiplicand,
                                                                      o_reg_result,
                                                                      (i_multiplicand*i_multiplier));
    endtask

    task automatic report_pass();
        $display("[PASS] %0d * %0d = %0d", i_multiplier, i_multiplicand, o_reg_result);
    endtask





    initial begin
        i_clk = 0;
        i_rstn = 0;
        #PERIOD i_rstn = 1;
        $info("RESET DEASSERTED");

        for (int i = 0; i < TEST_ITERATIONS; i++) begin
            i_multiplicand = $urandom();
            i_multiplier = $urandom();
            #(2*PERIOD);
            assert (o_reg_result == (i_multiplicand*i_multiplier)) report_pass();
            else   report_fail();
        end

        $finish();

    end

endmodule
