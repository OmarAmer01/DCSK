module serialization_counter(
								input logic clk, rstn, chaos_empty, send, 
								
								output logic [$clog2(2*SPREAD_FACTOR) -1 : 0] chip_index
							);

parameter SPREAD_FACTOR = 2;
reg en;

assign en = ~chaos_empty & send; 

always @(posedge clk or negedge rstn) begin : counter
	if (~rstn) begin
		chip_index <= 0;
	end 
	else if (en) begin
		chip_index <= chip_index + 1;
	end
end
endmodule : serialization_counter