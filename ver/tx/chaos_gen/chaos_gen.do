log * -r
config wave -signalnamewidth 1

add wave -position end             sim:/chaos_gen_tb/i_arst_n
add wave -position end             sim:/chaos_gen_tb/i_clk
add wave -position end -group "TB" sim:/chaos_gen_tb/i_load_seed
add wave -position end -group "TB" sim:/chaos_gen_tb/i_seed
add wave -position end -group "TB" sim:/chaos_gen_tb/o_chaos_bit
add wave -position end -group "TB" sim:/chaos_gen_tb/o_chaos_empty


add wave -position end -group "UUT" sim:/chaos_gen_tb/UUT/i_load_seed
add wave -position end -group "UUT" sim:/chaos_gen_tb/UUT/i_seed
add wave -position end -group "UUT" sim:/chaos_gen_tb/UUT/o_chaos_bit
add wave -position end -group "UUT" sim:/chaos_gen_tb/UUT/o_chaos_empty
add wave -position end -group "UUT" sim:/chaos_gen_tb/UUT/lmap_out
add wave -position end -group "UUT" sim:/chaos_gen_tb/UUT/piso_empty
add wave -position end -group "UUT" sim:/chaos_gen_tb/UUT/xpanded_chaos


add wave -position end -group "Logistic Map" sim:/chaos_gen_tb/UUT/U_logistic_map/i_en
add wave -position end -group "Logistic Map" sim:/chaos_gen_tb/UUT/U_logistic_map/i_load_seed
add wave -position end -group "Logistic Map" sim:/chaos_gen_tb/UUT/U_logistic_map/i_seed
add wave -position end -group "Logistic Map" sim:/chaos_gen_tb/UUT/U_logistic_map/o_next_val
add wave -position end -group "Logistic Map" sim:/chaos_gen_tb/UUT/U_logistic_map/mul_res
add wave -position end -group "Logistic Map" sim:/chaos_gen_tb/UUT/U_logistic_map/one_minus_value
add wave -position end -group "Logistic Map" sim:/chaos_gen_tb/UUT/U_logistic_map/reg_mul_res
add wave -position end -group "Logistic Map" sim:/chaos_gen_tb/UUT/U_logistic_map/value

add wave -position end -group "Chaos PISO" sim:/chaos_gen_tb/UUT/U_chaos_piso/i_data
add wave -position end -group "Chaos PISO" sim:/chaos_gen_tb/UUT/U_chaos_piso/i_load
add wave -position end -group "Chaos PISO" sim:/chaos_gen_tb/UUT/U_chaos_piso/i_shift
add wave -position end -group "Chaos PISO" sim:/chaos_gen_tb/UUT/U_chaos_piso/o_bit
add wave -position end -group "Chaos PISO" sim:/chaos_gen_tb/UUT/U_chaos_piso/o_empty
add wave -position end -group "Chaos PISO" sim:/chaos_gen_tb/UUT/U_chaos_piso/buffer
add wave -position end -group "Chaos PISO" sim:/chaos_gen_tb/UUT/U_chaos_piso/counter

run -all