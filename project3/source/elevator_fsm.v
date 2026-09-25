`timescale 1ns / 1ps

module main(
	 
	input wire clk,                  // clock signal
	input wire rst_n,		 // active-low asynchrnous reset
	
	input wire floor_1_up_button,
	input wire floor_2_down_button,
	input wire floor_2_up_button,
	input wire floor_3_down_button,
	input wire elevator _floor_1_button,
	input wire elevator_floor_2_button,
	input wire elevator_floor_3_button,
	
	output reg [2:0] next_state,

	output reg floor_1, // (indicates elevator is on floor 1)
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
	
	
	// State encoding
	localparam 
		F1DC  = 3'd0,
               	F1DO  = 3'd1,
               	F2DCU = 3'd2,
               	F2DOU = 3'd3,
               	F2DCD = 3'd4,
               	F2DOD = 3'd5,
               	F3DC  = 3'd6,
               	F3DO  = 3'd7;
	

	// FSM seq block for curr state
	always@(posedge clk or negedge rst_n) begin 
		if (!rst_n) begin
			state <= F1DC;
		end else state <= next_state;		
	end
  

    	// FSM Next State Logic
    	always @(*) begin
 	
        	case (state)
            		F1DC: begin
                		
				if (floor_1_up_button | elevator_floor_1_button)            next_state = F1DO;                        // open door
                		
				else if (floor_3_down_button    | elevator_floor_3_button |
                                        floor_2_up_button       | floor_2_down_button     | 
                                        elevator_floor_2_button)  next_state = F2DCU;                       // go up
            			
				end
 
            		F1DO:  next_state = F1DC;               
 
            		F2DCU: begin
                		
				if (floor_2_up_button           | elevator_floor_2_button)   next_state = F2DOU;                       // open door
                		else if (floor_3_down_button    | elevator_floor_3_button)   next_state = F3DC;                        // keep going up
                		else if (floor_1_up_button      | elevator_floor_1_button)   next_state = F2DCD;                       // reverse
            			
				end
 
            		F2DOU: next_state = F2DCU;                
 
            		F2DCD: begin
                		
				if (floor_2_down_button         | elevator_floor_2_button)    next_state = F2DOD;                       // open door
                		else if (floor_1_up_button      | elevator_floor_1_button)    next_state = F1DC;                        // keep going down
               			else if (floor_3_down_button    | elevator_floor_3_button)    next_state = F2DCU;                       // reverse
            			
				end
 
            		F2DOD: next_state = F2DCD;                   
 	
        	    	F3DC: begin
                		if (floor_3_down_button         | elevator_floor_3_button)    next_state = F3DO;                        // open door
                		else if (floor_2_down_button 	| elevator_floor_2_button |
                         		floor_1_up_button   	| elevator_floor_1_button |
                       			floor_2_up_button)	  next_state = F2DCD;                       // go down
            	
				end
 
	            	F3DO:  next_state = F3DC;                        
 
        		default: next_state = F1DC;
       		endcase
	end
 
    	// FSM Output Logic 
    	always @(*) begin
		
        
        	floor_1                       = 1'b0;
        	floor_2                       = 1'b0;
        	floor_3                       = 1'b0;
        	elevator_door_open            = 1'b0;
        	floor_1_up_button_clear       = 1'b0;
        	floor_2_down_button_clear     = 1'b0;
        	floor_2_up_button_clear       = 1'b0;
        	floor_3_down_button_clear     = 1'b0;
        	elevator_floor_1_button_clear = 1'b0;
        	elevator_floor_2_button_clear = 1'b0;
        	elevator_floor_3_button_clear = 1'b0;
 
	        case (state)
	        	F1DC:  floor_1 = 1'b1;
            		F1DO:  begin
                       		elevator_door_open            = 1'b1;
                       		floor_1_up_button_clear       = 1'b1;
                       		elevator_floor_1_button_clear = 1'b1;
                   		end
            		F2DCU: floor_2 = 1'b1;
            		F2DOU: begin
                       		elevator_door_open            = 1'b1;
                       		floor_2_up_button_clear       = 1'b1;
                       		elevator_floor_2_button_clear = 1'b1;
                   		end
            		F2DCD: floor_2 = 1'b1;
            		F2DOD: begin
                       		elevator_door_open            = 1'b1;
                       		floor_2_down_button_clear     = 1'b1;
                       		elevator_floor_2_button_clear = 1'b1;
                   		end
            		F3DC:  floor_3 = 1'b1;
            		F3DO:  begin
                       		elevator_door_open            = 1'b1;
                       		floor_3_down_button_clear     = 1'b1;
                       		elevator_floor_3_button_clear = 1'b1;
                   		end
            		default: F1DC;
        	endcase
    	end
 
endmodule
