
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;

	electronicDetectorDevice EDD (.U(SW[9]), .P(SW[8]), .C(SW[7]), .M(SW[0]), .discount(LEDR[0]), .stolen(LEDR[1]));
	
endmodule

module DE1_SoC_testbench();

	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	
	DE1_SoC dut (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);
	
	integer i;
	initial begin
	for (i=0; i<2**10; i++) begin
		SW[9:0] = i; #10;
	end
end

endmodule 