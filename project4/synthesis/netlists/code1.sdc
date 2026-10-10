# ####################################################################

#  Created by Genus(TM) Synthesis Solution 25.10-p002_1 on Fri Oct 09 23:49:45 EDT 2026

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design code1

create_clock -name "clk" -period 10.0 -waveform {0.0 5.0} [get_ports clk]
create_clock -name "v_clk" -period 10.0 -waveform {0.0 5.0} 
set_clock_transition -rise 0.1 [get_clocks clk]
set_clock_transition -fall 0.12 [get_clocks clk]
set_load -pin_load 0.02 [get_ports {c[1]}]
set_load -pin_load 0.02 [get_ports {c[0]}]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks v_clk] -add_delay 3.0 [get_ports rst_n]
set_input_delay -clock [get_clocks v_clk] -add_delay 3.0 [get_ports {a[1]}]
set_input_delay -clock [get_clocks v_clk] -add_delay 3.0 [get_ports {a[0]}]
set_input_delay -clock [get_clocks v_clk] -add_delay 3.0 [get_ports {b[1]}]
set_input_delay -clock [get_clocks v_clk] -add_delay 3.0 [get_ports {b[0]}]
set_input_delay -clock [get_clocks v_clk] -add_delay 3.0 [get_ports enable]
set_output_delay -clock [get_clocks v_clk] -add_delay 3.0 [get_ports {c[1]}]
set_output_delay -clock [get_clocks v_clk] -add_delay 3.0 [get_ports {c[0]}]
set_max_fanout 1.000 [get_ports clk]
set_max_fanout 1.000 [get_ports rst_n]
set_max_fanout 1.000 [get_ports {a[1]}]
set_max_fanout 1.000 [get_ports {a[0]}]
set_max_fanout 1.000 [get_ports {b[1]}]
set_max_fanout 1.000 [get_ports {b[0]}]
set_max_fanout 1.000 [get_ports enable]
set_max_transition 1.5 [current_design]
set_max_capacitance 0.2 [current_design]
set_input_transition -rise 0.1 [get_ports clk]
set_input_transition -fall 0.12 [get_ports clk]
set_input_transition -rise 0.1 [get_ports rst_n]
set_input_transition -fall 0.12 [get_ports rst_n]
set_input_transition -rise 0.1 [get_ports {a[1]}]
set_input_transition -fall 0.12 [get_ports {a[1]}]
set_input_transition -rise 0.1 [get_ports {a[0]}]
set_input_transition -fall 0.12 [get_ports {a[0]}]
set_input_transition -rise 0.1 [get_ports {b[1]}]
set_input_transition -fall 0.12 [get_ports {b[1]}]
set_input_transition -rise 0.1 [get_ports {b[0]}]
set_input_transition -fall 0.12 [get_ports {b[0]}]
set_input_transition -rise 0.1 [get_ports enable]
set_input_transition -fall 0.12 [get_ports enable]
set_wire_load_mode "enclosed"
set_clock_latency  0.6 [get_clocks clk]
set_clock_uncertainty -setup 0.6 [get_clocks clk]
set_clock_uncertainty -hold 0.4 [get_clocks clk]
