`timescale 1ns / 1ps

module running_time(
	input wire clk,
	input wire rst_n,
	input wire set_time,
	input wire inc_hours, 
	input wire inc_minutes,

	output reg [4:0] running_hours, 
	output reg [5:0] running_minutes
	
	);

	reg [2:0] counter;
	reg [5:0] seconds;
	
	always@(posedge clk) begin
		if (!rst_n) begin 				//required so all values are reset when rst_n flag is triggered
			counter 	<= 6'b000000;
			seconds 	<= 6'b000000;
			running_minutes <= 6'b000000;
			running_hours   <= 5'b00000;
		end else if (set_time) begin // if set_time is high then make new time the output of func2 (increment_time submodule) 
			running_hours   <= inc_hours;
			running_minutes <= inc_minutes;
			counter 	<= 6'b000000;
			seconds 	<= 6'b000000;	
		end else if (seconds == 6'b111011) begin	// if you hit 59 seconds -> sec = 0 
			seconds <= 6'b000000;
			if (minutes == 6'b111011) begin		// if you hit 59 minutes -> minutes = 0
				minutes <= 6'b000000;				
				if (hours == 5'b10111) begin 	// if you hit 23 hours -> hours = 0
					hours <= 5'b00000;
				end else begin			// otherwise hours -> +1
					hours <= hours + 5'b000001;
				end
			end 
		end else if (counter == 3'b111) begin 		// if # of clks = 7 -> sec +1
			counter <= 3'b000;
			seconds <= seconds + 6'b000001;
		end else begin
			counter <= counter + 3'b001; 		// every clk cycle increment by 1
		end
	end
