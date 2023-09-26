// Eugene Ngo
// 12/2/2022
// EE 271
// Lab 5

// userInput module takes clk, reset, and button as 1-Bit inputs and returns 1-Bit out
// This module instatiates the buttons for user input.

module userInput(out, clk, reset, button);
	output logic out;
	input logic clk, reset, button;
	
	enum {on, off} ps, ns;
	
	always_comb begin
		case(ps)
			on: 	if(button) ns = on;
					else ns = off;
				
			off: 	if(button) ns = on;
					else ns = off;
			
		endcase
	end
	
	// same as Lab 6 behavior
	assign out = (ps == on & ns == off);
	
	always_ff @(posedge clk) begin
		if(reset) 
			ps <= off;
		else
			ps <= ns;
	end
endmodule

// userInput_testbench tests all expected, unexpected, and edgecase behaviors

module userInput_testbench();
	logic clk, reset;
	logic button;
	logic out;
	
	userInput dut (.out, .clk, .reset, .button);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) 
		clk <= ~clk;
	end
	
	initial begin
		reset <= 1;						@(posedge clk);
											@(posedge clk);
		reset <= 0;						@(posedge clk);
											@(posedge clk);
		button <= 1;					@(posedge clk);
											@(posedge clk);
											@(posedge clk);
		button <= 0;					@(posedge clk);
											@(posedge clk);
											@(posedge clk);
		button <= 1;					@(posedge clk);
											@(posedge clk);
											@(posedge clk);
		button <= 0; 					@(posedge clk);
											@(posedge clk);
											@(posedge clk);
		button <= 1;					@(posedge clk);
											@(posedge clk);
											@(posedge clk);
		button <= 0; 					@(posedge clk);
											@(posedge clk);
											@(posedge clk);
		button <= 1;					@(posedge clk);
											@(posedge clk);
		$stop;
	end
endmodule 