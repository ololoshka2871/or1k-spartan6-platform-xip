`include "../timescale.v"
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

`include "config.v"
`include "bench_cfg.vh"

`ifdef CLOCK_USE_PLL
parameter CLK_HZ = `DEVICE_REF_CLOCK_HZ * `CLOCK_CPU_PLL_MULTIPLYER / `CLOCK_CPU_CLOCK_DEVIDER * 1.0;
`else
parameter CLK_HZ = `DEVICE_REF_CLOCK_HZ * 1.0;
`endif

module tb_wb_spi_flash;

    reg     [31:0]  addr;
    wire    [7:0]   data;
    wire            ack;
    wire    [31:0]  resp_addr;

    reg             clk;
    reg             reset;
    reg             fetch_r;

    wire            spi_mosi, spi_miso;


spi_flash_simulator
#(
    .SYS_CLK_RATE(CLK_HZ),
    .FLASH_ADR_BITS(8),
    .FLASH_INIT(`SPI_FLASH_SIM_DATA_FILE)
) spi_flash_0 (
    .sys_rst_n(~reset),
    .sys_clk(clk),
    .sys_clk_en(1'b1),

    .spi_cs_i(spi_cs),
    .spi_sck_i(spi_sck),
    .spi_si_i(spi_mosi),
    .spi_so_o(spi_miso)
);

spi_flash_sys_init
#(
    .SYS_CLK_RATE(CLK_HZ),
    .FLASH_IDLE(2),
    .DECODE_BITS(1),
    .DEF_R_4(32'h0), // No initialisation
    .DEF_R_5(32'h00000001)  // Enable memory-mapped interface at startup
) controller (
    .sys_rst_n(~reset),
    .sys_clk(clk),
    .sys_clk_en(1'b1),

    .adr_i(4'b0),
    .sel_i(1'b0),
    .we_i(1'b0),
    .dat_i(32'b0),
    .dat_o(/* open */),
    .ack_o(/* open */),

    .fl_adr_i(addr),
    .fl_sel_i(fetch_r),
    .fl_we_i(1'b0),
    .fl_dat_i(8'b0),
    .fl_dat_o(data),
    .fl_ack_o(ack),

    .init_adr_o(/* open */),
    .init_dat_o(/* open */),
    .init_cyc_o(/* open */),
    .init_ack_i(/* open */),
    .init_fin_o(/* open */),

    .spi_adr_o(/* open */),
    .spi_cs_o(spi_cs),
    .spi_sck_o(spi_sck),
    .spi_so_o(spi_mosi),
    .spi_si_i(spi_miso)
);

initial begin
    clk = 0;
    reset = 1;
    fetch_r = 0;

    #20

    reset = 0;

    #31

    addr = 32'h1a2b3c4d;
    fetch_r = 1;
end


always #10 clk <= !clk;

always @(posedge clk) begin
    //if (fetch_r)
    //    fetch_r <= 0;
end

endmodule
