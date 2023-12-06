/*
Project        : DCSK
Standard doc.  : 
Module name    : PISO
Dependancy     :
Design doc.    : 
References     : 
Description    : Message Parallel In Serial out
Owner          : Yahia Ahmed
*/
module piso #(parameter MSG_WIDTH=8) 
(
  input logic                   clk,
                                rst_n,
                                ld,
  input logic [MSG_WIDTH-1:0]   parallel_in,
  output logic                  serial_out,
                                empty
);

  // Internal shift register
  logic [MSG_WIDTH-1:0] shift_reg;
  //empty counter
  parameter CNT_WIDTH = $clog2(MSG_WIDTH);
  logic [CNT_WIDTH-1 : 0] counter;

  // Sequential logic for parallel-in and load
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
    begin
        shift_reg <= 0;
        counter <= 0;
    end
    else if (ld)
    begin
        shift_reg <= parallel_in;
        counter <= {(CNT_WIDTH){1'b1}};
    end
    else
    begin
        shift_reg <= {shift_reg[MSG_WIDTH-2:0], 1'b0};
        counter <= (counter == 0)? 0 : counter - 1'b1;
    end
  end

assign serial_out = shift_reg[MSG_WIDTH-1];
assign  empty = (counter == 0);


endmodule