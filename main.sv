module main(
	input logic clk_in,
	output logic vsync,
	output logic hsync,
	output logic clk_out,
	output logic red,
	output logic green,
	output logic blue,
	output logic data);
	
 	logic [15:0] memory [0:511];
	
	logic [15:0] data_out;
	logic [15:0] data_in;
	logic [11:0] address;
	logic memwt;
	logic INT;
	logic INTACK;
	
	logic IRQ0, IRQ1, IRQ2, IRQ3, IRQ4, IRQ5, IRQ6, IRQ7;
	
	logic IRQ_Vsync;
	logic graphic_wren;
	
	logic [15:0] keyboard_out;
	
	assign clk_out = clk_in;
	assign INT = IRQ0 | IRQ1 | IRQ2 | IRQ3 | IRQ4 | IRQ5 | IRQ6 | IRQ7;
	
	localparam 	BEGIN_MEM = 12'h000,
					BEGIN_GRAPHIC_MEM = 12'h200,
					ADDR_KEYBOARD = 12'h224;
				  
	mammal cpu(
	.clk(clk_in),
	.data_in(data_in),
	.data_out(data_out),
	.address(address),
	.memwt(memwt),
	.INT(INT),
	.intack(INTACK));
	
	vga_sync vga(
	.clk(clk_in),
	.wren(graphic_wren),
	.ldr(data_out),
	.addr(address[5:0]),
	.rgb({red, green, blue}),
	.hsync(hsync),
	.vsync(vsync),
	.IRQ_Vsync(IRQ_Vsync));
	
	//keyboard ps2(
	//.clk(clk_in),
	//.ps2d(?),
	//.ps2c(?),
	//.ack(?),
	//.dout(keyboard_out));
	
	always_comb begin
      IRQ0 = 1'b0;
      IRQ1 = 1'b0;
      IRQ2 = 1'b0;
      IRQ3 = 1'b0;
      IRQ4 = 1'b0;
      IRQ5 = 1'b0;
      IRQ6 = 1'b0;
      IRQ7 = IRQ_Vsync;
   end
	
	always_comb begin
		if (memwt && (address >= BEGIN_GRAPHIC_MEM) && (address < ADDR_KEYBOARD))
			graphic_wren = 1;
		else
			graphic_wren = 0;
	end
	
	always_comb begin
		if(INTACK == 0) begin
			if ((address >= BEGIN_MEM) && (address < BEGIN_GRAPHIC_MEM))
				data_in = memory[address[8:0]];
			else if ((address == ADDR_KEYBOARD))
				data_in = keyboard_out;
			else
				data_in = 16'h0000;
		end else begin
			if (IRQ0)
				data_in = 16'h0;
         else if (IRQ1)
            data_in = 16'h1;
         else if (IRQ2)
            data_in = 16'h2;
         else if (IRQ3)
            data_in = 16'h3;
         else if (IRQ4)
            data_in = 16'h4;
         else if (IRQ5)
            data_in = 16'h5;
         else if (IRQ6)
            data_in = 16'h6;
         else
            data_in = 16'h7;
		end
	end
	
	always_ff @(posedge clk_in) begin
		if(memwt && (address >= BEGIN_MEM) && (address < BEGIN_GRAPHIC_MEM))
			memory[address[8:0]] <= data_out;
	end
	
	initial begin
		keyboard_out = 0;
		$readmemh("ram.txt", memory);
	end
endmodule