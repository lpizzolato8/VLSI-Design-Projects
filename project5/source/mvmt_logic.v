`timescale 1ns / 1ps

module mvmt_logic #(
    parameter CURR_X = 0,
    parameter CURR_Y = 0,
    parameter DATA = 37
)(
    input  wire [DATA-1:0] pkt,      // head packet of one input fifo
    output reg  [4:0] route          // one-hot -> which output this packet wants
);
    localparam LOCAL = 0, UP = 1, RIGHT = 2, DOWN = 3, LEFT = 4;

    // header: [36] new data, [35:34] dest_x, [33:32] dest_y, [31:0] payload
    wire [1:0] dest_x = pkt[35:34];
    wire [1:0] dest_y = pkt[33:32];

    // packet goes both directions. uses destination coordinates to determine if it should go left or right when searching for the column
    // or up or down when searching for the row. Using XY routing and the packet will never need to reverse

    always @(*) begin
        route = 5'b00000;
        if (dest_x > CURR_X) route[RIGHT]      = 1'b1;   // wrong column -> go right
        else if (dest_x < CURR_X) route[LEFT]  = 1'b1;   // wrong column -> go left
        else if (dest_y > CURR_Y) route[UP]    = 1'b1;   // right column -> go up
        else if (dest_y < CURR_Y) route[DOWN]  = 1'b1;   // right column -> go down
        else route[LOCAL]                      = 1'b1;   // arrived -> go to local
    end

endmodule