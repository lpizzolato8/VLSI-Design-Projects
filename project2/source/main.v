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


	increment_time func1(
		.clk(clk),
		.rst_n(rst_n),
		.increment_hour(increment_hour), 
		.increment_minute(increment_minute), 
		.time_hours(time_hours), 
		.time_minutes(time_minutes)
	);

	running_time func2(
		.clk(clk),
		.rst_n(rst_n),	
		.set_time(set_time),

		.time_hours(time_hours),
		.time_minutes(time_minutes)
	);


	always@(posedge clk & negedge rst_n)	
	begin 
		if (rst_n) begin
			time_minutes [5:0] <= 6'b000000;
			time_hours   [4:0] <= 5'b00000;
			alarm 		   <= 1'b0;
		end
	end

	always@(posedge clk) begin
		

			
		if (enable_alarm) begin
			alarm_enabled      = !alarm_enabled;
		end else if (alarm_off) begin
			alarm 		   = 1'b0;
		end else if (set_time)  begin
		
		end else begin		
			func2();
		end
		
		
	end
