module bus_addr(M_addr,S0_sel,S1_sel,S2_sel, S3_sel);//address decoder module

	input [7:0] M_addr;//master address
	output S0_sel, S1_sel, S2_sel, S3_sel;//slave selection output
	reg S0_sel, S1_sel, S2_sel, S3_sel;//reg slave selection
	wire [3:0] upper_bit;//wire upper bit
	
	assign upper_bit=M_addr[7:4];//assign upper bit as M_addr[7:4]
	
	always @ (M_addr) begin//combinational logic block
		if(upper_bit==4'h0) {S0_sel, S1_sel, S2_sel, S3_sel}<=4'b1000;//if upper_bit==4'h0, slave0 is selected
		else if(upper_bit==4'h1)	{S0_sel, S1_sel, S2_sel, S3_sel}<=4'b0100;//if upper_bit==4'h1, slave 1 is selected
		else if((upper_bit==4'h2)||(upper_bit==4'h3))	{S0_sel, S1_sel, S2_sel, S3_sel}<=4'b0010;//if upper_bit==4'h2or 4'h3, slave 2 is selected
		else if((upper_bit==4'h4)||(upper_bit==4'h5))	{S0_sel, S1_sel, S2_sel, S3_sel}<=4'b0001;//if upper_bit==4'h4 or 4'h5, slave 3 is selected
		else	{S0_sel, S1_sel, S2_sel, S3_sel}<=4'b0000;//default
	end
	
endmodule//endmodule



		