`timescale 1ns / 1ps

// doesnt grant two fifos at the same time
// 1 fifo doesnt keep winning
// reset works
// all fifos request


module arbiter_tb;

    parameter N = 5;

    reg          clk;
    reg          rst_n;
    reg  [N-1:0] req;

    wire [N-1:0] grant;
    wire         winner_found;

    reg  [(40*8)-1:0] testcase;     

    arbiter #(.N(N)) DUT (
        .clk          (clk),
        .rst_n        (rst_n),
        .req          (req),
        .grant        (grant),
        .winner_found (winner_found)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    integer errors = 0;
    task check (input [63:0] actual, input [63:0] expected, input [8*24-1:0] name);
        if (actual !== expected) begin
            $display("**FAIL** %0s: expected %b, got %b at %0t", name, expected[N-1:0], actual[N-1:0], $time);
            errors = errors + 1;
        end else begin
            $display("  PASS   %0s: %h at %0t", name, actual, $time);
        end
    endtask

    // wait n full clock cycles, ending on a negedge like every other step
    task tick (input integer n);
        repeat (n) @(negedge clk);
    endtask

    
    task reset;
        begin
            req = 0;
            rst_n = 0; tick(1);
            rst_n = 1; tick(1);
        end
    endtask

    // everything should be done on the negative edge since last_winner updates on the positive edge

    initial begin

        // last_winner = 4, so fifo 0 is checked first
        testcase = "TESTCASE: reset functionality";
        $display("%0s", testcase);
        req = 0;
        rst_n = 0;
        tick(3);
        rst_n = 1;
        tick(1);

        // no requests: no grant
        #1;
        check(grant,        5'b00000, "no req: grant");
        check(winner_found, 0,        "no req: winner_found");

        req = 0; tick(1);    

        // one requester gets the grant every cycle
        testcase = "TESTCASE: single requester";
        $display("%0s", testcase);
        req = 5'b00100;
        #1; check(grant, 5'b00100, "single 1");
        tick(1);
        #1; check(grant, 5'b00100, "single 2");
        check(winner_found, 1, "single: winner_found");
        tick(1);

        req = 0; tick(1); 
        reset;

        // all 5 request and grants rotate 0,1,2,3,4 then back to 0
        testcase = "TESTCASE: full rotation";
        $display("%0s", testcase);
        req = 5'b11111;
        #1; check(grant, 5'b00001, "rotate 0");    tick(1);
        #1; check(grant, 5'b00010, "rotate 1");    tick(1);
        #1; check(grant, 5'b00100, "rotate 2");    tick(1);
        #1; check(grant, 5'b01000, "rotate 3");    tick(1);
        #1; check(grant, 5'b10000, "rotate 4");    tick(1);
        #1; check(grant, 5'b00001, "rotate wrap"); tick(1);

        req = 0; tick(1);  
        reset;

        // a fifo that just won does not win again while another waits
        testcase = "TESTCASE: no double grant";
        $display("%0s", testcase);
        req = 5'b01010;                                             // fifos 1 and 3
        #1; check(grant, 5'b00010, "no double: 1");      tick(1);   // 1 wins
        req = 5'b01000;                                             // only 3 left
        #1; check(grant, 5'b01000, "no double: 3");      tick(1);   // 3 wins
        req = 5'b01010;                                             // 1 is back, 3 still waiting
        #1; check(grant, 5'b00010, "no double: 1 next"); tick(1);
        #1; check(grant, 5'b01000, "no double: 3 next"); tick(1);

        req = 0; tick(1);  
        reset;

        // a cycle with no requests does not move last_winner
        testcase = "TESTCASE: idle keeps place";
        $display("%0s", testcase);
        req = 5'b10010;
        #1; check(grant, 5'b00010, "idle: 1 wins");  tick(1);       // last_winner = 1
        req = 0;
        #1; check(winner_found, 0, "idle: no winner"); tick(2);     // 2 idle cycles
        req = 5'b10010;
        #1; check(grant, 5'b10000, "idle: 4 next");                 // still after 1, so 4
        tick(1);

        req = 0; tick(1); 
        reset;

        // reset in the middle
        testcase = "TESTCASE: async reset";
        $display("%0s", testcase);
        req = 5'b10010;
        #1; check(grant, 5'b00010, "before reset");   tick(1);      // 1 wins
        #1; check(grant, 5'b10000, "4 is next");                    // 4 would win
        rst_n = 0;
        #1; check(grant, 5'b00010, "after reset");                  // back to 1
        req = 0;
        tick(1);
        rst_n = 1;
        tick(1);


        if (errors == 0) $display("\n---------- ARBITER: SIMULATION PASSED ----------\n");
        else             $display("\n---------- ARBITER: SIMULATION FAILED, %0d errors ----------\n", errors);
        $finish;
    end

endmodule