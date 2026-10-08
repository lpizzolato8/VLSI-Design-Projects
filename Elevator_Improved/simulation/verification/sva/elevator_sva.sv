`timescale 1ns / 1ps

module elevator_sva (
    
	input logic rst_n,
	input logic clk,

	input logic floor_1_up_button,
	input logic floor_2_down_button,
	input logic floor_2_up_button,
	input logic floor_3_down_button,
	input logic elevator_floor_1_button,
	input logic elevator_floor_2_button,
	input logic elevator_floor_3_button,

	input logic floor_1,	
	input logic floor_2,
	input logic floor_3,
	input logic elevator_door_open,
	input logic floor_1_up_button_clear,
	input logic floor_2_down_button_clear,
	input logic floor_2_up_button_clear,
	input logic floor_3_down_button_clear,
	input logic elevator_floor_1_button_clear,
	input logic elevator_floor_2_button_clear,
	input logic elevator_floor_3_button_clear

);
  
	default clocking @(posedge clk); endclocking
	default disable iff (!rst_n);

	// position logic 

	// exactly one floor indicator is active at all times
	a_onehot_floor: assert property ($onehot({floor_1, floor_2, floor_3}))
	else $error("not exactly one floor active");

	// floor 1 and floor 3 can't be reached from each other without passing floor 2
	// |=> checks the next cycle, |-> checks the same cycle
	a_f1_no_jump: assert property (floor_1 |=> !floor_3)
	else $error("elevator jumped from floor 1 to floor 3");

	a_f3_no_jump: assert property (floor_3 |=> !floor_1)
	else $error("elevator jumped from floor 3 to floor 1");

	// door logic

	// elevator cant move while the door is open
	a_door_no_move: assert property (elevator_door_open |=> $stable({floor_1, floor_2, floor_3}))
	else $error("elevator moved while door was open");


	// button clear logic

	// door open on floor n -> a floor n button is being cleared
	a_f1_door_clears: assert property ((elevator_door_open && floor_1) |-> (floor_1_up_button_clear || elevator_floor_1_button_clear))
	else $error("door open on floor 1 but no floor 1 clear");

	a_f2_door_clears: assert property ((elevator_door_open && floor_2) |-> (floor_2_down_button_clear || floor_2_up_button_clear || elevator_floor_2_button_clear))
	else $error("door open on floor 2 but no floor 2 clear");

	a_f3_door_clears: assert property ((elevator_door_open && floor_3) |-> (floor_3_down_button_clear || elevator_floor_3_button_clear))
	else $error("door open on floor 3 but no floor 3 clear");

	// reverse direction: a clear only happens while the door is open
	a_clear_needs_door: assert property (
		(floor_1_up_button_clear || floor_2_down_button_clear || floor_2_up_button_clear || floor_3_down_button_clear ||
		 elevator_floor_1_button_clear || elevator_floor_2_button_clear || elevator_floor_3_button_clear)
		|-> elevator_door_open)
	else $error("button cleared while door closed");

	// coverage
	// cover property doesn't check anything; it confirms the testbench actually reached a situation
	c_door_open_f1: cover property (elevator_door_open && floor_1);
	c_door_open_f2: cover property (elevator_door_open && floor_2);
	c_door_open_f3: cover property (elevator_door_open && floor_3);

endmodule

bind elevator_controller elevator_sva u_sva (.*);