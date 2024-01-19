module timer(
	input logic clk_50_mhz,
	input logic ack,
	output logic IRQ_second_elapsed);

	logic [25:0] counter;
	
	localparam divisor = 50000000;

	always_ff @(posedge clk_50_mhz) begin
		counter <= counter + 1;
	
		if(counter == divisor) begin
			IRQ_second_elapsed <= 1;
			counter <= 0;
		end else if(ack) begin
			IRQ_second_elapsed <= 0;
		end
	end

	initial begin
		IRQ_second_elapsed = 0;
		counter = 0;
	end
endmodule