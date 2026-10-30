`timescale 1ns / 1ps

//  data_in (185 bits)
//  184      148 147      111 110       74 73        37 36         0
//  [   LEFT    ][   DOWN    ][   RIGHT   ][    UP     ][   LOCAL   ]

// +: is a selector that choose starting bit and length inside of bit stream


module crossbar #(
    parameter N    = 5,
    parameter DATA = 37
)(
    input  wire [N*DATA-1:0] data_in,   // input data coming in
    input  wire [N*N-1:0]    sel,       // one hot selector coming from arbiters
    output reg  [N*DATA-1:0] data_out   // data going out
);

    integer i, j;

    // The outer loop picks the output i, and the inner loop tries every input j
    always @(*) begin
        for (i = 0; i < N; i = i + 1) begin
            // data_out should be 0 when nothing is being put out
            data_out[i*DATA +: DATA] = 0;

            for (j = 0; j < N; j = j + 1) begin
                // if the one hot grant is high for the fifo it is evaluating at then data out = data in 
                if (sel[i*N + j]) data_out[i*DATA +: DATA] = data_in[j*DATA +: DATA];
            end
        end
    end
endmodule