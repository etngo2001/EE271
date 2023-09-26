/*	Name: Nicole Pham, Syed Yasir
	Date: April 3rd, 2022
	Class: EE 371
	Lab 1: Parking Lot Occupancy Counter*/

// counter implements a car counter that can count from 0 to 16.
// It takes 1-bit input clk, reset, incr, and decr and returns 5-bits count as output.
// count represents the number of cars in the parking lot. count returns to 0 on reset (when reset is set to 1).
// count does not go below 0 or above 16.
// count connects to the seg7 module's input.
// A 1 on incr will add 1 to the count. A 1 on decr will subtract 1 from the count.
// incr and decr are connected to the carDetection module's enter and exit output.
// clk represents the clock input.
module carCount (clk, reset, inc, dec, count);
	input logic clk, reset, inc, dec;
	output logic [4:0] count;

	always_ff @(posedge clk) begin // Assigns count to appropriate value based on if a car comes in or out
		if (reset)
			count <= 5'b0;
		else if (inc && (count != 5'b11001)) // if count is 25, don't add
			count <= count + 5'b1;
		else if (dec && (count != 5'b00000)) // if count is 0, don't subtract
			count <= count - 5'b1;
	end // always_ff
endmodule

// Testbench for counter module that tests for counting cars accurately
module carCount_testbench();
	logic clk;
	logic reset;
	logic inc, dec;
	logic[4:0] count;
	
	carCount dut(.clk, .reset, .inc, .dec, .count);
	
	parameter clock_period = 100;	//clock setup, from EE 271
	initial begin
		clk <= 0;
		forever #(clock_period /2) clk <= ~clk;
	end //initial
	
	// Runs all possible combinations of inputs
	// to display 0 through 25
	initial begin
		reset <= 1;				@(posedge clk); // reset on, values don't change
						inc = 0;@(posedge clk);
						dec = 0;@(posedge clk);
		reset <= 0;
						inc = 1;@(posedge clk); // count up past 16
						inc = 1;@(posedge clk); // 2
						inc = 1;@(posedge clk); // 3
						inc = 1;@(posedge clk); // 4
						inc = 1;@(posedge clk); // 5
						inc = 1;@(posedge clk); // 6
						inc = 1;@(posedge clk); // 7
						inc = 1;@(posedge clk); // 8
						inc = 1;@(posedge clk); // 9
						inc = 1;@(posedge clk); // 10
						inc = 1;@(posedge clk); // 11
						inc = 1;@(posedge clk); // 12
						inc = 1;@(posedge clk); // 13
						inc = 1;@(posedge clk); // 14
						inc = 1;@(posedge clk); // 15
						inc = 1;@(posedge clk); // 16
						inc = 1;@(posedge clk); // 17
						inc = 1;@(posedge clk); // 18
						inc = 1;@(posedge clk); // 19
						inc = 1;@(posedge clk); // 20
						inc = 1;@(posedge clk); // 21
						inc = 1;@(posedge clk); // 22
						inc = 1;@(posedge clk); // 23
						inc = 1;@(posedge clk); // 24
						inc = 1;@(posedge clk); // 25
						inc = 1;@(posedge clk); // should stay 25
						inc = 1;@(posedge clk); // should stay 25
						inc = 1;@(posedge clk); // should stay 25
						inc = 0; // turn off incrementing
						dec = 1;@(posedge clk); // 24
						dec = 1;@(posedge clk); // 23
						dec = 1;@(posedge clk); // 22
		reset <= 1;
						inc = 0;@(posedge clk); // reset on, count goes back to zero
						dec = 0;@(posedge clk);
		reset <= 0;
						dec = 1;@(posedge clk); // should stay zero
						dec = 1;@(posedge clk); // should stay zero
						dec = 1;@(posedge clk); // should stay zero
		$stop; //end simulation						
	end //initial
endmodule
