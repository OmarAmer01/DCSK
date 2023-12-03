module serialization_counter_tb();
	parameter SPREAD_FACTOR = 4;
	reg clk, rstn, chaos_empty, send;
	wire [$clog2(2*SPREAD_FACTOR) -1 : 0] chip_index;
	serialization_counter #(4) DUT(clk, rstn, chaos_empty, send, chip_index);

initial begin 
	clk=0;
	forever 
	#1 clk=~clk;
end

initial begin
	
	rstn=0;
	chaos_empty = 0;
	send = 0;
	
	#5
	
	rstn=1;
	send = 1;
	
	#20
	$stop;
end

endmodule

