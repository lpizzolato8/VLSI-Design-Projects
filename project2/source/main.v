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
	
	// temp var for methods -> used to load times between main & submod
	wire [4:0] inc_hours;
	wire [5:0] inc_minutes;
	wire [4:0] running_hours; 
	wire [5:0] running_minutes;
	reg  [4:0] alarm_hours; 
	reg  [5:0] alarm_minutes;
		
	increment_time func1(
		.clk(clk),
		.rst_n(rst_n),
		.increment_hour(increment_hour), 
		.increment_minute(increment_minute), 
		
		.time_hours(inc_hours), 
		.time_minutes(inc_minutes)
	);

	running_time func2(
		.clk(clk),
		.rst_n(rst_n),	
		.set_time(set_time),
		.inc_hours(inc_hours),
		.inc_minutes(inc_minutes),
		
		.time_hours(running_hours),
		.time_minutes(running_minutes)
	);

	// reset block
	always@(posedge clk or negedge rst_n) begin 
		if (!rst_n) begin
			time_minutes  <= 6'b000000;
			time_hours    <= 5'b00000;
			alarm         <= 1'b0;
			alarm_enabled <= 1'b0;
		end
	end

	// timekeeping block
	always@(posedge clk or negedge rst_n) begin 
		if (set_time) begin
			time_hours   <= running_hours;
			time_minutes <= running_minutes;		
		end
		if (set_alarm_time) begin


		end
	end	
	
	// alarm logic block
	always@(posedge clk or negedge rst_n) begin 
		if (enable_alarm) begin 			// if pressed toggle alarm on/off
			alarm_enabled <= !alarm_enabled;
		end else if (alarm_off) begin			// if pressed means snooze alarm (wont do anything unless alarm is going)
			alarm <= 1'b0;
		end else if(alarm_enabled && alarm_hours == running_hours && alarm_minutes == running_minutes) begin //logic block for alarm turning on
			alarm <= 1'b1;
		end
	end
	
	// display mux
	always@(*) begin
		
			end

	
end
