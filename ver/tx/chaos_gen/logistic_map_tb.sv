/*
============================================================================================================
* Logistic Map Testbench
* Author: Omar Tarek Amer
* Date: 12/02/2023

* Command:
vsim logistic_map_tb -debugDB=+ACC -do "./ver/tx/chaos_gen/lmap.do" -displaymsgmode both -msgmode both
=============================================================================================================
*/

`timescale 1ns/100ps
module logistic_map_tb ();

    logic         i_clk;
    logic         i_arst_n;
    logic         i_en;
    logic  [7: 0] i_seed;
    logic         i_load_seed;
    logic  [15:0] o_next_val;
    int           err_cnt_tst_1, err_cnt_tst_2;

    task automatic report_fail(int i, int test_no, ref int err_ctr);
        err_ctr++;
        $error("[FAIL] STIM = %2h => Found %4h Expected %4h", i_seed, o_next_val, test_no == 1 ? test_1_csv[i] : test_2_csv[i]);
    endtask

    task automatic report_pass(bit verbose=0);
        if (verbose) $display("[PASS] Stim %2h matches with model (%4h)", i_seed, o_next_val);
    endtask

    logistic_map UUT (.*);
    localparam longint PERIOD = 100;
    always #(PERIOD/2) i_clk = ~i_clk;



    logic [15:0] test_1_csv [256];
    logic [15:0] test_2_csv [256];
    int discard, fd_1, fd_2;
    logic [15:0] matlab_model_sol_1, matlab_model_sol_2;

    initial begin

        fd_1 = $fopen(".\\modeling\\lmap_table.csv", "r");
        if (fd_1 == 0) $fatal(1, "Failed To Open File.");

        for (int line_no = 0; line_no < 256 ; line_no++) begin : csv_read_tst_1
            discard = $fscanf(fd_1, "%h,%h", discard, test_1_csv[line_no]);
        end

        i_clk = 0;
        i_en = 0;
        i_load_seed = 0;
        i_seed = 0;

        // Reset
        i_arst_n = 1;
        #PERIOD i_arst_n = 0;
        #PERIOD i_arst_n = 1;


/*
!       Test 1: One to One Mapping Test
        Load each value from 8'h00 to 8'hff as an initial seed
        and test each mapped value to the results obtained from
        MATLAB.
*/

        i_load_seed = 1;
        i_en = 1;
        err_cnt_tst_1 = 0;
        for (int i = 0; i <= 255; i++) begin: one_to_one_mapping_test
            i_seed = i;
            matlab_model_sol_1 = test_1_csv[i];
            #PERIOD;
            assert (o_next_val == matlab_model_sol_1) report_pass();
            else report_fail(i, 1, err_cnt_tst_1);
        end

/*
!       Test 2: Running Mode Test.
        The Logistic Map is initialized with a seed and is left to run
        for a set number of iterations while storing the output bits.
        Said output bits are compared against the results obtained
        from MATLAB
*/
    fd_2 = $fopen(".\\modeling\\lmap_run.csv", "r");
    if (fd_2 == 0) $fatal(1, "Failed To Open File.");

    for (int line_no = 0; line_no < 256 ; line_no++) begin : csv_read_tst_2
        discard = $fscanf(fd_2, "%h", test_2_csv[line_no]);
    end

        i_seed = 8'hba; // Load seed.
        i_load_seed = 1; // Do not load anymore.



        for (int j = 0; j <= 255; j++) begin: running_mode_test
            #PERIOD;
            i_load_seed = 0; // Do not load anymore.
            matlab_model_sol_2 = test_2_csv[j];
            assert (o_next_val == matlab_model_sol_2) report_pass();
            else report_fail(j, 2, err_cnt_tst_2);
        end

        //* Print Test Summary
        $display("\n\n");
        $display("[TEST 1] %0d Failed (%0d Passed) Out of 256 Cases.",
                  err_cnt_tst_1, 256-err_cnt_tst_1);

        $display("[TEST 2] %0d Failed (%0d Passed) Out of 256 Cases.",
                  err_cnt_tst_2, 256-err_cnt_tst_2);

        $display("\n\n");
        $finish();

    end

endmodule
