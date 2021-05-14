module fifo_ns(wr_en,rd_en,state,data_count,next_state);//fifo next state logic module
	input wr_en, rd_en;//enable inputs
	input [2:0]state;//state
	input  [3:0]data_count;
	output [2:0]next_state;//next state
	reg 	 [2:0] next_state;
	
	//parameter of states
	parameter IDLE=3'b000;
	parameter WRITE=3'b001;
	parameter READ=3'b010;
	parameter WR_ERROR=3'b011;
	parameter RD_ERROR=3'b100;
	
	
	always @ (wr_en,rd_en,state,data_count) begin
		case(state)
			IDLE: 	if((!wr_en)&&(!rd_en)) next_state<=IDLE;// if state==IDLE, next state can be anything under enable and data_count conditions
						else if((wr_en)&&(!rd_en)&&(data_count<8)) next_state<=WRITE;
						else if((!wr_en)&&(rd_en)&&(data_count>0))  next_state<=READ;
						else if((wr_en)&&(!rd_en)&&(data_count==8)) next_state<=WR_ERROR;
						else if((!wr_en)&&(rd_en)&&(data_count==0)) next_state<=RD_ERROR;						
						
			WRITE:   if((!wr_en)&&(!rd_en)) next_state<=IDLE;// if state==WRITE, RD_ERROR can't be next state
						else if((wr_en)&&(!rd_en)&&(data_count<8)) next_state<=WRITE;
						else if((wr_en)&&(!rd_en)&&(data_count==8)) next_state<=WR_ERROR;
						else if((!wr_en)&&(rd_en)&&(data_count>0))  next_state<=READ;						
						
			READ:		if((!wr_en)&&(!rd_en)) next_state<=IDLE;// if state==READ, WR_ERROR can't be next state
						else if((!wr_en)&&(rd_en)&&(data_count>0))  next_state<=READ;
						else if((wr_en)&&(!rd_en)&&(data_count<8)) next_state<=WRITE;
						else if((!wr_en)&&(rd_en)&&(data_count==0)) next_state<=RD_ERROR;					
						
			WR_ERROR: if((!wr_en)&&(!rd_en)) next_state<=IDLE;//if state==WR_ERROR, WRITE and RD_ERROR can't be next state
						 else if((wr_en)&&(!rd_en)&&(data_count==8)) next_state<=WR_ERROR;
						 else if((!wr_en)&&(rd_en)&&(data_count>0))  next_state<=READ;
						
			RD_ERROR: if((!wr_en)&&(!rd_en)) next_state<=IDLE;//if state==RD_ERROR, READ and WR_ERROR can't be next state
						 else if((!wr_en)&&(rd_en)&&(data_count==0)) next_state<=RD_ERROR;
						 else if((wr_en)&&(!rd_en)&&(data_count<8)) next_state<=WRITE;
						
		   default:  next_state<=3'bx;
		endcase
	end
endmodule
	
				
			 
				
	