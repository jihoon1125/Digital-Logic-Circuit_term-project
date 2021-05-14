module _dff4_r(clk, reset_n, d, q);//Resettable D 4bit register
	input clk, reset_n;
	input [3:0] d;
	output[3:0]q;//output q
	
_dff_r U0_dff_r(clk, reset_n, d[0], q[0]);
_dff_r U1_dff_r(clk, reset_n, d[1], q[1]);
_dff_r U2_dff_r(clk, reset_n, d[2], q[2]);
_dff_r U3_dff_r(clk, reset_n, d[3], q[3]);

endmodule//endmodule