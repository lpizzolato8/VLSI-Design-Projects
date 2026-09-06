`timescale 1ns / 1ps

module main(
	
	input wire clk,
	input wire rst_n,
	input wire set_time,
	input wire increment_hour,
	input wire increment_minute,
	input wire set_alarm_time,
	input wire enable_alarm,
	input wire alarm_off,
	
	output reg [4:0] time_hours,
	output reg [5:0] time_minutes,
	output reg alarm,
	output reg alarm_enabled
	);

	always@(posedge clk & negedge rst_n)	
	begin 
		if (rst_n) begin
			time_minutes [5:0] <= 6'b000000;
			time_hours   [4:0] <= 5'b00000;
		end

		if (enable_alarm) begin
			alarm_enabled      <= !alarm_enabled;
		end

		if (alarm_off) begin
			alarm 		   <= !alarm;
		end	
	end

	always@(*)





	begin


