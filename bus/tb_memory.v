`timescale 1ns/100ps

module tb_memory();
	reg clk, cen, wen;
	reg [7:0] addr;
	reg [31:0] din;
	wire [31:0] dout;
	
memory U0_memory(clk, cen, wen, addr, din, dout);

	always
	begin
		clk=1; #2 clk=1; #2;
	end
	
	initial begin
	cen=0; wen=0; addr=0; din=0;
	#5 cen=1; wen=1;
	#4 addr=8'h01; din=32'h1;
	#4 addr=8'h02; din=32'h2;
	#4 addr=8'h03; din=32'h3;
	#4 addr=8'h04; din=32'h4;
	#4 addr=8'h05; din=32'h5;
	#4 addr=8'h06; din=32'h6;
	#4 addr=8'h07; din=32'h7;
	#4 addr=8'h08; din=32'h8;
	#4 addr=8'h09; din=32'h9;
	#4 addr=8'h0a; din=32'h10;
	#4 addr=8'h0b; din=32'h11;
	#4 addr=8'h0c; din=32'h12;
	#4 addr=8'h0d; din=32'h13;
	#4 addr=8'h0e; din=32'h14;
	#4 addr=8'h0f; din=32'h15;
	#4 addr=8'h10; din=32'h16;
	#4 addr=8'h11; din=32'h17;
	#4 addr=8'h12; din=32'h18;
	#4 addr=8'h13; din=32'h19;
	#4 addr=8'h14; din=32'h20;
	#4 addr=8'h15; din=32'h21;
	#4 addr=8'h16; din=32'h22;
	#4 addr=8'h17; din=32'h23;
	#4 addr=8'h18; din=32'h24;
	#4 addr=8'h19; din=32'h25;
	#4 addr=8'h1a; din=32'h26;
	#4 addr=8'h1b; din=32'h27;
	#4 addr=8'h1c; din=32'h28;
	#4 addr=8'h1d; din=32'h29;
	#4 addr=8'h1e; din=32'h30;
	#4 addr=8'h1f; din=32'h31;
	#4 addr=8'h00; wen=0; din=0;
	#4 addr=8'h01;
	#4 addr=8'h02;
	#4 addr=8'h03;
	#4 addr=8'h04;
	#4 addr=8'h05;
	#4 addr=8'h06;
	#4 addr=8'h07;
	#4 addr=8'h08;
	#4 addr=8'h09;
	#4 addr=8'h0a;
	#4 addr=8'h0b;
	#4 addr=8'h0c;
	#4 addr=8'h0d;
	#4 addr=8'h0e;
	#4 addr=8'h0f;
	#4 addr=8'h10;
	#4 addr=8'h11;
	#4 addr=8'h12;
	#4 addr=8'h13;
	#4 addr=8'h14;
	#4 addr=8'h15;
	#4 addr=8'h16;
	#4 addr=8'h17;
	#4 addr=8'h18;
	#4 addr=8'h19;
	#4 addr=8'h1a;
	#4 addr=8'h1b;
	#4 addr=8'h1c;
	#4 addr=8'h1d;
	#4 addr=8'h1e;
	#4 addr=8'h1f;
	#4 addr=8'h00; cen=0;
	#4 $stop;
	end
	
endmodule

