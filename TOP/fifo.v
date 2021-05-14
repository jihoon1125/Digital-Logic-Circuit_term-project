module fifo(clk,reset_n,rd_en,wr_en,din,dout,data_count,full,empty,wr_ack,wr_err,rd_ack,rd_err);//fifo top module
	input clk,reset_n,rd_en,wr_en;//inputs
	input [31:0]din;
	output [31:0]dout;//ouputs
	output full, empty;
	output wr_ack,wr_err,rd_ack,rd_err;
	output [3:0]data_count;
	
	//wires
	wire [2:0]head,next_head;
	wire [2:0]tail,next_tail;
	wire[2:0]state,next_state;
	wire[3:0]next_data_count;
	wire we,re;
	wire [31:0]to_mux,to_ff;
	
	//Instances of modules	
	_dff3_r state_dff3_r(clk, reset_n, next_state, state);//state register 
	_dff4_r data_count_dff3_r(clk, reset_n, next_data_count, data_count);//data_count register
	_dff3_r head_dff3_r(clk, reset_n, next_head, head);//head register
	_dff3_r tail_dff3_r(clk, reset_n, next_tail, tail);//tail register
	_dff32_r dout_dff32_r(clk, reset_n, to_ff, dout);//d_out  register
	_2_to_1_MUX mux(32'h0, to_mux, re, to_ff);//2-to-1 MUX 
	
	Register_file U0_Register_file(clk, reset_n, tail, din, we, head, to_mux);//Register file 
	fifo_ns U1_fifo_ns(wr_en,rd_en,state,data_count,next_state);//fifo_ns 
	fifo_cal U2_fifo_cal(next_state, data_count, head, tail,next_data_count,next_head,next_tail,we,re);//fifo_cal
	fifo_out U3_fifo_out(state, data_count, full, empty, wr_ack, wr_err, rd_ack, rd_err);//fifo_out
	
endmodule
	
	