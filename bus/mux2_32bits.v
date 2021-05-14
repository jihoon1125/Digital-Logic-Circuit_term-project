module mux2_32bits(a,b,sel,d);//mux2-32bits

	input [31:0] a,b;//32-bits inputs
	input sel;//selection
	output [31:0] d;//32-bits output
	
	assign d = (sel==0)? a : b;//conditional operation
	
	endmodule//endmodule
	
	