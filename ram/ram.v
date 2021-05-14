module ram(clk, cen, wen, addr, din, dout);//memory module
	input clk, cen, wen;// clock and enable sign
	input [4:0] addr;//address
	input [31:0] din;//din
	output reg [31:0] dout;//dout
	
	reg [31:0]  	mem 	[0:31];//memory declaration
	
	integer i;//integer
	
	initial begin//memory initialization
		for(i=0; i<32; i=i+1)	begin
			mem[i]=32'h00000000;//memory resets
			end
		end
		
	always @ (posedge clk)//read/write performance
	begin
		if((cen==1)&&(wen==1)) mem[addr]<=din;//write operation
		else if((cen==1)&&(wen==0)) dout<=mem[addr];//read operation
		else dout<=0;//else 0
	end
	
endmodule//endmodule

