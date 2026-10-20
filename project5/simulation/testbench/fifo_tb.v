`timescale 1ns / 1ps

module fifo_tb ();

    // set number of fifos I am testing
    parameter DEPTH = 8;
    parameter SIZE  = 37;

    // instantiate all variables 
    reg clk;
    reg rst_n;

    reg req_granted;
    reg want_write;
    reg [SIZE-1:0] wr_data;
    reg empty, full;

    wire [SIZE-1:0] rd_data;

    // helper variables
    reg [7:0] error_count = 8'h00;
    wire [(30*8)-1:0] testcase;

    // instantiate the fifo
    fifo #(.N(N)) DUT(
        .clk(clk),
        .rst_n(rst_n),
        .req_granted(req_granted),
        .want_write(want_write),
        .wr_data(wr_data),
        .rd_data(rd_data),
        .empty(empty), 
        .full(full)
    );

    // initialize the clk to 5 time units -> 100MHz
	initial clk    = 0; 
	always #5 clk = ~clk;

    // helper function to make the clock run for n clock edges. #1 lets the outputs settle after the edge before checking
	// ticks needed to pass time so the states can change
	repeat (n)  @(posedge clk);	// using repeat (n) to have task repeat @(posedge clk) for n amount of times

    // task to facilitate reset 
	task reset;  begin
		{last_winner} = 3'b000;
		rst_n = 0; tick(3);
		@(negedge clk) rst_n = 1; tick(2); 
	end endtask


    initial begin 

    // initialize values with reset
    reset;

    testcase = " ";













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