`timescale 1ns / 1ps

module elevator_controller_tb();

	// var instantiation
	reg clk;
	reg rst_n;
	reg floor_1_up_button;
	reg floor_2_down_button;
	reg floor_2_up_button;
	reg floor_3_down_button;
	reg elevator_floor_1_button;
	reg elevator_floor_2_button;
	reg elevator_floor_3_button;
	reg [7:0] error_count = 8'h00;

	wire floor_1;
	wire floor_2;
	wire floor_3;
	wire elevator_door_open;
	wire floor_1_up_button_clear;
	wire floor_2_down_button_clear;
	wire floor_2_up_button_clear;
	wire floor_3_down_button_clear;
	wire elevator_floor_1_button_clear;
	wire elevator_floor_2_button_clear;
	wire elevator_floor_3_button_clear;

	reg [(20*8)-1:0] testcase;

	// instantiate elevator controller
	elevator_controller dut (
		.clk(clk),
		.rst_n(rst_n),
		.floor_1_up_button(floor_1_up_button),
		.floor_2_down_button(floor_2_down_button),
		.floor_2_up_button(floor_2_up_button),
		.floor_3_down_button(floor_3_down_button),
		.elevator_floor_1_button(elevator_floor_1_button),
		.elevator_floor_2_button(elevator_floor_2_button),
		.elevator_floor_3_button(elevator_floor_3_button),
		.floor_1(floor_1),
		.floor_2(floor_2),
		.floor_3(floor_3),
		.elevator_door_open(elevator_door_open),
		.floor_1_up_button_clear(floor_1_up_button_clear),
		.floor_2_down_button_clear(floor_2_down_button_clear),
		.floor_2_up_button_clear(floor_2_up_button_clear),
		.floor_3_down_button_clear(floor_3_down_button_clear),
		.elevator_floor_1_button_clear(elevator_floor_1_button_clear),
		.elevator_floor_2_button_clear(elevator_floor_2_button_clear),
		.elevator_floor_3_button_clear(elevator_floor_3_button_clear)
	);

	initial clk = 0;
	always #5 clk = ~clk;


	// helper function to make the clock run for n clock edges. #1 lets the outputs settle after the edge before checking
	// ticks needed to pass time so the states can change
	task tick(input integer n); integer i; begin for(i=0;i<n;i=i+1) @(posedge clk); #1; end endtask

	// helper function that simulates pressing the reset button at the start. Needs to assign the inputs as 0 before beginning testing
	task reset; begin
		{floor_1_up_button,floor_2_down_button,floor_2_up_button,floor_3_down_button,
		 elevator_floor_1_button,elevator_floor_2_button,elevator_floor_3_button} = 0;
		rst_n = 0; tick(3); 
		@(negedge clk) rst_n = 1; tick(2);
	end endtask

	// helper functions that simulate buttons being pressed once. 
	task press_f1_up;   begin 
		@(negedge clk) floor_1_up_button       = 1'b1; 
		@(negedge clk) floor_1_up_button       = 1'b0; 
	end endtask
	task press_f2_down; begin 
		@(negedge clk) floor_2_down_button     = 1'b1; 
		@(negedge clk) floor_2_down_button     = 1'b0; 
	end endtask
	task press_f2_up;   begin 
		@(negedge clk) floor_2_up_button       = 1'b1; 
		@(negedge clk) floor_2_up_button       = 1'b0; 
	end endtask
	task press_f3_down; begin 
		@(negedge clk) floor_3_down_button     = 1'b1; 
		@(negedge clk) floor_3_down_button     = 1'b0; 
	end endtask
	task press_floor_1; begin 
		@(negedge clk) elevator_floor_1_button = 1'b1; 
		@(negedge clk) elevator_floor_1_button = 1'b0; 
	end endtask
	task press_floor_2; begin 
		@(negedge clk) elevator_floor_2_button = 1'b1; 
		@(negedge clk) elevator_floor_2_button = 1'b0; 
	end endtask
	task press_floor_3; begin 
		@(negedge clk) elevator_floor_3_button = 1'b1; 
		@(negedge clk) elevator_floor_3_button = 1'b0; 
	end endtask

	// helper function that checks which floor the elevator is on and whether the door is open
	task check(input [7:0] floor, input [7:0] door); begin
		if (floor == 1) error_count = compare_outputs(8'd1, floor_1, "floor_1", error_count);
		if (floor == 2) error_count = compare_outputs(8'd1, floor_2, "floor_2", error_count);
		if (floor == 3) error_count = compare_outputs(8'd1, floor_3, "floor_3", error_count);
		else error_count = compare_outputs(door, elevator_door_open, "elevator_door_open", error_count);
	end endtask
	

	// Tesetcases
	initial begin

		$monitor("Testcase %s : Time = %t", testcase, $time);
		// start with everything at 0 then rst
		{floor_1_up_button,floor_2_down_button,floor_2_up_button,floor_3_down_button,
		 elevator_floor_1_button,elevator_floor_2_button,elevator_floor_3_button} = 0;
		rst_n = 1;

		// Test 1 : Floor 1 -> Floor 2
		testcase = "F1->F2";
		reset;
		press_f1_up;
		tick(1); check(1, 1);                                   // door opens on floor 1
		error_count = compare_outputs(8'd1, floor_1_up_button_clear, "floor_1_up_clear", error_count);
		tick(1); check(1, 0);                                   // door closes
		press_floor_2;
		tick(1); check(2, 0);                                   // travels to floor 2
		tick(1); check(2, 1);                                   // door opens on floor 2
		error_count = compare_outputs(8'd1, elevator_floor_2_button_clear, "floor_2_clear", error_count);

		// Test 2 : Floor 1 -> Floor 3
		testcase = "F1->F3";
		reset;
		press_f1_up;
		tick(1); check(1, 1);                                   // door opens on floor 1
		error_count = compare_outputs(8'd1, floor_1_up_button_clear, "floor_1_up_clear", error_count);
		tick(1); check(1, 0);                                   // door closes
		press_floor_3;
		tick(1); check(2, 0);                                   // floor 2, door stays closed
		tick(1); check(3, 0);                                   // travels to floor 3
		tick(1); check(3, 1);                                   // door opens on floor 3
		error_count = compare_outputs(8'd1, elevator_floor_3_button_clear, "floor_3_clear", error_count);

		// Test 3 : Floor 2 -> Floor 3
		testcase = "F2->F3";
		reset;
		press_f2_up;
		tick(1); check(2, 0);                                   // travels to floor 2
		tick(1); check(2, 1);                                   // door opens on floor 2
		error_count = compare_outputs(8'd1, floor_2_up_button_clear, "floor_2_up_clear", error_count);
		tick(1); check(2, 0);                                   // door closes
		press_floor_3;
		tick(1); check(3, 0);                                   // travels to floor 3
		tick(1); check(3, 1);                                   // door opens on floor 3
		error_count = compare_outputs(8'd1, elevator_floor_3_button_clear, "floor_3_clear", error_count);

		// Test 4 : Floor 2 -> Floor 1
		testcase = "F2->F1";
		reset;
		press_f2_down;
		tick(1); check(2, 0);                                   // travels to floor 2
		tick(1); check(2, 0);                                   // turns around to answer the down call (has to change states from 2U to 2D)
		tick(1); check(2, 1);                                   // door opens on floor 2
		error_count = compare_outputs(8'd1, floor_2_down_button_clear, "floor_2_down_clear", error_count);
		tick(1); check(2, 0);                                   // door closes
		press_floor_1;
		tick(1); check(1, 0);                                   // travels to floor 1
		tick(1); check(1, 1);                                   // door opens on floor 1
		error_count = compare_outputs(8'd1, elevator_floor_1_button_clear, "floor_1_clear", error_count);

		// Test 5 : Floor 3 -> Floor 2
		testcase = "F3->F2";
		reset;
		press_f3_down;
		tick(1); check(2, 0);                                   // passes floor 2
		tick(1); check(3, 0);                                   // travels to floor 3
		tick(1); check(3, 1);                                   // door opens on floor 3
		error_count = compare_outputs(8'd1, floor_3_down_button_clear, "floor_3_down_clear", error_count);
		tick(1); check(3, 0);                                   // door closes
		press_floor_2;
		tick(1); check(2, 0);                                   // travels to floor 2
		tick(1); check(2, 1);                                   // door opens on floor 2
		error_count = compare_outputs(8'd1, elevator_floor_2_button_clear, "floor_2_clear", error_count);

		// Test 6 : Floor 3 -> Floor 1
		testcase = "F3->F1";
		reset;
		press_f3_down;
		tick(1); check(2, 0);                                   // passes floor 2
		tick(1); check(3, 0);                                   // travels to floor 3
		tick(1); check(3, 1);                                   // door opens on floor 3
		error_count = compare_outputs(8'd1, floor_3_down_button_clear, "floor_3_down_clear", error_count);
		tick(1); check(3, 0);                                   // door closes
		press_floor_1;
		tick(1); check(2, 0);                                   // floor 2, door stays closed
		tick(1); check(1, 0);                                   // travels to floor 1
		tick(1); check(1, 1);                                   // door opens on floor 1
		error_count = compare_outputs(8'd1, elevator_floor_1_button_clear, "floor_1_clear", error_count);

		// Test 7 : Floor 1 -> Floor 3 w/ pickup on Floor 2
		testcase = "F1->F3_pickup_F2";
		reset;
		press_f1_up;
		tick(1); check(1, 1);                                   // door opens on floor 1
		error_count = compare_outputs(8'd1, floor_1_up_button_clear, "floor_1_up_clear", error_count);
		tick(1); check(1, 0);                                   // door closes
		// passenger hits floor3 at same time as passanger hits floor 2 (same clk edge)
		@(negedge clk) begin elevator_floor_3_button = 1; floor_2_up_button = 1; end
		@(negedge clk) begin elevator_floor_3_button = 0; floor_2_up_button = 0; end
		tick(1); check(2, 0);                                   // travels to floor 2
		tick(1); check(2, 1);                                   // door opens on floor 2
		error_count = compare_outputs(8'd1, floor_2_up_button_clear, "floor_2_up_clear", error_count);
		tick(1); check(2, 0);                                   // door closes
		tick(1); check(3, 0);                                   // travels to floor 3
		tick(1); check(3, 1);                                   // door opens on floor 3
		error_count = compare_outputs(8'd1, elevator_floor_3_button_clear, "floor_3_clear", error_count);

		// Test 8 : Floor 3 -> Floor 2 -> Floor 1 
		testcase = "F3->F2->F1";
		reset;
		press_f3_down;
		tick(1); check(2, 0);                                   // passes floor 2
		tick(1); check(3, 0);                                   // travels to floor 3
		tick(1); check(3, 1);                                   // door opens on floor 3
		error_count = compare_outputs(8'd1, floor_3_down_button_clear, "floor_3_down_clear", error_count);
		tick(1); check(3, 0);                                   // door closes
		// passenger presses floor 1 and floor 2 dwn at the same time (same clk edge)
		@(negedge clk) begin elevator_floor_1_button = 1; floor_2_down_button = 1; end
		@(negedge clk) begin elevator_floor_1_button = 0; floor_2_down_button = 0; end
		tick(1); check(2, 0);                                   // travels to floor 2
		tick(1); check(2, 1);                                   // door opens on floor 2
		error_count = compare_outputs(8'd1, floor_2_down_button_clear, "floor_2_down_clear", error_count);
		tick(1); check(2, 0);                                   // door closes
		tick(1); check(1, 0);                                   // travels to floor 1
		tick(1); check(1, 1);                                   // door opens on floor 1
		error_count = compare_outputs(8'd1, elevator_floor_1_button_clear, "floor_1_clear", error_count);

		// Test 9 : No passangers stuck. Door opens on floor 2 (already going up to three) person hits floor one
		// takes them to floor 3 then back down to floor 1
		testcase = "No_passengers_stuck";
		reset;
		press_f1_up;
		tick(1); check(1, 1);                                   // door opens on floor 1
		tick(1); check(1, 0);                                   // door closes
		// passenger presses 2up and another presses 3
		@(negedge clk) begin elevator_floor_3_button = 1; floor_2_up_button = 1; end
		@(negedge clk) begin elevator_floor_3_button = 0; floor_2_up_button = 0; end
		tick(1); check(2, 0);                                   // travels to floor 2
		tick(1); check(2, 1);                                   // door opens on floor 2
		press_floor_1;                                          // floor 2 passenger hits "floor 1"
		tick(1); check(3, 0);                                   // keeps going up to floor 3
		tick(1); check(3, 1);                                   // door opens on floor 3
		error_count = compare_outputs(8'd1, elevator_floor_3_button_clear, "floor_3_clear", error_count);
		tick(1); check(3, 0);                                   // door closes
		tick(1); check(2, 0);                                   // floor 2, door stays closed
		tick(1); check(1, 0);                                   // travels to floor 1
		tick(1); check(1, 1);                                   // door opens on floor 1
		error_count = compare_outputs(8'd1, elevator_floor_1_button_clear, "floor_1_clear", error_count);

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
