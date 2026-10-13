`timescale 1ns / 1ps

module fifo #(parameter DEPTH = 8)(

    input wire clk,
    input wire rst_n, 

    output reg req;

    );

    localparam THRESH = (DEPTH * 4) / 5;        // 80%, rounded down
    localparam Y = (DEPTH * 2) / 5;;
    reg almost_empty, almost_full, empty, full;


endmodule
    