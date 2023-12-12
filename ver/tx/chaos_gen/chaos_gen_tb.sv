/*
================================================================================
* Chaos Generator Testbench
* Authors: Omar Tarek Amer

* Date: 12/03/2023

* Command:
vsim chaos_gen_tb -c -debugDB=+ACC -do "./ver/tx/chaos_gen/chaos_gen.do"
=================================================================================
*/

`timescale 1ns/100ps
module chaos_gen_tb;

    logic        i_clk;
    logic        i_arst_n;
    logic [7:0]  i_seed;
    logic        i_load_seed;
    logic        o_chaos_empty;
    logic        o_chaos_bit;

    chaos_gen UUT (.*);

    localparam TEST_ITERATIONS = 1024;
    localparam PERIOD = 100;
    always #(PERIOD/2) i_clk = ~i_clk;

    initial begin
        i_clk = 0;
        i_arst_n = 0;

        i_seed = '0;
        i_load_seed = '0;


        #PERIOD i_arst_n = 1;

        // Load Seed
        i_seed = 8'hac;
        #PERIOD;
        i_load_seed = 1;

        #PERIOD;
        i_load_seed = 0;


        for (int i = 0; i < TEST_ITERATIONS; i++) begin
            $display(o_chaos_bit);
            #PERIOD;
        end

        $finish();

    end

endmodule
