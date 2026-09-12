`timescale 1ns / 1ps

#(720000 * 10) $finish;

module main_tb();

	// var instantiation
	reg clk,
	reg rst_n,
	reg set_time,
	reg increment_hour,
	reg increment_minute,
	reg set_alarm_time, 
	reg enable_alarm, 	
	reg alarm_off,
	reg [7:0] error_count = 8'h00;


		
	wire [4:0] time_hours, 
	wire [5:0] time_minutes, 
	wire alarm,
	wire alarm_enable,
	
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


	always #5 clk = ~clk;
	
	initial begin 
	
	// test reset functions
	
		// set reset high 
		rst_n = 1'b0;
		
		#10
		
		// set reset low
		rst_n = 0'b0;

		#10
				
		always @(posedge clk) begin
        		if (rst_n) begin
            			if (time_hours > 23) begin
                			$display("[%0t] ERROR (Requirement 4): time_hours=%0d out of range", $time, time_hours);
                			error_count = error_count + 1;
            			end if (time_minutes > 59) begin
                			$display("[%0t] ERROR (Requirement 4): time_minutes=%0d out of range", $time, time_minutes);
                			error_count = error_count + 1;
            			end
        		end
    		end
	



	end








endmodule : main_tb

