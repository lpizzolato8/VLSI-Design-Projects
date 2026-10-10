`timescale 1ns / 1ps

// Testcase Ideas: demonstrate reset when in1 and in2 have values in them
// 				   
//				   

module code3_tb(

	);

	// instantiate code3 module var
	reg clk;
	reg rst_n; 
	reg in1;
	reg in2; 
	
	wire out1; 
	wire out2;

	// instantiate helper variables 	
	reg[(30*8)-1:0] testcase;
	reg [7:0] error_count = 8'b00000000;

	code3 DUT(
		.clk(clk),
		.rst_n(rst_n),
		.in1(in1),
		.in2(in2),
		.out1(out1),
		.out2(out2)
	);

	// initialize the clk to 5 time units -> 100MHz
	initial clk    = 0; 
	always #5 clk = ~clk;
		
	// task to cycle through n clk
	task tick(input integer n); begin
		repeat (n)  @(posedge clk);	// using repeat (n) to have task repeat @(posedge clk) for n amount of times
 		#1;
	end endtask
	
	// task to facilitate reset 
	task reset;  begin
		{in1,in2} = 2'b0;
		rst_n = 0; tick(3);
		@(negedge clk) rst_n = 1; tick(2); 
	end endtask


	initial begin

		$monitor("Testcase %s : Time = %t", testcase, $time);


		reset;
 
		testcase = "Test Reset";
 
		// initialize both inputs to 1, then again after 1 clk cycle, then check that all values have been stored
		in1 = 1'b1;
		in2 = 1'b1;
 
		tick(1);
 
		in1 = 1'b1;
		in2 = 1'b1;
 
		tick(1);
 
		error_count = compare_outputs(1'b1, DUT.mid1, "mid1 = 1'b1", error_count);
		error_count = compare_outputs(1'b1, out1,     "out1 = 1'b1", error_count);
		error_count = compare_outputs(1'b1, DUT.mid2, "mid2 = 1'b1", error_count);
		error_count = compare_outputs(1'b1, out2,     "out2 = 1'b1", error_count);
 
		// check if rst functions
		rst_n = 1'b0;
		#1;
 
		error_count = compare_outputs(1'b0, DUT.mid1, "mid1 = 1'b0", error_count);
		error_count = compare_outputs(1'b0, out1,     "out1 = 1'b0", error_count);
		error_count = compare_outputs(1'b0, DUT.mid2, "mid2 = 1'b0", error_count);
		error_count = compare_outputs(1'b0, out2,     "out2 = 1'b0", error_count);
 
		reset;
 
		error_count = compare_outputs(1'b0, DUT.mid1, "mid1 = 1'b0", error_count);
		error_count = compare_outputs(1'b0, out1,     "out1 = 1'b0", error_count);
		error_count = compare_outputs(1'b0, DUT.mid2, "mid2 = 1'b0", error_count);
		error_count = compare_outputs(1'b0, out2,     "out2 = 1'b0", error_count);
 
		// buffer tick
		tick(2);
 
 
		testcase = "Full Cycle";
 
		// set both inputs to 1, check after 1 clock
		in1 = 1'b1;
		in2 = 1'b1;
 
		tick(1);
 
		error_count = compare_outputs(1'b1, DUT.mid1, "mid1 = 1'b1", error_count);
		error_count = compare_outputs(1'b0, out1,     "out1 = 1'b0", error_count);
		error_count = compare_outputs(1'b1, DUT.mid2, "mid2 = 1'b1", error_count);
		error_count = compare_outputs(1'b0, out2,     "out2 = 1'b0", error_count);
 
		// drop inputs: mid goes to 0, the 1 moves to out
		in1 = 1'b0;
		in2 = 1'b0;
 
		tick(1);
 
		error_count = compare_outputs(1'b0, DUT.mid1, "mid1 = 1'b0", error_count);
		error_count = compare_outputs(1'b1, out1,     "out1 = 1'b1", error_count);
		error_count = compare_outputs(1'b0, DUT.mid2, "mid2 = 1'b0", error_count);
		error_count = compare_outputs(1'b1, out2,     "out2 = 1'b1", error_count);
 
		tick(1);
 
		// pipeline drained
		error_count = compare_outputs(1'b0, DUT.mid1, "mid1 = 1'b0", error_count);
		error_count = compare_outputs(1'b0, out1,     "out1 = 1'b0", error_count);
		error_count = compare_outputs(1'b0, DUT.mid2, "mid2 = 1'b0", error_count);
		error_count = compare_outputs(1'b0, out2,     "out2 = 1'b0", error_count);
 
		// buffer tick
		tick(2);


 		testcase = "Individual Pipes";
 
		// cycle 1: in1 = 1, in2 = 0 -> only mid1 is 1
		in1 = 1'b1;
		in2 = 1'b0;
 
		tick(1);
 
		error_count = compare_outputs(1'b1, DUT.mid1, "mid1 = 1'b1", error_count);
		error_count = compare_outputs(1'b0, out1,     "out1 = 1'b0", error_count);
		error_count = compare_outputs(1'b0, DUT.mid2, "mid2 = 1'b0", error_count);
		error_count = compare_outputs(1'b0, out2,     "out2 = 1'b0", error_count);
 
		// cycle 2: in2 = 1, in2 = 0 -> out1 and mid2 are 1
		in1 = 1'b0;
		in2 = 1'b1;
 
		tick(1);
 
		error_count = compare_outputs(1'b0, DUT.mid1, "mid1 = 1'b0", error_count);
		error_count = compare_outputs(1'b1, out1,     "out1 = 1'b1", error_count);
		error_count = compare_outputs(1'b1, DUT.mid2, "mid2 = 1'b1", error_count);
		error_count = compare_outputs(1'b0, out2,     "out2 = 1'b0", error_count);
 
		// cycle 3: inputs low -> only out2 is 1
		in1 = 1'b0;
		in2 = 1'b0;
 
		tick(1);
 
		error_count = compare_outputs(1'b0, DUT.mid1, "mid1 = 1'b0", error_count);
		error_count = compare_outputs(1'b0, out1,     "out1 = 1'b0", error_count);
		error_count = compare_outputs(1'b0, DUT.mid2, "mid2 = 1'b0", error_count);
		error_count = compare_outputs(1'b1, out2,     "out2 = 1'b1", error_count);
 
		// buffer tick
		tick(2);
 
 
 
 
		// final pass/fail count
		if (error_count == 0) begin
			$display("\n\n----------SIMULATION PASSED----------");
			$display("----------RTL SIMULATION   ----------\n\n");
		end else begin
			$display("\n\n----------SIMULATION FAILED----------");
			$display("----------RTL SIMULATION   ----------");
			$display("---------- %d ERRORS TOTAL----------\n\n", error_count);
		end
		$finish;
 
	end

	// pass/fail comparison
		function  [7:0] compare_outputs (
			input [7:0]    expected_value,
			input [7:0]    actual_value,
			input [8*19:0] signal_name,
			input [7:0]    error_count);
			if (expected_value == actual_value) begin
				$display("  PASS  : %s: Expected = %h, Actual = %h, Time = %t",
			         signal_name, expected_value, actual_value, $time);
				compare_outputs = error_count;
			end else begin
				$display("**FAIL**: %s: Expected = %h, Actual = %h, Time = %t",
			         signal_name, expected_value, actual_value, $time);
				compare_outputs = error_count + 1;
			end
		endfunction


endmodule
