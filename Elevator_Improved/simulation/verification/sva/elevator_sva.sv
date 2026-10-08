module elevator_sva (
    
	input logic rst_n;
	input logic clk;

	input logic floor_1_up_button;
	input logic floor_2_down_button;
	input logic floor_2_up_button;
	input logic floor_3_down_button;
	input logic elevator_floor_1_button;
	input logic elevator_floor_2_button;
	input logic elevator_floor_3_button;

	input logic floor_1;	
	input logic floor_2;
	input logic floor_3;
	input logic elevator_door_open;
	input logic floor_1_up_button_clear;
	input logic floor_2_down_button_clear;
	input logic floor_2_up_button_clear;
	input logic floor_3_down_button_clear;
	input logic elevator_floor_1_button_clear;
	input logic elevator_floor_2_button_clear;
	input logic elevator_floor_3_button_clear;

);
  
  default clocking @(posedge clk); endclocking
  default disable iff (!rst_n);

  // Exactly one floor indicator is active at all times
  a_onehot_floor: assert property ($onehot({floor_1, floor_2, floor_3}));


endmodule

bind elevator_controller elevator_sva u_sva (.*);