`timescale 1ns / 1ps

module main(
	 
	input wire clk,                  // 8Hz clock signal
	input wire rst_n,		 // active-low asynchrnous reset
	input wire set_time,		 //
	input wire increment_hour,	 // increment by 1 each clock cycle
	input wire increment_minute,	 // increment by 1 each clock cycle
	input wire set_alarm_time,	 // 
	input wire enable_alarm,	 // enable/disable alarm
	input wire alarm_off,
	
	output reg [4:0] time_hours,
	output reg [5:0] time_minutes,
	output reg alarm,		 // active when alarm is going
	output reg alarm_enabled	 // indicates if alarm is enabled/disabled
	);
	
	// wires for the submodule connections
	wire [4:0] inc_hours, running_hours;
	wire [5:0] inc_minutes, running_minutes;

	// reg for alarm tracking 
	reg  [4:0] alarm_hours;
	reg  [5:0] alarm_minutes;	

	// edge detection registers
	reg increment_hour_q, increment_minute_q, enable_alarm_q, set_time_q, set_alarm_time_q; 	// _p  -> previous signal 

	// edge detection pulses
	wire increment_hour_pe, increment_minute_pe, enable_alarm_pe, set_time_pe, set_alarm_time_pe;	// _pe -> rising pulse edge
	

	// submodule for incrementing time (set_time and set_alarm_time)
	increment_time func1(
        	.clk(clk),
        	.rst_n(rst_n),
		// feed pulses through to keep edge detection throughout
        	.increment_hour_pe(increment_hour_pe),
        	.increment_minute_pe(increment_minute_pe),
		.running_hours(running_hours),
		.running_minutes(running_minutes),
		.alarm_hours(alarm_hours),
		.alarm_minutes(alarm_minutes),
		
		.inc_hours(inc_hours), 
		.inc_minutes(inc_minutes)
	);

	// submodule for tracking running time and setting new time
	running_time func2(
		.clk(clk),
		.rst_n(rst_n),	
		.set_time(set_time),
		.inc_hours(inc_hours),
		.inc_minutes(inc_minutes),
		.set_time_pe(set_time_pe),
		.set_alarm_time_pe(set_alarm_time_pe),
		
		.running_hours(running_hours),
		.running_minutes(running_minutes)
	);	

	// edge detection block -> dflipflop
	always@(posedge clk or negedge rst_n) begin
   		if (!rst_n) begin
        		increment_hour_q   <= 1'b0;
        		increment_minute_q <= 1'b0;
        		enable_alarm_q     <= 1'b0;
			set_time_q	   <= 1'b0;
			set_alarm_time_q   <= 1'b0;
    		end else begin // current value is stored in prev value reg on the next clock cycle due to blocking assignment
        		increment_hour_q   <= increment_hour;
        		increment_minute_q <= increment_minute;
        		enable_alarm_q     <= enable_alarm;
			set_time_q	   <= set_time;
			set_alarm_time_q   <= set_alarm_time;
		end
	end
	// only changes when both values are different -> when high is sent
	// 1&&!0 therefore 1 -> then check the next value 1&&!1 therfore 0 ->
	// when low is then sent 0&&!1 therefore 0 (always running (ignore clk)) 
	wire increment_hour_pe   = increment_hour   && !increment_hour_q;
	wire increment_minute_pe = increment_minute && !increment_minute_q;
	wire enable_alarm_pe     = enable_alarm     && !enable_alarm_q;
	wire set_time_pe         = set_time         && !set_time_q;
	wire set_alarm_time_pe	 = set_alarm_time   && !set_alarm_time_q;


	// alarm logic block
	always@(posedge clk or negedge rst_n) begin 
		if (!rst_n) begin
			alarm 	      <= 1'b0;
			alarm_enabled <= 1'b0;
		end else if (enable_alarm_pe) begin 			// if pressed toggle alarm on/off
			alarm_enabled <= !alarm_enabled;
		end else if (alarm_off) begin			// if pressed means snooze alarm (wont do anything unless alarm is going)
			alarm <= 1'b0;
		end else if(alarm_enabled && alarm_hours == running_hours && alarm_minutes == running_minutes) begin //logic block for alarm turning on
			alarm <= 1'b1;
		end
	end
	
	// timekeeping block
	always@(posedge clk or negedge rst_n) begin 
		if (!rst_n) begin
			time_minutes  <= 6'b000000;
			time_hours    <= 5'b00000;
			alarm_hours   <= 5'b00000;
			alarm_minutes <= 6'b000000;
		end else if (set_time) begin
			time_hours    <= inc_hours;
			time_minutes  <= inc_minutes;		
		end else if (set_alarm_time) begin
			alarm_hours   <= inc_hours;
			alarm_minutes <= inc_minutes;
			time_hours    <= inc_hours;
			time_minutes  <= inc_minutes;					
		end else begin 
			time_hours    <= running_hours;
			time_minutes  <= running_minutes;
		end
	end
	
end
