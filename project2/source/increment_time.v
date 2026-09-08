`timescale 1ns / 1ps 

module increment_time(
	input wire clk,
	input wire rst_n,
	input wire increment_minute,
	input wire increment_hour, 

	output reg [4:0] hours, 
	output reg [5:0] minutes
	);


	always@(posedge clk & negedge rst_n)	
	begin 
		if (!rst_n) begin
			minutes  <= 6'b000000;
			hours    <= 5'b00000;
		end else if (increment_minute) begin
			minutes  <= minutes + 6'b000001;
		end else if (increment_hour) begin
			hours    <= hours + 5'b00001;
		end
	end


