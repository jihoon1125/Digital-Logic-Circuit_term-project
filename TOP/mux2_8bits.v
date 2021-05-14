module mux2_8bits(a,b,sel,d);//mux2-8bits
	input [7:0] a,b;//8-bits inputs
	input sel;//selection
	output [7:0] d;//8-bit output
	
	assign d = (sel==0)? a : b;//condition operator
	
	endmodule//endmodule
	
	
	