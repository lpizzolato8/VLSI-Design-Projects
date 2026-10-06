`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ECE6214
// Matthew LaRue 
// code 3 for synthesis class
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module code3(
    input wire clk,
    input wire rst_n,
    input wire in1,
    input wire in2,		       
    output reg out1,
    output reg out2	     
    );

   reg	       mid1;
   reg	       mid2;
   
   // clock in registers, asynch active-low reset    
   always @(posedge clk or negedge rst_n)
     begin
        if (rst_n == 1'b0) begin
	   mid1 <= 1'b0;
	   out1 <= 1'b0;
        end else begin
	   mid1 <= in1;
	   out1 <= mid1;
        end   
     end

   // clock in registers, asynch active-low reset    
   always @(posedge clk or negedge rst_n)
     begin
        if (rst_n == 1'b0) begin
	   mid2 <= 1'b0;			//CHANGED: 4 IF STATEMENTS BELOW = -> <=
	   out2 <= 1'b0;
        end else begin
	   mid2 <= in2;
	   out2 <= mid2;
        end   
     end

     
endmodule
