`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ece6213
// matthew larue 
// alarm clock controller
//////////////////////////////////////////////////////////////////////////////////

module code4a(
	input wire 	clk,
	input wire 	rst_n,
	input wire 	set_time,
	input wire 	increment_hour,
	input wire 	increment_minute, 
   	input wire 	set_alarm_time,
	input wire 	enable_alarm,
	input wire 	alarm_off,
	output wire [4:0] time_hours,
	output wire [5:0] time_minutes,
	output wire alarm,				    // CHANGED: REG -> WIRE SINCE IT IS DRIVEN BY ASSIGN 
	output wire alarm_enabled			// CHANGED: REG -> WIRE SINCE IT IS DRIVEN BY ASSIGN 	);

   	// sequential variables
   	reg [4:0] 	time_hours_q;
   	reg [5:0] 	time_minutes_q;
   	reg 			alarm_enabled_q;
   
   	// combinational variables
   	reg [4:0] 			time_hours_d;
   	reg [5:0] 			time_minutes_d;
   	reg 				alarm_enabled_d;
   	wire				update_minutes;

   	// assign outputs
   	assign time_hours   = time_hours_q;
   	assign time_minutes = time_minutes_q; 
	assign alarm_enabled = alarm_enabled_q;			// CHANGED: output never driven
   	assign alarm         = 1'b0;					// CHANGED: output never driven
													
   	code4b  U_counter (
		.clk(clk),
		.rst_n(rst_n),
		.update_minutes(update_minutes)
	);
       
    // clock in registers, asynch active-low reset    
    always @(posedge clk or negedge rst_n)
    begin
        if (rst_n == 1'b0) begin
	   		time_hours_q    <= 5'h00;
	   		time_minutes_q  <= 6'h00;
	   		alarm_enabled_q <= 1'b0;	   
        end else begin
	   		time_hours_q    <= time_hours_d;
	   		time_minutes_q  <= time_minutes_d;
	   		alarm_enabled_q <= alarm_enabled_d;	   
        end   
    end
  

    // combinational process to update hours/minutes
    always @(*)
    begin
		// default to hold current time;
		time_hours_d 	   = time_hours_q;
		time_minutes_d     = time_minutes_q;
		alarm_enabled_d    = alarm_enabled_q;

	// update seconds/minutes/hours when update_seconds goes active
		if (update_minutes == 1'b1) begin
	    	if (time_minutes_q == 6'd59) begin
	       		time_minutes_d 	= 6'h00;
	    		if (time_hours_q == 5'd23) begin
					time_hours_d = 5'h00;
	    		end else begin 
				// !if(time_hours_q == 5'd23)
		  			time_hours_d = time_hours_q + 5'd1; 	// CHANGED TO MATCH THE BID WIDTH OF THE VAR
	       		end 		  
	    	end else begin
	       		// !if(time_minutes_q == 6'd59)
	       		time_minutes_d = time_minutes_q + 6'd1;		// CHANGED TO MATCH THE BID WIDTH OF THE VAR
	    	end	       
	 	end // if (update_minutes == 1'b1)
    end // always @ (*)  

endmodule