`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ECE6214
// Matthew LaRue 
// code 2 for synthesis
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module code2(
    input wire	     clk,
    input wire	     rst_n,
    input wire	     quarter_inserted,
    input wire	     button_pressed,
    output reg	     vend_cola
    );
    
    // internal registers 
   reg [1:0]	     state_current;   
   
   // internal combinational variables
   reg [1:0]	     state_next; 

   // decalare state names
   parameter [1:0]   S0_IDLE                   = 2'd0;
   parameter [1:0]   S1_ONE_QUARTER_INTERTED   = 2'd1;
   parameter [1:0]   S2_TWO_QUARTER_INSERTED   = 2'd2;
   parameter [1:0]   S3_VEND                   = 2'd4;
   
       
    // clock in registers, asynch active-low reset    
    always @(posedge clk or negedge rst_n)
    begin
        if (rst_n == 1'b0) begin
	   state_current <= S0_IDLE;
        end else begin
           state_current <= state_next;
        end   
    end

    // combinational logic for next_state_logic
    always @(*)
      begin
	 state_next     = state_current;
	 
	 case(state_current)
	   S0_IDLE : begin
	      if (quarter_inserted == 1'b1)
		state_next = S1_ONE_QUARTER_INTERTED;
	   end
	   S1_ONE_QUARTER_INTERTED : begin
	      if (quarter_inserted == 1'b1)
		state_next = S2_TWO_QUARTER_INSERTED;
	   end
	   S2_TWO_QUARTER_INSERTED : begin
	      if ( button_pressed == 1'b1) begin
		state_next = S3_VEND; 			// CHANGED:  S4_VEND -> S3_VEND
	      end
	   end
	   S3_VEND : begin
	      state_next = S0_IDLE;
	   end
	   default : begin
	      state_next = S0_IDLE;
	   end
	 endcase // case (state_current)
      end // always @ (*)

   // output logic
   always @(*)
     begin
        if (state_current == S3_VEND ) begin
	   vend_cola = 1'b1;
	end
    
     end
     
endmodule
