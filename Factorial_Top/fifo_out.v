module fifo_out(state, data_count, full, empty, wr_ack, wr_err, rd_ack, rd_err);//fifo_out module

	input [2:0] state;//inputs
	input [3:0] data_count;
	output full, empty, wr_ack, wr_err, rd_ack, rd_err;//outputs
	reg full, empty, wr_ack, wr_err, rd_ack, rd_err;
	
	always @ (state, data_count) begin
		if(data_count==8) begin//if data_count==8, full signal
								full<=1; empty<=0;
								end
		else if(data_count==0) begin//if data_count==0, empty signal
								full<=0; empty<=1;
								end
		else begin//else no full, no empty
					full<=0;	empty<=0;
				end
		end
		
	//parameter of states
	parameter IDLE=3'b000;
	parameter WRITE=3'b001;
	parameter READ=3'b010;
	parameter WR_ERROR=3'b011;
	parameter RD_ERROR=3'b100;
	
	
	//Always block of each state's signal 
	always @ (state, data_count) begin
		case(state)
	IDLE : begin
					wr_ack<=0; wr_err<=0; rd_ack<=0; rd_err<=0;
			 end
	WRITE : begin
					wr_ack<=1; wr_err<=0; rd_ack<=0; rd_err<=0;
			  end
	READ : begin
					wr_ack<=0; wr_err<=0; rd_ack<=1; rd_err<=0;
			 end
	WR_ERROR: begin
					wr_ack<=0; wr_err<=1; rd_ack<=0; rd_err<=0;
				 end
	RD_ERROR: begin
					wr_ack<=0; wr_err<=0; rd_ack<=0; rd_err<=1;
				 end
	default: begin
					wr_ack<=1'bx; wr_err<=1'bx; rd_ack<=1'bx; rd_err<=1'bx;
					end
		endcase
	end
	
endmodule
