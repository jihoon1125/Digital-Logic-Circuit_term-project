module BUS(clk, reset_n, M0_req, M0_wr, M0_address, M0_dout, M1_req,//bus top module
				M1_wr, M1_address, M1_dout, S0_dout, S1_dout, S2_dout, S3_dout,
				M0_grant, M1_grant, M_din, S0_sel, S1_sel, S2_sel, S3_sel, S_address,
				S_wr, S_din);
				
	input clk, reset_n, M0_req, M0_wr, M1_req, M1_wr;//clock, reset, M0/M1 request, M0/M1 write
	input [7:0]M0_address, M1_address;//M0/M1 address
	input [31:0] M0_dout, M1_dout, S0_dout, S1_dout, S2_dout, S3_dout;//M0/M1,S0/S1/S2/S3 dout
	output M0_grant, M1_grant, S0_sel, S1_sel, S2_sel, S3_sel, S_wr;//M0/M1 grant, S0/S1/S2/S3 selection, S_write
	output [7:0] S_address;//Slave address
	output [31:0] M_din, S_din;//M/S din
	
	reg S0_sel_out, S1_sel_out, S2_sel_out, S3_sel_out;//S0/S1/S2/S3 sel_out reg
	
	always @ (posedge clk or negedge reset_n) begin//register for S0/S1/S2/S3 selection
		if(reset_n==0) begin	//reset
									S0_sel_out<=0; S1_sel_out<=0; S2_sel_out<=0; S3_sel_out<=0;
							end
		else 				begin//if clock active,
									S0_sel_out<=S0_sel;
									S1_sel_out<=S1_sel;
									S2_sel_out<=S2_sel;
									S3_sel_out<=S3_sel;
							end
	end		
		
	wire Msel;//Msel wire	
	
//module instance
bus_arbit U0_arbit(clk, reset_n, M0_req, M1_req, M0_grant, M1_grant, Msel);
bus_addr U1_decoder(S_address, S0_sel, S1_sel, S2_sel, S3_sel);
mux2 M_wr(M0_wr, M1_wr, Msel, S_wr);
mux2_8bits M_addr(M0_address, M1_address, Msel, S_address);
mux2_32bits M_dout(M0_dout, M1_dout, Msel, S_din);
mux5_32bits din(32'h00, S0_dout, S1_dout, S2_dout, S3_dout,{S0_sel_out,S1_sel_out,S2_sel_out, S3_sel_out},M_din);

endmodule

