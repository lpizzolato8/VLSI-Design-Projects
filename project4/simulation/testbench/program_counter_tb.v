`timescale 1ns / 1ps

module program_counter_tb(
    );

    // string to display section labels on waveforms, change its radix 
    //      to ASCII in the waveform to view correctly
   reg [(20*8)-1:0] testcase;  
   reg [7:0] 	    error_count = 8'h00;
   
   
   reg 		    clk;
   reg 		    rst_n;
   reg 		    update_msbs;
   reg 		    update_lsbs;
   reg 		    jump;
   reg [5:0] 	    jump_destination;
   reg 		    branch;
   reg [5:0] 	    branch_offset;
   wire [7:0] 	    mem_addr;

    
      
    program_counter DUT(
    .clk(clk),
    .rst_n(rst_n),
    .update_msbs(update_msbs),
    .update_lsbs(update_lsbs),
    .jump(jump),
    .jump_destination(jump_destination),
    .branch(branch),
    .branch_offset(branch_offset),
    .mem_addr(mem_addr)
    );
    
        always #5 clk = ~clk;
    
    initial begin
       $monitor("Tescase %s: Time = %t", testcase, $time);
       
       // initial values
       clk             = 0;
       rst_n           = 1;
       update_msbs     = 0;
       update_lsbs     = 0;
       jump            = 0;
       jump_destination = 6'h00;
       branch          = 0;
       branch_offset   = 6'h00;
       testcase            = "Reset_Checks";
       
       // check that reset works
       repeat(3)
	 @(negedge clk);
       
       // activate reset and check
       rst_n       = 0;
       repeat(2)
	 @(negedge clk);
       error_count = compare_outputs(8'h00, mem_addr, "mem_addr", error_count);
       
       // release reset and check
       rst_n       = 1;
       repeat(2)
	 @(negedge clk);
       error_count = compare_outputs(8'h00, mem_addr, "mem_addr", error_count);
       
       
       // check updating program counter LSBs for normal operation
       testcase        = "LSBs_update";
       update_lsbs     = 1;    
       repeat(2)
	 @(negedge clk);
       error_count = compare_outputs(8'h01, mem_addr, "mem_addr", error_count);
       @(negedge clk);
       error_count = compare_outputs(8'h02, mem_addr, "mem_addr", error_count);
       @(negedge clk);
       error_count = compare_outputs(8'h03, mem_addr, "mem_addr", error_count);
       @(negedge clk);
       error_count = compare_outputs(8'h00, mem_addr, "mem_addr", error_count);
       @(negedge clk);
       error_count = compare_outputs(8'h01, mem_addr, "mem_addr", error_count);
       update_lsbs = 0;
       

        // check updating program counter MSBs for normal operation        
       testcase            = "MSBs_update";
       update_msbs     = 1;       
       repeat(2)
	 @(negedge clk);
       error_count = compare_outputs(8'h04, mem_addr, "mem_addr", error_count);
       @(negedge clk);
       error_count = compare_outputs(8'h08, mem_addr, "mem_addr", error_count);
       @(negedge clk);
       error_count = compare_outputs(8'h0C, mem_addr, "mem_addr", error_count);
       update_msbs     = 0;   
       update_lsbs     = 1;
       @(negedge clk);
       error_count = compare_outputs(8'h10, mem_addr, "mem_addr", error_count);
       @(negedge clk);
       error_count = compare_outputs(8'h11, mem_addr, "mem_addr", error_count);
       @(negedge clk);
       error_count = compare_outputs(8'h12, mem_addr, "mem_addr", error_count);
       @(negedge clk);
       error_count = compare_outputs(8'h13, mem_addr, "mem_addr", error_count);
       @(negedge clk);
       error_count = compare_outputs(8'h10, mem_addr, "mem_addr", error_count);
       @(negedge clk);
       error_count = compare_outputs(8'h11, mem_addr, "mem_addr", error_count);
       update_msbs     = 0;   
       update_lsbs     = 0;
       @(negedge clk);
       error_count = compare_outputs(8'h12, mem_addr, "mem_addr", error_count);
       @(negedge clk);
       error_count = compare_outputs(8'h12, mem_addr, "mem_addr", error_count);
        
       // check jump mode      
       testcase            = "Jump"; 
       jump             = 1;
       jump_destination = 6'h0F;
       repeat(2)
	 @(negedge clk);
       error_count = compare_outputs(8'h3C, mem_addr, "mem_addr", error_count);
       @(negedge clk);
       error_count = compare_outputs(8'h3C, mem_addr, "mem_addr", error_count); 
       jump_destination = 6'h0A;
       repeat(2)
	 @(negedge clk);
       error_count = compare_outputs(8'h28, mem_addr, "mem_addr", error_count);
       @(negedge clk);
       error_count = compare_outputs(8'h28, mem_addr, "mem_addr", error_count);
       jump             = 0;
  
        
       // check branch
       testcase            = "Banch"; 
       branch          = 1;
       branch_offset   = 6'h3F;
       repeat(2)
	 @(negedge clk);
       error_count = compare_outputs(8'h24, mem_addr, "mem_addr", error_count);      
       branch_offset   = 6'h04;
       repeat(2)
	 @(negedge clk);
       error_count = compare_outputs(8'h30, mem_addr, "mem_addr", error_count);
       //error_count = compare_outputs(8'h34, mem_addr, "mem_addr", error_count);
       branch          = 0;

       repeat(3)
	 @(negedge clk);

       if (error_count == 0) begin
	  $display("\n\n----------SIMULATION PASSED----------");
	  $display("----------RTL SIMULATION   ----------\n\n");
       end else begin
	  $display("\n\n----------SIMULATION FAILED----------");
	  $display("----------RTL SIMULATION   ----------");
	  $display("---------- %d ERRORS TOTAL----------\n\n",error_count);
       end

       $finish;         
    end // initial begin

   function [7:0] compare_outputs (
				       input [7:0]    expected_value,
				       input [7:0]    actual_value,
				       input [8*19:0] signal_name,
				       input [7:0]    error_count);
      if (expected_value == actual_value ) begin
	 $display("  PASS  : %s: Expected = %h, Actual = %h, Time = %t", signal_name, 
		  expected_value, actual_value, $time);
	 compare_outputs = error_count;
      end else begin
	 $display("**FAIL**: %s: Expected = %h, Actual = %h, Time = %t", signal_name, 
		  expected_value, actual_value, $time);
	 compare_outputs = error_count + 1;
      end
   endfunction // compare_outputs     
    
endmodule
