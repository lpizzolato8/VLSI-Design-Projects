`timescale 1ns / 1ps

module main_tb();

	// var instantiation
	reg clk;
	reg rst_n;
	reg set_time;
	reg increment_hour;
	reg increment_minute;
	reg set_alarm_time;
	reg enable_alarm;	
	reg alarm_off;
	reg [7:0] error_count = 8'h00;
	
	wire [4:0] time_hours;
	wire [5:0] time_minutes; 
	wire alarm;
	wire alarm_enable;

	reg [(20*8)-1:0] testcase;

	// clk per min & clk per hr
	localparam integer MIN  = 480;
	localparam integer HOUR = 28800;
	
	// var to hold pass/fail count
	integer pass = 0, fail = 0;
	integer h0;  
	reg [5:0] m0;
	integer i;
	
	// instantiate main
 	main dut (
  		.clk(clk),
    		.rst_n(rst_n),
    		.set_time(set_time),
    		.increment_hour(increment_hour),
    		.increment_minute(increment_minute),
    		.set_alarm_time(set_alarm_time),
    		.enable_alarm(enable_alarm),
    		.alarm_off(alarm_off),
    		.time_hours(time_hours),
    		.time_minutes(time_minutes),
    		.alarm(alarm),
    		.alarm_enabled(alarm_enabled)
	);

	initial clk = 0;
	always #5 clk = ~clk;
	
 
    	// helper functions


	// helper function to make the clock run for n clock edges
	task tick(input integer n); integer i; begin for(i=0;i<n;i=i+1) @(posedge clk); end endtask

	// helper function that simulates pressing the reset button at the start. Needs to assign the inputs as 0 before beginning testing
    	task reset; begin
        	{set_time,increment_hour,increment_minute,set_alarm_time,enable_alarm,alarm_off} = 0;
        	rst_n = 0; tick(3); @(negedge clk) rst_n = 1; tick(2);
    	end endtask
 
   	// helper function that simulates buttons being pressed once. DFF in the main code samples on the positive edge thus changing value on the negative edge to avoid the
	// the signal begin lost to the dff
    	task press_hr;  begin 
		@(negedge clk) increment_hour   = 1;   
		@(negedge clk) increment_hour   = 0;   
	end endtask
    	task press_min; begin 
		@(negedge clk) increment_minute = 1; 
		@(negedge clk) increment_minute = 0; 
	end endtask
    	task press_en;  begin 
		@(negedge clk) enable_alarm     = 1;     
		@(negedge clk) enable_alarm     = 0;     
	end endtask
 
	initial begin
        
	$monitor("Testcase %s : Time = %t", testcase, $time);
        // start with everything at 0 then rst
	{set_time,increment_hour,increment_minute,set_alarm_time,enable_alarm,alarm_off} = 0; 
	rst_n = 1;
 
        // Requirements 1 : reset functionality & alarm off
        testcase = "Reset";
	
	// rst before to initialize reg

	reset;

	// preload values
	tick(10*MIN);
	tick(2*HOUR);
	press_en; 
	
	// check if nonzero
	error_count = compare_outputs(8'd2,  time_hours,    "time_hours_preload",    error_count); 
	error_count = compare_outputs(8'd10, time_minutes,  "time_minutes_preload",  error_count); 
	error_count = compare_outputs(8'd01, alarm_enabled, "alarm_enabled_preload", error_count); 
	
	// start alarm set stage
	set_alarm_time = 1; 
	tick(2);
        
	// alarm time +1 hr
	h0 = time_hours;   
	press_hr;  
	tick(2);
        
	set_alarm_time = 0;
	reset;
        
	// checks if all values are set to their default 0
	error_count = compare_outputs(8'd00, time_hours,    "time_hours",    error_count);
        error_count = compare_outputs(8'd00, time_minutes,  "time_minutes",  error_count);
        error_count = compare_outputs(8'd00, alarm,         "alarm",         error_count);
        error_count = compare_outputs(8'd00, alarm_enabled, "alarm_enabled", error_count);
	
        // Req2 : min wraps around
        testcase = "Minute_tick";
	reset;
	// min +1
        tick(MIN);                               
        
	error_count = compare_outputs(8'd1, time_minutes, "time_minutes", error_count); // exactly 01
        
 	
        // Req3 : hour wraps after 60 min
        testcase = "Hour_tick";
        reset;

	// min +59
	tick(59*MIN);
                        
        // at 00:59?
	error_count = compare_outputs(8'd59, time_minutes, "time_minutes", error_count); // sit at 00:59
        error_count = compare_outputs(8'd0,  time_hours,   "time_hours",   error_count);
        
	// min +1 to wrap around
	tick(MIN); 

	// at 01:00?
        error_count = compare_outputs(8'd0,  time_minutes, "time_minutes", error_count); 
        error_count = compare_outputs(8'd1,  time_hours,   "time_hours",   error_count); 
        
	// Requirement 4 : run 25 h, then confirm the time is valid
        testcase = "Run_25hrs";
	reset;	
	// use for loop to run through entire 25hrs and check validity of time values
	for (i = 0; i < 25; i = i + 1) begin
            tick(HOUR);                          
            error_count = compare_outputs(8'd01, (time_hours<=23 && time_minutes<=59), "time_valid", error_count);
        end

   
        // Requirement 5/6 : set_time + increment buttons
        testcase = "Set_time";
        reset; 
	
	set_time=1; 
	tick(2);
        
	// increment hours
	h0 = time_hours;   
	press_hr;  
	tick(2);
       
	// hr +1 ? 
	error_count = compare_outputs(h0+1, time_hours,   "time_hours",   error_count);
        
	// increment minutes once, save prev value
	m0 = time_minutes; 
	press_min; 
	tick(2);
        
	// min +1?
	error_count = compare_outputs(m0+1, time_minutes, "time_minutes", error_count);
        set_time=0;
        
	// save prev value
	m0 = time_minutes; 
	
	// starts on next clk so it needs +8 to the total min to get it on the next cycle
	tick(MIN+8);
        
	// min +1?
	error_count = compare_outputs(m0+1, time_minutes, "time_minutes", error_count);
 
        // Requirement 7/8/9 : set_alarm_time output and change alarm, real time keeps running
        testcase = "Set_alarm";
        reset; 
	
	// start alarm set stage
	set_alarm_time=1; 
	tick(2);
        
	// alarm time +1 hr
	h0 = time_hours;   
	press_hr;  
	tick(2);
        
	// hr alarm +1?
	error_count = compare_outputs(h0+1, time_hours,   "time_hours",   error_count);
        
	// alarm time +1 minute
	m0 = time_minutes; 
	press_min; 
	tick(2);
        
	// minute alarm +1?
	error_count = compare_outputs(m0+1, time_minutes, "time_minutes", error_count);
                
	// hold the clock in the alarm set stage for 2 minutes to determine if time keeps running
	tick(2*MIN);                        
        set_alarm_time = 0; 
	tick(2);
        
	// time was increasing while held in alarm set stage?
	error_count = compare_outputs(8'd00, time_hours,        "time_hours",    error_count);
        error_count = compare_outputs(8'd01, (time_minutes>=1), "time_advanced", error_count);
 
        // Requirement 10 : enable_alarm toggles alarm_enabled
        testcase = "Enable_alarm";
        reset;
        
	// turn alarm on
	press_en; 
	tick(2);
        
	// alarm on?
	error_count = compare_outputs(8'd01, alarm_enabled, "alarm_enabled", error_count);
        
	// alarm off
	press_en; 
	tick(2);
        
	// alarm off?
	error_count = compare_outputs(8'd00, alarm_enabled, "alarm_enabled", error_count);
 
        // Requirement 11 : alarm fires when alarm matches running time then alarm_off snoozes it
        testcase = "Alarm->Snooze";
        reset;
        
	// set time to 00:02
	set_alarm_time=1;
	tick(2); 
	press_min; 
	press_min; 
	tick(2); 
        
	// turn on alarm and run clock past the set alarm time to trigger
	set_alarm_time=0; 
	tick(2);
        press_en; 
	tick(2);                       
        tick(3*MIN);        

	
        // alarm on?, then simulates snooze button, alarm snoozed? 
	error_count = compare_outputs(8'd01, alarm, "alarm", error_count);
        @(negedge clk) alarm_off=1; 
	tick(2); 
	@(negedge clk) alarm_off=0; 
	tick(2);
        error_count = compare_outputs(8'd00, alarm, "alarm", error_count);
 
        // final pass/fail count
        if (error_count == 0) begin
            $display("\n\n----------SIMULATION PASSED----------");
            $display("----------RTL SIMULATION   ----------\n\n");
        end else begin
            $display("\n\n----------SIMULATION FAILED----------");
            $display("----------RTL SIMULATION   ----------");
            $display("---------- %d ERRORS TOTAL----------\n\n", error_count);
        end
        $finish;
    end
 
    // pass/fail comparison
    function  [7:0] compare_outputs (
        input [7:0]    expected_value,
        input [7:0]    actual_value,
        input [8*19:0] signal_name,
        input [7:0]    error_count);
        if (expected_value == actual_value) begin
            $display("  PASS  : %s: Expected = %h, Actual = %h, Time = %t",
                     signal_name, expected_value, actual_value, $time);
            compare_outputs = error_count;
        end else begin
            $display("**FAIL**: %s: Expected = %h, Actual = %h, Time = %t",
                     signal_name, expected_value, actual_value, $time);
            compare_outputs = error_count + 1;
        end
    endfunction
endmodule
