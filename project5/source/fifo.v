`timescale 1ns / 1ps

// all packets have a 5bit header and a 32bit message


// 1st bit new data -> 0 old 1 new
// next two bits are where its coming from 
// next two bits are where its going
// rest of the 32 are data 

module fifo #(
    parameter DEPTH = 8,
    parameter WIDTH  = 37)(

    input wire clk,
    input wire rst_n, 

    // grant signal coming from the ariter
    input wire read_en,

    // signal req to write coming from wherever
    input wire write_en,

    // data coming in 
    input wire [WIDTH-1:0] wr_data,

    // data going out 
    output wire [WIDTH-1:0] rd_data,

    // almost flags can be used but are not
    // we can use these flags as requests and stoppers for the flow of the fifo
    output wire empty, full

    ); 

    // finds the amount of bits needed to represent depth with extra bit
    localparam X = $clog2(DEPTH);


    // uses localparam X above to number the rows
    reg [X:0] wr_pntr,rd_pntr;


    // array with DEPTH rows and WIDTH bit wide
    reg [WIDTH-1:0] mem [0:DEPTH-1];


    // empty when both pointers are equal ie. read caught up with write
    assign empty = (wr_pntr == rd_pntr);

    // full when the pointers differ by the MSB
    assign full  = (wr_pntr[X-1] == rd_pntr[X-1] && wr_pntr[X] != rd_pntr[X]);


// write, mem, read block
    // write block 
    // if the fifo is not full and data is being written then increment the write pointer by 1
    always @(posedge clk or negedge rst_n) begin 
        if (!rst_n) wr_pntr <= '0;
        else if (!full && write_en) begin 
            wr_pntr <= wr_pntr + 1;
        end
    end // always @(posedge clk or negedge rst_n)


    // memory block
    // the memory does not have a reset since it needs to map to RAM
    always @(posedge clk) begin
        if (!full && write_en) mem[wr_pntr[X-1]] <= wr_data;
    end // always @(posedge clk)

    // read
    // if the fifo is not empty and data is being read then increment the read pointer by 1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) rd_pntr <= '0;
        else if (!empty && read_en) begin 
            rd_pntr <= rd_pntr + 1;
        end
    end // always @(posedge clk or negedge rst_n)

// output block
    assign rd_data = mem[rd_pntr[X-1]];


endmodule
    