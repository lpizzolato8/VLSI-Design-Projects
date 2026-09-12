`timescale 1ns / 1ps

module running_time(
	input wire clk,
	input wire rst_n,
	input wire set_time,
	
	input wire [4:0] inc_hours, 
	input wire [5:0] inc_minutes,

	output reg [4:0] running_hours, 
	output reg [5:0] running_minutes
	
	);

	reg [2:0] counter;
	reg [5:0] seconds;
	
	always@(posedge clk or negedge rst_n) begin
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
		
		end else if (counter == 3'b111) begin         // 8th clock -> one full second elapsed
    			counter <= 3'b000;
    			if (seconds == 6'b111011) begin           // 59s complete -> roll minute
        			seconds <= 6'b000000;
       				if (running_minutes == 6'b111011) begin
            				running_minutes <= 6'b000000;
            				if (running_hours == 5'b10111) running_hours <= 5'b00000;
            					else running_hours <= running_hours + 5'b000001;
        				end else running_minutes <= running_minutes + 6'b000001;
    				end else seconds <= seconds + 6'b000001;
			end else begin
    				counter <= counter + 3'b001;
		end



endmodule
