module slave(clk, reset_n, S_sel, S_wr, S_address, S_din, S_dout, interrupt, op_start, op_clear, op_done, op_mode,
					src_addr, dest_addr, data_size, wr_en, descriptor_size, next_state);//slave module
					
		input clk, reset_n;//clock and reset signal
		
		//Slave interface		
		input S_sel;
		input S_wr;
		input [7:0] S_address;
		input [31:0] S_din;
		output [31:0] S_dout;
		
		//interrupt signal
		output interrupt;
		
		//connected with fifo 
		output wr_en;
		output [31:0] src_addr, dest_addr, data_size;
		output [3:0] descriptor_size;
		
		//connected with Master		
		input op_done;
		output op_start;
		output op_clear;
		output [2:0] op_mode;	
		input [2:0] next_state;

		wire [3:0] offset;
		assign offset = S_address[3:0];
		
		// offset 0x0, OPERATION CLEAR register
		reg [31:0] reg_op_clear, next_op_clear;
		
		always	@ (posedge clk or negedge reset_n)	begin
			if(reset_n==0)	reg_op_clear<=32'h00000000;
			else reg_op_clear<=next_op_clear;
		end
		
		always	@ (S_sel, offset, S_din, S_wr, op_clear, reg_op_clear)	begin
			if((S_sel==1'b1)&&(S_wr==1)&&(offset==4'h0)&&(op_clear==0))	next_op_clear<=S_din;
			else	if(op_clear==0) next_op_clear<=reg_op_clear;
			else	next_op_clear<=32'h00000000;
		end
		
		assign op_clear = (op_done==1'b1)? reg_op_clear[0] : 1'b0;			
		
		// offset 0x1, OPERATION START register
		reg [31:0] reg_op_start, next_op_start;
		
		always	@ (posedge clk or negedge reset_n)	begin
			if(reset_n==0)	reg_op_start<=32'h00000000;
			else reg_op_start<=next_op_start;
		end
		
		always	@ (S_sel, offset, S_din, S_wr, op_clear, reg_op_start)	begin
			if((S_sel==1'b1)&&(S_wr==1)&&(offset==4'h1)&&(op_clear==0))	next_op_start<=S_din;
			else if(op_clear==0)	next_op_start<=reg_op_start;
			else 	next_op_start<=32'h00000000;
		end
		
		assign op_start = reg_op_start[0];
		
		// offset 0x2, INTERRUPT ENABLE register
		reg [31:0] reg_interrupt_en, next_interrupt_en;
		
		always	@ (posedge clk or negedge reset_n)	begin
			if(reset_n==0)	reg_interrupt_en<=32'h00000000;
			else reg_interrupt_en<=next_interrupt_en;
		end
		
		always	@ (S_sel, offset, S_din, S_wr, op_clear, reg_interrupt_en)	begin
			if((S_sel==1'b1)&&(S_wr==1)&&(offset==4'h2)&&(op_clear==0))	next_interrupt_en<=S_din;
			else	if(op_clear==0)	next_interrupt_en<=reg_interrupt_en;
			else	next_interrupt_en<=32'h00000000;
		end
		
		assign interrupt = (reg_interrupt_en[0]==1'b1)? op_done : 1'b0; 
		
		// offset 0x3, SOURCE ADDRESS register
		reg [31:0] reg_src_addr, next_src_addr;
		
		always	@ (posedge clk or negedge reset_n)	begin
			if(reset_n==0)	reg_src_addr<=32'h00000000;
			else reg_src_addr<=next_src_addr;
		end
		
		always	@ (S_sel, offset, S_din, S_wr, op_clear, reg_src_addr)	begin
			if((S_sel==1'b1)&&(S_wr==1)&&(offset==4'h3)&&(op_clear==0))	next_src_addr<=S_din;
			else	if(op_clear==0) 	next_src_addr<=reg_src_addr;
			else	next_src_addr<=32'h00000000;
		end
		
		assign src_addr = reg_src_addr;
		
	// offset 0x4, DESTINATION ADDRESS register
		reg [31:0] reg_dest_addr, next_dest_addr;
		
		always	@ (posedge clk or negedge reset_n)	begin
			if(reset_n==0)	reg_dest_addr<=32'h00000000;
			else reg_dest_addr<=next_dest_addr;
		end
		
		always	@ (S_sel, offset, S_din, S_wr, op_clear, reg_dest_addr)	begin
			if((S_sel==1'b1)&&(S_wr==1)&&(offset==4'h4)&&(op_clear==0))	next_dest_addr<=S_din;
			else	if(op_clear==0)	next_dest_addr<=reg_dest_addr;
			else next_dest_addr<=32'h00000000;
		end		
			
		assign dest_addr = reg_dest_addr;
		
		// offset 0x5, PUSH DESCRIPTOR register
		reg [31:0] reg_push_descriptor, next_push_descriptor;
		
		always	@ (posedge clk or negedge reset_n)	begin
			if(reset_n==0)	reg_push_descriptor<=32'h00000000;
			else reg_push_descriptor<=next_push_descriptor;
		end
		
		always	@ (S_sel, offset, S_din, S_wr, op_clear)	begin
			if((S_sel==1'b1)&&(S_wr==1)&&(offset==4'h5)&&(op_clear==0))	next_push_descriptor<=S_din;
			else	next_push_descriptor<=32'h00000000;
		end
		
		assign wr_en = reg_push_descriptor[0];
		
		// offset 0x6, DESCRIPTOR SIZE register
		reg [31:0] reg_descriptor_size, next_descriptor_size;
		wire [31:0] descriptor_add;
		wire [31:0] descriptor_sub;
			
		always	@ (posedge clk or negedge reset_n)	begin
			if(reset_n==0)	reg_descriptor_size<=32'h00000000;
			else reg_descriptor_size<=next_descriptor_size;
		end	
	
		always	@ (S_sel, offset, S_din, S_wr, op_clear, next_state, reg_descriptor_size)	begin
			if((S_sel==1'b1)&&(S_wr==1)&&(offset==4'h5)&&(S_din[0]==1'b1)&&(op_clear==0))	next_descriptor_size<=descriptor_add;
			else if((op_clear==0)&&(next_state==3'b001))	next_descriptor_size<= descriptor_sub;
			else if(op_clear==0) next_descriptor_size<= reg_descriptor_size;
			else	next_descriptor_size<=32'h00000000;
		end
		
		assign descriptor_size = reg_descriptor_size[3:0];
	cla32_ov U0_cla32(.a(reg_descriptor_size), .b(32'h00000001), .ci(32'h00000000), .s(descriptor_add));	
	cla32_ov U1_cla32(.a(reg_descriptor_size), .b(~(32'h00000001)), .ci(32'h00000001), .s(descriptor_sub));	
		//offset 0x7, DATA SIZE register		
		reg [31:0] reg_data_size, next_data_size;
		
		always	@ (posedge clk or negedge reset_n)	begin
			if(reset_n==0)	reg_data_size<=32'h00000000;
			else reg_data_size<=next_data_size;
		end
		
		always	@ (S_sel, offset, S_din, S_wr, op_clear, reg_data_size)	begin
			if((S_sel==1'b1)&&(S_wr==1)&&(offset==4'h7)&&(op_clear==0))	next_data_size<=S_din;
			else if(op_clear==0)	next_data_size<=reg_data_size;
			else		next_data_size<=32'h00000000;
		end
		
		assign data_size = reg_data_size;
		
		//offset 0x8, OPERATION MODE register		
		reg [31:0] reg_op_mode, next_op_mode;
		
		always	@ (posedge clk or negedge reset_n)	begin
			if(reset_n==0)	reg_op_mode<=32'h00000000;
			else reg_op_mode<=next_op_mode;
		end
		
		always	@ (S_sel, offset, S_din, S_wr, op_clear, reg_op_mode)	begin
			if((S_sel==1'b1)&&(S_wr==1)&&(offset==4'h8)&&(op_clear==0))	next_op_mode<=S_din;
			else	if(op_clear==0)	next_op_mode<=reg_op_mode;
			else 	next_op_mode<=32'h00000000;
		end		
		
		assign op_mode = reg_op_mode [2:0];
		
		//offset 0x9, OPERATION DONE register		
		reg [31:0] reg_op_done, next_op_done;
			
		always	@ (posedge clk or negedge reset_n)	begin
			if(reset_n==0)	reg_op_done<=32'h00000000;
			else reg_op_done<=next_op_done;
		end		
		
		always	@ (op_done, op_clear)		begin
			if(op_clear==0)	next_op_done<={28'h0000000,3'b000,op_done};
			else					next_op_done<=32'h00000000;
		end		

		//S_dout register		
		reg [31:0] S_dout, next_S_dout;
		
		always	@ (posedge clk or negedge reset_n)	begin
			if(reset_n==0)	S_dout<=32'h00000000;
			else S_dout<=next_S_dout;
		end		

		always 	@ (S_sel, offset, S_wr, reg_op_done, reg_interrupt_en, reg_src_addr, reg_dest_addr,
						reg_data_size, reg_descriptor_size,reg_op_mode)
			begin
				if((S_sel == 1'b1) && (S_wr == 1'b0))
				begin
					case(offset)
						4'h2 : next_S_dout<=reg_interrupt_en;
						4'h3 : next_S_dout<=reg_src_addr;
						4'h4 : next_S_dout<=reg_dest_addr;
						4'h6 : next_S_dout<=reg_descriptor_size;
						4'h7 : next_S_dout<=reg_data_size;
						4'h8 : next_S_dout<=reg_op_mode;
						4'h9 : next_S_dout<=reg_op_done;
						default: next_S_dout<=32'h00000000;
						endcase
					end
				else	next_S_dout<=32'h00000000;
				end										

endmodule

