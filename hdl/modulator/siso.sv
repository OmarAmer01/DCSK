/*
Project        : DCSK
Standard doc.  : 
Module name    : SISO
Dependancy     :
Design doc.    : 
References     : 
Description    : Delay Serial In Serial out
Owner          : Yahia Ahmed
*/
module SerialInSerialOut #(parameter DELAY=8) 
(
  input wire clk,
  input wire rst_n,
  input wire serial_in,
  output reg serial_out
);

  // Internal shift register
  reg [DELAY-1:0] shift_register;

  // Sequential logic for serial-in
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      shift_register <= 0;
    else
      shift_register <= {shift_register[DELAY-2:0], serial_in};
  end

assign serial_out = shift_register[DELAY-1];

endmodule


