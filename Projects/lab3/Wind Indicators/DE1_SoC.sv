
module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	
	input logic CLOCK_50; // 50MHz clock
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY; // Active low property
	input logic [9:0] SW;
	
	// Turns off the hex display
	assign HEX0 = 7'b1111111;
	assign HEX1 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;

	// Generate clk off of CLOCK_50, whichClock picks rate.
	logic [31:0] clk;
	parameter whichClock = 25;
	
	//Comment for simulations, Uncomment for FPGA
	//clock_divider cdiv (CLOCK_50, clk);

	logic reset;  // configure reset
	assign reset = KEY[0]; // Reset when KEY[0] is pressed
	
	
	//assign LEDR[5] = clk[whichClock];
	assign LEDR[5] = clk[CLOCK_50];
	
	// Sequential Logic for cycling lights in each state
	// wind_indicator wi (.clk(clk[whichClock]), .left(SW[0]), .right(SW[1]), .out(LEDR[2:0]), .reset); // for FPGA
	wind_indicator wi (.clk(CLOCK_50), .left(SW[0]), .right(SW[1]), .out(LEDR[2:0]), .reset); // for simulation
	
endmodule

module DE1_SoC_testbench();

	logic CLOCK_50; // 50MHz clock
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY; // Active low property
	logic [9:0] SW;
	
	DE1_SoC dut (.CLOCK_50, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);
	
	parameter CLOCK_PERIOD = 100;
	
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; // Keeps toggling the clock forever
	
	end // initial
	
	initial begin
	
		KEY[0] <= 0; 								 repeat(5) @(posedge CLOCK_50); // 5 cycles of Holding reset
		KEY[0] <= 1; SW[1] <= 0; SW[0] <= 0; repeat(9) @(posedge CLOCK_50); // 9 cycles of calm
		KEY[0] <= 1; SW[1] <= 0; SW[0] <= 1; repeat(9) @(posedge CLOCK_50); // 9 cycles of right to left
		KEY[0] <= 1; SW[1] <= 1; SW[0] <= 0; repeat(9) @(posedge CLOCK_50); // 9 cycles of left to right
										
		$stop; // stops the simulation
		
	end // initial
		
endmodule
								
