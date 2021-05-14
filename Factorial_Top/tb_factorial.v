`timescale 1ns/100ps


module tb_factorial();//tb_factorial

	reg clk, reset_n;
	reg S_sel, S_wr;
	reg [7:0] S_address;
	reg [31:0] S_din;
	
	wire  [31:0] S_dout;
	wire  interrupt;	
	
	wire [3:0] state;
	wire [31:0] r_op_clear, r_interrupt_en, r_op_start;
	wire [31:0] N_din, N_dout;
	wire [3:0] N_data_count;
	wire op_done, fac_op_done;
	wire [63:0] FAC_NUM;
	wire [5:0] FAC_multiplier;
	wire [63:0] mtp_result;
	wire [31:0] TOTAL_R_data_count;
	
	//Factorial_Top instance
	Factorial_Top  U0_Factorial_Top(clk, reset_n, S_sel, S_wr, S_address, S_din, S_dout, interrupt,
							state, r_op_clear, r_interrupt_en, r_op_start, N_din,N_dout, N_data_count, op_done, fac_op_done,
								FAC_NUM, FAC_multiplier,mtp_result, TOTAL_R_data_count);
								 
			parameter STEP = 1;//clk parameter			
			always #(STEP) clk = ~clk;// clock period
			
			
			initial	
			begin
			clk=1; reset_n=0; S_sel=0; S_wr=0; S_address=8'h00; S_din=32'h00000000;//reset all
			#4 reset_n=1;//reset inactive
			#2 S_sel=1; S_wr=1; S_address=8'h01; S_din=32'h00000001;//interrupt_en
			#4 S_address=8'h03; S_din=32'h00000009;//N_FIFO PUSH
			#2 S_din=32'h00000014;//..
			#2 S_din=32'h00000013;//..
			#2 S_din=32'h0000000d;//..
			#2 S_din=32'h0000000c;//..
			#2 S_din=32'h0000000a;//..
			#2 S_din=32'h00000013;//..
			#2 S_din=32'h00000002;//..
			#2 S_din=32'h00000001;//..
			#2 S_address=8'h02;	S_din=32'h00000001;//op_start
			#2 S_sel=0; S_wr=0; S_address=8'h04;//R_FIFO
			#100 S_address=8'h05;//N_FIFO_COUNT
			#100 S_address=8'h06;//N_FIFO_FLAGS
			#100 S_address=8'h07;//R_FIFO_COUNT
			#100 S_address=8'h08;//R_FIFO_FLAGS
			#100 S_address=8'h09;//OP_DONE
			#100 S_address=8'h04;//R_FIFO
			#550 S_sel=1;
			#20 S_sel=0;
			#10 S_sel=1;
			#40 S_wr=1; S_address=8'h00; S_din=32'h00000001;//op_clear
			#4	S_wr=0; S_address=8'h03;//N_FIFO read
			#4 S_address=8'h04;//R_FIFO
			#4 S_address=8'h05;//N_FIFO_COUNT
			#4 S_address=8'h06;//N_FIFO_FLAGS
			#4 S_address=8'h07;//R_FIFO_COUNT
			#4 S_address=8'h08;//R_FIFO_FLAGS
			#4 S_address=8'h09;//OP_DONE
			#4 S_address=8'h03; S_wr=1; S_din=32'h00000009;//N_FIFO PUSH
			#2 S_din=32'h0000000a;
			#2 S_address=8'h02; S_din=32'h1;
			#2 S_wr=0;
			#50 S_address=8'h05;//N_FIFO_COUNT
			#25 S_address=8'h06;//N_FIFO_FLAGS
			#25 S_address=8'h07;//R_FIFO_COUNT
			#50 S_address=8'h08;//R_FIFO_FLAGS
			#50 S_address=8'h04;//R_FIFO
			#150 S_address=8'h09;//OP_DONE
			#25 S_address=8'h04;
			#300 $stop;		
			end
			
			
			endmodule
			