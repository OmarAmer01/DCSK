log -r *
run -all

add wave -position end -radix "dec" sim:/calc_partial_product_tb/o_result
add wave -position end -radix "bin"  sim:/calc_partial_product_tb/i_opcode
add wave -position end -radix "dec" sim:/calc_partial_product_tb/i_multiplicand

add wave -position end -group "UUT" sim:/calc_partial_product_tb/UUT/result_sign
add wave -position end -group "UUT" sim:/calc_partial_product_tb/UUT/result_opposite_sign
add wave -position end -group "UUT" sim:/calc_partial_product_tb/UUT/selector
add wave -position end -group "UUT" sim:/calc_partial_product_tb/UUT/o_result
add wave -position end -group "UUT" sim:/calc_partial_product_tb/UUT/i_opcode
add wave -position end -group "UUT" sim:/calc_partial_product_tb/UUT/i_multiplicand

add wave -position end -color "white"  sim:/calc_partial_product_tb/WORD_LEN

exit