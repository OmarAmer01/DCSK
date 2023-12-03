module serialization_mux( 
							input logic chaos_bit, modulated_bit, MSBchip_index,
							output  logic tx
						);

assign tx = (MSBchip_index == 0)? chaos_bit: modulated_bit;

endmodule : serialization_mux