module seg7user (bcd, leds);

	input logic [3:0] bcd;
	
	output logic [6:0] leds;

	seg7 display1 (.bcd(bcd), .leds(leds));
	
endmodule 