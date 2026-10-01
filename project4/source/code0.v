`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ECE6214
// Matthew LaRue 
// code 0 for synthesis class
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module code0(
    input wire clk,
    input wire rst_n,
    input wire a,
    input wire b,		       
    output reg c
    );
   
   // clock in registers, asynch active-low reset    
   always @(posedge clk or negedge rst_n)
     begin
        if (rst_n == 1'b0) begin
	   c <= 1'b0;
        end else begin
	   if ( b == 1'b1 ) begin
	      c = 1'b0;
	   end else if (a == 1'b1) begin
	      c = 1'b1;
	   end
        end   
     end

     
endmodule
