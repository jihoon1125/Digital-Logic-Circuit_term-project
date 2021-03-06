module DMAC_Top(Clk, reset_n, M_grant, M_din, S_sel,S_wr,S_address,S_din,M_req,M_wr,M_address,M_dout,S_dout,Interrupt);	//DMAC module		

	//input and output ports
	input Clk, reset_n;
   input M_grant;
	input [31:0] M_din, S_din;
	input S_sel,S_wr;
	input [7:0] S_address;
	output M_req,M_wr, Interrupt;
	output [31:0] M_dout, S_dout;
	output [7:0] M_address;	
		
	
	
	wire wr_en, rd_en;
	wire [2:0] next_state;
	wire [3:0] data_count;
	wire op_start, op_done;
	wire op_clear;
	wire [2:0] op_mode;
	wire [31:0] din_src_addr, din_dest_addr, din_data_size;
	wire [31:0] dout_src_addr, dout_dest_addr, dout_data_size;
	
//slave, master, fifo instance
slave U0_slave(Clk, reset_n, S_sel, S_wr, S_address, S_din, S_dout, Interrupt, op_start, op_clear, op_done, op_mode,
						din_src_addr, din_dest_addr, din_data_size, wr_en, data_count, next_state);
master U1_master(Clk, reset_n, M_req, M_address, M_wr, M_dout, M_grant, M_din,
						op_start, op_done, op_clear, op_mode, rd_en, dout_src_addr, dout_dest_addr, dout_data_size, data_count, next_state);
fifo src_fifo(.clk(Clk), .reset_n(reset_n), .rd_en(rd_en), .wr_en(wr_en), .din(din_src_addr), .dout(dout_src_addr));
fifo dest_fifo(.clk(Clk),. reset_n(reset_n), .rd_en(rd_en), .wr_en(wr_en), .din(din_dest_addr), .dout(dout_dest_addr));
fifo data_size_fifo(.clk(Clk),. reset_n(reset_n), .rd_en(rd_en), .wr_en(wr_en), .din(din_data_size), .dout(dout_data_size));


endmodule
	
	