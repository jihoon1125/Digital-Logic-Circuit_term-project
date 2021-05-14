module _8_to_1_MUX(a,b,c,d,e,f,g,h,sel,d_out);//8 to 1 MUX
	input [31:0]a,b,c,d,e,f,g,h;//8 32bit inputs 
	input [2:0]sel;//3bit sel
	output reg[31:0]d_out;//32bit output reg
	
	always@(sel,a,b,c,d,e,f,g,h) begin//Assign appropriate output 
		case(sel)
			3'b000: d_out<=a;
			3'b001: d_out<=b;
			3'b010: d_out<=c;
			3'b011: d_out<=d;
			3'b100: d_out<=e;
			3'b101: d_out<=f;
			3'b110: d_out<=g;
			3'b111: d_out<=h;
			default:d_out=32'hx;//default
		endcase//endcase
	end
endmodule//endmodule


			