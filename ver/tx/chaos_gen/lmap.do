log * -r
config wave -signalnamewidth 1

add wave -position end                  sim:/logistic_map_tb/i_clk
add wave -position end                  sim:/logistic_map_tb/i_arst_n
add wave -position end                  sim:/logistic_map_tb/i_en
add wave -position end                  sim:/logistic_map_tb/i_seed
add wave -position end                  sim:/logistic_map_tb/i_load_seed
add wave -position end -color "Orange"  sim:/logistic_map_tb/o_next_val
add wave -position end -color "Cyan"    sim:/logistic_map_tb/matlab_model_sol_1
add wave -position end -color "Magenta"    sim:/logistic_map_tb/matlab_model_sol_2

add wave -position end -group "UUT" sim:/logistic_map_tb/UUT/one_minus_value
add wave -position end -group "UUT" sim:/logistic_map_tb/UUT/mul_res
add wave -position end -group "UUT" sim:/logistic_map_tb/UUT/value
add wave -position end -group "UUT" sim:/logistic_map_tb/UUT/reg_mul_res
add wave -position end -group "UUT" sim:/logistic_map_tb/UUT/o_next_val

run -all
