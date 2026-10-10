# ####################################################################

#  Created by Genus(TM) Synthesis Solution 25.10-p002_1 on Sat Oct 10 00:12:47 EDT 2026

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design code4a

create_clock -name "clk" -period 10.0 -waveform {0.0 5.0} [get_ports clk]
create_clock -name "v_clk" -period 10.0 -waveform {0.0 5.0} 
set_clock_transition -rise 0.1 [get_clocks clk]
set_clock_transition -fall 0.12 [get_clocks clk]
set_load -pin_load 0.02 [get_ports {time_hours[4]}]
set_load -pin_load 0.02 [get_ports {time_hours[3]}]
set_load -pin_load 0.02 [get_ports {time_hours[2]}]
set_load -pin_load 0.02 [get_ports {time_hours[1]}]
set_load -pin_load 0.02 [get_ports {time_hours[0]}]
set_load -pin_load 0.02 [get_ports {time_minutes[5]}]
set_load -pin_load 0.02 [get_ports {time_minutes[4]}]
set_load -pin_load 0.02 [get_ports {time_minutes[3]}]
set_load -pin_load 0.02 [get_ports {time_minutes[2]}]
set_load -pin_load 0.02 [get_ports {time_minutes[1]}]
set_load -pin_load 0.02 [get_ports {time_minutes[0]}]
set_load -pin_load 0.02 [get_ports alarm]
set_load -pin_load 0.02 [get_ports alarm_enabled]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks v_clk] -add_delay 3.0 [get_ports rst_n]
set_input_delay -clock [get_clocks v_clk] -add_delay 3.0 [get_ports set_time]
set_input_delay -clock [get_clocks v_clk] -add_delay 3.0 [get_ports increment_hour]
set_input_delay -clock [get_clocks v_clk] -add_delay 3.0 [get_ports increment_minute]
set_input_delay -clock [get_clocks v_clk] -add_delay 3.0 [get_ports set_alarm_time]
set_input_delay -clock [get_clocks v_clk] -add_delay 3.0 [get_ports enable_alarm]
set_input_delay -clock [get_clocks v_clk] -add_delay 3.0 [get_ports alarm_off]
set_output_delay -clock [get_clocks v_clk] -add_delay 3.0 [get_ports {time_hours[4]}]
set_output_delay -clock [get_clocks v_clk] -add_delay 3.0 [get_ports {time_hours[3]}]
set_output_delay -clock [get_clocks v_clk] -add_delay 3.0 [get_ports {time_hours[2]}]
set_output_delay -clock [get_clocks v_clk] -add_delay 3.0 [get_ports {time_hours[1]}]
set_output_delay -clock [get_clocks v_clk] -add_delay 3.0 [get_ports {time_hours[0]}]
set_output_delay -clock [get_clocks v_clk] -add_delay 3.0 [get_ports {time_minutes[5]}]
set_output_delay -clock [get_clocks v_clk] -add_delay 3.0 [get_ports {time_minutes[4]}]
set_output_delay -clock [get_clocks v_clk] -add_delay 3.0 [get_ports {time_minutes[3]}]
set_output_delay -clock [get_clocks v_clk] -add_delay 3.0 [get_ports {time_minutes[2]}]
set_output_delay -clock [get_clocks v_clk] -add_delay 3.0 [get_ports {time_minutes[1]}]
set_output_delay -clock [get_clocks v_clk] -add_delay 3.0 [get_ports {time_minutes[0]}]
set_output_delay -clock [get_clocks v_clk] -add_delay 3.0 [get_ports alarm]
set_output_delay -clock [get_clocks v_clk] -add_delay 3.0 [get_ports alarm_enabled]
set_max_fanout 1.000 [get_ports clk]
set_max_fanout 1.000 [get_ports rst_n]
set_max_fanout 1.000 [get_ports set_time]
set_max_fanout 1.000 [get_ports increment_hour]
set_max_fanout 1.000 [get_ports increment_minute]
set_max_fanout 1.000 [get_ports set_alarm_time]
set_max_fanout 1.000 [get_ports enable_alarm]
set_max_fanout 1.000 [get_ports alarm_off]
set_max_transition 1.5 [current_design]
set_max_capacitance 0.2 [current_design]
set_input_transition -rise 0.1 [get_ports clk]
set_input_transition -fall 0.12 [get_ports clk]
set_input_transition -rise 0.1 [get_ports rst_n]
set_input_transition -fall 0.12 [get_ports rst_n]
set_input_transition -rise 0.1 [get_ports set_time]
set_input_transition -fall 0.12 [get_ports set_time]
set_input_transition -rise 0.1 [get_ports increment_hour]
set_input_transition -fall 0.12 [get_ports increment_hour]
set_input_transition -rise 0.1 [get_ports increment_minute]
set_input_transition -fall 0.12 [get_ports increment_minute]
set_input_transition -rise 0.1 [get_ports set_alarm_time]
set_input_transition -fall 0.12 [get_ports set_alarm_time]
set_input_transition -rise 0.1 [get_ports enable_alarm]
set_input_transition -fall 0.12 [get_ports enable_alarm]
set_input_transition -rise 0.1 [get_ports alarm_off]
set_input_transition -fall 0.12 [get_ports alarm_off]
set_wire_load_mode "enclosed"
set_clock_latency  0.6 [get_clocks clk]
set_clock_uncertainty -setup 0.6 [get_clocks clk]
set_clock_uncertainty -hold 0.4 [get_clocks clk]
