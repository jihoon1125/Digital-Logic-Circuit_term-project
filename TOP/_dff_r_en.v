module _dff_r_en(clk, reset_n, en, d, q);//Resettable enabled D flip flop
	input clk, reset_n, en, d;
	output reg q;//output reg q
	
	always@ (posedge clk or negedge reset_n) begin//reset_n is prior than en
		if(~reset_n)		q<=1'b0;
		else if(en)			q<=d;
		else					q<=q;
	end
endmodule//endmodule

