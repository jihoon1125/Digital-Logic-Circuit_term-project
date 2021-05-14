module read_operation(Addr,Data,from_reg0, from_reg1, from_reg2,//reading operation
							from_reg3, from_reg4, from_reg5, from_reg6, from_reg7);
	input [31:0]from_reg0, from_reg1, from_reg2,from_reg3, from_reg4, from_reg5, from_reg6, from_reg7;//8 32bit inputs
	input [2:0]Addr;//3bit Addr
	output [31:0]Data;//32bit Data output
		
	//Mux instace
	_8_to_1_MUX U0_8_to_1_MUX(from_reg0, from_reg1, from_reg2,from_reg3, from_reg4, from_reg5, from_reg6, from_reg7, Addr, Data);
	
endmodule//endmodule



	
	