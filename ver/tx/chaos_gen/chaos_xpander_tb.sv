/*
==================================================================================
* Chaos Expander Testbench
* Compare the output of the expanded chaos with the results generated from MATLAB.

* Author: Omar Tarek Amer
* Date: 12/01/2023

* Command
* vsim chaos_xpander_tb -do .\ver\tx\chaos_gen\chaos_xpander_tb.do -debugDB=+ACC -c
===================================================================================
*/
import wire_shuffler_pkg::*;

module chaos_xpander_tb;
import wire_shuffler_pkg::*;
logic [15:0]  i_chaos;
logic [255:0] o_xpanded_chaos;

chaos_xpander UUT (.*);

int           fd, read_success;
int           err_cnt;

logic  [15:0] unxpanded[2**16];
logic [255:0] xpanded[2**16];
logic [255:0] unshuffled[2**16];

localparam NUM_TESTS = 2**16;


task automatic report_pass(int iteration, bit verbose = 0);
    if (verbose)
    $display("[PASS]\n%4h (Iteration #%0d)expanded to\n%64h.",
              iteration,
              i_chaos,
              o_xpanded_chaos);
endtask

task automatic report_fail(logic [255:0] exp, logic [255:0] exp_b4);
    string in = $sformatf("%4h",i_chaos);
    string found = $sformatf("%64h", o_xpanded_chaos);
    string expected = $sformatf("%64h", exp);
    string b4_shuffle = $sformatf("%64h", UUT.unshuffled_chaos);
    string expected_b4_shuffle = $sformatf("%64h", exp_b4);

    string eq = "=====================================";
    string big_eq = $sformatf("%s%s========", eq, eq);
    err_cnt++;
    $error("\n%s [FAIL] %s\nInput:            %s\nFound:            %s\nBefore Shuffling: %s\nExpected:         %s\nExp b4 Shuffle:   %s\n%s",
            eq,
            eq,
            in,
            found,
            b4_shuffle,
            expected,
            expected_b4_shuffle,
            big_eq);

endtask

initial begin

    $display("\n\n");
    $display("Attempting to open file...");
    fd = $fopen(".\\modeling\\xpander.csv", "r");

    if (fd == 0) $fatal(1, "Failed to open file. Exiting...");
    $display("File opened successfully. Reading...");

    for (int line_no = 0; line_no < NUM_TESTS; line_no++) begin: csv_read
        read_success = $fscanf(fd, "%h,%h,%h", unxpanded[line_no], unshuffled[line_no] ,xpanded[line_no]);
        assert(read_success == 3) else $fatal(1, "File read failed. Exiting");
    end

    $display("File read successful. Starting Test...");

    for (int i = 0; i < NUM_TESTS; i++) begin: test_loop
        i_chaos = unxpanded[i];
        #1;
        assert (o_xpanded_chaos == xpanded[i]) report_pass(i);
        else report_fail(xpanded[i], unshuffled[i]);
    end

    $display("\n\n");
    $display("================ Summary ================");
    $display("Total Tests: %0d", NUM_TESTS);
    $display("Passed: %0d | Failed: %0d",NUM_TESTS-err_cnt, err_cnt);

    $finish();

end

endmodule
