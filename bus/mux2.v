module mux2(a,b,sel,d);//mux2
	input a,b,sel;//inputs and selection
	output d;//output
	
	assign d = (sel==0)? a : b;//conditional operator
	
endmodule//endmodule

