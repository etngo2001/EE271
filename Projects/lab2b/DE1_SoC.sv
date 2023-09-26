
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	
	input logic [3:0] KEY;
	input logic [9:0] SW;
	
	// setting up the hex display
	translator item (.UPC(SW[8:6]), .leds0(HEX0), .leds1(HEX1), .leds2(HEX2), .leds3(HEX3), .leds4(HEX4), .leds5(HEX5));
	
	// setting up the edd
	electronicDetectorDevice EDD (.U(SW[8]), .P(SW[7]), .C(SW[6]), .M(SW[0]), .discount(LEDR[0]), .stolen(LEDR[1]));
	
endmodule

module DE1_SoC_testbench();

	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;

	DE1_SoC dut (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);
	
	// Try all combinations of inputs.
	integer i;
	
	initial begin
	
		SW[5:1] = 0;
		
		SW[0] = 0;
		for(i = 0; i < 8; i++) begin
			SW[8:6] = i; #10;
		end // for loop
		
		SW[0] = 1;
		for(i = 0; i < 8; i++) begin
			SW[8:6] = i; #10;
		end // for loop
		
	end // initial
endmodule 