`timescale 1ns / 1ps


module code3_tb(

	);

	// instantiate code3 module variables
	
	reg clk, 
	reg rst_n, 
	reg in1, 
	reg in2, 
	
	wire out1, 
	wire out2,

	// instantiate helper variables 	
	reg[(20*8)-1:0] testcase,
	reg [7:0] error_count = 8'b00000000
	
	);

	code3 DUT(
		.clk(clk),
		.rst_n(rst_n),
		.in1(in1),
		.in2(in2),
		.out1(out1),
		.out2(out2)
	);

	// initialize the clk to 5 time units -> 5Mhz
	initial clk    = 0; 
	always #5 clk = ~clk;
		
	// task to cycle through 1 clk
	task tick(input integer n); begin
		repeat (n)  @(posedge clk);	// using repeat (n) to have task repeat @(posedge clk) for n amount of times
 		#1 
	end endtask
	
	// task to facilitate reset 
	task reset;  begin
		{in1,in2} = 1'b0;
		rst_n = 0; tick(3);
		@(negedge clk) rst_n = 1; tick(2); 
	end endtask


	initial begin


	$monitor
	
	end

endmodule
