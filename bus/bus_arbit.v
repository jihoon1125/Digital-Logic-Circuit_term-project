module bus_arbit(clk, reset_n, M0_req, M1_req, M0_grt, M1_grt, Msel);//arbiter module

	input clk, reset_n, M0_req, M1_req;//clock, reset, M0 and M1's request
	output M0_grt, M1_grt, Msel;//M0 and M1's grant and Master selection
	
	reg M0_grt, M1_grt, Msel;//reg declaration of M0 and M1's grant and Master selection
	reg state, next_state;//state and next_state
	
	//parameter declaration of M0grant and M1grant states
	parameter M0grant=1'b0;
	parameter M1grant=1'b1;

	always @ (posedge clk or negedge reset_n) begin//sequential logic blocks
		if(reset_n==0) state<=M0grant;//reset							
		else 				state<=next_state;//update state as next_state
	 end
		
	always @ (state, M0_req, M1_req) begin//combinational logic blocks 
		case(state)//case statement
			M0grant: begin//operation in M0grant state's condition 
								if((M0_req==0&&M1_req==0)||(M0_req==1)) next_state<=M0grant;
								if((M0_req==0)&&(M1_req==1)) 	next_state<=M1grant;
								end
			M1grant: begin//operation in M1grant state's condition
								if((M1_req==1)||(M0_req==0&&M1_req==0)) next_state<=M1grant;
								if((M1_req==0)&&(M0_req==1)) next_state<=M0grant;
								end
			default: next_state<=1'bx;//default
		endcase
	end

	always @ (state, M0_req, M1_req) begin//combinational logic blocks
		if(state==M0grant)	begin M0_grt<=1; M1_grt<=0; Msel<=0;//updating outputs in M0grant state
											end
		else 						begin M0_grt<=0; M1_grt<=1; Msel<=1;//updating outputs in M1grant state
											end
	end
	
endmodule//endmodule


			
		
							
						