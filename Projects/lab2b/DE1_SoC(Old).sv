
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	
	input logic [3:0] KEY;
	input logic [9:0] SW;
	
	// setting up hex0
	seg7user seg (.bcd(SW[9:6]), .leds(HEX0));
	
	// setting up the edd
	electronicDetectorDevice EDD (.U(SW[8]), .P(SW[7]), .C(SW[6]), .M(SW[0]), .discount(LEDR[0]), .stolen(LEDR[1]));
	
	// assigning off values to other hex displays
	assign HEX1 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;
	
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
	
		for(i = 0; i < 10; i++) begin
			SW[9:6] = i; #10;
		end // for loop
		
	end // initial
	
endmodule 