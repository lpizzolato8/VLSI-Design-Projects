`timescale 1ns / 1ps

// packet is able to move in all directions
// packet always moves in X direction then Y direction 
// packet never falls off the mesh


module mvmt_logic_tb;

    parameter DATA = 37;

    // expected one-hot routes (bit = port: LOCAL 0, UP 1, RIGHT 2, DOWN 3, LEFT 4)
    localparam [4:0] GO_LOCAL = 5'b00001,
                     GO_UP    = 5'b00010,
                     GO_RIGHT = 5'b00100,
                     GO_DOWN  = 5'b01000,
                     GO_LEFT  = 5'b10000;

    reg  [DATA-1:0] pkt;
    wire [4:0] route_11, route_00, route_33;

    reg  [(40*8)-1:0] testcase;

    mvmt_logic #(.CURR_X(1), .CURR_Y(1), .DATA(DATA)) DUT_11 (.pkt(pkt), .route(route_11));
    mvmt_logic #(.CURR_X(0), .CURR_Y(0), .DATA(DATA)) DUT_00 (.pkt(pkt), .route(route_00));
    mvmt_logic #(.CURR_X(3), .CURR_Y(3), .DATA(DATA)) DUT_33 (.pkt(pkt), .route(route_33));

    integer errors = 0;
    task check (input [63:0] actual, input [63:0] expected, input [8*24-1:0] name);
        if (actual !== expected) begin
            $display("**FAIL** %0s: expected %b, got %b at %0t", name, expected[4:0], actual[4:0], $time);
            errors = errors + 1;
        end else begin
            $display("  PASS   %0s: %h at %0t", name, actual, $time);
        end
    endtask

    // function builds a test packet with coords (x,y)
    function [DATA-1:0] to (input [1:0] x, input [1:0] y);
        to = {1'b1, x, y, 32'h0};
    endfunction


    initial begin

        // packet moves once in each direction starting at (1,1)
        testcase = "TESTCASE: each direction from (1,1)";
        $display("%0s", testcase);
        pkt = to(2,1); #1; check(route_11, GO_RIGHT, "(1,1) to (2,1)");
        pkt = to(0,1); #1; check(route_11, GO_LEFT,  "(1,1) to (0,1)");
        pkt = to(1,3); #1; check(route_11, GO_UP,    "(1,1) to (1,3)");
        pkt = to(1,0); #1; check(route_11, GO_DOWN,  "(1,1) to (1,0)");
        pkt = to(1,1); #1; check(route_11, GO_LOCAL, "(1,1) to (1,1)");

        // moves in X direction first 
        testcase = "TESTCASE: X before Y";
        $display("%0s", testcase);
        pkt = to(3,0); #1; check(route_11, GO_RIGHT, "X first (3,0)");
        pkt = to(0,3); #1; check(route_11, GO_LEFT,  "X first (0,3)");

        // head along X toward the far edge, never off the mesh
        testcase = "TESTCASE: X stays on mesh";
        $display("%0s", testcase);

        pkt = to(3,3); #1;
        check(route_00, GO_RIGHT, "(0,0) to (3,3)");

        pkt = to(0,0); #1;
        check(route_33, GO_LEFT,  "(3,3) to (0,0)");

        pkt = to(0,3); #1;
        check(route_33, GO_LEFT,  "(3,3) to (0,3)");


        // head along Y toward the far edge, never off the mesh
        testcase = "TESTCASE: Y stays on mesh";
        $display("%0s", testcase);

        pkt = to(0,3); #1;
        check(route_00, GO_UP,    "(0,0) to (0,3)");    // same column: go up

        pkt = to(3,0); #1;
        check(route_33, GO_DOWN,  "(3,3) to (3,0)");    // same column: go down

        pkt = to(3,3); #1;
        check(route_33, GO_LOCAL, "(3,3) to (3,3)");    // arrived

        pkt = to(0,0); #1;
        check(route_00, GO_LOCAL, "(0,0) to (0,0)");    // arrived

        if (errors == 0) $display("\n---------- MVMT LOGIC: SIMULATION PASSED ----------\n");
        else             $display("\n---------- MVMT LOGIC: SIMULATION FAILED, %0d errors ----------\n", errors);
        $finish;
    end

endmodule