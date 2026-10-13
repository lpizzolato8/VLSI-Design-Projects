`timescale 1ns / 1ps



module arbiter_tb ();

    // set number of fifos I am testing
    parameter N = 5;

    // instantiate all variables 
    reg clk;
    reg rst_n;
    reg [N-1:0] req;

    wire [N-1:0] grant;
    wire winner_found;
    

    // helper variables
    reg [7:0] error_count = 8'h00;
    wire [(30*8)-1:0] testcase;

    // instantiate the arbiter we are testing
    arbiter #(.N(N)) DUT(
        .clk(clk),
        .rst_n(rst_n),
        .req(req),
        .grant(grant),
        .winner_found(winner_found)
    );

    // initialize the clk to 5 time units -> 100MHz
	initial clk    = 0; 
	always #5 clk = ~clk;

    // helper function to make the clock run for n clock edges. #1 lets the outputs settle after the edge before checking
	// ticks needed to pass time so the states can change
	task tick(input integer n); integer i; begin for(i=0;i<n;i=i+1) @(posedge clk); #1; end endtask 

    // task to facilitate reset 
	task reset;  begin
		{last_winner} = 3'b000;
		rst_n = 0; tick(3);
		@(negedge clk) rst_n = 1; tick(2); 
	end endtask


    initial begin 
        // initialize values with reset
        reset;

        testcase = "Rotation";

        req = 5'b10010;                      // FIFOs 4 and 1 have data
        #1;
        error_count = compare_outputs(5'b00010, grant, "grant = FIFO 1", error_count);

        tick(1);                             // FIFO 1 wins, last_winner updates
        error_count = compare_outputs(3'd1, DUT.last_winner, "last_winner = 1", error_count);
        error_count = compare_outputs(5'b10000, grant, "grant = FIFO 4", error_count);

        testcase = "Async Reset";
        rst_n = 0;
        #1;
        error_count = compare_outputs(3'd4, DUT.last_winner, "last_winner = 4", error_count);
        error_count = compare_outputs(5'b00010, grant, "grant = FIFO 1", error_count);

        //buffer cycle
        tick(2);

        // testing when fifo req is 10101;
        testcase = "Full Run";

        //buffer cycle
        tick(2);



        // a FIFO that just won should not win again while another is waiting
        testcase = "No Double Grant";
        reset;                                   // last_winner = 4

        req = 5'b01010;                          // FIFOs 3 and 1 have data
        #1;
        error_count = compare_outputs(5'b00010, grant, "grant = FIFO 1", error_count);
        tick(1);                                 // FIFO 1 wins, last_winner = 1

        req = 5'b01000;                          // FIFO 1 emptied, only FIFO 3 has data
        #1;
        error_count = compare_outputs(5'b01000, grant, "grant = FIFO 3", error_count);
        tick(1);                                 // FIFO 3 wins, last_winner = 3

        req = 5'b01010;                          // FIFO 1 refilled, FIFO 3 still has data
        #1;                                      // FIFO 3 just won, so FIFO 1 should win
        error_count = compare_outputs(5'b00010, grant, "grant = FIFO 1", error_count);
        tick(1);                                 // last_winner = 1

        #1;                                      // both still requesting: back to FIFO 3
        error_count = compare_outputs(5'b01000, grant, "grant = FIFO 3", error_count);      












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