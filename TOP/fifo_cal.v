module fifo_cal(state, data_count, head, tail,next_data_count,next_head,next_tail,we,re);//calculating logic address logic module
	input [2:0]state;//inputs
	input[2:0]head,tail;
	input [3:0]data_count;
	output [2:0]next_head,next_tail;//ouputs
	output [3:0]next_data_count;
	output we, re;//enable sign
	reg we, re;
	reg [2:0]next_head,next_tail;
	reg [3:0]next_data_count;
	reg next_we, next_re;
	
	//parameter of states
	parameter IDLE=3'b000;
	parameter WRITE=3'b001;
	parameter READ=3'b010;
	parameter WR_ERROR=3'b011;
	parameter RD_ERROR=3'b100;
	
	always@(state, head, tail, data_count) begin
		case(state)
		WRITE: 	begin next_tail<=tail + 1;//if WRITE, tail++, data_count++, we=1, re=0							
					  next_data_count<=data_count + 1;
					  we<=1; re<=0;
				 end
		READ: 	begin next_head<=head + 1;//if READ, head++, dadta_count--, we=0, re=1								
						next_data_count<=data_count - 1;
						we<=0; re<=1;
				end
		default: begin next_head<=head;//else, no change
							next_tail<=tail;
							next_data_count<=data_count;
						we<=0; re<=0;
					end
		endcase
	end			
endmodule//endmodule

	
		
			
	
	
	