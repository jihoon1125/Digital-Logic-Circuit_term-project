`timescale 1ns/100ps

module tb_dmac_3();//tb_dmac_3

	reg Clk, reset_n;
   reg M_grant;
	reg [31:0] M_din, S_din;
	reg S_sel,S_wr;
	reg [7:0] S_address;
	wire M_req,M_wr, Interrupt;
	wire [31:0] M_dout, S_dout;
	wire [7:0] M_address;	
	
	wire op_clear, op_start, op_done;
	wire [2:0] op_mode;
	wire wr_en, rd_en;
	wire [3:0] data_count;
	wire [2:0] next_state;
	
	wire [31:0] din_src_addr, din_dest_addr, din_data_size;
	wire [31:0] dout_src_addr, dout_dest_addr, dout_data_size;
	
	//DMAC_Top instance
DMAC_Top	U0_dmac(Clk, reset_n, M_grant, M_din, S_sel,S_wr,S_address,S_din,M_req,M_wr,M_address,M_dout,S_dout,Interrupt,
					next_state, wr_en, rd_en, data_count, op_start, op_done, op_clear, op_mode, din_src_addr, din_dest_addr, din_data_size, dout_src_addr, dout_dest_addr, dout_data_size);				
				

	parameter STEP = 1;//clk parameter
	always #(STEP) Clk = ~Clk;// clock period
	
	initial
	begin	
	Clk=1; reset_n=0; M_grant=0; M_din=0; S_din=0; S_sel=0; S_wr=0; S_address=8'h00;//reset all
	#2 reset_n=1;//reset inactive
	#3 S_sel=1; S_address=8'h00;
	#2 S_wr=1; S_address=8'h02; S_din=32'h00000001;//interrupt_en
	#2 S_address=8'h03; S_din=32'h0000000a;//src addr
	#2 S_address=8'h04; S_din=32'h00000014;//dest addr
	#2 S_address=8'h07; S_din=32'h00000004;//data size
	#2 S_address=8'h05; S_din=32'h00000001;//fifo push
	#2 S_address=8'h03; S_din=32'h0000001e;//src addr
	#2 S_address=8'h04; S_din=32'h00000028;//dest addr
	#2 S_address=8'h07; S_din=32'h00000004;//data size
	#2 S_address=8'h05; S_din=32'h00000001;//fifo push
	#2 S_address=8'h03; S_din=32'h00000028;//src addr
	#2 S_address=8'h04; S_din=32'h00000032;//dest addr
	#2 S_address=8'h07; S_din=32'h00000000;//data size
	#2 S_address=8'h05; S_din=32'h00000001;//fifo push
	#2 S_address=8'h08; S_din=32'h00000007;//op_mode
	#2 S_address=8'h01; S_din=32'h00000001;//op_start
	#2 S_sel=0; S_wr=0; 
	#10 M_grant=1; 
	#80 S_sel=1; S_wr=1; S_address=8'h00; S_din=32'h00000001;//op_clear
	#3  S_wr=0; S_address=8'h08; //op_mode read
	#2	 S_address=8'h07;//data size read
	#2  S_address=8'h06;//descriptor size read
	#2  S_address=8'h03;//src addr read
	#4	$stop;
	end	
endmodule
	
	
	