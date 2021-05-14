module mux5_32bits(a, b, c, e, f, sel, d);//mux5 32bits module

	input [31:0] a, b, c, e, f;//32-bit inputs
	input [3:0] sel;//4-bit selection
	output [31:0] d;//32-bit output
	reg [31:0]d;//reg d
	
	always@ (a,b,c,e,f,sel) begin//case statements
		case(sel) 
		4'b0000 : d<=a;//if(sel==4'b0000) d<=a
		4'b0001 : d<=f;//if(sel==4'b0001) S3_sel==1, so d<=f
		4'b0010 : d<=e;//if(sel==4'b0010) S2_sel==1, so d<=e
		4'b0100 : d<=c;//if(sel==4'b0100) S1_sel==1, so d<=c
		4'b1000 : d<=b;//if(sel==4'b1000) S0_sel==1, so d<=b
		default: d=32'b0;//default
		endcase//endcase
	end
	
endmodule//endmodule

	
	
	