`timescale 1ns / 1ps

//   input  j       at data_in [j*DATA +: DATA]
//   output i       at data_out[i*DATA +: DATA]
//   output i grant at sel[i*N + j]  (bit j = input j)


// all five outputs being used at once
// some being used

module crossbar_tb;

    parameter N = 5;
    parameter DATA = 37;

    localparam LOCAL = 0, UP = 1, RIGHT = 2, DOWN = 3, LEFT = 4;

    reg  [N*DATA-1:0] data_in;
    reg  [N*N-1:0] sel;

    wire [N*DATA-1:0] data_out;

    integer i, j, k;

    reg  [(40*8)-1:0] testcase;

    crossbar #(.N(N), .DATA(DATA)) DUT (
        .data_in  (data_in),
        .sel      (sel),
        .data_out (data_out)
    );

    integer errors = 0;
    task check (input [63:0] actual, input [63:0] expected, input [8*24-1:0] name);
        if (actual !== expected) begin
            $display("**FAIL** %0s: expected %h, got %h at %0t", name, expected, actual, $time);
            errors = errors + 1;
        end else begin
            $display("  PASS   %0s: %h at %0t", name, actual, $time);
        end
    endtask

    // 0 means nothing selected so it starts at 1-5 and it will show which input it took
    function [DATA-1:0] pkt (input integer n);
        pkt = n + 1;
    endfunction


    initial begin

        // position in data_in being set equal to pkt(j)
        for (j = 0; j < N; j = j + 1) begin
            data_in[j*DATA +: DATA] = pkt(j);
        end

        // nothing selected thus every output is 0
        testcase = "TESTCASE: nothing selected";
        $display("%0s", testcase);
        sel = 0;
        #1;
        for (i = 0; i < N; i = i + 1) begin
            check(data_out[i*DATA +: DATA], 0, "nothing selected");
        end 

        // every output takes every input, one pair at a time (25 pairs) and only output i gets data, the rest stay 0
        testcase = "TESTCASE: every single pair";
        $display("%0s", testcase);
        for (i = 0; i < N; i = i + 1) begin
            for (j = 0; j < N; j = j + 1) begin
                sel = 0;
                sel[i*N + j] = 1;               // output i takes input j
                #1;
                for (k = 0; k < N; k = k + 1)
                    check(data_out[k*DATA +: DATA], (k == i) ? pkt(j) : 0, "single pair");
            end
        end

        // all five outputs busy at once, each with a different input
        testcase = "TESTCASE: all outputs busy";
        $display("%0s", testcase);
        sel = 0;
        sel[LOCAL*N + UP]   = 1;
        sel[UP*N    + RIGHT]   = 1;
        sel[RIGHT*N + DOWN] = 1;
        sel[DOWN*N  + LEFT]  = 1;
        sel[LEFT*N  + LOCAL] = 1;
        #1;
        check(data_out[LOCAL*DATA +: DATA], pkt(UP),    "all busy: LOCAL");
        check(data_out[UP*DATA    +: DATA], pkt(RIGHT), "all busy: UP");
        check(data_out[RIGHT*DATA +: DATA], pkt(DOWN),  "all busy: RIGHT");
        check(data_out[DOWN*DATA  +: DATA], pkt(LEFT),  "all busy: DOWN");
        check(data_out[LEFT*DATA  +: DATA], pkt(LOCAL), "all busy: LEFT");

        // a two packets moving, three outputs idle
        testcase = "TESTCASE: some outputs idle";
        $display("%0s", testcase);
        sel = 0;
        sel[RIGHT*N + LEFT] = 1;                // left -> right
        sel[LOCAL*N + UP  ] = 1;                // up -> arrives here
        #1;
        check(data_out[RIGHT*DATA +: DATA], pkt(LEFT), "idle: RIGHT");
        check(data_out[LOCAL*DATA +: DATA], pkt(UP),   "idle: LOCAL");
        check(data_out[UP*DATA +: DATA], 0,            "idle: UP");
        check(data_out[DOWN*DATA +: DATA], 0,          "idle: DOWN");
        check(data_out[LEFT*DATA +: DATA], 0,          "idle: LEFT");

        // full 37-bit packet passes through untouched
        testcase = "TESTCASE: full packet width";
        $display("%0s", testcase);
        data_in[LEFT*DATA +: DATA] = 37'h1F_FFFF_FFFF; // all ones
        #1;
        check(data_out[RIGHT*DATA +: DATA], 37'h1F_FFFF_FFFF, "full width"); //output all ones


        if (errors == 0) $display("\n---------- CROSSBAR: SIMULATION PASSED ----------\n");
        else             $display("\n---------- CROSSBAR: SIMULATION FAILED, %0d errors ----------\n", errors);
        $finish;
    end

endmodule