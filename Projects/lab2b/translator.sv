module translator (UPC, leds0, leds1, leds2, leds3, leds4, leds5);

	input logic [2:0] UPC;
	
	output logic [6:0] leds0, leds1, leds2, leds3, leds4, leds5;
	
	logic [6:0] A, B, C, E, H, I, J, K, L, O, S, T, U, W;
	
	integer i;
	
	//assigning 7-bit values to letters
	assign A = 7'b1110111;
	assign B = 7'b1111100;
	assign C = 7'b0111001;
	assign E = 7'b1111001;
	assign H = 7'b1110110;
	assign I = 7'b0000110;
	assign J = 7'b0001101;
	assign K = 7'b1110101;
	assign L = 7'b0111000;
	assign O = 7'b0111111;
	assign S = 7'b1101101;
	assign T = 7'b1111000;
	assign U = 7'b0011100;
	assign W = 7'b1101010;
	assign off = 7'b0000000; // turns off the hex display
	
	/*
	 *Note that if the UPC is a 'don't care' such as 010 then
	 *the display will just show gibberish
	 */
	
	always_comb begin
	
		// Letter 1
		case (UPC)
			3'b000: leds5 = S;
			3'b001: leds5 = J;
			3'b011: leds5 = B;
			3'b100: leds5 = S;
			3'b101: leds5 = C;
			3'b110: leds5 = S;
			default: leds5 = 7'bX;
		endcase
		
		// Letter 2
		case (UPC)
			3'b000: leds4 = H;
			3'b001: leds4 = E;
			3'b011: leds4 = I;
			3'b100: leds4 = U;
			3'b101: leds4 = O;
			3'b110: leds4 = O;
			default: leds4 = 7'bX;
		endcase
		
		// Letter 3
		case (UPC)
			3'b000: leds3 = O;
			3'b001: leds3 = W;
			3'b011: leds3 = K;
			3'b100: leds3 = I;
			3'b101: leds3 = A;
			3'b110: leds3 = C;
			default: leds3 = 7'bX;
		endcase
		
		// Letter 4
		case (UPC)
			3'b000: leds2 = E;
			3'b001: leds2 = E;
			3'b011: leds2 = E;
			3'b100: leds2 = T;
			3'b101: leds2 = T;
			3'b110: leds2 = K;
			default: leds2 = 7'bX;
		endcase
		
		// Letter 5
		case (UPC)
			3'b000: leds1 = S;
			3'b001: leds1 = L;
			3'b011: leds1 = off;
			3'b100: leds1 = off;
			3'b101: leds1 = off;
			3'b110: leds1 = S;
			default: leds1 = 7'bX;
		endcase
		
		// Letter 6
		case (UPC)
			3'b000: leds0 = off;
			3'b001: leds0 = S;
			3'b011: leds0 = off;
			3'b100: leds0 = off;
			3'b101: leds0 = off;
			3'b110: leds0 = off;
			default: leds0 = 7'bX;
		endcase
		
		//inverts all outputs
		for (i=0; i<= 6; i++) begin
			leds0[i] = ~leds0[i];
			leds1[i] = ~leds1[i];
			leds2[i] = ~leds2[i];
			leds3[i] = ~leds3[i];
			leds4[i] = ~leds4[i];
			leds5[i] = ~leds5[i];
		end // for loop
		
	end // always_comb
	
endmodule 