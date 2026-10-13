`timescale 1ns / 1ps

// Important!! never grant to a fifo that is empty


module arbiter #( parameter N = 5 ) (

    input wire clk,
    input wire rst_n,

    // incoming reqs -> (when N number of fifos is 5 -> 00101) this means fifo 3 and 5 are high
    input wire [N-1:0] req,

    // grant signal to send back to the fifo
    output reg [N-1:0] grant,
    output reg winner_found

    );

    localparam X = $clog2(N);

    // local variables
    reg [X-1:0] last_winner;
    reg [N-1] winner;
    integer i, which_fifo;

    always @(*) begin
        // default values to make sure there arent latches
        grant        = {N{1'b0}};
        winner_found = 1'b0;
        winner       = last_winner;

        for (i=1; i<=N; i=i+1) begin

            // think that there is a number of checkers N that rotate the fifos. the last winning fifo is the last fifo to be checked and the last winning fifo
            // + 1 is the first fifo to be checked. so we can say that the fifo we are checking right now is the last winner plus the # checker we are in.
            // ie. last winner was 3, so we check 3+1 first, second 3+2, third 3+3 but what if 3+4 is greater than the number of checkers we have (only 6)
            
            // then take 3+4 and subtract the total number of checkers, 3+4 - N = 1 -> 7-6=1. Since there will always be a number of checkers = to number of fifos
            // we know that that we can wrap like this

            which_fifo = last_winner + i;           
            if (which_fifo >= N) which_fifo = which_fifo - N;

            // a checker should only check a fifo if the winner isnt found and they have a high req, otherwise no point
            if (!winner_found && req[which_fifo]) begin
                // one hot implementation for grant signal
                grant[which_fifo] = 1'b1;
                winner        = which_fifo;
                winner_found  = 1'b1; 
            end

        end // for
    end // always @(*)


    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) last_winner <= N-1;                 // if reset then make most recent winner the second to last fifo then loop will start on the first
        else if (winner_found) last_winner <= winner;     // if the winner is found then the last winner is now the current winner
    end


endmodule
