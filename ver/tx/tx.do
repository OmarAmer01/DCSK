log -r *
config wave -signalnamewidth 1

add wave -position end  sim:/tx_tb/intf/i_clk
add wave -position end  sim:/tx_tb/intf/i_arst_n


add wave -position end -color "cyan" -group "Modulator" sim:/tx_tb/UUT/U_chip_ctr/o_chip_index
add wave -position end -color "cyan" -group "Modulator" sim:/tx_tb/UUT/U_modulator/i_chip_idx_msb
add wave -position end -group "Modulator"  sim:/tx_tb/UUT/U_modulator/i_chaos_bit
add wave -position end -group "Modulator" -color "magenta" sim:/tx_tb/UUT/U_modulator/msg_piso_output_serial
add wave -position end -group "Modulator" -color "yellow" -label "D_bit" sim:/tx_tb/UUT/U_modulator/delayed_bit
add wave -position end -color "orange" sim:/tx_tb/intf/o_tx

#add wave -position end -group "Modulator" -group "Delays" -label "D2" sim:/tx_tb/UUT/U_modulator/delay_by_2_tap
#add wave -position end -group "Modulator" -group "Delays" -label "D4" sim:/tx_tb/UUT/U_modulator/delay_by_4_tap
#add wave -position end -group "Modulator" -group "Delays" -label "D8" sim:/tx_tb/UUT/U_modulator/delay_by_8_tap
#add wave -position end -group "Modulator" -group "Delays" -label "D16" sim:/tx_tb/UUT/U_modulator/delay_by_16_tap
#add wave -position end -group "Modulator" -group "Delays" -label "Buffer" sim:/tx_tb/UUT/U_modulator/delay_buffer

add wave -position end -group "Seed" sim:/tx_tb/intf/i_load_seed
add wave -position end -group "Seed" sim:/tx_tb/intf/i_seed

add wave -position end -group "Msg" sim:/tx_tb/intf/i_msg
add wave -position end -group "Msg" sim:/tx_tb/intf/i_send
add wave -position end -group "Msg" sim:/tx_tb/intf/i_sf

add wave -position end -group "UUT" sim:/tx_tb/UUT/chaos_bit
add wave -position end -group "UUT" sim:/tx_tb/UUT/chip_idx
add wave -position end -group "UUT" sim:/tx_tb/UUT/modulator_ready
add wave -position end -group "UUT" sim:/tx_tb/UUT/chaos_bits_depleted
run -all