`timescale 1ns / 1ps

module running_time(
	input wire clk,
	input wire rst_n,
	input wire set_time,
	
	output reg [4:0] hours, 
	output reg [5:0] minutes
	);

	always@(posedge clk) begin
		if (!rst_n) begin

		end else () begin
	
		end
	end
