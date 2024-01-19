module vga_sync(
	input logic clk,
	input logic wren,
	input logic [15:0] ldr,
	input logic [5:0] addr,
	output logic [2:0] rgb,
   output logic hsync,
   output logic vsync,
	output logic IRQ_Vsync);

   logic pixel_tick, video_on;
   logic [9:0] h_count;
   logic [9:0] v_count;
	
	logic [15:0] spaceship_bitmap [0:15];
	logic [15:0] planet_bitmap [0:15];
	logic [9:0] spaceship_x;
	logic [9:0] spaceship_y;
	logic [9:0] planet_x;
	logic [9:0] planet_y;

   localparam 	HD  = 640, //horizontal display area
					HF  = 48,  //horizontal front porch
					HB  = 16,  //horizontal back porch
					HFB = 96,  //horizontal flyback
					VD  = 480, //vertical display area
					VT  = 10,  //vertical top porch
					VB  = 33,  //vertical bottom porch
					VFB = 2,   //vertical flyback
					LINE_END = HF+HD+HB+HFB-1,
					PAGE_END = VT+VD+VB+VFB-1;
				  
	localparam  SPRITE_SIZE = 16,
					BEGIN_SPACESHIP_BITMAP = 6'h00,
					BEGIN_PLANET_BITMAP = 6'h10,
					ADDR_SPACESHIP_X = 6'h20,
					ADDR_SPACESHIP_Y = 6'h21,
					ADDR_PLANET_X = 6'h22,
					ADDR_PLANET_Y = 6'h23;

   always_ff @(posedge clk)
     pixel_tick <= ~pixel_tick; //25 MHZ signal

   always_ff @(posedge clk)
	begin
		if (pixel_tick)
		begin
			if (h_count == LINE_END)
			begin
				h_count <= 0;
				
            if (v_count == PAGE_END)
					v_count <= 0;
            else
					v_count <= v_count + 1;
			end else
			begin
				h_count <= h_count + 1;
			end
		end
	end
	
	always_ff @(posedge wren, posedge vsync)
	begin
		if(wren)
		begin
			if((addr >= BEGIN_SPACESHIP_BITMAP) && (addr < BEGIN_PLANET_BITMAP))
			begin
				spaceship_bitmap[addr[3:0]] <= ldr;
			end else if ((addr >= BEGIN_PLANET_BITMAP) && (addr < ADDR_SPACESHIP_X))
			begin
				planet_bitmap[addr[3:0]] <= ldr;
			end else if (addr == ADDR_SPACESHIP_X)
			begin
				spaceship_x <= ldr[9:0];
				IRQ_Vsync <= 0;
			end else if (addr == ADDR_SPACESHIP_Y)
			begin
				spaceship_y <= ldr[9:0];
				IRQ_Vsync <= 0;
			end else if (addr == ADDR_PLANET_X)
			begin
				planet_x <= ldr[9:0];
				IRQ_Vsync <= 0;
			end else if (addr == ADDR_PLANET_Y)
			begin
				planet_y <= ldr[9:0];
				IRQ_Vsync <= 0;
			end
		end else if(vsync)
		begin
			IRQ_Vsync <= 1;
		end
	end
      
   always_comb begin
		if ((h_count < HD) && (v_count < VD)) begin // if video on
		
			if ((h_count >= spaceship_x) && (h_count < (spaceship_x + SPRITE_SIZE))
			&& (v_count >= spaceship_y) && (v_count < spaceship_y + SPRITE_SIZE)
			&& (spaceship_bitmap[v_count - spaceship_y][spaceship_x + SPRITE_SIZE - h_count] == 1)) begin
				rgb = 3'b100;	//spaceship
			end else if ((h_count >= planet_x) && (h_count < (planet_x + SPRITE_SIZE))
			&& (v_count >= planet_y) && (v_count < planet_y + SPRITE_SIZE)
			&& (planet_bitmap[v_count - planet_y][planet_x + SPRITE_SIZE - h_count] == 1)) begin
				rgb = 3'b001;	//planet
			end else begin
				rgb = 3'b010;	//background
			end
		end else begin
				rgb = 3'b000;
		end
	end

   assign hsync = (h_count >= (HD+HB) && h_count <= (HFB+HD+HB-1));
   assign vsync = (v_count >= (VD+VB) && v_count <= (VD+VB+VFB-1));

   initial begin
		h_count = 0;
      v_count = 0;
      pixel_tick = 0;
		spaceship_x = 0;
		spaceship_y = 0;
		planet_x = 0;
		planet_y = 0;
   end

endmodule