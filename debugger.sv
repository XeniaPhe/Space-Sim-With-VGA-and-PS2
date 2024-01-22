module debugger(
input logic clk,
input logic en,
input logic [3:0] ldr,
output logic [3:0] gnds,
output logic [6:0] display);

logic [15:0] data;
logic [1:0] current_segment;

always_comb
begin
	case(data[current_segment])
		4'b0000 : display = 7'b1111110;
		4'b0001 : display = 7'b0110000;
		4'b0010 : display = 7'b1101101;
		4'b0011 : display = 7'b1111001;
		4'b0100 : display = 7'b0110011;
		4'b0101 : display = 7'b1011011;
		4'b0110 : display = 7'b1011111;
		4'b0111 : display = 7'b1110000;
		4'b1000 : display = 7'b1111111;
		4'b1001 : display = 7'b1111011;
		4'b1010 : display = 7'b1110111;
		4'b1011 : display = 7'b0011111;
		4'b1100 : display = 7'b1001110;
		4'b1101 : display = 7'b0111101;
		4'b1110 : display = 7'b1001111;
		4'b1111 : display = 7'b1000111;
	endcase
end

always_ff @(posedge clk)
begin
	gnds <= {gnds[2:0], gnds[3]};
	current_segment <= current_segment + 1;
	
	if(en)
		data <= {data[15:4], ldr};
end

initial
begin
	gnds = 4'b1110;
	current_segment = 0;
end

endmodule