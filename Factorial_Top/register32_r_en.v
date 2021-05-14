module register32_r_en(clk, reset_n, d_in, d_out, en);//32bit dff_r_en register 
	input clk,reset_n,en;
	input [31:0]d_in;//32bit input
	output [31:0]d_out;//32bit output
	
	//Instantiation of register8_r_en 4times
	register8_r_en U0_register8(clk, reset_n, d_in[7:0], d_out[7:0], en);
	register8_r_en U1_register8(clk, reset_n, d_in[15:8], d_out[15:8], en);
	register8_r_en U2_register8(clk, reset_n, d_in[23:16], d_out[23:16], en);
	register8_r_en U3_register8(clk, reset_n, d_in[31:24], d_out[31:24], en);
endmodule//endmodule


	