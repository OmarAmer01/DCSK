/*
Project        : DCSK
Standard doc.  : 
Module name    : the Modulator
Dependancy     :
Design doc.    : 
References     : 
Description    : Message Modulator
Owner          : Yahia Ahmed
*/
module modulator #(parameter MSG_WIDTH=8, parameter DELAY=2) 
(
  input logic                   clk,
                                rst_n,
                                send,
                                chaos_bit,
  input logic [MSG_WIDTH-1:0]   message,
  output logic                  modulated_bit
);

  // Internal signals
  logic ready_to_send;
  logic semi_mod_bit;
  logic d_chaos_bit;

piso #(MSG_WIDTH) piso1 
(
    .clk                         (clk        ),
    .rst_n                       (rst_n      ),
    .ld                          (send & ready_to_send),
    .parallel_in                 (message),
    .serial_out                  (semi_mod_bit ),
    .empty                       (ready_to_send   )
);

SerialInSerialOut #(DELAY) siso1
(
    .clk                         (clk       ),
    .rst_n                       (rst_n     ),
    .serial_in                   (chaos_bit ),
    .serial_out                  (d_chaos_bit)
);

assign modulated_bit = d_chaos_bit ^ semi_mod_bit;

endmodule