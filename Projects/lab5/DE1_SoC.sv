// Eugene Ngo
// 12/2/2022
// EE 271
// Lab 5

// DE1_SoC is the top level module. It takes in a 4-Bit KEY, 1-Bit CLOCK_50, and a 10-Bit SW as inputs.
// It returns 7-Bit HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, as well as a 10-Bit LEDR. The LEDR indicates the
// the current position of the "rope" and once it reaches either opposing side, a victor is assigned and
// displayed on HEX-. Switch 9 is used to reset the game.

module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	 input logic 			CLOCK_50; // 50MHz clock
	 input logic 	[3:0] KEY;
	 input logic 	[9:0] SW;
	 output logic 	[6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	 output logic 	[9:0] LEDR;
	 
	 // Generate clk using CLOCK_50 (whichClock determines rate)
	 logic [31:0] clk;  
	 parameter whichClock = 15;
	 clock_divider cdiv (CLOCK_50, clk);
	 
	 // assign HEX values to be OFF to start game
	 assign HEX4 = 7'b1111111;
	 assign HEX3 = 7'b1111111;
	 assign HEX2 = 7'b1111111;
	 assign HEX1 = 7'b1111111;
	 
	 // declare key, key base, and CPU variables 
	 logic key0, key3;
	 logic key0_base, key3_base;
	 logic CPU;	 
	 
	 // Instantiates dff modules to process button inputs at clock cycles
	 // doubleFlipFlop module takes in clk[whichClock] to clk, SW[9] to reset, and KEY[0]/CPU to button as inputs
	 // and returns out as clocked inputs
	 doubleFlipFlop flipFlop1 (.clk(clk[whichClock]), .reset(SW[9]), .button(~KEY[0]), .out(key0_base));
	 doubleFlipFlop flipFlop2 (.clk(clk[whichClock]), .reset(SW[9]), .button(CPU), .out(key3_base));
	 
	 // Instantiates user input modules with switch zero and three for user inputs
	 // userInput module takes in clk[whichClock] to clk, SW[9] to reset, and and clocked inputs to button as inputs
	 // and returns button states to out
	 // One of the user inputs is designated to be the user/human and the other is an automated computer opponent
	 userInput human (.clk(clk[whichClock]), .reset(SW[9]), .button(key0_base), .out(key0));
	 userInput computer (.clk(clk[whichClock]), .reset(SW[9]), .button(key3_base), .out(key3));
	
	 // Light instantiations
	 // The light modules takes in clk[whichClock] to clk, SW[9] to reset, key3 to L, key 0 to R, LEDR[9:0] to NL, LEDR[0:9] to NR, restart to restart
	 // and returns LEDR[0:9] to lightOn.
	 normalLight L1 (.clk(clk[whichClock]), .reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[2]), .NR(1'b0), .lightOn(LEDR[1]), .restart(restart));
	 normalLight L2 (.clk(clk[whichClock]), .reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[3]), .NR(LEDR[1]), .lightOn(LEDR[2]), .restart(restart));
	 normalLight L3 (.clk(clk[whichClock]), .reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[4]), .NR(LEDR[2]), .lightOn(LEDR[3]), .restart(restart));
	 normalLight L4 (.clk(clk[whichClock]), .reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[5]), .NR(LEDR[3]), .lightOn(LEDR[4]), .restart(restart));
	 
	 // center light is a little different from the normalLight module so that when the game is reset or restarted, the LED light is recenetered
	 centerLight L5 (.clk(clk[whichClock]), .reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[6]), .NR(LEDR[4]), .lightOn(LEDR[5]), .restart(restart));
	 
	 normalLight L6 (.clk(clk[whichClock]), .reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[7]), .NR(LEDR[5]), .lightOn(LEDR[6]), .restart(restart));
	 normalLight L7 (.clk(clk[whichClock]), .reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[8]), .NR(LEDR[6]), .lightOn(LEDR[7]), .restart(restart));
	 normalLight L8 (.clk(clk[whichClock]), .reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[9]), .NR(LEDR[7]), .lightOn(LEDR[8]), .restart(restart));
	 normalLight L9 (.clk(clk[whichClock]), .reset(SW[9]), .L(key3), .R(key0), .NL(1'b0), .NR(LEDR[8]), .lightOn(LEDR[9]), .restart(restart));
	 
	 // generate button for CPU
	 logic [9:0] LFSR_out;
	 
	 // The LFSR module takes in clk[whichClock] to clk, SW[9] to reset, and returns LFSR_OUT to Q
	 // This module is used to simulate computer button presses via a random number generator.
	 LFSR random(.clk(clk[whichClock]), .reset(SW[9]), .Q(LFSR_out));
	 
	 // The compButton module takes in clk[whichClock] to clk, LFSR_out to Q, SW[8:0] to SW, and returns CPU to out
	 // This module formats the switches for the computer opponent's input
	 compButton comp(.clk(clk[whichClock]), .reset(SW[9]), .Q(LFSR_out), .SW(SW[8:0]), .out(CPU));
	 
	 // Determines who scores points
	 // victory module takes in clk[whichClock] to clk, SW[9] to reset, LEDR[9] to LED9, LEDR[1] to LED1, key3 to L, key0 to R,
	 // restart to restart, HEX0 to HEX0 and HEX5 to HEX5.
    // If the human scores points then it will be displayed and reflects on HEX0 and when the computer scores it will be
	 // shown on HEX5
	 winner winnerFound (.clk(clk[whichClock]), .reset(SW[9]), .LED9(LEDR[9]), .LED1(LEDR[1]), .L(key3), .R(key0), .restart(restart), .HEX0(HEX0), .HEX5(HEX5));
	 
endmodule

// DE1_SoC_testbench tests all expected, unexpected, and edgecase behaviors
module DE1_SoC_testbench();
	logic 		CLOCK_50;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	
	DE1_SoC dut (.CLOCK_50, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD / 2)
		CLOCK_50 <= ~CLOCK_50;
	end
	
	initial begin
																@(posedge CLOCK_50);
																@(posedge CLOCK_50);
		SW[9] <= 1;											@(posedge CLOCK_50);
																@(posedge CLOCK_50);
																@(posedge CLOCK_50);
																@(posedge CLOCK_50);
		SW[9] <= 0;											@(posedge CLOCK_50);
																@(posedge CLOCK_50);
																@(posedge CLOCK_50);
																@(posedge CLOCK_50);
		KEY[0] <= 1; SW[8:0] = 9'b000000000;		@(posedge CLOCK_50);
																@(posedge CLOCK_50);
		KEY[0] <= 0;										@(posedge CLOCK_50);
																@(posedge CLOCK_50);
		KEY[0] <= 1;										@(posedge CLOCK_50);
																@(posedge CLOCK_50);
		KEY[0] <= 0;										@(posedge CLOCK_50);
																@(posedge CLOCK_50);
		KEY[0] <= 1; 										@(posedge CLOCK_50);
																@(posedge CLOCK_50);
		KEY[0] <= 0;										@(posedge CLOCK_50);
																@(posedge CLOCK_50);
		KEY[0] <= 1;										@(posedge CLOCK_50);
																@(posedge CLOCK_50);
		KEY[0] <= 0;										@(posedge CLOCK_50);
																@(posedge CLOCK_50);
		KEY[0] <= 1;										@(posedge CLOCK_50);
																@(posedge CLOCK_50);
		KEY[0] <= 0;										@(posedge CLOCK_50);
																@(posedge CLOCK_50);
		KEY[0] <= 1;										@(posedge CLOCK_50);
																@(posedge CLOCK_50);
		KEY[0] <= 0;										@(posedge CLOCK_50);
																@(posedge CLOCK_50);
		KEY[0] <= 1;										@(posedge CLOCK_50);
																@(posedge CLOCK_50);
		KEY[0] <= 0; 										@(posedge CLOCK_50);
																@(posedge CLOCK_50);
																@(posedge CLOCK_50);
																@(posedge CLOCK_50);
																@(posedge CLOCK_50);
		SW[9] <= 1; 										@(posedge CLOCK_50);
																@(posedge CLOCK_50);
		SW[9] <= 0;											@(posedge CLOCK_50);
																@(posedge CLOCK_50);
		KEY[0] <= 0; SW[8:0] <= 9'b0111111110;		@(posedge CLOCK_50);
																@(posedge CLOCK_50);
																@(posedge CLOCK_50);
																@(posedge CLOCK_50);
																@(posedge CLOCK_50);
																@(posedge CLOCK_50);
																@(posedge CLOCK_50);
																@(posedge CLOCK_50);
																@(posedge CLOCK_50);
																@(posedge CLOCK_50);
		$stop;
	end
endmodule 