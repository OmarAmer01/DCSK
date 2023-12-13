log * -r
add wave -position end  sim:/end2end_tb/intf/i_clk
add wave -position end  sim:/end2end_tb/intf/i_arst_n

add wave -position end -color "orange" sim:/end2end_tb/intf/i_msg
add wave -position end -color "orange" sim:/end2end_tb/intf/i_send
add wave -position end -color "orange" sim:/end2end_tb/intf/o_is_sending

run -all