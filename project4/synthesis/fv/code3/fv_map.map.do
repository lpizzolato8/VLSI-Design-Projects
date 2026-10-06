
//input ports
add mapped point clk clk -type PI PI
add mapped point rst_n rst_n -type PI PI
add mapped point in1 in1 -type PI PI
add mapped point in2 in2 -type PI PI

//output ports
add mapped point out1 out1 -type PO PO
add mapped point out2 out2 -type PO PO

//inout ports




//Sequential Pins
add mapped point out1/q out1_reg/Q -type DFF DFF
add mapped point out2/q out2_reg/Q -type DFF DFF
add mapped point mid2/q mid2_reg/Q -type DFF DFF
add mapped point mid1/q mid1_reg/Q -type DFF DFF



//Black Boxes



//Empty Modules as Blackboxes
