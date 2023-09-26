module wind_indicator (clk, left, right, out, reset);
	input logic clk, left, right, reset;
	output logic [2:0] out;
	
	// State variables
	enum { S0, S1, S2, S3 } ps, ns;
	
	//Next State logic
	//S1 = 010; S2 = 100; S3 = 101; S4 = 001;
	always_comb begin
	
		case (ps)
		
			S0: if (right) ns = S3;
					else if (left) ns = S1;
					else ns = S2;
				
			S1: if (right) ns = S0;
					else if (left) ns = S3;
					else ns = S2;
				
			S2: ns = S0;
			
			S3: if (right) ns = S1;
					else if (left) ns = S0;
					else ns = S2;
				
		endcase
		
	end
	
	// Output logic
	always_comb begin
	
		case (ps)
		
			S0: if (right) out = 3'b001;
					else if (left) out = 3'b100;
					else out = 3'b101;
				
			S1: if (right) out = 3'b010;
					else if (left) out = 3'b001;
					else out = 3'b101;
			
			S2: out = 3'b010;
			
			S3: if (right) out = 3'b100;
					else if (left) out = 3'b010;
					else out = 3'b101;
		endcase
		
	end
	
	// DFFs
	always_ff @(posedge clk) begin
		if (reset)
			ps <= S0;
		else
			ps <= ns;
	end
endmodule 

module wind_indicator_testbench();
	logic clk, left, right, reset;
	logic [2:0] out;
	
	wind_indicator dut (.clk, .left, .right, .out, .reset);
	
	// clock set-up
	parameter clock_period = 100;
		
		initial begin
			clk <= 0;
			forever #(clock_period /2) clk <= ~clk;
					
		end // initial
		
		initial begin
	
			reset <= 0; 								 repeat(5) @(posedge clk); // 5 cycles of Holding reset
			reset <= 1; right <= 0; left <= 0; repeat(9) @(posedge clk); // 9 cycles of calm
			reset <= 1; right <= 0; left <= 1; repeat(9) @(posedge clk); // 9 cycles of right to left
			reset <= 1; right <= 1; left <= 0; repeat(9) @(posedge clk); // 9 cycles of left to right
										
			$stop; // stops the simulation
		
		end // initial
		
endmodule 