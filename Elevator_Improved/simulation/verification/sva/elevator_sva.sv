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

	// Exactly one floor indicator is active at all times
	a_onehot_floor: assert property ($onehot({floor_1, floor_2, floor_3}));

	// if on floor #n there must be a button clear for floor n
	a_f1_door_clears: assert property ((elevator_door_open && floor_1) |-> (floor_1_up_button_clear || elevator_floor_1_button_clear)) 
	else $error("door open on floor 1 but no floor 1 clear");

	a_f2_door_clears: assert property ((elevator_door_open && floor_2) |-> (floor_2_down_button_clear || floor_2_up_button_clear || elevator_floor_2_button_clear)) 
	else $error("door open on floor 2 but no floor 2 clear");

	a_f3_door_clears: assert property ((elevator_door_open && floor_3) |-> (floor_3_down_button_clear || elevator_floor_3_button_clear)) 
	else $error("door open on floor 3 but no floor 3 clear");



	// if elevator is on floor n it shouldnt be on another floor
	a_f1_no_jump: assert property ((floor_1) |-> (~floor_2 && ~floor_3))
	else $error("elevator should be on floor 1 but on other floor")

	a_f1_no_jump: assert property ((floor_2) |-> (~floor_1 && ~floor_3))
	else $error("elevator should be on floor 2 but on other floor")

	a_f1_no_jump: assert property ((floor_3) |-> (~floor_2 && ~floor_1))
	else $error("elevator should be on floor 3 but on other floor")


endmodule

bind elevator_controller elevator_sva u_sva (.*);