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

// 2 Masters, one slave
module wb_arbiter_2m1s
#(
    parameter WB_DAT_WIDTH = 32,
    parameter WB_ADR_WIDTH = 32
) (
    // WB Master one
    input [WB_ADR_WIDTH-1:0]    wbm0_adr_i,
    input [WB_DAT_WIDTH-1:0]    wbm0_dat_i,
    input [3:0]                 wbm0_sel_i,
    input                       wbm0_we_i,
    input                       wbm0_cyc_i,
    input                       wbm0_stb_i,
    output[WB_DAT_WIDTH-1:0]    wbm0_dat_o,
    output                      wbm0_ack_o,

    input [WB_ADR_WIDTH-1:0]    wbm1_adr_i,
    input [WB_DAT_WIDTH-1:0]    wbm1_dat_i,
    input [3:0]                 wbm1_sel_i,
    input                       wbm1_we_i,
    input                       wbm1_cyc_i,
    input                       wbm1_stb_i,
    output[WB_DAT_WIDTH-1:0]    wbm1_dat_o,
    output                      wbm1_ack_o,


    // Wishbone Slave interface
    output [WB_ADR_WIDTH-1:0]   wbs0_adr_o,
    output [WB_DAT_WIDTH-1:0]   wbs0_dat_o,
    output [3:0]                wbs0_sel_o,
    output                      wbs0_we_o,
    output                      wbs0_cyc_o,
    output                      wbs0_stb_o,
    input  [WB_DAT_WIDTH-1:0]   wbs0_dat_i,
    input                       wbs0_ack_i
);
   
   // Master select
   wire [1:0] 		     master_sel;
   // priority to wbm0
   assign master_sel[0] = wbm0_cyc_i;
   assign master_sel[1] = wbm1_cyc_i & !wbm0_cyc_i;

   //----------------------------------------------------

   // Master input mux, priority to debug master
   assign wbs0_adr_o = master_sel[1] ? wbm1_adr_i : wbm0_adr_i;
   assign wbs0_dat_o = master_sel[1] ? wbm1_dat_i : wbm0_dat_i;
   assign wbs0_sel_o = master_sel[1] ? wbm1_sel_i : wbm0_sel_i;
   assign wbs0_we_o  = master_sel[1] ? wbm1_we_i  : wbm0_we_i;
   assign wbs0_cyc_o = master_sel[1] ? wbm1_cyc_i : wbm0_cyc_i;
   assign wbs0_stb_o = master_sel[1] ? wbm1_stb_i : wbm0_stb_i;

   //----------------------------------------------------

   assign wbm0_dat_o = wbs0_dat_i;
   assign wbm0_ack_o = wbs0_ack_i & master_sel[0];
   
   assign wbm1_dat_o = wbs0_dat_i;
   assign wbm1_ack_o = wbs0_ack_i & master_sel[1];

endmodule
