
//input ports
add mapped point clk clk -type PI PI
add mapped point rst_n rst_n -type PI PI
add mapped point quarter_inserted quarter_inserted -type PI PI
add mapped point button_pressed button_pressed -type PI PI

//output ports
add mapped point vend_cola vend_cola -type PO PO

//inout ports




//Sequential Pins
add mapped point state_current[0]/q state_current_reg[0]/Q -type DFF DFF
add mapped point state_current[1]/q state_current_reg[1]/Q -type DFF DFF



//Black Boxes



//Empty Modules as Blackboxes
