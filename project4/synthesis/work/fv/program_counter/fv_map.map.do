
//input ports
add mapped point clk clk -type PI PI
add mapped point rst_n rst_n -type PI PI
add mapped point update_msbs update_msbs -type PI PI
add mapped point update_lsbs update_lsbs -type PI PI
add mapped point jump jump -type PI PI
add mapped point jump_destination[5] jump_destination[5] -type PI PI
add mapped point jump_destination[4] jump_destination[4] -type PI PI
add mapped point jump_destination[3] jump_destination[3] -type PI PI
add mapped point jump_destination[2] jump_destination[2] -type PI PI
add mapped point jump_destination[1] jump_destination[1] -type PI PI
add mapped point jump_destination[0] jump_destination[0] -type PI PI
add mapped point branch branch -type PI PI
add mapped point branch_offset[5] branch_offset[5] -type PI PI
add mapped point branch_offset[4] branch_offset[4] -type PI PI
add mapped point branch_offset[3] branch_offset[3] -type PI PI
add mapped point branch_offset[2] branch_offset[2] -type PI PI
add mapped point branch_offset[1] branch_offset[1] -type PI PI
add mapped point branch_offset[0] branch_offset[0] -type PI PI

//output ports
add mapped point mem_addr[7] mem_addr[7] -type PO PO
add mapped point mem_addr[6] mem_addr[6] -type PO PO
add mapped point mem_addr[5] mem_addr[5] -type PO PO
add mapped point mem_addr[4] mem_addr[4] -type PO PO
add mapped point mem_addr[3] mem_addr[3] -type PO PO
add mapped point mem_addr[2] mem_addr[2] -type PO PO
add mapped point mem_addr[1] mem_addr[1] -type PO PO
add mapped point mem_addr[0] mem_addr[0] -type PO PO

//inout ports




//Sequential Pins
add mapped point mem_addr[7]/q mem_addr_reg[7]/Q -type DFF DFF
add mapped point mem_addr[6]/q mem_addr_reg[6]/Q -type DFF DFF
add mapped point mem_addr[5]/q mem_addr_reg[5]/Q -type DFF DFF
add mapped point mem_addr[4]/q mem_addr_reg[4]/Q -type DFF DFF
add mapped point mem_addr[3]/q mem_addr_reg[3]/Q -type DFF DFF
add mapped point mem_addr[2]/q mem_addr_reg[2]/Q -type DFF DFF
add mapped point mem_addr[0]/q mem_addr_reg[0]/Q -type DFF DFF
add mapped point mem_addr[1]/q mem_addr_reg[1]/Q -type DFF DFF
add mapped point jump_destination_q[5]/q jump_destination_q_reg[5]/Q -type DFF DFF
add mapped point jump_destination_q[4]/q jump_destination_q_reg[4]/Q -type DFF DFF
add mapped point branch_offset_q[1]/q branch_offset_q_reg[1]/Q -type DFF DFF
add mapped point branch_offset_q[5]/q branch_offset_q_reg[5]/Q -type DFF DFF
add mapped point jump_destination_q[2]/q jump_destination_q_reg[2]/Q -type DFF DFF
add mapped point jump_destination_q[3]/q jump_destination_q_reg[3]/Q -type DFF DFF
add mapped point branch_q/q branch_q_reg/Q -type DFF DFF
add mapped point jump_destination_q[1]/q jump_destination_q_reg[1]/Q -type DFF DFF
add mapped point branch_offset_q[2]/q branch_offset_q_reg[2]/Q -type DFF DFF
add mapped point branch_offset_q[4]/q branch_offset_q_reg[4]/Q -type DFF DFF
add mapped point branch_offset_q[3]/q branch_offset_q_reg[3]/Q -type DFF DFF
add mapped point branch_offset_q[0]/q branch_offset_q_reg[0]/Q -type DFF DFF
add mapped point jump_destination_q[0]/q jump_destination_q_reg[0]/Q -type DFF DFF
add mapped point jump_q/q jump_q_reg/Q -type DFF DFF
add mapped point update_msbs_q/q update_msbs_q_reg/Q -type DFF DFF
add mapped point update_lsbs_q/q update_lsbs_q_reg/Q -type DFF DFF



//Black Boxes



//Empty Modules as Blackboxes
