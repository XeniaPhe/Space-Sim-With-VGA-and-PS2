module main(
	input logic clk,
	input logic ps2c,
	input logic ps2d,
	output logic vsync,
	output logic hsync,
	output logic red,
	output logic green,
	output logic blue);
	
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
	logic keyboard_ack;
	
	logic IRQ_second_elapsed;
	
	assign INT = IRQ0 | IRQ1 | IRQ2 | IRQ3 | IRQ4 | IRQ5 | IRQ6 | IRQ7;
	
	localparam 	BEGIN_MEM = 12'h000,
					BEGIN_GRAPHIC_MEM = 12'h200,
					ADDR_KEYBOARD_OUT = 12'h224,
					ADDR_KEYBOARD_ACK = 12'h225;
				  
	mammal cpu(
	.clk(clk),
	.data_in(data_in),
	.data_out(data_out),
	.address(address),
	.memwt(memwt),
	.INT(INT),
	.intack(INTACK));
	
	vga_sync vga(
	.clk_50_mhz(clk),
	.wren(graphic_wren),
	.ldr(data_out),
	.addr(address[5:0]),
	.rgb({red, green, blue}),
	.hsync(hsync),
	.vsync(vsync),
	.IRQ_Vsync(IRQ_Vsync));
	
	keyboard ps2(
	.clk(clk),
	.ps2d(ps2d),
	.ps2c(ps2c),
	.ack(keyboard_ack),
	.dout(keyboard_out));
	
	timer t(
	.clk_50_mhz(clk),
	.ack(INTACK),
	.IRQ_second_elapsed(IRQ_second_elapsed));
	
	always_comb begin
      IRQ0 = 1'b0;
      IRQ1 = 1'b0;
      IRQ2 = 1'b0;
      IRQ3 = 1'b0;
      IRQ4 = 1'b0;
      IRQ5 = 1'b0;
      IRQ6 = IRQ_second_elapsed;
      IRQ7 = IRQ_Vsync;
   end
	
	always_comb begin
		if (memwt && (address >= BEGIN_GRAPHIC_MEM) && (address < ADDR_KEYBOARD_OUT))
			graphic_wren = 1;
		else
			graphic_wren = 0;
	end
	
	always_comb begin
		if(INTACK == 0) begin
			if ((address >= BEGIN_MEM) && (address < BEGIN_GRAPHIC_MEM))
				data_in = memory[address[8:0]];
			else if (address == ADDR_KEYBOARD_OUT)
				data_in = keyboard_out;
			else if (address == ADDR_KEYBOARD_ACK)
				data_in = {15'h0000, keyboard_ack};
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
	
	always_ff @(posedge clk) begin
		if(memwt) begin
			if((address >= BEGIN_MEM) && (address < BEGIN_GRAPHIC_MEM))
				memory[address[8:0]] <= data_out;
			else if(address == ADDR_KEYBOARD_ACK)
				keyboard_ack <= data_out[0];
		end
	end
	
	initial begin
		keyboard_out = 16'h0000;
		keyboard_ack = 0;
		$readmemh("ram.txt", memory);
	end
endmodule