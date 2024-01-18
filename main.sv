module main(
	input logic clk_in,
	output logic vsync,
	output logic hsync,
	output logic clk_out,
	output logic red,
	output logic green,
	output logic blue,
	output logic data);
	
	logic [15:0] spaceship [15:0];
	logic [15:0] planet [15:0];
	logic [15:0] spaceship_x;
	logic [15:0] spaceship_y;
	logic [15:0] planet_x;
	logic [15:0] planet_y;
	logic [15:0] keyboard;
	
	assign clk_out = clk_in;
	
	localparam BEGIN_MEM = 12'h000,
				  ADDR_SPACESHIP_X = 12'h1db,
				  ADDR_SPACESHIP_Y = 12'h1dc,
				  ADDR_PLANET_X = 12'h1dd,
				  ADDR_PLANET_Y = 12'h1de,
				  ADDR_KEYBOARD = 12'h1df,
				  BEGIN_SPACESHIP_BITMAP = 12'h1e0,
				  BEGIN_PLANET_BITMAP = 12'h1f0,
				  END_MEM = 12'h200;
				  
	
	logic IRQ_Vsync;
	
	vga_sync vga(.spaceship_bitmap(spaceship), .planet_bitmap(planet), .spaceship_x(spaceship_x[9:0]), .spaceship_y(spaceship_y[9:0]), 
	.planet_x(planet_x[9:0]), .planet_y(planet_y[9:0]), .clk(clk_in), .hsync(hsync), .vsync(vsync), .rgb({red, green, blue}),
	.IRQ_Vsync(IRQ_Vsync));
	
	always_comb begin
		ackx =0;
		
		if ((address >= BEGIN_MEM) && (address < ADDR_SPACESHIP_X)) begin
			data_in = memory[address];
		end else if ((address == ADDR_KEYBOARD) begin
			ackx = 1;
         data_in = keyboard;
		end else begin
         data_in = 16'h0000;
		end
	end
	
	always_ff @(posedge clk) begin
		if(memwt) begin
			if((address >= BEGIN_MEM) && (address < ADDR_SPACESHIP_X))
				memory[address] <= data_out;
			else if((address >= BEGIN_SPACESHIP_BITMAP) && (address < BEGIN_PLANET_BITMAP))
				spaceship[address[3:0]] <= data_out;
			else if((address >= BEGIN_PLANET_BITMAP) && (address < END_MEM))
				planet[address[3:0]] <= data_out;
			else if(address == ADDR_SPACESHIP_X) 
				spaceship_x <= data_out;
			else if(address == ADDR_SPACESHIP_Y)
				spaceship_y <= data_out;
			else if(address == ADDR_PLANET_X)
				planet_x <= data_out;
			else if(address == ADDR_PLANET_Y)
				planet_y <= data_out;
			else if(address == ADDR_KEYBOARD)
				keyboard <= data_out;
		end
	end
	
	initial begin
		spaceship[0] = 16'b0000000010000000;
		spaceship[1] = 16'b0000000111000000;
		spaceship[2] = 16'b0000000111000000;
		spaceship[3] = 16'b0000000111000000;
		spaceship[4] = 16'b0000000111000000;
		spaceship[5] = 16'b0000001111100000;
		spaceship[6] = 16'b0000011111110000;
		spaceship[7] = 16'b0000111111111000;
		spaceship[8] = 16'b0011111111111110;
		spaceship[9] = 16'b0000000111000000;
		spaceship[10] = 16'b0000000111000000;
		spaceship[11] = 16'b0000000111000000;
		spaceship[12] = 16'b0000000111000000;
		spaceship[13] = 16'b0000001111100000;
		spaceship[14] = 16'b0000011111110000;
		spaceship[15] = 16'b0000000111000000;
		
		planet[0] = 16'b0000000010000000;
		planet[1] = 16'b0000000111000000;
		planet[2] = 16'b0000000111000000;
		planet[3] = 16'b0000000111000000;
		planet[4] = 16'b0000000111000000;
		planet[5] = 16'b0000001111100000;
		planet[6] = 16'b0000011111110000;
		planet[7] = 16'b0000111111111000;
		planet[8] = 16'b0011111111111110;
		planet[9] = 16'b0000000111000000;
		planet[10] = 16'b0000000111000000;
		planet[11] = 16'b0000000111000000;
		planet[12] = 16'b0000000111000000;
		planet[13] = 16'b0000001111100000;
		planet[14] = 16'b0000011111110000;
		planet[15] = 16'b0000000111000000;
		
		spaceship_x = 320;
		spaceship_y = 240;
		planet_x = 325;
		planet_y = 234;
	end
endmodule