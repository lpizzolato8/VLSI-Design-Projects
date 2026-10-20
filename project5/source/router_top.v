`timescale 1ns / 1ps

// all packets have a 5bit header and a 32bit message

module router_top #()(

    input wire clk, 
    input wire rst_n

    ); 

    fifo #(.N(N)) left(
        .clk(clk),
        .rst_n(rst_n),
        .req_granted(req_granted),
        .want_write(want_write),
        .wr_data(wr_data),
        .rd_data(rd_data),
        .almost_empty(almost_empty), 
        .almost_full(almost_full), 
        .empty(empty), 
        .full(full)
    );

    fifo #(.N(N)) right(
        .clk(clk),
        .rst_n(rst_n),
        .req_granted(req_granted),
        .want_write(want_write),
        .wr_data(wr_data),
        .rd_data(rd_data),
        .almost_empty(almost_empty), 
        .almost_full(almost_full), 
        .empty(empty), 
        .full(full)
    );

    fifo #(.N(N)) up(
        .clk(clk),
        .rst_n(rst_n),
        .req_granted(req_granted),
        .want_write(want_write),
        .wr_data(wr_data),
        .rd_data(rd_data),
        .almost_empty(almost_empty), 
        .almost_full(almost_full), 
        .empty(empty), 
        .full(full)
    );

    fifo #(.N(N)) down(
        .clk(clk),
        .rst_n(rst_n),
        .req_granted(req_granted),
        .want_write(want_write),
        .wr_data(wr_data),
        .rd_data(rd_data),
        .almost_empty(almost_empty), 
        .almost_full(almost_full), 
        .empty(empty), 
        .full(full)
    );

    fifo #(.N(N)) local(
        .clk(clk),
        .rst_n(rst_n),
        .req_granted(req_granted),
        .want_write(want_write),
        .wr_data(wr_data),
        .rd_data(rd_data),
        .almost_empty(almost_empty), 
        .almost_full(almost_full), 
        .empty(empty), 
        .full(full)
    );

    arbiter #(.N(N)) left(
        .clk(clk),
        .rst_n(rst_n),
        .req(req),
        .grant(grant),
        .winner_found(winner_found)
    );

    arbiter #(.N(N)) right(
        .clk(clk),
        .rst_n(rst_n),
        .req(req),
        .grant(grant),
        .winner_found(winner_found)
    );

    arbiter #(.N(N)) up(
        .clk(clk),
        .rst_n(rst_n),
        .req(req),
        .grant(grant),
        .winner_found(winner_found)
    );

    arbiter #(.N(N)) down(
        .clk(clk),
        .rst_n(rst_n),
        .req(req),
        .grant(grant),
        .winner_found(winner_found)
    );

    arbiter #(.N(N)) local(
        .clk(clk),
        .rst_n(rst_n),
        .req(req),
        .grant(grant),
        .winner_found(winner_found)
    );


endmodule
    