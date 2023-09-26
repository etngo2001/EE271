/*	Name: Nicole Pham, Syed Yasir
	Date: April 3rd, 2022
	Class: EE 371
	Lab 1: Parking Lot Occupancy Counter*/

// carDetection implements an FSM that can detect when a car enters or exits a parking lot and ignores pedestrians.
// It takes 1-bit input clk and reset, 2-bit w and returns 2-bits out as output.
// out represents whether a car entered or exited (the bit order is {enter, exit}). This connects to the counter module.
// w represents the inner and outer sensors (the bit order is {outer, inner}).
// clk represents the clock input.
module carDetect (clk, reset, w, out);
	input logic clk, reset;
	input logic [1:0] w; // w[1] is the outer sensor, w[0] is the inner sensor
	output logic  [1:0] out; // out[1] represents a car entering, out[0] represents a car exiting

	enum {unblocked, outer, blocked, inner} ps, ns; // Present state, next state

	// Next state logic
	always_comb begin
		case (ps)
			unblocked:
					if (w == 2'b01) ns = inner;
					else if (w == 2'b10) ns = outer;
					else if (w == 2'b11) ns = blocked;
					else ns = unblocked;
			outer:
					if (w == 2'b01) ns = inner;
					else if (w == 2'b10) ns = outer;
					else if (w == 2'b11) ns = blocked;
					else ns = unblocked;
			blocked:
					if (w == 2'b01) ns = inner;
					else if (w == 2'b10) ns = outer;
					else if (w == 2'b11) ns = blocked;
					else ns = unblocked;
			inner:
					if (w == 2'b01) ns = inner;
					else if (w == 2'b10) ns = outer;
					else if (w == 2'b11) ns = blocked;
					else ns = unblocked;
		endcase
	end // always_comb
	
	// Assigns pattern
	assign out[0] = (ps == blocked) && (w == 2'b10); // exit
	assign out[1] = (ps == blocked) && (w == 2'b01); // enter

	//sequential logic (DFFs)
	always_ff @(posedge clk) begin
		if (reset)
			ps <= unblocked;
		else
			ps <= ns;
	end // always_ff
endmodule

// Testbench for carDetect module that tests cars and pedestrians going in and out of the parking lot with various behaviors
module carDetect_testbench();
	logic clk, reset;
	logic [1:0] w; // w[1] is the outer sensor, w[0] is the inner sensor
	logic  [1:0] out; // out[1] represents a car entering, out[0] represents a car exiting
	
	carDetect dut (.clk, .reset, .w, .out);
		
	//clock setup
	parameter clock_period = 100;
	
	initial begin
		clk <= 0;
		forever #(clock_period /2) clk <= ~clk;
				
	end //initial
		
	initial begin
	
		reset <= 1;         		@(posedge clk);
		reset <= 0; w<=2'b00;   @(posedge clk); // start with empty sensor
						w<=2'b00;   @(posedge clk);
						w<=2'b10;   @(posedge clk); // outer sensor engaged
						w<=2'b00;   @(posedge clk); // outer sensor disengaged; no count
		            w<=2'b10;   @(posedge clk); // outer sensor engaged again
		            w<=2'b10;   @(posedge clk); // sitting on outer sensor
						w<=2'b11;   @(posedge clk); // blocked (car here!)
						w<=2'b11;   @(posedge clk); // taking a while to leave blocked
						w<=2'b01;   @(posedge clk); // inner sensor engaged, car entered (out == 2'b10)
						w<=2'b01;   @(posedge clk); // sitting on inner sensor, no count should happen
						w<=2'b00;   @(posedge clk); // car leaves
						w<=2'b01;   @(posedge clk); // inner sensor engaged
						w<=2'b11;   @(posedge clk); // blocked, car in sensor
						w<=2'b11;   @(posedge clk); // car sitting on both sensors
						w<=2'b10;   @(posedge clk); // outer sensor engaged, car exited (out == 2'b01)
						w<=2'b00;   @(posedge clk); // car leaves
						w<=2'b10;   @(posedge clk); // outer sensor engaged (pedestrian entered)
						w<=2'b01;   @(posedge clk); // inner sensor engaged (pedestrian passing through; no count)
						w<=2'b00;   @(posedge clk); // inner sensor disengaged; no count
										@(posedge clk);
										@(posedge clk);
		$stop; //end simulation							
							
	end //initial
		
endmodule
