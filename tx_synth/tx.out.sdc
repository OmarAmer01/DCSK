## Generated SDC file "tx.out.sdc"

## Copyright (C) 2023  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions
## and other software and tools, and any partner logic
## functions, and any output files from any of the foregoing
## (including device programming or simulation files), and any
## associated documentation or information are expressly subject
## to the terms and conditions of the Intel Program License
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details, at
## https://fpgasoftware.intel.com/eula.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 22.1std.2 Build 922 07/20/2023 SC Lite Edition"

## DATE    "Thu Dec 14 02:14:12 2023"

##
## DEVICE  "5CEFA9U19I7"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {Clock} -period 20.000 -waveform { 0.000 10.000 } [get_ports {tx_if.i_clk}]



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {Clock}] -rise_to [get_clocks {Clock}] -setup 0.100
set_clock_uncertainty -rise_from [get_clocks {Clock}] -rise_to [get_clocks {Clock}] -hold 0.060
set_clock_uncertainty -rise_from [get_clocks {Clock}] -fall_to [get_clocks {Clock}] -setup 0.100
set_clock_uncertainty -rise_from [get_clocks {Clock}] -fall_to [get_clocks {Clock}] -hold 0.060
set_clock_uncertainty -fall_from [get_clocks {Clock}] -rise_to [get_clocks {Clock}] -setup 0.100
set_clock_uncertainty -fall_from [get_clocks {Clock}] -rise_to [get_clocks {Clock}] -hold 0.060
set_clock_uncertainty -fall_from [get_clocks {Clock}] -fall_to [get_clocks {Clock}] -setup 0.100
set_clock_uncertainty -fall_from [get_clocks {Clock}] -fall_to [get_clocks {Clock}] -hold 0.060


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_clk}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_arst_n}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_load_seed}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_msg[0]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_msg[1]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_msg[2]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_msg[3]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_msg[4]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_msg[5]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_msg[6]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_msg[7]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_msg[8]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_msg[9]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_msg[10]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_msg[11]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_msg[12]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_msg[13]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_msg[14]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_msg[15]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_msg[16]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_msg[17]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_msg[18]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_msg[19]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_msg[20]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_msg[21]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_msg[22]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_msg[23]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_msg[24]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_msg[25]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_msg[26]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_msg[27]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_msg[28]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_msg[29]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_msg[30]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_msg[31]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_seed[0]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_seed[1]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_seed[2]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_seed[3]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_seed[4]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_seed[5]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_seed[6]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_seed[7]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_send}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_sf[0]}]
set_input_delay  -clock [get_clocks {Clock}]  4.000 [get_ports {tx_if.i_sf[1]}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay  -clock [get_clocks {Clock}]  4.0 [get_ports {tx_if.o_is_sending}]
set_output_delay -add_delay  -clock [get_clocks {Clock}]  4.0 [get_ports {tx_if.o_tx}]


#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************
set_input_transition 0.4 [remove_from_collection [all_inputs] [all_clocks]]

