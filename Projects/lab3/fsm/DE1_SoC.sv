
module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	
	input logic CLOCK_50; // 50MHz clock
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY; // Active low property
	input logic [9:0] SW;

	// Generate clk off of CLOCK_50, whichClock picks rate.

	logic [31:0] clk;

	parameter whichClock = 25;

	//clock_divider cdiv (CLOCK_50, clk);

	logic reset;  // configure reset

	assign reset = KEY[0]; // Reset when KEY[0] is pressed
	
	//assign LEDR[5] = clk[whichClock];
	assign LEDR[5] = clk[CLOCK_50];
	
	// instantiates Hazard light and assigned corresponding ports
	//fsm f1 (.clk(clk[whichClock]), .reset(reset), .w(SW[0]), .out(LEDR[0]));
	fsm1101 f1 (.clk(CLOCK_50), .reset(reset), .w(SW[0]), .out(LEDR[0]));
	
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
		forever #(CLOCK_PERIOD /2) CLOCK_50 <= ~CLOCK_50; // Keeps toggling the clock forever
	
	end // initial
	
	initial begin
	
		KEY[0] <= 1;					@(posedge CLOCK_50);
		KEY[0] <= 0;	SW[0]<=0;   @(posedge CLOCK_50);
											@(posedge CLOCK_50);
											@(posedge CLOCK_50);
											@(posedge CLOCK_50);
							SW[0]<=1;   @(posedge CLOCK_50);
							SW[0]<=1;   @(posedge CLOCK_50);
							SW[0]<=0;   @(posedge CLOCK_50);
							SW[0]<=1;   @(posedge CLOCK_50);
											@(posedge CLOCK_50);
											@(posedge CLOCK_50);
											@(posedge CLOCK_50);
							SW[0]<=1;   @(posedge CLOCK_50);
							SW[0]<=1;   @(posedge CLOCK_50);
							SW[0]<=0;   @(posedge CLOCK_50);
							SW[0]<=1;   @(posedge CLOCK_50);
							SW[0]<=1;   @(posedge CLOCK_50);
							SW[0]<=0;   @(posedge CLOCK_50);
							SW[0]<=1;   @(posedge CLOCK_50);
											@(posedge CLOCK_50);
											@(posedge CLOCK_50);
							SW[0]<=0;   @(posedge CLOCK_50);
							SW[0]<=1;   @(posedge CLOCK_50);
											@(posedge CLOCK_50);
							SW[0]<=0;   @(posedge CLOCK_50);
							SW[0]<=1;   @(posedge CLOCK_50);
							SW[0]<=0;   @(posedge CLOCK_50);
											@(posedge CLOCK_50);
										
			$stop; // stops the simulation
		
		end // initial
		
endmodule
								
