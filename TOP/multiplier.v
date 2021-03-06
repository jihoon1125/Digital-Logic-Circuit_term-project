module multiplier(clk, reset_n, op_start, op_clear, mtplicand, mtplier, op_done,result);//multiplier top module

	input clk, reset_n, op_start, op_clear;//input ports
	input [63:0] mtplicand;
	input [5:0] mtplier;//multiplicand, multiplier
	output reg [63:0] result;//result	
	reg [63:0] next_result;
	output reg op_done;//op_done	
	reg next_op_done;	
	 reg [31:0] count;//shift count	
	 reg [31:0] next_count;//next_shift_count
			
	//X1 and next_X1
	reg [5:0] X1, next_X1;
	//X0 and next_X0
	reg X0, next_X0;		
	reg [69:0] u_v, next_u_v;//u_v and next_u_v
	
	
	reg[1:0] state, next_state;//state and next_state
	
	
	   wire [63:0] u_v_add, u_v_sub, mtp_double, u_v_double_add, u_v_double_sub;//u_v addition and subtraction wire
		wire [31:0] add_count;
			
	//state parameter		
	parameter IDLE = 2'b00;
	parameter EXEC = 2'b01;
	parameter DONE = 2'b10;
	
	always @ (posedge clk or negedge reset_n) begin//state, X1, X0, u_v, count sequential logic
		if(reset_n==0) begin
								state<=IDLE;		
								X1<=6'b00;
								X0<=1'b0;
								u_v<=70'h00;
								count<=32'h00;
								op_done<=1'b0;	
								result<=64'h00;
							end
		else 				begin								
								state<=next_state;	
								X1<=next_X1;
								X0<=next_X0;
								u_v<=next_u_v;
								count<=next_count;
								op_done<=next_op_done;	
								result<=next_result;
							end						
	end
	
	always @ (state, op_start, op_clear, next_op_done) begin// next_state sequential logic
		case(state)
		IDLE : begin//IDLE state
				 if(op_start==1) next_state<=EXEC;
				 else next_state<=IDLE;
				 end	
		EXEC : begin //EXEC state
						if(next_op_done==0) next_state<=EXEC;
						else next_state<=DONE;
				 end
		DONE : begin//DONE state
				if(op_clear==1) next_state<=IDLE;
				else 				 next_state<=DONE;
				end
		default: next_state<=2'bx;//default
		endcase
	end
		
		
	always	@ (state, mtplier,  X1, X0, count, u_v,
					add_count, u_v_add, u_v_sub, u_v_double_add, u_v_double_sub, op_done, result)	begin//state combinational logic
		case(state)
		IDLE : begin//IDLE state, initialize registers
				 next_X1<=mtplier;//update next_X1 as multiplier
				 next_X0<=1'b0;//initialize next_X0, next_count, next_u_v
				 next_count<=32'h00000000;
				 next_u_v<={68'h00000000000000000, 2'b00};	
				 next_op_done<=0;
				 next_result<=0;
				 end
		EXEC :	begin			
				if(count==32'h00000003)		begin//if count==3, execution is done
														next_op_done<=1;
														next_result<=u_v[63:0];
													end	//op_done condition
				else 	begin				
						next_op_done<=0;
									
				case({X1[1], X1[0], X0})//EXEC state
					{1'b0, 1'b0, 1'b0} : begin //double shift only
														next_u_v[69]<=u_v[69];
														next_u_v[68]<=u_v[69];
														next_u_v[67:0]<=u_v[69:2];
														next_X0<=X1[1];
														next_X1[3:0]<=X1[5:2];
														next_X1[5:4]<=X1[1:0];
														next_count<=add_count;																
												end
												
					{1'b0, 1'b0, 1'b1} : begin // +A and double shift
												next_u_v[69]<=u_v_add[63];
												next_u_v[68]<=u_v_add[63];
												next_u_v[67:4]<=u_v_add;
												next_u_v[3:0]<=u_v[5:2];	
												next_X0<=X1[1];
												next_X1[3:0]<=X1[5:2];
												next_X1[5:4]<=X1[1:0];
												next_count<=add_count;												
												end										
					{1'b0, 1'b1, 1'b0} : begin // +A and double shift
												next_u_v[69]<=u_v_add[63];
												next_u_v[68]<=u_v_add[63];
												next_u_v[67:4]<=u_v_add;
												next_u_v[3:0]<=u_v[5:2];	
												next_X0<=X1[1];
												next_X1[3:0]<=X1[5:2];
												next_X1[5:4]<=X1[1:0];
												next_count<=add_count;												
												end						
					{1'b0, 1'b1, 1'b1} : begin // +2A and double shift
												next_u_v[69]<=u_v_double_add[63];
												next_u_v[68]<=u_v_double_add[63];
												next_u_v[67:4]<=u_v_double_add;
												next_u_v[3:0]<=u_v[5:2];	
												next_X0<=X1[1];
												next_X1[3:0]<=X1[5:2];
												next_X1[5:4]<=X1[1:0];
												next_count<=add_count;												
												end
					{1'b1, 1'b0, 1'b0} : begin // -2A and double shift
												next_u_v[69]<=u_v_double_sub[63];
												next_u_v[68]<=u_v_double_sub[63];
												next_u_v[67:4]<=u_v_double_sub;
												next_u_v[3:0]<=u_v[5:2];	
												next_X0<=X1[1];
												next_X1[3:0]<=X1[5:2];
												next_X1[5:4]<=X1[1:0];
												next_count<=add_count;												
												end
					{1'b1, 1'b0, 1'b1} : begin // -A and double shift
												next_u_v[69]<=u_v_sub[63];
												next_u_v[68]<=u_v_sub[63];
												next_u_v[67:4]<=u_v_sub;
												next_u_v[3:0]<=u_v[5:2];	
												next_X0<=X1[1];
												next_X1[3:0]<=X1[5:2];
												next_X1[5:4]<=X1[1:0];
												next_count<=add_count;												
												end
					{1'b1, 1'b1, 1'b0} : begin // -A and double shift
												next_u_v[69]<=u_v_sub[63];
												next_u_v[68]<=u_v_sub[63];
												next_u_v[67:4]<=u_v_sub;
												next_u_v[3:0]<=u_v[5:2];	
												next_X0<=X1[1];
												next_X1[3:0]<=X1[5:2];
												next_X1[5:4]<=X1[1:0];
												next_count<=add_count;												
												end	
					{1'b1, 1'b1, 1'b1} : begin //double shift only
												next_u_v[69]<=u_v[69];
												next_u_v[68]<=u_v[69];
												next_u_v[67:0]<=u_v[69:2];
												next_X0<=X1[1];
												next_X1[3:0]<=X1[5:2];
												next_X1[5:4]<=X1[1:0];
												next_count<=add_count;																		
												end										
						default 	 : begin
											next_u_v<=70'bx;	//default
											next_count<=32'hxxxxxxxx;
											next_X1<=6'bxxxxxx;
											next_X0<=1'bx;											
										end
					endcase//endcase					
					end					
					end					
					
		DONE : 	begin//DONE state						
						next_op_done<=0;
						next_result<=result;
					end
		
		default: u_v<=64'bx;//default
		endcase//endcase
		end	
		
		
cla64_ov	add_shift(.a(u_v[69:6]), .b(mtplicand), .ci(1'b0), .s(u_v_add));//adder instance to get u_v_add
cla64_ov	sub_shift(.a(u_v[69:6]), .b(~mtplicand), .ci(1'b1), .s(u_v_sub));//subtractor instance to get u_v_sub
cla64_ov	double_mtp(.a(mtplicand), .b(mtplicand), .ci(1'b0), .s(mtp_double));//double_add instance to get 2A
cla64_ov	double_add_shift(.a(u_v[69:6]), .b(mtp_double), .ci(1'b0), .s(u_v_double_add));//adder instance to get u_v_double_add
cla64_ov	double_sub_shift(.a(u_v[69:6]), .b(~mtp_double), .ci(1'b1), .s(u_v_double_sub));//subtractor instance	to get u_v_double_sub
cla32_ov count_add(.a(count), .b(32'h00000001), .ci(1'b0), .s(add_count));// count addition
		
endmodule
	
	
		
				
	
	
		