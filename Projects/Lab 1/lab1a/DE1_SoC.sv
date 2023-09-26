
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [5:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	
	/*
	Initializes 4 fullAdders and assigns the A inputs to switches 4 to 1,
	assigns the B inputs to switches 8 to 5, assigns cin to switch 0,
	assigns the sum outputs to LEDs 4 to 0, and assigns the cout to LED 5.
	*/
	fullAdder4 FA (.A(SW[4:1]), .B(SW[8:5]), .cin(SW[0]), .sum(LEDR[4:0]), .cout(LEDR[5]));
	
	assign HEX0 = 7'b0010000; //g
	assign HEX1 = 7'b0101011; //n
	assign HEX2 = 7'b1111011; //i
	assign HEX3 = 7'b0100001; //d
	assign HEX4 = 7'b0100001; //d
	assign HEX5 = 7'b0001000; //A
	
endmodule

module DE1_SoC_testbench();

	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [5:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	
	DE1_SoC dut (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);
	
	integer i;
	initial begin
	SW[9] = 1'b0;
	SW[8] = 1'b0;
	for (i=0; i<2**8; i++) begin
		SW[7:0] = i; #10;
	end
end

endmodule 