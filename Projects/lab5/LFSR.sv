// Eugene Ngo
// 11/28/2022
// EE 271
// Lab 5

// LFSR module takes in 1-bit clk and 1-bit reset as inputs and returns 10-bit Q. This module is used to
// simulate computer button presses via a random number generator.

module LFSR(clk, reset, Q);
	output logic [9:0] Q;
	input logic clk, reset; 
	
	logic xnor_out;
	
	assign xnor_out = (Q[0] ~^ Q[3]); 
	
	always_ff @(posedge clk) begin
		if(reset) Q <= 10'b0000000000;
		
		else Q <= {xnor_out, Q[9:1]};
	end
endmodule

// LFSR_testbench tests all expected, unexpected, and edgecase behaviors
module LFSR_testbench();
	logic [10:1] Q;
	logic clk, reset;
	logic xnor_out;
	
	LFSR dut(.clk, .reset, .Q);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2)
		clk <= ~clk;
	end
	
	initial begin
		reset <= 1; 						@(posedge clk);
												@(posedge clk);
		reset <= 0;							@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
		$stop;
	end
endmodule

												