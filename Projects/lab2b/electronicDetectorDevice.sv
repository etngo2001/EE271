module electronicDetectorDevice (U, P, C, M, discount, stolen);   

	input logic U, P, C, M;
	output logic discount, stolen;

	// Logic to determine if LED for discount and LED for stolen should be on
 
	assign discount = P | (U & C);
	assign stolen = (U & ~P & ~M) | (~U & ~C & ~M);
 
endmodule  
 
module electronicDetectorDevice_testbench();  
	
	logic U, P, C, M, discount, stolen;
  
	electronicDetectorDevice dut (U, P, C, M, discount, stolen);  
  
	// Try all combinations of inputs.  
	integer i;   
	initial begin
 
	for(i = 0; i < 2**4; i++) begin  
		{U, P, C, M} = i; #10;  
	end //for loop
	
 end //initial
 
endmodule  