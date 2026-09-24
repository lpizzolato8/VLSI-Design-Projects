`timescale 1ns / 1ps

module main(
	 
	input wire clk,                  // 8Hz clock signal
	input wire rst_n,		 // active-low asynchrnous reset
	
	);
	
	temp func2(
		.clk(clk),
		.rst_n(rst_n),	

		);	

	// alarm logic block
	always@(posedge clk or negedge rst_n) begin 
		if (!rst_n) begin
	
		end
	end
	
end

endmodule
