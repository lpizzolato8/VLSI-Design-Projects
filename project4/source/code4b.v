`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ECE6213
// Matthew LaRue 
// Alarm clock controller
//////////////////////////////////////////////////////////////////////////////////

module code4b(
		       input wire 	clk,
		       input wire 	rst_n,
		       output reg       update_minutes		     
		       );

   // sequential variables
   reg [7:0] 				count_q; // 256 Hz clock, so 8-bit value needed
   reg [5:0] 				time_seconds_q;
   
   // combinational variables
   reg [7:0] 			        count_d;
   reg [5:0] 				time_seconds_d;
       
    // clock in registers, asynch active-low reset    
    always @(posedge clk or negedge rst_n)
    begin
       if (rst_n == 1'b0) begin
	  count_q 	 <= 8'h00;
	  time_seconds_q <= 6'h00;
	end else begin
	   count_q         <= count_d; 
	   time_seconds_q  <= time_seconds_d;
        end   
    end
  
 
   // combinational always block
   // update counter every clock cycle
   // when counter fills up, 256 clock cycles have passed. At 256 Hz clock this means one second has passed
    always @(*)
      begin
	 count_d 	 = count_q + 1'b1;
	 time_seconds_d  = time_seconds_q;
	 update_minutes  = 1'b0;
	 
	 if (count_q == 8'hff) begin
	    if (time_seconds_q == 6'd59) begin
	       time_seconds_d = 6'h00;
	       update_minutes = 1'b1;	       
	    end else begin      
	       time_seconds_d = time_seconds_q + 1'b1;
	    end
	 end
     end
       
endmodule
