// Eugene Ngo
// 11/18/2022
// EE 271
// Lab 4

// DE1_SoC is the top level module. It takes in a 3-Bit KEY, 1-Bit CLOCK_50, and a 10-Bit SW as inputs.
// It returns 7-Bit HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, as well as a 10-Bit LEDR. The LEDR indicates the
// the current position of the "rope" and once it reaches either opposing side, a victor is assigned and
// displayed on HEX-. Switch 9 is used to reset the game.

module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	 input logic 			CLOCK_50; // 50MHz clock.
	 output logic 	[6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	 output logic 	[9:0] LEDR;
	 input logic 	[3:0] KEY; // True when not pressed, False when pressed
	 input logic 	[9:0] SW;

	 
	 // logic reset;
	 logic key0, key3;
	 logic key0_Stable, key3_Stable;
	 
	 // Assign HEX 5 - 1 to default display
	 
	 assign HEX5 = 7'b1111111;
	 assign HEX4 = 7'b1111111;
	 assign HEX3 = 7'b1111111;
	 assign HEX2 = 7'b1111111;
	 assign HEX1 = 7'b1111111;
	 
	 // Instantiates dff modules to process button inputs at clock cycles
	 // doubledFlip module takes in CLOCK_50 to clk, SW[9] to reset, and KEY[0 or 3] to button as inputs
	 // and returns out as clocked inputs
	 
	 doubleFlip ff1 (.clk(CLOCK_50), .reset(SW[9]), .button(~KEY[0]), .out(key0_Stable));
	 doubleFlip ff2 (.clk(CLOCK_50), .reset(SW[9]), .button(~KEY[3]), .out(key3_Stable));
	 
	 // Instantiates user input modules with switch zero and three for user inputs
	 // userInput module takes in CLOCK_50 to clk, SW[9] to reset, and and clocked inputs to button as inputs
	 // and returns button states to out
	 
	 userInput switchZero (.clk(CLOCK_50), .reset(SW[9]), .button(key0_Stable), .out(key0));
	 userInput switchThree (.clk(CLOCK_50), .reset(SW[9]), .button(key3_Stable), .out(key3));
	
	 // Light instantiations
	 // The light modules takes in CLOCK_50 to clk, SW[9] to reset, key3 to L, key 0 to R, LEDR[9:0] to NL, LEDR[0:9] to NR
	 // and returns LEDR[0:9] to lightOn.
	 
	 normalLight one (.clk(CLOCK_50), .reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[2]), .NR(1'b0), .lightOn(LEDR[1]));
	 normalLight two (.clk(CLOCK_50), .reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[3]), .NR(LEDR[1]), .lightOn(LEDR[2]));
	 normalLight three (.clk(CLOCK_50), .reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[4]), .NR(LEDR[2]), .lightOn(LEDR[3]));
	 normalLight four (.clk(CLOCK_50), .reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[5]), .NR(LEDR[3]), .lightOn(LEDR[4]));
	 
	 // center light is a little different from the normalLight module so that when the game is reset, the LED light is recenetered
	 centerLight five (.clk(CLOCK_50), .reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[6]), .NR(LEDR[4]), .lightOn(LEDR[5]));
	 
	 normalLight six (.clk(CLOCK_50), .reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[7]), .NR(LEDR[5]), .lightOn(LEDR[6]));
	 normalLight seven (.clk(CLOCK_50), .reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[8]), .NR(LEDR[6]), .lightOn(LEDR[7]));
	 normalLight eight (.clk(CLOCK_50), .reset(SW[9]), .L(key3), .R(key0), .NL(LEDR[9]), .NR(LEDR[7]), .lightOn(LEDR[8]));
	 normalLight nine (.clk(CLOCK_50), .reset(SW[9]), .L(key3), .R(key0), .NL(1'b0), .NR(LEDR[8]), .lightOn(LEDR[9]));
	 
	 // Determines who wins
	 // victory module takes in CLOCK_50 to clk, SW[9] to reset, LEDR[9] to LED9, LEDR[1] to LED1, key3 to L, key0 to R, and
	 // returns HEX0 to winner
	 victory gameEnds (.clk(CLOCK_50), .reset(SW[9]), .LED9(LEDR[9]), .LED1(LEDR[1]), .L(key3), .R(key0), .winner(HEX0));
	 
	 
endmodule

//DE1_SoC_testbench tests all expected, unexpected, and edgecase behaviors that the Tug of War system implemented in this lab may encounter.

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
		SW[9] <= 1;							@(posedge CLOCK_50);
												@(posedge CLOCK_50);
												@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		SW[9] <= 0;							@(posedge CLOCK_50);
												@(posedge CLOCK_50);
												@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 0; KEY[3] <= 0;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 1;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 0;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 1;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 0; 						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 1;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 0;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 1;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 0;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 1;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 0;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 1;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 0;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 1; 						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
												@(posedge CLOCK_50);
												@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 0; 						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 1;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 0; KEY[3] <= 1;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
						 KEY[3] <= 0;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
						 KEY[3] <= 1;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
						 KEY[3] <= 0;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
						 KEY[3] <= 1;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
						 KEY[3] <= 0;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
						 KEY[3] <= 1;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
						 KEY[3] <= 0;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
						 KEY[3] <= 1;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
						 KEY[3] <= 0;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
						 KEY[3] <= 1;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
						 KEY[3] <= 0;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
						 KEY[3] <= 1;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
						 KEY[3] <= 0;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
						 KEY[3] <= 1;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
						 KEY[3] <= 0;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
						 KEY[3] <= 1;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
						 KEY[3] <= 0;		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		$stop;
	end
endmodule 