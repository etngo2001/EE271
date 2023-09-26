//Eugene Ngo
//1965514
//EE 271 Autumn 2022


module fullAdder4 (A, B, cin, sum, cout);

	input logic [3:0] A, B; //Declares input variables A and B with 4 bits
	input logic cin; //Declares Cin as an input
	
	output logic [3:0] 	sum; //Declares output logic sum with 4 bits
	output logic cout; //Declares cout as an output
	
	//c0, c1, c2 are just logics to hold the outputs of each fulladder which will then be inputted into the next fulladder
	logic c0;
	logic c1;
	logic c2;
	
	//Initializes the first FullAdder
	fullAdder FA0 (.A(A[0]), .B(B[0]), .cin(cin), .sum(sum[0]), .cout(c0)); 
	//Initializes the second FullAdder which takes the output of the first FA as an input
	fullAdder FA1 (.A(A[1]), .B(B[1]), .cin(c0), .sum(sum[1]), .cout(c1));
	//Initializes the third FullAdder which takes the output of the second FA as an input
	fullAdder FA2 (.A(A[2]), .B(B[2]), .cin(c1), .sum(sum[2]), .cout(c2));	
	//Initializes the fourth FullAdder which takes the output of the third FA as an input
	fullAdder FA3 (.A(A[3]), .B(B[3]), .cin(c2), .sum(sum[3]), .cout(cout)); 
	
endmodule 

module fullAdder4_testbench();
	
		logic [3:0] A, B, sum;
		logic cin, cout;
		
		fullAdder dut (.A(A), .B(B), .cin(cin), .sum(sum), .cout(cout));
		
		integer i;
		initial begin
			
			//loops through all possible combinations of bits from 000000000 to 111111111
			for(i=0; i<2**9; i++) begin
				{A, B, cin} = i; #10;
			end //for loop
		
		end //intial

		
endmodule 