












Edge Detection Design
---------------------------------------------------------------------
``` Verilog
reg signal_prev;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        signal_prev <= 0;
    end else begin
        signal_prev <= signal;   // store previous value every cycle
    end
end

wire signal_edge = signal && !signal_prev;   // rising edge: 0 -> 1
```
----------------------------------------------------------------------
