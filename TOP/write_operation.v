module write_operation(Addr,we,to_reg);//writing operation module
	input we;//writing enable input
	input [2:0]Addr;//3bit Addr input
	output [7:0]to_reg;//8bit output to register
	
	wire [7:0] write_wire;//wire to check we
	
	//Instantiation of 3 to 8 decoder and 8 and2 gates to write
	_3_to_8decoder U0_3_to_8decoder(Addr,write_wire);
	_and2 			U1_and2(we,write_wire[0],to_reg[0]);
	_and2 			U2_and2(we,write_wire[1],to_reg[1]);
	_and2 			U3_and2(we,write_wire[2],to_reg[2]);
	_and2 			U4_and2(we,write_wire[3],to_reg[3]);
	_and2 			U5_and2(we,write_wire[4],to_reg[4]);
	_and2 			U6_and2(we,write_wire[5],to_reg[5]);
	_and2 			U7_and2(we,write_wire[6],to_reg[6]);
	_and2 			U8_and2(we,write_wire[7],to_reg[7]);
endmodule//endmodule