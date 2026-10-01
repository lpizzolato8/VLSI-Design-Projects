# Cadence Genus(TM) Synthesis Solution, Version 25.10-p002_1, built Apr 17 2025 15:35:38

# Date: Thu Oct 01 19:15:32 2026
# Host: shell01 (x86_64 w/Linux 4.18.0-553.158.1.el8_10.x86_64) (14cores*56cpus*2physical cpus*Intel(R) Xeon(R) Gold 6132 CPU @ 2.60GHz 19712KB)
# OS:   Rocky Linux 8.10 (Green Obsidian)

set CLK_PERIOD 10.00
set CLK_LATENCY 0.60
set CLK_SKEW 0.40
set CLK_JITTER 0.20
set SETUP_UNCERTAINTY [expr $CLK_SKEW + $CLK_JITTER]
set INPUT_DELAY 3.00
set OUTPUT_DELAY 3.00
  
create_clock clk -period $CLK_PERIOD -waveform {0.0 5.0}
set_clock_latency $CLK_LATENCY clk
set_clock_uncertainty -setup $SETUP_UNCERTAINTY clk
set_clock_uncertainty -hold $CLK_SKEW clk
set_clock_transition -rise 0.1 clk
set_clock_transition -fall 0.12 clk
  
create_clock -name v_clk -period $CLK_PERIOD -waveform {0.0 5.0}
  
set_max_transition 1.5 [current_design]
set_max_capacitance 0.2 [current_design]
 
set_input_delay $INPUT_DELAY -clock v_clk [remove_from_collection [all_inputs] clk]
set_max_fanout 1 [all_inputs]
set_input_transition -rise 0.1 [all_inputs]
set_input_transition -fall 0.12 [all_inputs]
  
set_output_delay $OUTPUT_DELAY -clock v_clk [all_outputs]
set_load 0.02 [all_outputs]
set DESIGN "program_counter"
   
   
   
set_db init_lib_search_path /apps/design_kits/ibm_kits/IBM_IP/ibm_cmos8hp/std_cell/sc/v.20110613/synopsys/ss_125/
set_db library IBM_CMOS8HP_SS125.lib
set_db init_hdl_search_path ../../source
  
read_hdl program_counter.v
  
  
elaborate ${DESIGN}
source ../constraints/constraints_${DESIGN}.tcl
  
uniquify ${DESIGN} -verbose
check_design
  
set_db syn_generic_effort medium
set_db syn_map_effort medium
  
syn_generic
syn_map
  
report_timing -max_paths 5 -from clk -to clk > ../reports/${DESIGN}_timing.rpt
report_gates > ../reports/${DESIGN}_gates.rpt
report_area > ../reports/${DESIGN}_area.rpt
report_power > ../reports/${DESIGN}_power.rpt
report_design > ../reports/${DESIGN}_const.rpt
  
write_hdl > ../netlists/${DESIGN}.v
write_sdc > ../netlists/${DESIGN}.sdc
write_sdf > ../netlists/${DESIGN}.sdf
  
echo "Synthesis Complete"
 
echo "   use command 'quit' to exit"
