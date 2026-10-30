`timescale 1ns / 1ps

// send packets in all directions
// packet comes in then leaves
// packet doesnt flow when next is full
// can handle multiple packets coming in

module router_top_tb;

    parameter DEPTH = 4; 
    parameter DATA  = 37;
    parameter N     = 5;
 
    // port numbers, same as the router
    localparam LOCAL = 0, UP = 1, RIGHT = 2, DOWN = 3, LEFT = 4;

    reg clk;
    reg rst_n;

    // DUT inputs: the testbench drives these, so reg
    reg  [N*DATA-1:0] in_data;       // packet from neighbor node p
    reg  [N-1:0]      in_valid;      // bit p = neighbor p is pushing a packet this cycle
    reg  [N-1:0]      out_full;      // bit p = neighbor p's fifo is full, don't send

    // DUT outputs: the router drives these, so wire
    wire [N-1:0]      in_full;       // bit p = our fifo p is full, neighbor p must stop
    wire [N*DATA-1:0] out_data;      // packet going to neighbor node p
    wire [N-1:0]      out_valid;     // bit p = a packet is leaving on output p this cycle

    reg  [(40*8)-1:0] testcase;

    // the location of the current node is at 1,1

    router_top #(.DEPTH(DEPTH), .DATA(DATA), .CURR_X(1), .CURR_Y(1), .N(N)) DUT (
        .clk       (clk),
        .rst_n     (rst_n),
        .in_data   (in_data),
        .in_valid  (in_valid),
        .in_full   (in_full),
        .out_data  (out_data),
        .out_valid (out_valid),
        .out_full  (out_full)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    // wait n full clock cycles, ending on a negedge like every other step
    task tick (input integer n);
        repeat (n) @(negedge clk);
    endtask


    integer errors = 0;
    task check (input [63:0] actual, input [63:0] expected, input [8*30-1:0] name);
        if (actual !== expected) begin
            $display("**FAIL** %0s: expected %h, got %h at %0t", name, expected, actual, $time);
            errors = errors + 1;
        end else begin
            $display("  PASS   %0s: %h at %0t", name, actual, $time);
        end
    endtask

    // reset with every input idle
    task reset;
        begin
            in_valid = 0; in_data = 0; out_full = 0;
            rst_n = 0; tick(2);
            rst_n = 1; tick(2);
        end
    endtask
 
    // push one packet into input port p for one cycle
    task send (input integer p, input [DATA-1:0] packet);
        begin
            in_data[p*DATA +: DATA] = packet;
            in_valid[p] = 1;
            tick(1);
            in_valid[p] = 0;
        end
    endtask
 
    // packet for destination (x,y), new data = 1, payload d
    // wrapper for the packet so it makes it easier to see when testing 
    function [DATA-1:0] to (input [1:0] x, input [1:0] y, input [31:0] d);
        to = {1'b1, x, y, d};
    endfunction
 
    // the packet currently on output port q
    function [DATA-1:0] out_pkt (input integer q);
        out_pkt = out_data[q*DATA +: DATA];
    endfunction

    integer k;


    initial begin
    
        // testing reset when nothing is sent and no fifo is full
        testcase = "TESTCASE: reset functionality";
        $display("%0s", testcase);
        reset;
        check(out_valid, 5'b00000, "no output after reset");
        check(in_full,   5'b00000, "no fifo full after reset");
 
        tick(1); 
 
        // one packet sent into the node from local that leaves in each direction one at a time
        // local is at 1,1
        testcase = "TESTCASE: each direction";
        $display("%0s", testcase);
 
        send(LOCAL, to(2,1, 32'h0000_0001));            // from local to x=2 must go right
        check(out_valid, 5'b00100, "RIGHT high");
        check(out_pkt(RIGHT), to(2,1, 32'h0000_0001), "RIGHT data");
        tick(1);
        check(out_valid, 5'b00000, "RIGHT sent once");
 
        send(LOCAL, to(0,1, 32'h0000_0002));            // from local to x=0 must go left
        check(out_valid, 5'b10000, "LEFT high");
        check(out_pkt(LEFT), to(0,1, 32'h0000_0002), "LEFT data");
        tick(1);
        check(out_valid, 5'b00000, "LEFT sent once");
 
        send(LOCAL, to(1,3, 32'h0000_0003));            // same x, y=3 therefore go up to 3
        check(out_valid, 5'b00010, "UP high");
        check(out_pkt(UP), to(1,3, 32'h0000_0003), "UP data");
        tick(1);
        check(out_valid, 5'b00000, "UP sent once");
 
        send(LOCAL, to(1,0, 32'h0000_0004));            // same x, y=0 therefore go down
        check(out_valid, 5'b01000, "DOWN high");
        check(out_pkt(DOWN), to(1,0, 32'h0000_0004), "DOWN data");
        tick(1);
        check(out_valid, 5'b00000, "DOWN sent once");
 
        send(UP, to(1,1, 32'h0000_0005));               // coming from up, being sent to the current node 
        check(out_valid, 5'b00001, "LOCAL high");
        check(out_pkt(LOCAL), to(1,1, 32'h0000_0005), "LOCAL data");
        tick(1);
        check(out_valid, 5'b00000, "LOCAL sent once");
 
        tick(1); 
 
        // test that it moves x direction first
        testcase = "TESTCASE: Move X then Y";
        $display("%0s", testcase);
        send(LOCAL, to(3,0, 32'h0000_0006));
        check(out_valid, 5'b00100, "X moved first");
        check(out_pkt(RIGHT), to(3,0, 32'h0000_0006), "X first: data");
        tick(1);
 
        tick(1);
 
        // a packet comes in from the left and goes right
        testcase = "TESTCASE: pass through";
        $display("%0s", testcase);
        send(LEFT, to(3,1, 32'h0000_0007));
        check(out_valid, 5'b00100, "through the RIGHT");
        check(out_pkt(RIGHT), to(3,1, 32'h0000_0007), "data");
        tick(1);
 
        tick(1);
 
        // two packets for different outputs move in the same cycle
        testcase = "TESTCASE: parallel packets";
        $display("%0s", testcase);
        // sending two packets during the same cycle
        in_data[LEFT *DATA +: DATA] = to(3,1, 32'h0000_0008);    // LEFT  -> RIGHT
        in_data[RIGHT*DATA +: DATA] = to(1,1, 32'h0000_0009);    // RIGHT -> LOCAL
        in_valid[LEFT]  = 1;
        in_valid[RIGHT] = 1;
        tick(1);
        in_valid = 0;
        check(out_valid, 5'b00101, "both outputs valid");
        check(out_pkt(RIGHT), to(3,1, 32'h0000_0008), "parallel RIGHT with LOCAL");
        check(out_pkt(LOCAL), to(1,1, 32'h0000_0009), "parallel LOCAL with RIGHT");
        tick(1);
        // if out_valid is all 0, then there are no directions in whih a second packet is being sent, thus sent together in one cycle
        check(out_valid, 5'b00000, "both sent at same time");
 
        tick(1);
 
        // two packets want the same direction. one goes now, one next cycle.
        testcase = "TESTCASE: competition";
        $display("%0s", testcase);
        reset;
        // send during same clock cycle down should come out first, then left
        in_data[LEFT*DATA +: DATA] = to(1,3, 32'h0000_000A);
        in_data[DOWN*DATA +: DATA] = to(1,3, 32'h0000_000B);
        in_valid[LEFT] = 1;
        in_valid[DOWN] = 1;
        tick(1);
        in_valid = 0;
        check(out_valid, 5'b00010, "up is high");
        check(out_pkt(UP), to(1,3, 32'h0000_000B), "down wins");
        tick(1);
        check(out_valid, 5'b00010, "up is high again");
        check(out_pkt(UP), to(1,3, 32'h0000_000A), "left goes after");
        tick(1);
        check(out_valid, 5'b00000, "both sent");
 
        tick(1);
 
        // local is full so it waits, then it goes once finished
        testcase = "TESTCASE: neighbor full";
        $display("%0s", testcase);
        out_full[LOCAL] = 1;
        send(UP, to(1,1, 32'h0000_000C));
        check(out_valid, 5'b00000, "held while full");
        tick(2);
        check(out_valid, 5'b00000, "still held");
        out_full[LOCAL] = 0;
        #1;
        check(out_valid, 5'b00001, "sent when room");
        check(out_pkt(LOCAL), to(1,1, 32'h0000_000C), "packet untouched");
        tick(1);
        check(out_valid, 5'b00000, "clean (no packets leaving)");
 
        tick(1);
 
        // fill up a fifo, then drain the fifo, packets should come out in order
        testcase = "TESTCASE: full fifo in and out";
        $display("%0s", testcase);
        out_full[RIGHT] = 1;
        for (k = 0; k < DEPTH; k = k + 1) begin
            send(LOCAL, to(3,1, 32'h0000_00D0 + k));
        end
        check(in_full[LOCAL], 1, "LOCAL fifo full");
        check(in_full[UP], 0, "other fifos not full");
 
        out_full[RIGHT] = 0;
        #1;
        for (k = 0; k < DEPTH; k = k + 1) begin
            check(out_valid, 5'b00100, "draining");
            check(out_pkt(RIGHT), to(3,1, 32'h0000_00D0 + k), "drain order");
            tick(1);
        end
        check(out_valid, 5'b00000, "drained");
        check(in_full[LOCAL], 0, "LOCAL fifo has room");
 
        tick(1);
 
        // reset with packets waiting inside clears every fifo
        testcase = "TESTCASE: reset clears router";
        $display("%0s", testcase);
        out_full = 5'b11111;                        // out is full so it cannot leave the node
        send(LOCAL, to(3,1, 32'h0000_00E0));
        send(UP, to(1,1, 32'h0000_00E1));
        reset;                                     
        check(out_valid, 5'b00000, "nothing left after reset");
        check(in_full,   5'b00000, "no fifo full after reset");


        tick(5);


        if (errors == 0) $display("PASSED");
        else             $display("FAILED: %0d errors", errors);
        $finish;
    end
endmodule