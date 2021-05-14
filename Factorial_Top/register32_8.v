module register32_8(clk,reset_n,en,d_in,d_out0,d_out1,d_out2,d_out3,d_out4,d_out5,d_out6,d_out7);//making 32 bit register 8times
	input clk,reset_n;
	input [7:0]en;//8bit en
	input [31:0]d_in;//32bit input
	output [31:0]d_out0,d_out1,d_out2,d_out3,d_out4,d_out5,d_out6,d_out7;//8 outputs of 32bit register
	
	//Instantiation of register32_r_en 8times
	register32_r_en U0_register32(clk, reset_n, d_in, d_out0, en[0]);
	register32_r_en U1_register32(clk, reset_n, d_in, d_out1, en[1]);
	register32_r_en U2_register32(clk, reset_n, d_in, d_out2, en[2]);
	register32_r_en U3_register32(clk, reset_n, d_in, d_out3, en[3]);
	register32_r_en U4_register32(clk, reset_n, d_in, d_out4, en[4]);
	register32_r_en U5_register32(clk, reset_n, d_in, d_out5, en[5]);
	register32_r_en U6_register32(clk, reset_n, d_in, d_out6, en[6]);
	register32_r_en U7_register32(clk, reset_n, d_in, d_out7, en[7]);
endmodule//endmodule
	
	
	
	
	