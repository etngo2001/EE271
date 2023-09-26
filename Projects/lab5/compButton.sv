// Eugene Ngo
// 12/2/2022
// EE 271
// Lab 5

// compButton takes 1-Bit clk, 1-Bit reset, 10-Bit Q, and 9-Bit SW as inputs and returns 1-Bit out
// This module extends comparator and formats the switch values to be used in comparator
module compButton(clk, reset, Q, SW, out);
	output logic out;
	input logic clk, reset;
	input logic [9:0] Q;
	input logic [8:0] SW;
	
	logic [9:0] SW_extend;
	
	assign SW_extend = {1'b0, SW}; 
	
	// The comparator module takes in clk, reset, SW_extend to A, Q to B, and returns out to value_final
	// The comparator takes in the selected switch and determines the difficulty and value of the CPU
	comparator computer(.clk, .reset, .A(SW_extend), .B(Q), .value_final(out));
endmodule

// compButton_testbench tests all expected, unexpected, and edgecase behaviors
module compButton_testbench();
	logic out;
	logic clk, reset;
	logic [9:0] Q;
	logic [8:0] SW;
	logic [9:0] SW_extend;
	
	compButton dut(.clk, .reset, .Q, .SW, .out);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) 
		clk <= ~clk;
	end
	
	initial begin
		reset <= 1;											@(posedge clk);
																@(posedge clk);
		reset <= 0;											@(posedge clk);
																@(posedge clk);
		Q = 10'b0000000001;	SW = 9'b000000010;	@(posedge clk);
																@(posedge clk);
		Q = 10'b0000000011;								@(posedge clk);
																@(posedge clk);
		$stop;
	end
endmodule 