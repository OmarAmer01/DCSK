/*
Project        : DCSK
Standard doc.  :
Module name    : TB for the Modulator
Dependancy     :
Design doc.    :
References     :
Description    : Testbench
Owner          : Yahia Ahmed
*/

module modulator_tb;
    //Parameter
    parameter           MSG_WIDTH = 4;
    parameter           DELAY = 2;

	//Testbench Signals
  logic                                                                             clk_tb             ,
                                                                                    rst_n_tb           ,
                                                                                    send_tb            ,
                                                                                    chaos_bit_tb       ,
                                                                                    modulated_bit_tb   ;
  logic              [MSG_WIDTH-1:0]                                                message_tb         ;

    //DUT instantiation
    modulator #(MSG_WIDTH,DELAY) DUT
                                (
                                .clk                                                (clk_tb             ),
                                .rst_n                                              (rst_n_tb           ),
                                .send                                               (send_tb            ),
                                .chaos_bit                                          (chaos_bit_tb       ),
                                .message                                            (message_tb         ),
                                .modulated_bit                                      (modulated_bit_tb   )
                                );


    always
        begin
            #5  clk_tb      = !clk_tb;
        end

    initial
        begin
            //$display("%d",$clog2(MSG_WIDTH));
                clk_tb      = 1'b0;
                rst_n_tb    = 1'b0;
                message_tb  = 4'b0000;
                send_tb     = 1'b0;
                chaos_bit_tb= 1'b0;

            #3  rst_n_tb    = 1'b1;
                message_tb  = 4'b1011;
                send_tb     = 1'b1;
                chaos_bit_tb   = 1'b1;

            #7  send_tb    = 1'b0;

            #50  send_tb    = 1'b1;

        end

endmodule
