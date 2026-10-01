`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ECE6214
// Matthew LaRue 
// Program Counter for MIPS processor
// Modified with input/output registering for use in synthesis
//    will add additional clock cycles of latency
//////////////////////////////////////////////////////////////////////////////////

module program_counter(
    input wire clk,
    input wire rst_n,
    input wire update_msbs,
    input wire update_lsbs,
    input wire jump,
    input wire [5:0] jump_destination,
    input wire branch,
    input wire [5:0] branch_offset,
    output reg [7:0] mem_addr
    );

   // variables for clockin in inputs
   reg 		     update_msbs_q;
   reg 		     update_lsbs_q;
   reg 		     jump_q;
   reg [5:0] 	     jump_destination_q;
   reg 		     branch_q;
   reg [5:0] 	     branch_offset_q;
     
    // internal variables
    reg [7:0] mem_addr_next;
    
    // clock in registers, asynch active-low reset    
    always @(posedge clk or negedge rst_n)
    begin
        if (rst_n == 1'b0) begin
           mem_addr 	      <= 8'h00;
	   update_msbs_q      <= 1'b0;
	   update_lsbs_q      <= 1'b0;
	   jump_q 	      <= 1'b0;
	   jump_destination_q <= 6'b000000;
	   branch_q 	      <= 1'b0;
	   branch_offset_q    <= 6'b000000;	   
        end else begin
           mem_addr 	      <= mem_addr_next;
	   update_msbs_q      <= update_msbs;
	   update_lsbs_q      <= update_lsbs;
	   jump_q 	      <= jump;
	   jump_destination_q <= jump_destination;
	   branch_q 	      <= branch;
	   branch_offset_q    <= branch_offset;	   
        end   
    end
    
    always @(*)
    begin
        mem_addr_next = mem_addr;
        
        if (update_msbs_q == 1'b1) begin
            // use "update_msbs" to progress one instruction, each instruction is 4 memory addresses 
            //    so it counts in increments of 4
            mem_addr_next[7:2] = mem_addr[7:2] + 1'b1;
            mem_addr_next[1:0] = 2'b00;
        end else if (update_lsbs_q == 1'b1) begin
            // use "update_lsbs" to progress to the next memory address, use it to advance to the next
            //    8 bits of an instruction
            mem_addr_next[1:0] = mem_addr[1:0] + 1'b1;
        end else if (jump_q == 1'b1) begin
            // use "jump" for the jump command, jumps to the instruction indicated. 
            mem_addr_next[7:2] = jump_destination_q;
            mem_addr_next[1:0] = 2'b00;
        end else if (branch_q == 1'b1) begin
            // use "branch" for the "branch if equal" command, branches to 
            //    current instruction number + branch_offset
            mem_addr_next[7:2] = mem_addr[7:2] + branch_offset_q;
            mem_addr_next[1:0] = 2'b00;
        end
     end
       
endmodule
