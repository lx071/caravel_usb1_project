###############################################################################
# Created by write_sdc
# Fri Nov 18 16:53:38 2022
###############################################################################
current_design rtc_top
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name rtc_clk -period 100.0000 [get_ports {rtc_clk}]
create_clock -name sys_clk -period 10.0000 [get_ports {sys_clk}]

set_clock_groups \
   -name clock_group \
   -logically_exclusive \
   -group [get_clocks {sys_clk}]\
   -group [get_clocks {rtc_clk}]\
   -comment {Async Clock group}

set_propagated_clock [all_clocks]
set_clock_transition 0.1500 [all_clocks]
set_clock_uncertainty -setup 0.5000 [all_clocks]
set_clock_uncertainty -hold 0.2500 [all_clocks]

set_input_delay -max 6.0000 -clock [get_clocks {sys_clk}] -add_delay [get_ports {reg_addr[*]}]
set_input_delay -max 6.0000 -clock [get_clocks {sys_clk}] -add_delay [get_ports {reg_be[*]}]
set_input_delay -max 6.0000 -clock [get_clocks {sys_clk}] -add_delay [get_ports {reg_cs}]
set_input_delay -max 6.0000 -clock [get_clocks {sys_clk}] -add_delay [get_ports {reg_wdata[*]}]
set_input_delay -max 6.0000 -clock [get_clocks {sys_clk}] -add_delay [get_ports {reg_wdata[9]}]
set_input_delay -max 6.0000 -clock [get_clocks {sys_clk}] -add_delay [get_ports {reg_wr}]
set_input_delay -max 6.0000 -clock [get_clocks {sys_clk}] -add_delay [get_ports {rst_n}]

set_input_delay -min 2.0000 -clock [get_clocks {sys_clk}] -add_delay [get_ports {reg_addr[*]}]
set_input_delay -min 2.0000 -clock [get_clocks {sys_clk}] -add_delay [get_ports {reg_be[*]}]
set_input_delay -min 2.0000 -clock [get_clocks {sys_clk}] -add_delay [get_ports {reg_cs}]
set_input_delay -min 2.0000 -clock [get_clocks {sys_clk}] -add_delay [get_ports {reg_wdata[*]}]
set_input_delay -min 2.0000 -clock [get_clocks {sys_clk}] -add_delay [get_ports {reg_wdata[9]}]
set_input_delay -min 2.0000 -clock [get_clocks {sys_clk}] -add_delay [get_ports {reg_wr}]
set_input_delay -min 2.0000 -clock [get_clocks {sys_clk}] -add_delay [get_ports {rst_n}]


set_output_delay -max 6.0000 -clock [get_clocks {sys_clk}] -add_delay [get_ports {inc_date_d}]
set_output_delay -max 6.0000 -clock [get_clocks {sys_clk}] -add_delay [get_ports {inc_time_s}]
set_output_delay -max 6.0000 -clock [get_clocks {sys_clk}] -add_delay [get_ports {reg_ack}]
set_output_delay -max 6.0000 -clock [get_clocks {sys_clk}] -add_delay [get_ports {reg_rdata[*]}]

set_output_delay -min 2.0000 -clock [get_clocks {sys_clk}] -add_delay [get_ports {inc_date_d}]
set_output_delay -min 2.0000 -clock [get_clocks {sys_clk}] -add_delay [get_ports {inc_time_s}]
set_output_delay -min 2.0000 -clock [get_clocks {sys_clk}] -add_delay [get_ports {reg_ack}]
set_output_delay -min 2.0000 -clock [get_clocks {sys_clk}] -add_delay [get_ports {reg_rdata[*]}]

set_output_delay -max 6.0000 -clock [get_clocks {rtc_clk}] -add_delay [get_ports {rtc_intr}]
set_output_delay -min 2.0000 -clock [get_clocks {rtc_clk}] -add_delay [get_ports {rtc_intr}]
###############################################################################
# Environment
###############################################################################
set_load -pin_load 0.0334 [get_ports {inc_date_d}]
set_load -pin_load 0.0334 [get_ports {inc_time_s}]
set_load -pin_load 0.0334 [get_ports {reg_ack}]
set_load -pin_load 0.0334 [get_ports {rtc_intr}]
set_load -pin_load 0.0334 [get_ports {reg_rdata[31]}]
set_load -pin_load 0.0334 [get_ports {reg_rdata[30]}]
set_load -pin_load 0.0334 [get_ports {reg_rdata[29]}]
set_load -pin_load 0.0334 [get_ports {reg_rdata[28]}]
set_load -pin_load 0.0334 [get_ports {reg_rdata[27]}]
set_load -pin_load 0.0334 [get_ports {reg_rdata[26]}]
set_load -pin_load 0.0334 [get_ports {reg_rdata[25]}]
set_load -pin_load 0.0334 [get_ports {reg_rdata[24]}]
set_load -pin_load 0.0334 [get_ports {reg_rdata[23]}]
set_load -pin_load 0.0334 [get_ports {reg_rdata[22]}]
set_load -pin_load 0.0334 [get_ports {reg_rdata[21]}]
set_load -pin_load 0.0334 [get_ports {reg_rdata[20]}]
set_load -pin_load 0.0334 [get_ports {reg_rdata[19]}]
set_load -pin_load 0.0334 [get_ports {reg_rdata[18]}]
set_load -pin_load 0.0334 [get_ports {reg_rdata[17]}]
set_load -pin_load 0.0334 [get_ports {reg_rdata[16]}]
set_load -pin_load 0.0334 [get_ports {reg_rdata[15]}]
set_load -pin_load 0.0334 [get_ports {reg_rdata[14]}]
set_load -pin_load 0.0334 [get_ports {reg_rdata[13]}]
set_load -pin_load 0.0334 [get_ports {reg_rdata[12]}]
set_load -pin_load 0.0334 [get_ports {reg_rdata[11]}]
set_load -pin_load 0.0334 [get_ports {reg_rdata[10]}]
set_load -pin_load 0.0334 [get_ports {reg_rdata[9]}]
set_load -pin_load 0.0334 [get_ports {reg_rdata[8]}]
set_load -pin_load 0.0334 [get_ports {reg_rdata[7]}]
set_load -pin_load 0.0334 [get_ports {reg_rdata[6]}]
set_load -pin_load 0.0334 [get_ports {reg_rdata[5]}]
set_load -pin_load 0.0334 [get_ports {reg_rdata[4]}]
set_load -pin_load 0.0334 [get_ports {reg_rdata[3]}]
set_load -pin_load 0.0334 [get_ports {reg_rdata[2]}]
set_load -pin_load 0.0334 [get_ports {reg_rdata[1]}]
set_load -pin_load 0.0334 [get_ports {reg_rdata[0]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_cs}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_wr}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {rst_n}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {rtc_clk}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_addr[4]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_addr[3]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_addr[2]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_addr[1]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_addr[0]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_be[3]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_be[2]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_be[1]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_be[0]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_wdata[31]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_wdata[30]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_wdata[29]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_wdata[28]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_wdata[27]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_wdata[26]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_wdata[25]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_wdata[24]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_wdata[23]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_wdata[22]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_wdata[21]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_wdata[20]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_wdata[19]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_wdata[18]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_wdata[17]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_wdata[16]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_wdata[15]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_wdata[14]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_wdata[13]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_wdata[12]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_wdata[11]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_wdata[10]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_wdata[9]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_wdata[8]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_wdata[7]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_wdata[6]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_wdata[5]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_wdata[4]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_wdata[3]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_wdata[2]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_wdata[1]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reg_wdata[0]}]
set_timing_derate -early 0.9500
set_timing_derate -late 1.0500
###############################################################################
# Design Rules
###############################################################################
set_max_fanout 4.0000 [current_design]
