module fa_v2(a,b,ci,s);//fa_v2
input a,b,ci;
output s;

wire sum;

_xor2 U0_xor1(a,b,sum);//_xor2 instantiation twice
_xor2 U1_xor2(ci,sum,s);

endmodule
