`timescale 1ns / 1ps 

module increment_time(
	input wire clk,
	input wire rst_n,
	input wire increment_minute_pe,
	input wire increment_hour_pe,
       	input wire set_alarm_time_pe,
	input wire set_time_pe,	
	input wire [4:0] alarm_hours, 
	input wire [5:0] alarm_minutes,
	input wire [4:0] running_hours, 
	input wire [5:0] running_minutes,
	
	output reg [4:0] inc_hours, 
	output reg [5:0] inc_minutes
	);
	

	// logic for incrementing min -> 59 and hr -> 23 on pulse edge
	always@(posedge clk or negedge rst_n) begin 
		if (!rst_n) begin
			inc_minutes  <= 6'b000000;
			inc_hours    <= 5'b00000;
		end else if (set_time_pe) begin
			inc_hours    <= running_hours;
			inc_minutes  <= running_minutes;	
		end else if (set_alarm_time_pe) begin
			inc_hours    <= alarm_hours;
			inc_minutes  <= alarm_minutes;
		end else if (increment_minute_pe) begin
			if (inc_minutes == 6'b111011) begin
				inc_minutes  <= 1'b0;
			end else begin
				inc_minutes  <= inc_minutes + 6'b000001;
			end
		end else if (increment_hour_pe) begin
			if (inc_hours == 5'b10111) begin
				inc_hours    <= 1'b0;
			end else begin
				inc_hours    <= inc_hours + 5'b00001;
			end
		end
	end

endmodule
