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

module flash_sim_memory
#(
    parameter INIT_FILE                     = "NONE",
    parameter ADR_WIDTH                     = 8,
    parameter DAT_WIDTH                     = 8
) (
    input   wire                            clk,
    input   wire    [ADR_WIDTH-1:0]         adr_i,
    input   wire                            we_i,
    input   wire    [DAT_WIDTH-1:0]         dat_i,
    output  reg     [DAT_WIDTH-1:0]         dat_o
);

parameter MEM_CELLS_COUNT   = 2 ** ADR_WIDTH;

reg [DAT_WIDTH-1:0] memory[MEM_CELLS_COUNT-1:0];

always @(posedge clk) begin
    if (we_i) begin
        memory[adr_i] <= dat_i;
        dat_o <= dat_i;
    end else
        dat_o <= memory[adr_i];
end

initial begin
    if (INIT_FILE != "NONE")
        $readmemh(INIT_FILE, memory);
end

endmodule
