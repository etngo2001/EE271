
//module to implement a string recognizer for the string 1101

module fsm1101 (clk, reset, w, out);

	input  logic  clk, reset, w;
	output logic  out;

	enum {S0, S1, S2, S3} ps, ns; // Present state, next state

	//Next state logic
	always_comb begin
		case (ps)
			S0: if (w) ns = S1;
					else ns = S0;
			S1: if (w) ns = S2;
					else ns = S0;
			S2: if (w) ns = S2;
					else ns = S3;
			S3: if (w) ns = S1;
					else ns = S0;
		endcase
	end
			
	assign out = (ps == S3) & w;  //use this statement or the next one
	//assign out = ps[1] & w;
	
	//sequential logic (DFFs)
		always_ff @(posedge clk) begin
			if (reset)
				ps <= S0;
			else
				ps <= ns;
		end
				
	
endmodule



module fsm1101_testbench();

		logic clk, reset, w, out;
		
		fsm1101 dut (.clk, .reset, .w, .out);
		
		//clock setup
		parameter clock_period = 100;
		
		initial begin
			clk <= 0;
			forever #(clock_period /2) clk <= ~clk;
					
		end //initial
		
		initial begin
		
			reset <= 1;         @(posedge clk);
			reset <= 0; w<=0;   @(posedge clk);
									  @(posedge clk);
			                    @(posedge clk);	
			                    @(posedge clk);	
			            w<=1;   @(posedge clk);
							w<=1;   @(posedge clk);	
							w<=0;   @(posedge clk);	
							w<=1;   @(posedge clk);	
									  @(posedge clk);	
			                    @(posedge clk);	
			                    @(posedge clk);	
							w<=0;   @(posedge clk);	
									  @(posedge clk);	
									  @(posedge clk);	
									  @(posedge clk);
							w<=1;   @(posedge clk);
							w<=1;   @(posedge clk);	
							w<=0;   @(posedge clk);	
							w<=1;   @(posedge clk);	
									  @(posedge clk);
									  @(posedge clk);
			$stop; //end simulation							
							
		end //initial
		
endmodule		