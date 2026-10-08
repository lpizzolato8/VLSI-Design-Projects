`timescale 1ns / 1ps

module elevator_button(

    input logic clk,
    input logic rst_n,
    input logic button_pressed,
    input logic clear,		       
    output logic button_out
    );

   logic	       button_out_next;
   
    // clock in registers, asynch active-low reset    
    always_ff @(posedge clk or negedge rst_n)
    begin
        if (rst_n == 1'b0) begin
	   button_out <= 1'b0;
        end else begin
           button_out <= button_out_next; 
        end   
    end

    // combinational logic
    always_comb begin
	 // default value, button holds previous output
	 button_out_next = button_out;

	 // button pressed and clear logic
	 if ( clear == 1'b1 ) begin
	    button_out_next = 1'b0;
	 end else if (button_pressed == 1'b1) begin
	    button_out_next = 1'b1;
	 end
	 
      end 
     
endmodule

