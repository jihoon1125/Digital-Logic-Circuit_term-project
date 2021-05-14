module cla4(a,b,ci,s,co);//cla4 module
input [3:0] a,b;//input a, b
input ci;//carry in
output [3:0] s;//sum
output co;//carry out

wire [2:0] c;

//clb instantiation
clb4 U0_clb4(.a(a), .b(b), .ci(ci), .c1(c[0]), .c2(c[1]), .c3(c[2]), .co(co));
	
//fa_v2 instantiation
fa_v2 U1_fa_v2(.a(a[0]), .b(b[0]), .ci(ci), .s(s[0]));
fa_v2 U2_fa_v2(.a(a[1]), .b(b[1]), .ci(c[0]), .s(s[1]));
fa_v2 U3_fa_v2(.a(a[2]), .b(b[2]), .ci(c[1]), .s(s[2]));
fa_v2 U4_fa_v2(.a(a[3]), .b(b[3]), .ci(c[2]), .s(s[3]));
	
endmodule
