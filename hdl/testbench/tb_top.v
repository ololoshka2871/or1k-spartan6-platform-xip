`include "../timescale.v"

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:16:19 04/10/2016
// Design Name:   top
// Module Name:   /home/shiloxyz/src/Xilinx/or32_boot/tb/tb_top.v
// Project Name:  or32_boot
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_top;

	// Inputs
	reg clk;
	reg rx;
	
	// Outputs
	wire tx;
	
	wire[3:0] leds_io;
	
	reg rst = 1'b1;

	// Bidirs

	// Instantiate the Unit Under Test (UUT)
	top uut (
		.clk(clk), 
		.rx(rx), 
		.tx(tx),
		.leds_io(leds_io),
		.rst_i(rst)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rx = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
	
	always #10 clk <= !clk;
      
endmodule

