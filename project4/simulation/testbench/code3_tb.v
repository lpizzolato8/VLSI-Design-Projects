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
		
	
	task 
	
	// task to facilitate reset 
	task reset;  begin
		{in1,in2} = 1'b0;
		@negedge 
	end endtask


	initial begin



	end

endmodule
