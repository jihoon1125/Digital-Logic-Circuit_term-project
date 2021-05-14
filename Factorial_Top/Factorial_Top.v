module Factorial_Top(clk, reset_n, S_sel, S_wr, S_address, S_din, S_dout, interrupt,
							state, r_op_clear, r_interrupt_en, r_op_start, N_din,N_dout, N_data_count, op_done, fac_op_done,
							FAC_NUM, FAC_multiplier,mtp_result, TOTAL_R_data_count);//Factorial_Top
	//input ports
	input clk, reset_n;
	input S_sel, S_wr;
	input [7:0] S_address;
	input [31:0] S_din;
	
	//output ports
	output [31:0] S_dout;
	output interrupt;
	

	//state encoding	
	parameter IDLE = 4'b0000;
	parameter N_FIFO_POP=4'b0001;
	parameter FACTORIAL_EXEC=4'b0010;
	parameter R_FIFO_PUSH_1=4'b0011;
	parameter R_FIFO_PUSH_2=4'b0100;	
	parameter MEM_WRITE_1=4'b0101;	
	parameter MEM_WRITE_2=4'b0110;
	parameter STOP_1=4'b0111;
	parameter DONE=4'b1000;
	parameter STOP_2=4'b1001;
	
	//About states sequential, combinational logic
	output  reg [3:0] state;
			 reg [3:0] next_state;
	
	always @ (posedge clk or negedge reset_n)	begin
		if(reset_n==0) state<=IDLE;
		else 	state<=next_state;
	end
	
	//0x0 offset op_clear register
		output reg [31:0] r_op_clear;
		reg [31:0]next_op_clear;
		wire op_clear;
		
	always	@ (posedge clk or negedge reset_n)	begin
		if(reset_n==0)	r_op_clear<=32'h00000000;
		else		r_op_clear<=next_op_clear;
			end	
	always	@ (S_sel, S_wr, S_address, S_din, state)	begin
		if((S_sel==1'b1)&&(S_wr==1'b1)&&(S_address[3:0]==4'h0)&&(state==DONE))	next_op_clear<=S_din;
		else				next_op_clear<=32'h00000000;
	     end

		assign op_clear=r_op_clear[0];
		//0x1 offset interrupt_en register
		output reg [31:0] r_interrupt_en;
				 reg [31:0] next_interrupt_en;
		
	always @ (posedge clk or negedge reset_n) begin
		if(reset_n==0) r_interrupt_en<=32'h00000000;
		else		r_interrupt_en<=next_interrupt_en;
	     end

	always	@ (S_sel, S_wr, S_address, S_din, r_interrupt_en, op_clear)	begin
		if((S_sel==1'b1)&&(S_wr==1'b1)&&(S_address[3:0]==4'h1)&&(op_clear==0)) next_interrupt_en<=S_din;
		else	if(op_clear==1) next_interrupt_en<=32'h00000000; 
		else	next_interrupt_en<=r_interrupt_en;
		end
		
		
							
		//0x2 offset op_start register
		output reg [31:0]  r_op_start;
				 reg [31:0]  next_op_start;
	
	always @ (posedge clk or negedge reset_n) begin
		if(reset_n==0) r_op_start<=32'h00000000;
		else	r_op_start<=next_op_start;
			end
	
	always @ (S_sel, S_wr, S_address, S_din, state, op_clear)	begin
		if((S_sel==1'b1)&&(S_wr==1'b1)&&(S_address[3:0]==4'h2)&&(state==IDLE)&&(op_clear==0)) next_op_start<=S_din;
		else	next_op_start<=32'h00000000;
	     end

		//0x3 offset N_FIFO					
			reg r_N_wr_en, next_N_wr_en;
			reg [31:0] next_N_din;
			output reg [31:0] N_din;
			wire N_wr_en, N_rd_en;
			output [31:0] N_dout;
			output [3:0]  N_data_count;
			wire  N_full, N_empty, N_wr_ack, N_wr_err, N_rd_ack, N_rd_err;
			
			always @ (posedge clk or negedge reset_n)	begin
				if(reset_n==0)	begin
										N_din<=32'h00000000;
										r_N_wr_en<=0;
									end
				else				begin
										N_din<=next_N_din;
										r_N_wr_en<=next_N_wr_en;
									end
					end
				
										
	always @ (S_sel, S_wr, S_address, S_din, state, N_din, op_clear)	begin
		if((S_sel==1'b1)&&(S_wr==1'b1)&&(S_address[3:0]==4'h3)&&(state==IDLE)&&(op_clear==0))
				begin
					next_N_din<=S_din; 	
					next_N_wr_en<=1;
				end
		else	if(op_clear==1)
					begin
							next_N_din<=32'h00000000;
							next_N_wr_en<=0;
					end
		else
					begin
						next_N_din<=N_din;
						next_N_wr_en<=0;
					end
		end
		
		assign N_rd_en = (next_state==N_FIFO_POP)? 	1'b1 : 1'b0;
		assign N_wr_en = r_N_wr_en;
						
	fifo	N_FIFO(clk,reset_n,N_rd_en,N_wr_en,N_din,N_dout,N_data_count,N_full,N_empty,N_wr_ack,N_wr_err,N_rd_ack,N_rd_err);
		//0x4 offset R_FIFO			
			wire R1_rd_en, R1_wr_en;
			wire R2_rd_en, R2_wr_en;
			wire [31:0] R1_dout, R2_dout;
			
			wire [3:0] R1_data_count, R2_data_count;
			wire R1_full, R1_empty, R1_wr_ack, R1_wr_err, R1_rd_ack, R1_rd_err;
			wire R2_full, R2_empty, R2_wr_ack, R2_wr_err, R2_rd_ack, R2_rd_err;		

		//0X5 offset N_FIFO_COUNT
			

		//0X6 offset N_FIFO_FLAGS
			
		//0X7 offset R_FIFO_COUNT			
			output [31:0] TOTAL_R_data_count;				
			
	 cla32_ov	R_COUNT(.a({28'h0000000, R1_data_count}), .b({28'h0000000, R2_data_count}), .ci(1'b0), .s(TOTAL_R_data_count));

		//0X8 offset R_FIFO_FLAGS
			
		//0X9 offset r_OP_DONE;
			output op_done;	
			reg next_fac_op_done;
			output reg fac_op_done;
			
			reg	[31:0] r_OP_DONE, next_OP_DONE;
			
			
				always	@	(posedge clk or negedge reset_n)	begin
					if(reset_n==0)	fac_op_done<=0;
					else				fac_op_done<=next_fac_op_done;
					end
					
				always	@ (posedge clk or negedge reset_n)	begin
					if(reset_n==0)	r_OP_DONE<=32'h00000000;
					else				r_OP_DONE<=next_OP_DONE;
				end
				
				always	@ (next_state, N_empty, r_OP_DONE, op_clear)	begin
					if((next_state==R_FIFO_PUSH_1)&&(N_empty==1)&&(op_clear==0)) next_OP_DONE<=32'h00000001;
					else	if(op_clear==1) next_OP_DONE<=32'h00000000;
					else 				next_OP_DONE<=r_OP_DONE;
					end
					
				assign op_done = r_OP_DONE[0];			
				
				
				
					
				output FAC_NUM;//accumulated factorial number
				reg [63:0] FAC_NUM, next_FAC_NUM;
				output FAC_multiplier;//factorial multiplier
				reg [5:0] FAC_multiplier, next_FAC_multiplier;			
				
				
				output [63:0] mtp_result;//multiplier result
				wire [31:0] sub_FAC_NUM, first_multiplier;
				
				
				
				always	@	(posedge clk or negedge reset_n)	begin
					if(reset_n==0)	FAC_NUM<=64'h00000000;
					else				FAC_NUM<=next_FAC_NUM;
					end
						
				always	@	(posedge clk or negedge reset_n)	begin
					if(reset_n==0)	FAC_multiplier<=6'b000000;
					else				FAC_multiplier<=next_FAC_multiplier;
					end				
				
				
				//multiplier module wire instance
				wire mtp_op_start;
				wire mtp_op_done;				
				wire mtp_op_clear;
				assign mtp_op_start = (state==FACTORIAL_EXEC)?	1'b1 : 1'b0;
				assign mtp_op_clear = (FAC_multiplier==6'b000010)? 1'b0 : 1'b1;	
				//R_FIFO read, wr_en, rd_en assign
				assign R1_wr_en = (next_state==R_FIFO_PUSH_1)? 1'b1 : 1'b0;
				assign R2_wr_en = (next_state==R_FIFO_PUSH_2)? 1'b1 : 1'b0;				
				assign R1_rd_en = (next_state==MEM_WRITE_1)? 1'b1 : 1'b0;
				assign R2_rd_en = (next_state==MEM_WRITE_2)? 1'b1 : 1'b0;
				
				
				assign interrupt = (r_interrupt_en[0]==1'b1)? op_done : 1'b0;
	
	//cla32_ov instance
	cla32_ov	FIRST_MULTIPLIER_SUBTRACTION(.a(N_dout), .b(32'hffffffff), .ci(32'h00000000), .s(first_multiplier));		
	cla32_ov	MULTIPLIER_SUBTRACTION(.a({24'h000000, 2'b00, FAC_multiplier}), .b(32'hffffffff), .ci(32'h00000000), .s(sub_FAC_NUM));			
	multiplier	U0_multiplier (.clk(clk), .reset_n(reset_n), .op_start(mtp_op_start), .op_clear(mtp_op_clear), .mtplicand(FAC_NUM), .mtplier(FAC_multiplier), .op_done(mtp_op_done),
					.result(mtp_result));		
				
				
				always	@ (state, N_dout, first_multiplier, mtp_result, FAC_multiplier, FAC_NUM, sub_FAC_NUM,
									fac_op_done, mtp_op_done)	begin//combinational logic
					case(state)
					N_FIFO_POP :	begin//FAC_NUM, FAC_multiplier, fac_op_done update
										next_FAC_NUM<={32'h00000000, N_dout};
										next_FAC_multiplier<=first_multiplier[5:0];
										next_fac_op_done<=0;
										end
			
					FACTORIAL_EXEC :	begin											
												if((FAC_multiplier==32'h2)&&(mtp_op_done==1))	begin	//fac_op_done on																									
																										next_FAC_NUM<=mtp_result;	
																										next_FAC_multiplier<=FAC_multiplier;
																										next_fac_op_done<=1;
																														end
																																			
												else if ((mtp_op_done==1)&&(FAC_multiplier>32'h2))	begin	//still execute																														
																												next_FAC_NUM<=mtp_result;
																												next_FAC_multiplier<=sub_FAC_NUM[5:0];
																												next_fac_op_done<=0;	
																													end	
																															
												else if (FAC_NUM<32'h3)	begin//fac_op_done on
																					next_FAC_NUM<=FAC_NUM;
																					next_FAC_multiplier<=FAC_multiplier;
																					next_fac_op_done<=1;																												
																				end
																									
											else	begin//still execute
																next_FAC_NUM<=FAC_NUM;
																next_FAC_multiplier<=FAC_multiplier;
																next_fac_op_done<=0;																												
													end
										end	
																		
					default : 	begin//default
										next_FAC_NUM<=64'h0000000000000000;
										next_FAC_multiplier<=6'b000000;
										next_fac_op_done<=0;		
										
									end
					endcase
					end
	//R_FIFO instance			
	fifo	R_FIFO_1(clk,reset_n,R1_rd_en,R1_wr_en,FAC_NUM[63:32],R1_dout,R1_data_count,R1_full,R1_empty,R1_wr_ack,R1_wr_err,R1_rd_ack,R1_rd_err);
	fifo	R_FIFO_2(clk,reset_n,R2_rd_en,R2_wr_en,FAC_NUM[31:0],R2_dout,R2_data_count,R2_full,R2_empty,R2_wr_ack,R2_wr_err,R2_rd_ack,R2_rd_err);
				
				
				reg [31:0] S_dout;			
				
				
				//S_dout write
				always @ (S_sel, S_wr, S_address, state, R1_dout, R2_dout, N_dout, N_data_count, N_empty, N_full, N_rd_err, N_wr_err,
								TOTAL_R_data_count, R2_empty, R2_full, R2_rd_err, R2_wr_err, r_OP_DONE)	begin
					if(reset_n==0)	S_dout<=32'h00;
			else	if((S_address[3:0]==4'h3)&&(S_sel==1)&&(S_wr==0)&&(state!=MEM_WRITE_1)&&(state!=MEM_WRITE_2))	S_dout<=N_dout;
			else  if(state==MEM_WRITE_1)  S_dout<=R1_dout;
			else  if(state==MEM_WRITE_2)  S_dout<=R2_dout;
			else  if((S_address[3:0]==4'h5)&&(S_sel==1)&&(S_wr==0)&&(state!=MEM_WRITE_1)&&(state!=MEM_WRITE_2))	S_dout<={28'h0000000, N_data_count};
			else  if((S_address[3:0]==4'h6)&&(S_sel==1)&&(S_wr==0)&&(state!=MEM_WRITE_1)&&(state!=MEM_WRITE_2))	S_dout<={28'h0000000, N_empty, N_full, N_rd_err, N_wr_err};
			else  if((S_address[3:0]==4'h7)&&(S_sel==1)&&(S_wr==0)&&(state!=MEM_WRITE_1)&&(state!=MEM_WRITE_2))	S_dout<=TOTAL_R_data_count;
			else  if((S_address[3:0]==4'h8)&&(S_sel==1)&&(S_wr==0)&&(state!=MEM_WRITE_1)&&(state!=MEM_WRITE_2))	S_dout<={28'h0000000, R2_empty, R2_full, R2_rd_err, R2_wr_err};
			else  if((S_address[3:0]==4'h9)&&(S_sel==1)&&(S_wr==0)&&(state!=MEM_WRITE_1)&&(state!=MEM_WRITE_2))	S_dout<=r_OP_DONE;
			else	S_dout<=32'h00000000;
					end
				
	
	//Factorial_Top FSM
	always @ (state, r_op_start, N_empty, fac_op_done, op_done, R2_empty, r_op_clear, S_sel, S_wr, S_address)	begin
		case(state)
		IDLE : 		begin//IDLE state
					if((r_op_start[0]==1'b1)&&(N_empty==0)) next_state<=N_FIFO_POP;//
					else next_state<=IDLE;
				end
		N_FIFO_POP :	next_state<=FACTORIAL_EXEC;//N_FIFO_POP state
			
		FACTORIAL_EXEC :	begin//FACTORIAL_EXEC state
						 if(fac_op_done==1) next_state<=R_FIFO_PUSH_1;
					 	else  		 next_state<=FACTORIAL_EXEC;
								end
		R_FIFO_PUSH_1 : 	next_state<=R_FIFO_PUSH_2;//R_FIFO_PUSH_1 state
		R_FIFO_PUSH_2 :		begin//R_FIFO_PUSH_2 state
						if((op_done==1)&&(S_sel==1)&&(S_wr==0)&&(S_address[3:0]==4'h4))	next_state<=MEM_WRITE_1;
						else if(op_done==1) next_state<=STOP_1;
						else		next_state<=N_FIFO_POP;
									end				
		MEM_WRITE_1 :		begin//MEM_WRITE_1 state
									if((R2_empty==0)&&(S_sel==1)&&(S_wr==0)&&(S_address[3:0]==4'h4))next_state<=MEM_WRITE_2;	
										else	next_state<=STOP_2;
								end
		STOP_2 :		begin//STOP_2state
							if((R2_empty==0)&&(S_sel==1)&&(S_wr==0)&&(S_address[3:0]==4'h4))next_state<=MEM_WRITE_2;
							else next_state<=STOP_2;
					   end
		MEM_WRITE_2 :		begin//MEM_WRITE_2 state
					     if((R2_empty==0)&&(S_sel==1)&&(S_wr==0)&&(S_address[3:0]==4'h4)) next_state<=MEM_WRITE_1;
					     else if(R2_empty==1)	next_state<=DONE;
						  else next_state<=STOP_1;
						  		end
		STOP_1 : 	begin//STOP_1 state
						 if((R2_empty==0)&&(S_sel==1)&&(S_wr==0)&&(S_address[3:0]==4'h4)) next_state<=MEM_WRITE_1;
						 else	next_state<=STOP_1;
					end
		DONE	:	begin//DONE state
						if(r_op_clear==1) next_state<=IDLE;						
						else				 next_state<=DONE;
					end
		default:	next_state<=3'bx;
		endcase
		end
		
		
			
				
	
				
		
	endmodule
				
					
			
			
	
	
	
	
	
	