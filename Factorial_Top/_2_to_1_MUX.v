module _2_to_1_MUX(a,b,sel,d_out);//2 to 1 MUX
	input [31:0]a,b;//2 32bit inputs 
	input sel;//3bit sel
	output reg[31:0]d_out;//32bit output reg
	
	always@(sel,a,b) begin//Assign appropriate output 
		case(sel)
			1'b0: d_out<=a;
			1'b1: d_out<=b;
			default:d_out<=32'hx;//default
		endcase//endcase
	end
endmodule//endmodule