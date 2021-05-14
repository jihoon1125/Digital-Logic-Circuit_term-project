module master(clk, reset_n, M_req, M_address, M_wr, M_dout, M_grant, M_din, 
						op_start, op_done, op_clear, op_mode, rd_en, src_addr, dest_addr, data_size, data_count, next_state);//master module
		
		input	 clk, reset_n;//clock and reset signal
				
		// Master interface
		input [31:0] M_din;
		output [7:0] M_address;
		output [31:0] M_dout;
		input M_grant;
		output M_req;
		output M_wr;				
		
		//connected with fifo
		input [31:0] src_addr, dest_addr, data_size;
		input [3:0] data_count;
		output rd_en;
		
		//connected with slave
		input op_start, op_clear;
		input [2:0] op_mode;
		output op_done;
		
		//Encoded states
		parameter IDLE = 3'b000;
		parameter FIFO_POP = 3'b001;
		parameter BUS_REQ = 3'b010;
		parameter MEM_READ = 3'b011;
		parameter MEM_WRITE = 3'b100;
		parameter DONE = 3'b101;
			
		output [2:0] next_state;
		
		//state, src_addr, dest_addr, data_size register
		reg [2:0] state, next_state;
		reg [31:0] reg_src_addr, reg_dest_addr, reg_data_size;
		reg [31:0] next_src_addr, next_dest_addr, next_data_size;
		
		//next state logic
		always	@ (posedge clk or negedge reset_n)	begin
				if(reset_n==0) state<=IDLE;
				else	state<=next_state;
			end			
		
		always	@ (state, op_start, op_clear, M_grant, next_data_size, data_count)
			begin
				case(state)
				//IDLE state
				IDLE : begin 
								if(op_start==1'b1)	next_state<=FIFO_POP;
								else						next_state<=IDLE;
						 end
				//FIFO_POP state
				FIFO_POP : begin
									if(next_data_size!=32'h00)	next_state<=BUS_REQ;
									else	begin
												if(data_count>4'h0)	next_state<=FIFO_POP;
												else						next_state<=DONE;
									end
							  end
				//BUS_REQ state
				BUS_REQ : begin
								if(M_grant==1'b1) 	next_state<=MEM_READ;
								else 		next_state<=BUS_REQ;
							 end
				//MEM_READ state
				MEM_READ :  next_state<=MEM_WRITE;
				//MEM_WRITE state
				MEM_WRITE : begin
									if(next_data_size!=32'h00) 	next_state<=MEM_READ;
									else if(data_count>4'h0)	next_state<=FIFO_POP;
									else 	next_state<=DONE;
								end
				//DONE state
				DONE : begin	
							 if(op_clear==1'b1) 	next_state<=IDLE;
							 else 					next_state<=DONE;
						 end
				default: next_state<=3'bxxx;//default
				endcase//endcase
			end
			
			assign op_done = (state==DONE)? 1'b1 : 1'b0;//op_done assignment
			
			
		//reg_src_addr, reg_dest_addr, reg_data_size 
		always	@ (posedge clk or negedge reset_n)
			begin
				if(reset_n==1'b0)	begin
						reg_src_addr<=8'h00;
						reg_dest_addr<=8'h00;
						reg_data_size<=8'h00;
									end
				else 	begin
							reg_src_addr<=next_src_addr;
							reg_dest_addr<=next_dest_addr;
							reg_data_size<=next_data_size;
						end
			end
			
			
			//combinational logic of states
			
			//next_src_addr
		wire [31:0] op_reg_src_addr, op_reg_dest_addr;

		always	@ (state, src_addr, reg_src_addr, op_mode, op_reg_src_addr)
			begin	
				case(state)
					FIFO_POP: 	next_src_addr<=src_addr;
					BUS_REQ: 	next_src_addr<=reg_src_addr;
					MEM_READ: 	next_src_addr<=reg_src_addr;
					MEM_WRITE: 	begin
										if(op_mode[0]==1'b1)	next_src_addr<=op_reg_src_addr;
										else	next_src_addr<=reg_src_addr;
									end
					default: 	next_src_addr<=32'h00000000;
				endcase
			end
	cla32_ov op_src_cla32(.a(reg_src_addr), .b(32'h00000001), .ci(0), .s(op_reg_src_addr));			
				//next_dest_addr
			always	@ (state, dest_addr, reg_dest_addr, op_mode, op_reg_dest_addr)
				begin
					case(state)
						FIFO_POP: 	next_dest_addr<=dest_addr;										
						BUS_REQ:    next_dest_addr<=reg_dest_addr;
						MEM_READ: 	next_dest_addr<=reg_dest_addr;
						MEM_WRITE:  begin
												if((op_mode[1]==1'b1)||(op_mode[2]==1'b1))	next_dest_addr<=op_reg_dest_addr;
												else next_dest_addr<=reg_dest_addr;
										end
						default:		next_dest_addr<=32'h00000000;
					endcase
				end
	cla32_ov op_dest_cla32(.a(reg_dest_addr), .b(32'h00000001), .ci(0), .s(op_reg_dest_addr));
				
				//next_data_size						
			wire [31:0] sub_data_size;	
	
			always	@ (state, data_size, reg_data_size, sub_data_size)
				begin
					case(state)
						FIFO_POP: 	next_data_size<=data_size;
						BUS_REQ: 	next_data_size<=reg_data_size;
						MEM_READ:	next_data_size<=sub_data_size;
						MEM_WRITE:	next_data_size<=reg_data_size;
						default:		next_data_size<=32'h00000000;
					endcase
				end
		
		assign	rd_en = (next_state==FIFO_POP)?	1'b1: 1'b0;	
	cla32_ov U0_cla32(.a(reg_data_size), .b(~(32'h00000001)), .ci(1), .s(sub_data_size));
	
			//output logic	 
			//M_req
			reg	M_req;
			always	@ (state)	begin
					case(state)
						BUS_REQ: M_req<=1'b1;
						MEM_READ: M_req<=1'b1;
						MEM_WRITE: M_req<=1'b1;
						default:		M_req<=1'b0;
					endcase
				end
			
			//M_address
			reg [7:0] M_address;
			always	@ (state, reg_src_addr, reg_dest_addr)	begin
				case(state)
					MEM_READ: M_address<=reg_src_addr[7:0];
					MEM_WRITE: M_address<=reg_dest_addr[7:0];
					default:		M_address<=8'h00;
				endcase
			end
			
			//M_wr
			reg M_wr;
			always	@ (state)	begin
				case(state)
					MEM_WRITE:	M_wr<=1'b1;
					default:		M_wr<=1'b0;
				endcase
			end
			
			//M_dout
			reg	[31:0] M_dout;
			always	@ (state, M_din, op_mode)	begin
				case(state)
					MEM_WRITE:	begin
										if(op_mode[2]==1'b1) M_dout<=32'h00000000;
										else M_dout<=M_din;
									end
					default:		M_dout<=32'h00000000;
				endcase
			end
endmodule
