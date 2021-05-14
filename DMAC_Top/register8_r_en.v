module register8_r_en(clk, reset_n, d_in, d_out, en);//8bit dff_r_en register to make 32bit register
	input clk,reset_n,en;
	input [7:0]d_in;//8bit input
	output [7:0]d_out;//8bit output
	
	//Instantiation of dff_r_en 8times
	_dff_r_en U0_dff_r_en(clk, reset_n, en, d_in[0], d_out[0]);
	_dff_r_en U1_dff_r_en(clk, reset_n, en, d_in[1], d_out[1]);
	_dff_r_en U2_dff_r_en(clk, reset_n, en, d_in[2], d_out[2]);
	_dff_r_en U3_dff_r_en(clk, reset_n, en, d_in[3], d_out[3]);
	_dff_r_en U4_dff_r_en(clk, reset_n, en, d_in[4], d_out[4]);
	_dff_r_en U5_dff_r_en(clk, reset_n, en, d_in[5], d_out[5]);
	_dff_r_en U6_dff_r_en(clk, reset_n, en, d_in[6], d_out[6]);
	_dff_r_en U7_dff_r_en(clk, reset_n, en, d_in[7], d_out[7]);
endmodule//endmodule
	