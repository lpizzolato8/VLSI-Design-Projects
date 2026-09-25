
module elevator_controller(
	
	input  wire clk,
    	input  wire rst_n,
   

	// raw buttons from the testbench
   	input  wire floor_1_up_button,
   	input  wire floor_2_down_button,
	input  wire floor_2_up_button,
    	input  wire floor_3_down_button,
    	input  wire elevator_floor_1_button,
    	input  wire elevator_floor_2_button,
    	input  wire elevator_floor_3_button
    	
	output reg floor_1,
	output reg floor_2,
	output reg floor_3,
	output reg elevator_door_open,
	output reg floor_1_up_button_clear, 
	output reg floor_2_down_button_clear,
	output reg floor_2_up_button_clear,
	output reg floor_3_down_button_clear,
	output reg elevator_floor_1_button_clear,
	output reg elevator_floor_2_button_clear,
	output reg elevator_floor_3_button_clear

    	);
	
    	// internal variables 
    	wire floor_1_up_internal;
    	wire floor_2_down_internal;
    	wire floor_2_up_internal;
   	wire floor_3_down_internal;
   	wire elev_floor_1_internal;
    	wire elev_floor_2_internal;
    	wire elev_floor_3_internal;

    	// clear signals
    	wire floor_1_up_clear;
    	wire floor_2_down_clear;
    	wire floor_2_up_clear;
    	wire floor_3_down_clear;
    	wire elev_floor_1_clear;
    	wire elev_floor_2_clear;
    	wire elev_floor_3_clear;

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
        	.elev_floor_1_button_clear	(elev_floor_1_clear),
        	.elev_floor_2_button_clear	(elev_floor_2_clear),
        	.elev_floor_3_button_clear	(elev_floor_3_clear)
        	
		// outputs
		.floor_1           		(floor_1),
		.floor_2           		(floor_2),
		.floor_3           		(floor_3),
		.elevator_door_open		(elevator_door_open)

		    );

endmodule
