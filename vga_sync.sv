module vga_sync(
	input logic [15:0] spaceship_bitmap [15:0],
	input logic [15:0] planet_bitmap [15:0],
	input logic [9:0] spaceship_x,
	input logic [9:0] spaceship_y,
	input logic [9:0] planet_x,
	input logic [9:0] planet_y,
   input logic clk,
	output logic [2:0] rgb,
   output logic hsync,
   output logic vsync,
	output logic IRQ_Vsync);

   logic pixel_tick, video_on;
   logic [9:0] h_count;
   logic [9:0] v_count;

   localparam HD  = 640, //horizontal display area
              HF  = 48,  //horizontal front porch
              HB  = 16,  //horizontal back porch
              HFB = 96,  //horizontal flyback
              VD  = 480, //vertical display area
              VT  = 10,  //vertical top porch
              VB  = 33,  //vertical bottom porch
              VFB = 2,   //vertical flyback
              LINE_END = HF+HD+HB+HFB-1,
              PAGE_END = VT+VD+VB+VFB-1;
				  
	localparam SIZE = 16;

   always_ff @(posedge clk)
     pixel_tick <= ~pixel_tick; //25 MHZ signal is generated.


   //=====Manages hcount and vcount======
   always_ff @(posedge clk)
     if (pixel_tick) 
       begin
          if (h_count == LINE_END)
              begin
                  h_count <= 0;
                  if (v_count == PAGE_END)
                        v_count <= 0;
                  else
                     v_count <= v_count + 1;
               end
           else
               h_count <= h_count + 1;
        end
      
   //=====================color generation=================  
   //== origin of display area is at (h_count, v_count) = (0,0)===
   always_comb
		begin
			rgb = 3'b010;	//change this to 000 if anything goes wrong
			
			if ((h_count < HD) && (v_count < VD)) begin // if video on
				
				if ((h_count >= spaceship_x) && (h_count < (spaceship_x + SIZE))
				&& (v_count >= spaceship_y) && (v_count < spaceship_y + SIZE)
				&& (spaceship_bitmap[v_count - spaceship_y][spaceship_x + SIZE - h_count] == 1)) begin
					rgb = 3'b100;	//spaceship
				end else if ((h_count >= planet_x) && (h_count < (planet_x + SIZE))
				&& (v_count >= planet_y) && (v_count < planet_y + SIZE)
				&& (planet_bitmap[v_count - planet_y][planet_x + SIZE - h_count] == 1)) begin
					rgb = 3'b001;	//planet
				end else begin
					rgb = 3'b010;	//background
				end
			end
      end

   //=======hsync and vsync will become 1 during flybacks.=======
   //== origin of display area is at (h_count, v_count) = (0,0)===
   assign hsync = (h_count >= (HD+HB) && h_count <= (HFB+HD+HB-1));
   assign vsync = (v_count >= (VD+VB) && v_count <= (VD+VB+VFB-1));
	assign IRQ_Vsync = (v_count >= (VD+VB) && v_count <= (VD+VB+VFB-1));

   initial begin
       h_count = 0;
       v_count = 0;
       pixel_tick = 0;
   end

endmodule