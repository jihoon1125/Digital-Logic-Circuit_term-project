module _dff_r(clk, reset_n, d, q);//Resettable D flip flop
	input clk, reset_n;
	input d;
	output reg q;//output reg q
	
	always@ (posedge clk or negedge reset_n) begin//reset_n is prior than en
		if(~reset_n)		q<=1'b0;					
		else 					q<=d;
	end
endmodule//endmodule
