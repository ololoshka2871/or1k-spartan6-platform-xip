/*

Copyright (c) 2015-2016 Alex Forencich

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

// Language: Verilog 2001

`include "timescale.v"

/*
 * Wishbone dual port RAM
 */
module wb_dp_ram2 #
(
	 parameter IMAGE_FILE = "",					 // filename to init ram
    parameter DATA_WIDTH = 32,                // width of data bus in bits (8, 16, 32, or 64)
    parameter ADDR_WIDTH = 32,                // width of address bus in bits
    parameter SELECT_WIDTH = (DATA_WIDTH/8)   // width of word select bus (1, 2, 4, or 8)
)
(
    // port A
    input  wire                    a_clk,
    input  wire [ADDR_WIDTH-1:0]   a_adr_i,   // ADR_I() address
    input  wire [DATA_WIDTH-1:0]   a_dat_i,   // DAT_I() data in
    output wire [DATA_WIDTH-1:0]   a_dat_o,   // DAT_O() data out
    input  wire                    a_we_i,    // WE_I write enable input
    input  wire [SELECT_WIDTH-1:0] a_sel_i,   // SEL_I() select input
    input  wire                    a_stb_i,   // STB_I strobe input
    output wire                    a_ack_o,   // ACK_O acknowledge output
    input  wire                    a_cyc_i,   // CYC_I cycle input

    // port B
    input  wire                    b_clk,
    input  wire [ADDR_WIDTH-1:0]   b_adr_i,   // ADR_I() address
    input  wire [DATA_WIDTH-1:0]   b_dat_i,   // DAT_I() data in
    output wire [DATA_WIDTH-1:0]   b_dat_o,   // DAT_O() data out
    input  wire                    b_we_i,    // WE_I write enable input
    input  wire [SELECT_WIDTH-1:0] b_sel_i,   // SEL_I() select input
    input  wire                    b_stb_i,   // STB_I strobe input
    output wire                    b_ack_o,   // ACK_O acknowledge output
    input  wire                    b_cyc_i    // CYC_I cycle input
);

// for interfaces that are more than one word wide, disable address lines
parameter VALID_ADDR_WIDTH = ADDR_WIDTH - $clog2(SELECT_WIDTH);
// width of data port in words (1, 2, 4, or 8)
parameter WORD_WIDTH = SELECT_WIDTH;
// size of words (8, 16, 32, or 64 bits)
parameter WORD_SIZE = DATA_WIDTH/WORD_WIDTH;

reg [DATA_WIDTH-1:0] a_dat_o_reg = {DATA_WIDTH{1'b0}};
reg a_ack_o_reg = 1'b0;

reg [DATA_WIDTH-1:0] b_dat_o_reg = {DATA_WIDTH{1'b0}};
reg b_ack_o_reg = 1'b0;

// (* RAM_STYLE="BLOCK" *)
reg [DATA_WIDTH-1:0] mem[(2**VALID_ADDR_WIDTH)-1:0];

wire [VALID_ADDR_WIDTH-1:0] a_adr_i_valid = a_adr_i >> (ADDR_WIDTH - VALID_ADDR_WIDTH);
wire [VALID_ADDR_WIDTH-1:0] b_adr_i_valid = b_adr_i >> (ADDR_WIDTH - VALID_ADDR_WIDTH);

assign a_dat_o = a_dat_o_reg;
assign a_ack_o = a_ack_o_reg;

assign b_dat_o = b_dat_o_reg;
assign b_ack_o = b_ack_o_reg;

integer i;

generate
    if(IMAGE_FILE != "")
		initial begin
			 $readmemh(IMAGE_FILE, mem);	
		end
endgenerate

// port A
always @(posedge a_clk) begin
	if (a_cyc_i & a_stb_i) begin
		if (a_we_i) begin // write?
			if (a_sel_i[0]) begin
				mem[a_adr_i_valid][7:0] <= a_dat_i[7:0];
			end
			if (a_sel_i[1]) begin
				mem[a_adr_i_valid][15:8] <= a_dat_i[15:8];
			end
			if (a_sel_i[2]) begin
				mem[a_adr_i_valid][23:16] <= a_dat_i[23:16];
			end
			if (a_sel_i[3]) begin
				mem[a_adr_i_valid][31:24] <= a_dat_i[31:24];
			end
			a_dat_o_reg <= {DATA_WIDTH{1'b0}};
		end
		else
		begin
			//read
			a_dat_o_reg <= mem[a_adr_i_valid];
		end
		a_ack_o_reg <= 1'b1;
	end
	else
	begin
		a_ack_o_reg <= 1'b0;
	end
end

// port B
always @(posedge b_clk) begin
    if (b_cyc_i & b_stb_i) begin
		if (b_we_i) begin // write?
			if (b_sel_i[0]) begin
				mem[b_adr_i_valid][7:0] <= b_dat_i[7:0];
			end
			if (b_sel_i[1]) begin
				mem[b_adr_i_valid][15:8] <= b_dat_i[15:8];
			end
			if (b_sel_i[2]) begin
				mem[b_adr_i_valid][23:16] <= b_dat_i[23:16];
			end
			if (b_sel_i[3]) begin
				mem[b_adr_i_valid][31:24] <= b_dat_i[31:24];
			end
			b_dat_o_reg <= {DATA_WIDTH{1'b0}};
		end
		else
		begin
			//read
			b_dat_o_reg <= mem[b_adr_i_valid];
		end
		b_ack_o_reg <= 1'b1;
	end
	else
	begin
		b_ack_o_reg <= 1'b0;
	end
end

endmodule
