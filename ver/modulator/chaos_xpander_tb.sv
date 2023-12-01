/*
================================================================================
* Chaos Expander Testbench
* Generates all possible expansions of
* all 16-bit numbers to be later compared with the same expansions obtained
* from MATLAB.

* Author: Omar Tarek Amer
* Date: 12/01/2023

* Command
* vsim chaos_xpander_tb -do .\ver\modulator\chaos_xpander_tb.do -debugDB=+ACC -c
=================================================================================
*/

module chaos_xpander_tb ();
import wire_shuffler_pkg::*;
logic [15:0]  i_chaos;
logic [255:0] o_xpanded_chaos;

chaos_xpander UUT (.*);

int file_d = $fopen("./ver/modulator/hdl_model_xpnd.csv", "w");

initial begin
    i_chaos = '0;
    for (int i = 0; i < 2**16; i++) begin
        i_chaos = i;
        #1;
        $fdisplay(file_d, "%h,%h", i_chaos, o_xpanded_chaos);
    end
    $finish();
end

endmodule
