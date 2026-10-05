`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ECE6214
// Matthew LaRue 
// code 1 for synthesis class
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module code1(
    input wire 	     clk,
    input wire 	     rst_n,
    input wire [1:0] a,
    input wire [1:0] b, 
    input wire 	     enable, 
    output reg [1:0] c
    );

   reg [2:0] 	     c_next;
   
   // clock in registers, asynch active-low reset    
   always @(posedge clk or negedge rst_n)
     begin
        if (rst_n == 1'b0) begin
	   c <= 2'b0;
        end else begin
	   c <= c_next;
        end   
     end // always @ (posedge clk or negedge rst_n)

   always @(*)
     begin
	if (enable == 1'b1) begin	// CHANGED: == -> = 
	   c_next   = a + b;
        end else begin
	   c_next   = 3'b0; 		// CHANGED: NO VALUE FOR CNEXT WHEN ENABLE NOT HIGH
	end				// THUS CREATING AN INFERRED LATCH. FIXED BY ADDING
     end				// AN ELSE STATEMENT SETTING CNEXT TO 0

     
endmodule
