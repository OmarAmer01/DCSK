## Generated SDC file "Demod_Top.out.sdc"

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

## DATE    "Thu Dec 14 02:41:20 2023"

##
## DEVICE  "5CSEBA6U19I7"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {Clk} -period 20.000 -waveform { 0.000 10.00 } [get_ports {Clk}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {Clk}] -rise_to [get_clocks {Clk}] -setup 0.170
set_clock_uncertainty -rise_from [get_clocks {Clk}] -rise_to [get_clocks {Clk}] -hold 0.060
set_clock_uncertainty -rise_from [get_clocks {Clk}] -fall_to [get_clocks {Clk}] -setup 0.170
set_clock_uncertainty -rise_from [get_clocks {Clk}] -fall_to [get_clocks {Clk}] -hold 0.060
set_clock_uncertainty -fall_from [get_clocks {Clk}] -rise_to [get_clocks {Clk}] -setup 0.170
set_clock_uncertainty -fall_from [get_clocks {Clk}] -rise_to [get_clocks {Clk}] -hold 0.060
set_clock_uncertainty -fall_from [get_clocks {Clk}] -fall_to [get_clocks {Clk}] -setup 0.170
set_clock_uncertainty -fall_from [get_clocks {Clk}] -fall_to [get_clocks {Clk}] -hold 0.060


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Clk}]
set_input_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {In_Mod_Data}]
set_input_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {N_Rst}]
set_input_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Spread_Factor_Sel[0]}]
set_input_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Spread_Factor_Sel[1]}]
set_input_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Valid}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Out_Data[0]}]
set_output_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Out_Data[1]}]
set_output_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Out_Data[2]}]
set_output_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Out_Data[3]}]
set_output_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Out_Data[4]}]
set_output_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Out_Data[5]}]
set_output_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Out_Data[6]}]
set_output_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Out_Data[7]}]
set_output_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Out_Data[8]}]
set_output_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Out_Data[9]}]
set_output_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Out_Data[10]}]
set_output_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Out_Data[11]}]
set_output_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Out_Data[12]}]
set_output_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Out_Data[13]}]
set_output_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Out_Data[14]}]
set_output_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Out_Data[15]}]
set_output_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Out_Data[16]}]
set_output_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Out_Data[17]}]
set_output_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Out_Data[18]}]
set_output_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Out_Data[19]}]
set_output_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Out_Data[20]}]
set_output_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Out_Data[21]}]
set_output_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Out_Data[22]}]
set_output_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Out_Data[23]}]
set_output_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Out_Data[24]}]
set_output_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Out_Data[25]}]
set_output_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Out_Data[26]}]
set_output_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Out_Data[27]}]
set_output_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Out_Data[28]}]
set_output_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Out_Data[29]}]
set_output_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Out_Data[30]}]
set_output_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Out_Data[31]}]
set_output_delay -add_delay  -clock [get_clocks {Clk}]  4.000 [get_ports {Valid_Data}]


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

set_input_transition 0.400 [all_inputs]
set_input_transition 0.400 [all_inputs]
