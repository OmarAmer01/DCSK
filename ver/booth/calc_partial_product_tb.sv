/*
========================================================================================================
* Calculate Booth Partial Product Testbench

* Author: Omar Tarek Amer
* Date: 11/26/2023

* Command
* vsim calc_partial_product_tb -debugDB=+ACC -c -do ./ver./booth/calc_prod.do -sv_seed random -msgmode both -displaymsgmode both
========================================================================================================
*/
`timescale 1ns/100ps

module calc_partial_product_tb ();
localparam WORD_LEN = 4;

logic  [WORD_LEN-1:0]  i_multiplicand;
logic  [2:0]  i_opcode;
logic signed [(2*WORD_LEN)-1:0] o_result;

calc_partial_product #(WORD_LEN) UUT (.*);

localparam test_iterations = 10000;

task automatic report_error(logic[(2*WORD_LEN)-1:0] expected);
    $display("============== FAIL =============");
    $error("Found %h | Expected %h\n", o_result, expected);
    $display("Multiplicand: %h\nOpcode: %b", i_multiplicand, i_opcode);
    $display("================================\n");
endtask

task automatic report_pass();
    $display("=============== PASS =============");
    $display("Multiplicand: %h\nOPCODE: %b\nResult: %h", i_multiplicand, i_opcode, o_result);
    $display("================================\n");
endtask

initial begin
    i_opcode = 0;
    for (int i = 0; i < test_iterations*8; i++) begin
        i_multiplicand = $urandom();

        #1; // Wait for comb delay

        case (i_opcode)
            3'b000, 3'b111: begin: Zero
                assert (o_result == '0)
                else   $error("NOT ZERO ON 000");
            end

            3'b001, 3'b010: begin : One
                automatic int result = signed'(i_multiplicand);
                assert (o_result == result)
                else report_error(result);
            end


            3'b011: begin : Two
                automatic int result = 2 * signed'(i_multiplicand);
                assert (o_result == result)
                else report_error(result);
            end

            3'b100: begin : Negative_Two
                automatic int result = -2* signed'(i_multiplicand);
                assert (o_result == result)
                else report_error(result);
            end

            3'b101, 3'b110: begin : Negative_One
                automatic int result = -1*signed'(i_multiplicand);
                assert (o_result == result)
                else report_error(result);
            end
            default: $fatal (1, "BAD OPCODE! => %0b", i_opcode);
        endcase
        i_opcode++;
    end
    $finish();
end

endmodule
