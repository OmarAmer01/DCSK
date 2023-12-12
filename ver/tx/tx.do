log -r *
config wave -signalnamewidth 1

add wave -position end -label "Clock" sim:/tx_tb/intf/i_clk
add wave -position end -label "Reset" sim:/tx_tb/intf/i_arst_n

add wave -position end -color "Violet" -label "Current State" sim:/tx_tb/UUT/U_tx_fsm/current
add wave -position end -color "Violet" -label "Next State" sim:/tx_tb/UUT/U_tx_fsm/next

add wave -position end -label "Bit-Chip Ctr EN"  sim:/tx_tb/UUT/U_chip_bit_ctr/i_en
add wave -position end -radix "unsigned" -label "Bit Index" sim:/tx_tb/UUT/U_chip_bit_ctr/o_bit_index
add wave -position end -radix "unsigned" -label "Chip Index" sim:/tx_tb/UUT/U_chip_bit_ctr/o_chip_index

add wave -position end -label "Spreading Factor ID" sim:/tx_tb/intf/i_sf
add wave -position end -label "Msg" -color "cyan" sim:/tx_tb/UUT/msg_bit
add wave -position end -label "Chaos" -color "magenta" sim:/tx_tb/UUT/U_chaos_gen/o_chaos_bit
add wave -position end -label "TX" -color "orange" sim:/tx_tb/intf/o_tx

add wave -position end  sim:/tx_tb/intf/i_send
add wave -position end  sim:/tx_tb/intf/i_msg
add wave -position end  sim:/tx_tb/UUT/U_msg_buffer/buffer

run -all