`timescale 1ns/100ps


module tb_bus();//bus testbench

	//reg and wire type data
	reg clk, reset_n, M0_req, M0_wr, M1_req, M1_wr;
	reg [7:0]M0_address, M1_address;
	reg [31:0] M0_dout, M1_dout, S0_dout, S1_dout, S2_dout, S3_dout;
	wire M0_grant, M1_grant, S0_sel, S1_sel, S2_sel, S3_sel, S_wr;
	wire [7:0] S_address;
	wire [31:0] M_din, S_din;
	
//bus instance 
BUS U0_bus(clk, reset_n, M0_req, M0_wr, M0_address, M0_dout, M1_req,//bus top module
				M1_wr, M1_address, M1_dout, S0_dout, S1_dout, S2_dout, S3_dout,
				M0_grant, M1_grant, M_din, S0_sel, S1_sel, S2_sel, S3_sel, S_address,
				S_wr, S_din);
	
	always
	begin
		clk = 1; #2; clk = 0; #2;//clock period = 2ns
	end
	
	
	initial
	begin
	reset_n=0; M0_req=0; M0_address=8'h00; M1_address=8'h00; M0_wr=0; M1_wr=0; M0_dout=32'h00000000; M1_req=0; M1_dout=32'h00000000; S0_dout=32'h00000000; S1_dout=32'h00000000;
	S2_dout=32'h0;  S3_dout=32'h0;//reset all
	#7 reset_n=1;//reset inactive
	#4 M0_req=1; S0_dout=32'h1; S1_dout=32'h2;  S2_dout=32'h3;  S3_dout=32'h4;//M0 grant, S0, S1, S2, S3 dout decision
	#4 M0_wr=1;//M0_write signal 
	#4 M0_address=8'h00; M0_dout=32'd1;//M0_dout<0x10, slave 0 select, M0grant 
	#4 M0_address=8'h01; M0_dout=32'd2;//M0_dout<0x10, slave 0 select, M0grant
	#4 M0_address=8'h10; M0_dout=32'd10;//M0_dout>=0x10, slave 1 select, M0grant
	#4 M0_address=8'h11; M0_dout=32'd11;//..	
	#4 M0_address=8'h20; M0_dout=32'd20;//M0_dout>=0x20, slave 2 select, M0grant
	#4 M0_address=8'h21; M0_dout=32'd21;//..
	#4 M0_address=8'h30; M0_dout=32'd30;//..
	#4 M0_address=8'h31; M0_dout=32'd31;//..
	#4 M0_address=8'h40; M0_dout=32'd40;//M0_dout>=0x40, slave 3 select, M0grant
	#4 M0_address=8'h41; M0_dout=32'd41;//..
	#4 M0_address=8'h50; M0_dout=32'd50;//..
	#4 M0_address=8'h51; M0_dout=32'd51;//..	
	#4 M0_wr=0; M1_wr=1;//M1_write signal
	#4 M1_req=1;//still M0 grant	
	#4 M0_address=8'h32; M0_dout=32'h000000fe;//checking still M0grant 
	#4 M0_req=0;//M1grant from now on
	#4 M1_address=8'h03; M1_dout=32'd3;//checking M1 grant
	#4 M1_address=8'h24; M1_dout=32'd24;//..
	#4 M0_req=1;//still M1grant
	#4 M0_address=8'h14; M0_dout=32'd14; M1_address=8'h22; M1_dout=32'd22;//checking if M0grant
	#4 M0_req=0; M1_req=0;//still M1grant
	#4 M0_address=8'h34; M0_dout=32'd34; M1_address=8'h44; M1_dout=32'd44;//checking if M1grant
	#4 M0_req=1;//M0grant from now on
	#4 M0_address=8'h44; M0_dout=32'd44; M1_address=8'h24; M1_dout=32'd24;//checking if M0grant
	#8 $stop;
	end
endmodule

