`timescale 1ns / 1ps

module elevator_controller(
	
	input  logic clk,
    input  logic rst_n,
   

	// input buttons from the testbench
   	input logic  floor_1_up_button,
   	input logic  floor_2_down_button,
	input logic  floor_2_up_button,
    input logic  floor_3_down_button,
	input logic  elevator_floor_1_button,
	input logic  elevator_floor_2_button,
	input logic  elevator_floor_3_button,
    	
	output logic floor_1,
	output logic floor_2,
	output logic floor_3,
	output logic elevator_door_open,
	output logic floor_1_up_button_clear, 
	output logic floor_2_down_button_clear,
	output logic floor_2_up_button_clear,
	output logic floor_3_down_button_clear,
	output logic elevator_floor_1_button_clear,
	output logic elevator_floor_2_button_clear,
	output logic elevator_floor_3_button_clear

    	);
	
    // internal variables 
    logic floor_1_up_internal;
    logic floor_2_down_internal;
   	logic floor_2_up_internal;
	logic floor_3_down_internal;
	logic elev_floor_1_internal;
   	logic elev_floor_2_internal;
   	logic elev_floor_3_internal;

   	// internal clear signals
   	logic floor_1_up_clear;
   	logic floor_2_down_clear;
   	logic floor_2_up_clear;
   	logic floor_3_down_clear;
   	logic elev_floor_1_clear;
	logic elev_floor_2_clear;
    logic elev_floor_3_clear;
	

	assign floor_1_up_button_clear       = floor_1_up_clear;
	assign floor_2_down_button_clear     = floor_2_down_clear;
	assign floor_2_up_button_clear       = floor_2_up_clear;
	assign floor_3_down_button_clear     = floor_3_down_clear;
	assign elevator_floor_1_button_clear = elev_floor_1_clear;
	assign elevator_floor_2_button_clear = elev_floor_2_clear;
	assign elevator_floor_3_button_clear = elev_floor_3_clear;

    	// one elevator_button instance per button in elevator car and outside car
    	elevator_button u_floor_1_up (
        	.clk(clk), 
			.rst_n(rst_n),
        	.button_pressed(floor_1_up_button),
        	.clear(floor_1_up_clear),
        	.button_out(floor_1_up_internal)
    	);

    	elevator_button u_floor_2_down (
        	.clk(clk), 
			.rst_n(rst_n),
        	.button_pressed(floor_2_down_button),
        	.clear(floor_2_down_clear),
        	.button_out(floor_2_down_internal)
    	);

    	elevator_button u_floor_2_up (
        	.clk(clk), 
			.rst_n(rst_n),
        	.button_pressed(floor_2_up_button),
        	.clear(floor_2_up_clear),
        	.button_out(floor_2_up_internal)
    	);

    	elevator_button u_floor_3_down (
        	.clk(clk), 
			.rst_n(rst_n),
        	.button_pressed(floor_3_down_button),
        	.clear(floor_3_down_clear),
        	.button_out(floor_3_down_internal)
    	);

    	elevator_button u_elev_floor_1 (
        	.clk(clk), 
			.rst_n(rst_n),
        	.button_pressed(elevator_floor_1_button),
        	.clear(elev_floor_1_clear),
        	.button_out(elev_floor_1_internal)
    	);

    	elevator_button u_elev_floor_2 (
        	.clk(clk), 
			.rst_n(rst_n),
        	.button_pressed(elevator_floor_2_button),
        	.clear(elev_floor_2_clear),
        	.button_out(elev_floor_2_internal)
    	);
	
    	elevator_button u_elev_floor_3 (
        	.clk(clk), 
			.rst_n(rst_n),
        	.button_pressed(elevator_floor_3_button),
        	.clear(elev_floor_3_clear),
        	.button_out(elev_floor_3_internal)
    	);

    	// main FSM
	elevator_fsm u_fsm (
        .clk(clk), 
		.rst_n(rst_n),
    	// requests in
        .floor_1_up_button      	(floor_1_up_internal),
    	.floor_2_down_button     	(floor_2_down_internal),
    	.floor_2_up_button      	(floor_2_up_internal),
        .floor_3_down_button    	(floor_3_down_internal),
    	.elevator_floor_1_button	(elev_floor_1_internal),
    	.elevator_floor_2_button	(elev_floor_2_internal),
       	.elevator_floor_3_button	(elev_floor_3_internal),

       	// clears out
       	.floor_1_up_button_clear  	(floor_1_up_clear),
       	.floor_2_up_button_clear  	(floor_2_up_clear),
		.floor_2_down_button_clear	(floor_2_down_clear),
        .floor_3_down_button_clear	(floor_3_down_clear),
       	.elevator_floor_1_button_clear	(elev_floor_1_clear),
       	.elevator_floor_2_button_clear	(elev_floor_2_clear),
        .elevator_floor_3_button_clear	(elev_floor_3_clear),
       	
		// outputs
		.floor_1           		(floor_1),
		.floor_2           		(floor_2),
		.floor_3           		(floor_3),
		.elevator_door_open		(elevator_door_open)

		);

endmodule
