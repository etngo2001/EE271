// Eugene Ngo
// 12/2/2022
// EE 271
// Lab 5

// comparator takes 1-Bit clk, 1-Bit reset, 10-Bit A, and 10-Bit B as inputs and returns 1-Bit value_final
// This module determines the difficulty and value of the CPU input by comparing the switch value with 
// the LFSR random value

module comparator(clk, reset, A, B, value_final);
	output logic value_final;
	input logic clk, reset;
	input logic [9:0] A, B;
	
	logic value;
	
	// consider metastability for computer 
		always_comb begin
			
			 value = (A > B); // where: A = SW , B = LFSR 
			
		end

	always_ff @(posedge clk) begin
		value_final <= value;
	end
	
endmodule

// comparator_testbench tests all expected, unexpected, and edgecase behaviors
module comparator_testbench();
	logic value_final;
	logic clk, reset;
	logic [9:0] A, B;
	
	comparator dut(.clk, .reset, .A, .B, .value_final);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2)
		clk <= ~clk;
	end
	
	initial begin
		 	A = 10'b0010000001; B = 10'b0100000010; 	@(posedge clk);
																	@(posedge clk);
									  B = 10'b0000010000;	@(posedge clk);
																	@(posedge clk);
		$stop;
	end
endmodule

			