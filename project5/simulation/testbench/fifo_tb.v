`timescale 1ns / 1ps

// important fifo checks are do not read when empty and do not write when full
// write and read at the same time
// fifo can be full and fifo can be empty
// fifo can read and fifo can write
// reset clears the fifo but not the pointers (obv reset then functions)
// fifo should pop in the order that they came in 

module fifo_tb;

    parameter DEPTH = 4;
    parameter WIDTH = 37;

    reg clk;
    reg rst_n;
    reg write_en;
    reg read_en;
    reg  [WIDTH-1:0] wr_data;

    wire [WIDTH-1:0] rd_data;
    wire empty, full;

    reg  [(40*8)-1:0] testcase;      // name of the current test, printed and shown in the waveform

    integer k;

    fifo #(.DEPTH(DEPTH), .WIDTH(WIDTH)) DUT (
        .clk      (clk),
        .rst_n    (rst_n),
        .write_en (write_en),
        .read_en  (read_en),
        .wr_data  (wr_data),
        .rd_data  (rd_data),
        .empty    (empty),
        .full     (full)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    // wait n full clock cycles, ending on a negedge like every other step
    task tick (input integer n);
        repeat (n) @(negedge clk);
    endtask

    //tick(n);

    integer errors = 0;
    task check (input [63:0] actual, input [63:0] expected, input [8*24-1:0] name);
        if (actual !== expected) begin
            $display("**FAIL** %0s: expected %h, got %h at %0t", name, expected, actual, $time);
            errors = errors + 1;
        end else begin
            $display("  PASS   %0s: %h at %0t", name, actual, $time);
        end
    endtask

    // everything should be done on the negative edge since the fifo samples on the positive edge

    initial begin

        // reset test (initialize values then hit reset and make sure all empty)
        testcase = "TESTCASE: reset functionality";
        $display("%0s", testcase);
        write_en = 0; read_en = 0; wr_data = 0;
        rst_n = 0;
        repeat (5) @(negedge clk);
        rst_n = 1;
        @(negedge clk);

        // empty after reset 
        check(empty, 1, "empty after reset");
        check(full,  0, "full after reset");

        tick(3);

        // write one packet, read it back 
        testcase = "TESTCASE: push then read";
        $display("%0s", testcase);        
        write_en = 1; wr_data = 37'h0_1111_1111;
        @(negedge clk);
        write_en = 0;
        check(empty, 0, "empty after write");
        check(rd_data, 37'h0_1111_1111, "head after write");

        read_en = 1;
        @(negedge clk);
        read_en = 0;
        check(empty, 1, "empty after read");

        tick(3);

        // fill up fifo to the max
        testcase = "TESTCASE: fill fifo";
        $display("%0s", testcase);
        write_en = 1;
        for (k = 0; k < DEPTH; k = k + 1) begin
            wr_data = 37'hA0 + k;
            @(negedge clk);
        end
        write_en = 0;
        check(full, 1, "full");

        tick(3);

        // fifo should never take a write when full
        testcase = "TESTCASE: write while full";
        $display("%0s", testcase);
        write_en = 1; wr_data = 37'hDEAD;
        @(negedge clk);
        write_en = 0;
        check(full,    1,      "still full");
        check(rd_data, 37'hA0, "packet unchanged");

        tick(3);

        // empty out the fifo testing to make sure that packets come out in the order they went in
        testcase = "TESTCASE: fifo pop";
        $display("%0s", testcase);
        read_en = 1;
        for (k = 0; k < DEPTH; k = k + 1) begin
            check(rd_data, 37'hA0 + k, "drain out");
            @(negedge clk);
        end
        read_en = 0;
        check(empty, 1, "empty after drain");

        tick(3);

        // should never be able to read from an empty fifo
        testcase = "TESTCASE: empty doesnt read";
        $display("%0s", testcase);
        read_en = 1;
        @(negedge clk);
        read_en = 0;
        check(empty, 1, "still empty");

        tick(3);

        // read and write in the same cycle
        testcase = "TESTCASE: read vs write";
        $display("%0s", testcase);
        write_en = 1; read_en = 1;
        wr_data = 37'hC0; @(negedge clk);
        check(rd_data, 37'hC0, "same time");
        write_en = 0;
        @(negedge clk);
        read_en = 0;
        check(empty, 1, "empty after");

        tick(3);

        // a reset with data inside clears the fifo with nothing left
        testcase = "TESTCASE: reset clears fifo";
        $display("%0s", testcase);
        write_en = 1; wr_data = 37'hD0;
        @(negedge clk);
        write_en = 0;
        rst_n = 0;
        @(negedge clk);
        rst_n = 1;
        @(negedge clk);
        check(empty, 1, "empty after reset");
        check(full,  0, "not full after reset");

        tick(3);


        if (errors == 0) $display("\n---------- FIFO: SIMULATION PASSED ----------\n");
        else             $display("\n---------- FIFO: SIMULATION FAILED, %0d errors ----------\n", errors);
        $finish;
    end

endmodule