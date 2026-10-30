`timescale 1ns / 1ps

// using default_nettype none to catch errors in non assigned names (mispelled in my case)
`default_nettype none

module router_top #(
    parameter DEPTH  = 8,
    parameter DATA   = 37,
    parameter CURR_X = 0,
    parameter CURR_Y = 0,
    parameter N      = 5
    )(

    input wire clk,
    input wire rst_n,

    // in from the neighbor nodes
    input  wire [N*DATA-1:0] in_data,       // packet from neighbor node
    input  wire [N-1:0]      in_valid,      // neighbor node is pushing a packet this cycle
    output wire [N-1:0]      in_full,       // our fifo is full, neighbor node must stop

    // out to the neighbor nodes
    output wire [N*DATA-1:0] out_data,      // packet going to neighbor node
    output wire [N-1:0]      out_valid,     // packet going out to a new node
    input  wire [N-1:0]      out_full       // neighbor node fifo is full, don't send

    );

    // local var

    // fifo var
    wire [N*DATA-1:0] fifo_data;            // the 1 bit new packet at head
    wire [N-1:0]      fifo_empty;           // fifo is empty
    reg  [N-1:0]      fifo_pop;             // fifo pop packet

    // mvmt logic var
    wire [N*N-1:0]    route;                // onehot output, which output this packet wants

    // arbiter var
    reg  [N*N-1:0]    arb_req;              // incoming reqs from the fifos, one bit per fifo (00001, 5 requesting)
    wire [N*N-1:0]    grant;                // onehot winner

    // loop variables for the always blocks: i = output (arbiter), k = input (fifo)
    integer i, k;


    // LOCAL = 0, UP = 1, RIGHT = 2, DOWN = 3, LEFT = 4
    genvar p; // genvar is a generation variable

    // fifo generation. N many of fifos needed (5 for this 4x4 mesh)
    generate
        for (p = 0; p < N; p = p + 1) begin : g_fifo
            fifo #(.DEPTH(DEPTH), .WIDTH(DATA)) u_fifo (
                .clk      (clk),
                .rst_n    (rst_n),
                .write_en (in_valid[p]),                 // neighbor node p is sending this node a packet
                .wr_data  (in_data[p*DATA +: DATA]),     // the packet from neighbor node p
                .read_en  (fifo_pop[p]),                 // fifo p req granted
                .rd_data  (fifo_data[p*DATA +: DATA]),   // packet of fifo p
                .empty    (fifo_empty[p]),
                .full     (in_full[p])                   // tells neighbor node p to stop sending 
            );
        end
    endgenerate

    // mvmt_logic generation
    generate
        for (p = 0; p < N; p = p + 1) begin : g_mvmt_logic
            mvmt_logic #(.CURR_X(CURR_X), .CURR_Y(CURR_Y), .DATA(DATA)) u_mvmt (
                .pkt   (fifo_data[p*DATA +: DATA]),     // packet of fifo p
                .route (route[p*N +: N])                // which output fifo p wants
            );
        end
    endgenerate

    // arbiter generation, same format as fifo. one per output
    generate
        for (p = 0; p < N; p = p + 1) begin : g_arbiter
            arbiter #(.N(N)) u_arbiter (
                .clk          (clk),
                .rst_n        (rst_n),
                .req          (arb_req[p*N +: N]),
                .grant        (grant[p*N +: N]),
                .winner_found (out_valid[p])
            );
        end
    endgenerate


    // arbiter request logic
    // fifo k requests arbiter i when fifo k has a packet, that packet is
    // headed out output i, and the neighbor on output i is not full
    always @(*) begin
        for (i = 0; i < N; i = i + 1) begin                     // here i = output (which arbiter)
            for (k = 0; k < N; k = k + 1) begin                 // here k = input (which fifo)
                arb_req[i*N + k] = 1'b0;                        // default is no req
                if (!fifo_empty[k] && route[k*N + i] && !out_full[i]) arb_req[i*N + k] = 1'b1;
            end
        end // for loop
    end // always @(*)


    // logic for the fifo to send its data to the mux
    // grant[2*5 + 4] -> arbiter 2, fifo 4 -> which is bit 14 in the bus
    always @(*) begin
        for (i = 0; i < N; i = i + 1) begin                     // here i = fifo
            fifo_pop[i] = 1'b0;                                 // default is don't pop
            for (k = 0; k < N; k = k + 1)                       // here k = arbiter
                if (grant[k*N + i]) fifo_pop[i] = 1'b1;         // if grant is high for that fifo then pop 
        end
    end // always @(*)

    // crossbar mux
    crossbar #(.N(N), .DATA(DATA)) u_crossbar (
        .data_in  (fifo_data),
        .sel      (grant),
        .data_out (out_data)
    );

endmodule

`default_nettype wire