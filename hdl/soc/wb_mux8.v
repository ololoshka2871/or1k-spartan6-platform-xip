//****************************************************************************
//*
//*   Copyright (C) 2016 Shilo_XyZ_. All rights reserved.
//*   Author:  Shilo_XyZ_ <Shilo_XyZ_<at>mail.ru>
//*
//* Redistribution and use in source and binary forms, with or without
//* modification, are permitted provided that the following conditions
//* are met:
//*
//* 1. Redistributions of source code must retain the above copyright
//*    notice, this list of conditions and the following disclaimer.
//* 2. Redistributions in binary form must reproduce the above copyright
//*    notice, this list of conditions and the following disclaimer in
//*    the documentation and/or other materials provided with the
//*    distribution.
//*
//* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
//* "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
//* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
//* FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
//* COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
//* INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
//* BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
//* OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
//* AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
//* LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
//* ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//* POSSIBILITY OF SUCH DAMAGE.
//*
//*
//****************************************************************************/

module wb_mux8
#(
    parameter OUT_ADDR_WIDTH = 8
) (
    // Outputs
    output [OUT_ADDR_WIDTH-1:0]         out0_addr_o,
    output [31:0]                       out0_data_o,
    input [31:0]                        out0_data_i,
    output reg [3:0]                    out0_sel_o,
    output reg                          out0_we_o,
    output reg                          out0_stb_o,
    output reg                          out0_cyc_o,
    input                               out0_ack_i,
    input                               out0_stall_i,

    output [OUT_ADDR_WIDTH-1:0]         out1_addr_o,
    output [31:0]                       out1_data_o,
    input [31:0]                        out1_data_i,
    output reg [3:0]                    out1_sel_o,
    output reg                          out1_we_o,
    output reg                          out1_stb_o,
    output reg                          out1_cyc_o,
    input                               out1_ack_i,
    input                               out1_stall_i,

    output [OUT_ADDR_WIDTH-1:0]         out2_addr_o,
    output [31:0]                       out2_data_o,
    input [31:0]                        out2_data_i,
    output reg [3:0]                    out2_sel_o,
    output reg                          out2_we_o,
    output reg                          out2_stb_o,
    output reg                          out2_cyc_o,
    input                               out2_ack_i,
    input                               out2_stall_i,

    output [OUT_ADDR_WIDTH-1:0]         out3_addr_o,
    output [31:0]                       out3_data_o,
    input [31:0]                        out3_data_i,
    output reg [3:0]                    out3_sel_o,
    output reg                          out3_we_o,
    output reg                          out3_stb_o,
    output reg                          out3_cyc_o,
    input                               out3_ack_i,
    input                               out3_stall_i,

    output [OUT_ADDR_WIDTH-1:0]         out4_addr_o,
    output [31:0]                       out4_data_o,
    input [31:0]                        out4_data_i,
    output reg [3:0]                    out4_sel_o,
    output reg                          out4_we_o,
    output reg                          out4_stb_o,
    output reg                          out4_cyc_o,
    input                               out4_ack_i,
    input                               out4_stall_i,

    output [OUT_ADDR_WIDTH-1:0]         out5_addr_o,
    output [31:0]                       out5_data_o,
    input [31:0]                        out5_data_i,
    output reg [3:0]                    out5_sel_o,
    output reg                          out5_we_o,
    output reg                          out5_stb_o,
    output reg                          out5_cyc_o,
    input                               out5_ack_i,
    input                               out5_stall_i,

    output [OUT_ADDR_WIDTH-1:0]         out6_addr_o,
    output  [31:0]                      out6_data_o,
    input [31:0]                        out6_data_i,
    output reg [3:0]                    out6_sel_o,
    output reg                          out6_we_o,
    output reg                          out6_stb_o,
    output reg                          out6_cyc_o,
    input                               out6_ack_i,
    input                               out6_stall_i,

    output [OUT_ADDR_WIDTH-1:0]         out7_addr_o,
    output [31:0]                       out7_data_o,
    input [31:0]                        out7_data_i,
    output reg [3:0]                    out7_sel_o,
    output reg                          out7_we_o,
    output reg                          out7_stb_o,
    output reg                          out7_cyc_o,
    input                               out7_ack_i,
    input                               out7_stall_i,

    // Input
    input [OUT_ADDR_WIDTH + 3 - 1:0]    mem_addr_i,
    input [31:0]                        mem_data_i,
    output reg[31:0]                    mem_data_o,
    input [3:0]                         mem_sel_i,
    input                               mem_we_i,
    input                               mem_stb_i,
    input                               mem_cyc_i,
    output reg                          mem_ack_o,
    output reg                          mem_stall_o
);

parameter SLAVE_ADDR_BITS = OUT_ADDR_WIDTH - 2; // force [1:0] == 2'b0

///

assign out0_addr_o = {mem_addr_i[OUT_ADDR_WIDTH-1:2], 2'b00};
assign out1_addr_o = {mem_addr_i[OUT_ADDR_WIDTH-1:2], 2'b00};
assign out2_addr_o = {mem_addr_i[OUT_ADDR_WIDTH-1:2], 2'b00};
assign out3_addr_o = {mem_addr_i[OUT_ADDR_WIDTH-1:2], 2'b00};
assign out4_addr_o = {mem_addr_i[OUT_ADDR_WIDTH-1:2], 2'b00};
assign out5_addr_o = {mem_addr_i[OUT_ADDR_WIDTH-1:2], 2'b00};
assign out6_addr_o = {mem_addr_i[OUT_ADDR_WIDTH-1:2], 2'b00};
assign out7_addr_o = {mem_addr_i[OUT_ADDR_WIDTH-1:2], 2'b00};

assign out0_data_o = mem_data_i;
assign out1_data_o = mem_data_i;
assign out2_data_o = mem_data_i;
assign out3_data_o = mem_data_i;
assign out4_data_o = mem_data_i;
assign out5_data_o = mem_data_i;
assign out6_data_o = mem_data_i;
assign out7_data_o = mem_data_i;

//-----------------------------------------------------------------
// Request
//-----------------------------------------------------------------
always @ *
begin

    out0_sel_o       = 4'b0000;
    out0_we_o        = 1'b0;
    out0_stb_o       = 1'b0;
    out0_cyc_o       = 1'b0;

    out1_sel_o       = 4'b0000;
    out1_we_o        = 1'b0;
    out1_stb_o       = 1'b0;
    out1_cyc_o       = 1'b0;

    out2_sel_o       = 4'b0000;
    out2_we_o        = 1'b0;
    out2_stb_o       = 1'b0;
    out2_cyc_o       = 1'b0;

    out3_sel_o       = 4'b0000;
    out3_we_o        = 1'b0;
    out3_stb_o       = 1'b0;
    out3_cyc_o       = 1'b0;

    out4_sel_o       = 4'b0000;
    out4_we_o        = 1'b0;
    out4_stb_o       = 1'b0;
    out4_cyc_o       = 1'b0;

    out5_sel_o       = 4'b0000;
    out5_we_o        = 1'b0;
    out5_stb_o       = 1'b0;
    out5_cyc_o       = 1'b0;

    out6_sel_o       = 4'b0000;
    out6_we_o        = 1'b0;
    out6_stb_o       = 1'b0;
    out6_cyc_o       = 1'b0;

    out7_sel_o       = 4'b0000;
    out7_we_o        = 1'b0;
    out7_stb_o       = 1'b0;
    out7_cyc_o       = 1'b0;

   case (mem_addr_i[OUT_ADDR_WIDTH+3-1:OUT_ADDR_WIDTH])

   2'd0:
   begin
       out0_sel_o       = mem_sel_i;
       out0_we_o        = mem_we_i;
       out0_stb_o       = mem_stb_i;
       out0_cyc_o       = mem_cyc_i;
   end
   2'd1:
   begin
       out1_sel_o       = mem_sel_i;
       out1_we_o        = mem_we_i;
       out1_stb_o       = mem_stb_i;
       out1_cyc_o       = mem_cyc_i;
   end
   2'd2:
   begin
       out2_sel_o       = mem_sel_i;
       out2_we_o        = mem_we_i;
       out2_stb_o       = mem_stb_i;
       out2_cyc_o       = mem_cyc_i;
   end
   3'd3:
   begin
       out3_sel_o       = mem_sel_i;
       out3_we_o        = mem_we_i;
       out3_stb_o       = mem_stb_i;
       out3_cyc_o       = mem_cyc_i;
   end
   2'd4:
   begin
       out4_sel_o       = mem_sel_i;
       out4_we_o        = mem_we_i;
       out4_stb_o       = mem_stb_i;
       out4_cyc_o       = mem_cyc_i;
   end
   2'd5:
   begin
       out5_sel_o       = mem_sel_i;
       out5_we_o        = mem_we_i;
       out5_stb_o       = mem_stb_i;
       out5_cyc_o       = mem_cyc_i;
   end
   2'd6:
   begin
       out6_sel_o       = mem_sel_i;
       out6_we_o        = mem_we_i;
       out6_stb_o       = mem_stb_i;
       out6_cyc_o       = mem_cyc_i;
   end
   3'd7:
   begin
       out7_sel_o       = mem_sel_i;
       out7_we_o        = mem_we_i;
       out7_stb_o       = mem_stb_i;
       out7_cyc_o       = mem_cyc_i;
   end
   endcase
end

//-----------------------------------------------------------------
// Response
//-----------------------------------------------------------------
always @ *
begin
   case (mem_addr_i[OUT_ADDR_WIDTH+3-1:OUT_ADDR_WIDTH])

    2'd0:
    begin
       mem_data_o   = out0_data_i;
       mem_stall_o  = out0_stall_i;
       mem_ack_o    = out0_ack_i;
    end
    2'd1:
    begin
       mem_data_o   = out1_data_i;
       mem_stall_o  = out1_stall_i;
       mem_ack_o    = out1_ack_i;
    end
    2'd2:
    begin
       mem_data_o   = out2_data_i;
       mem_stall_o  = out2_stall_i;
       mem_ack_o    = out2_ack_i;
    end
    2'd3:
    begin
       mem_data_o   = out3_data_i;
       mem_stall_o  = out3_stall_i;
       mem_ack_o    = out3_ack_i;
    end
    2'd4:
    begin
       mem_data_o   = out4_data_i;
       mem_stall_o  = out4_stall_i;
       mem_ack_o    = out4_ack_i;
    end
    2'd5:
    begin
       mem_data_o   = out5_data_i;
       mem_stall_o  = out5_stall_i;
       mem_ack_o    = out5_ack_i;
    end
    2'd6:
    begin
       mem_data_o   = out6_data_i;
       mem_stall_o  = out6_stall_i;
       mem_ack_o    = out6_ack_i;
    end
    2'd7:
    begin
       mem_data_o   = out7_data_i;
       mem_stall_o  = out7_stall_i;
       mem_ack_o    = out7_ack_i;
    end
   endcase
end

endmodule
