module timer(
	input logic clk_50Mhz,
	input logic ack,
	output logic IRQ_timer_100ms);

	logic [22:0] counter;
	
	localparam divisor = 5000000;

	always_ff @(posedge clk_50Mhz) begin
		counter <= counter + 1;
	
		if(counter == divisor) begin
			IRQ_timer_100ms <= 1;
			counter <= 0;
		end else if(ack) begin
			IRQ_timer_100ms <= 0;
		end
	end

	initial begin
		IRQ_timer_100ms = 0;
		counter = 0;
	end
endmodule