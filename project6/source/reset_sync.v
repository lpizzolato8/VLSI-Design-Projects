module reset_sync (

    input  wire clk,
    input  wire rst_n_async, 
    output wire rst_n_sync 

);
    // 2 registers to chain together
    reg ff1, ff2;

    always @(posedge clk or negedge rst_n_async) begin
        if (!rst_n_async) begin
            ff1 <= 1'b0;
            ff2 <= 1'b0;
        end else begin
            // ff1 goes high and ff2 samples ff1 data
            ff1 <= 1'b1;
            ff2 <= ff1;
        end
    end

    // rst_n_sync is assigned the value of ff2 always
    assign rst_n_sync = ff2;
    
endmodule