`timescale 1ns / 1ps

module main_tb();

	// var instantiation
	reg clk;
	reg rst_n;
	
	reg [7:0] error_count = 8'h00;
	reg [(20*8)-1:0] testcase;
	
	// var to hold pass/fail count
	integer pass = 0, fail = 0;
	integer h0;  
	reg [5:0] m0;
	integer i;
	
	// instantiate main
 	main dut (
  		.clk(clk),
    		.rst_n(rst_n),
	);

	initial clk = 0;
	always #5 clk = ~clk;
	
 
    	// helper functions

	// helper function that simulates pressing the reset button at the start. Needs to assign the inputs as 0 before beginning testing
    	task reset; begin
        	{} = 0;
        	rst_n = 0;  @(negedge clk) rst_n = 1; 
    	end endtask
 

	initial begin
        
	$monitor("Testcase %s : Time = %t", testcase, $time);
            










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
