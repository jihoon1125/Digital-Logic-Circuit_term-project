module _dff32_r(clk, reset_n, d, q);//Resettable D 4bit register
	input clk, reset_n;
	input [31:0] d;
	output [31:0]q;//output q
	
_dff4_r U0_dff_r(clk, reset_n, d[3:0], q[3:0]);
_dff4_r U1_dff_r(clk, reset_n, d[7:4], q[7:4]);
_dff4_r U2_dff_r(clk, reset_n, d[11:8], q[11:8]);
_dff4_r U3_dff_r(clk, reset_n, d[15:12], q[15:12]);
_dff4_r U4_dff_r(clk, reset_n, d[19:16], q[19:16]);
_dff4_r U5_dff_r(clk, reset_n, d[23:20], q[23:20]);
_dff4_r U6_dff_r(clk, reset_n, d[27:24], q[27:24]);
_dff4_r U7_dff_r(clk, reset_n, d[31:28], q[31:28]);

endmodule//endmodule