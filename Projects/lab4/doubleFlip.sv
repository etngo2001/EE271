// Eugene Ngo
// 11/18/2022
// EE 271
// Lab 4

// doubleFlip module takes in clk, reset, and button as 1-Bit inputs and returns 1-Bit out.
// This module processes buttons at clock cycles.

module doubleFlip (clk, reset, button, out);

	input logic clk, reset;
	input logic button;
	output logic out;

	logic out_ff1;

	always_ff @(posedge clk) begin
		out_ff1 <= button;
	end
	
	always_ff @(posedge clk) begin
		out <= out_ff1;
	end
endmodule 

// doubleFlip_testbench tests all expected, unexpected, and edgecase behaviors

module doubleFlip_testbench();

	logic clk, reset;
	logic button;
	logic out;

	doubleFlip dut (.clk, .reset, .button, .out);

	//Set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) 
		clk <= ~clk;
	end
	
	initial begin
							@(posedge clk);
		reset <= 1;		@(posedge clk);
							@(posedge clk);
		reset <= 0;		@(posedge clk);
							@(posedge clk);
		button <= 1;	@(posedge clk);
							@(posedge clk);
							@(posedge clk);
							@(posedge clk);
		button <= 0;	@(posedge clk);
							@(posedge clk);
							@(posedge clk);
							@(posedge clk);
		$stop; 
	end 
endmodule 