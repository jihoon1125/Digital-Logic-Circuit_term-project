`timescale 1ns/100ps

module tb_ram();//testbench of memory
	reg clk, cen, wen;//inputs and outputs
	reg [4:0] addr;
	reg [31:0] din;
	wire [31:0] dout;
//memory instance
ram U0_ram(clk, cen, wen, addr, din, dout);

	//clock period = 2 ns
	always
	begin
		clk=1; #2 clk=0; #2;
	end
	
	//verification
	initial begin
	cen=0; wen=0; addr=0; din=0;//reset
	#5 cen=1; wen=1;//do write operation
	#4 addr=5'h01; din=32'd1;//keep storing data in each address from 5'h01~5'h1f
	#4 addr=5'h02; din=32'd2;
	#4 addr=5'h03; din=32'd3;
	#4 addr=5'h04; din=32'd4;
	#4 addr=5'h05; din=32'd5;
	#4 addr=5'h06; din=32'd6;
	#4 addr=5'h07; din=32'd7;
	#4 addr=5'h08; din=32'd8;
	#4 addr=5'h09; din=32'd9;
	#4 addr=5'h0a; din=32'd10;
	#4 addr=5'h0b; din=32'd11;
	#4 addr=5'h0c; din=32'd12;
	#4 addr=5'h0d; din=32'd13;
	#4 addr=5'h0e; din=32'd14;
	#4 addr=5'h0f; din=32'd15;
	#4 addr=5'h10; din=32'd16;
	#4 addr=5'h11; din=32'd17;
	#4 addr=5'h12; din=32'd18;
	#4 addr=5'h13; din=32'd19;
	#4 addr=5'h14; din=32'd20;
	#4 addr=5'h15; din=32'd21;
	#4 addr=5'h16; din=32'd22;
	#4 addr=5'h17; din=32'd23;
	#4 addr=5'h18; din=32'd24;
	#4 addr=5'h19; din=32'd25;
	#4 addr=5'h1a; din=32'd26;
	#4 addr=5'h1b; din=32'd27;
	#4 addr=5'h1c; din=32'd28;
	#4 addr=5'h1d; din=32'd29;
	#4 addr=5'h1e; din=32'd30;
	#4 addr=5'h1f; din=32'd31;
	#4 addr=5'h00; wen=0; din=0;//write operation off and read operation on
	#4 addr=5'h01;//keep reading data from each address from 5'h01~5'h1f
	#4 addr=5'h02;
	#4 addr=5'h03;
	#4 addr=5'h04;
	#4 addr=5'h05;
	#4 addr=5'h06;
	#4 addr=5'h07;
	#4 addr=5'h08;
	#4 addr=5'h09;
	#4 addr=5'h0a;
	#4 addr=5'h0b;
	#4 addr=5'h0c;
	#4 addr=5'h0d;
	#4 addr=5'h0e;
	#4 addr=5'h0f;
	#4 addr=5'h10;
	#4 addr=5'h11;
	#4 addr=5'h12;
	#4 addr=5'h13;
	#4 addr=5'h14;
	#4 addr=5'h15;
	#4 addr=5'h16;
	#4 addr=5'h17;
	#4 addr=5'h18;
	#4 addr=5'h19;
	#4 addr=5'h1a;
	#4 addr=5'h1b;
	#4 addr=5'h1c;
	#4 addr=5'h1d;
	#4 addr=5'h1e;
	#4 addr=5'h1f;
	#4 addr=5'h00; cen=0;//if cen==0 and wen==0, dout will be 0 
	#4 $stop;//stop
	end
	
endmodule//endmodule


