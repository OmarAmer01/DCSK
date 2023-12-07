log * -r
config wave -signalnamewidth 1

add wave -position end  sim:/chaos_xpander_tb/o_xpanded_chaos
add wave -position end  sim:/chaos_xpander_tb/i_chaos
add wave -position end -group "UUT" sim:/chaos_xpander_tb/UUT/*

run -all

Found:            ffdff7fffffedefbbffffff9db7ffeefbeff7ff7a7effffffff56dfff7fff7ef