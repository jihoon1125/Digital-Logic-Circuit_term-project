module TOP(clk, reset_n, M0_req, M0_wr, M0_address, M0_dout, M0_grant, F_interrupt, D_interrupt, M_din);
	input clk, reset_n;
	input M0_req, M0_wr;
	input [7:0] M0_address;
	input [31:0] M0_dout;
	output M0_grant;
	output F_interrupt;
	output D_interrupt;
	output [31:0] M_din;
	
	
	wire M1_grant;
	wire S0_sel, S1_sel, S2_sel, S3_sel;
	wire S_wr;
	wire [7:0] S_address;
	wire [31:0] S_din;
	wire M1_req, M1_wr;
	wire [7:0] M1_address;
	wire [31:0] M1_dout;
	wire [31:0] S0_dout, S1_dout, S2_dout, S3_dout;
		
	DMAC_Top U0_DMAC(clk, reset_n, M1_grant, M_din, S0_sel,S_wr,S_address,S_din,M1_req,M1_wr,M1_address,M1_dout,S0_dout,D_interrupt);
	
	
	Factorial_Top U1_FACT(clk, reset_n, S1_sel, S_wr, S_address, S_din, S1_dout, F_interrupt);
	
	ram data(clk, S2_sel, S_wr, S_address[4:0], S_din, S2_dout);
	ram result(clk, S3_sel, S_wr, S_address[4:0], S_din, S3_dout);
	
	
	
	BUS center_bus(clk, reset_n, M0_req, M0_wr, M0_address, M0_dout, M1_req,
				M1_wr, M1_address, M1_dout, S0_dout, S1_dout, S2_dout, S3_dout,
				M0_grant, M1_grant, M_din, S0_sel, S1_sel, S2_sel, S3_sel, S_address,
				S_wr, S_din);
				
	endmodule	