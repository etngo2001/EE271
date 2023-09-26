// Eugene Ngo
// 12/2/2022
// EE 271
// Lab 6

// clock_divider module generates 32 different clocks that can be used for slower clock speeds.

// Takes in a clock signal, divides the clock cycle and outputs 32
// divided clock signals of varying frequency.
// divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ...
// [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ...
module clock_divider (clock, divided_clocks);
	
	input logic clock;
	output logic [31:0] divided_clocks = 32'b0;
	
	always_ff @(posedge clock) begin
		divided_clocks <= divided_clocks + 1;
	end
endmodule

// clock_divider_testbench tests all expected, unexpected, and edgecase behaviors
module clock_divider_testbench();
	logic clock;
	logic [31:0] divided_clocks;
	
	clock_divider dut (.clock, .divided_clocks);

	parameter clock_period = 100;
	
	integer i;
	initial begin

		for (i = 0; i < clock_period; i++) begin
			
			@(posedge clock);
		
		end // for loop
		
		$stop; // ends the simulation
	
	end // initial
endmodule 