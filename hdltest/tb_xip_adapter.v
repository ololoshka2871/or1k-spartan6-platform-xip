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

`include "bench_cfg.vh"

`ifdef CLOCK_USE_PLL
parameter CLK_HZ = `DEVICE_REF_CLOCK_HZ * `CLOCK_CPU_PLL_MULTIPLYER / `CLOCK_CPU_CLOCK_DEVIDER * 1.0;
`else
parameter CLK_HZ = `DEVICE_REF_CLOCK_HZ * 1.0;
`endif

module tb_xip_adapter;

    reg     [31:0]  addr;
    wire    [31:0]  data;
    wire            ack;
    reg             fetch_r;

    reg             clk;
    reg             reset;

    wire            spi_mosi, spi_miso, spi_cs, spi_sck;

xip_adapter
#(
    .MASTER_CLK_FREQ_HZ(CLK_HZ),
    .RAM_PROGRAMM_MEMORY_START(0),
    .SPI_FLASH_PROGRAMM_START(0)
) adapter (
    .rst_i(reset),
    .clk_i(clk),

    .mm_addr_i(addr),
    .mm_dat_o(data),
    .mm_cyc_i(fetch_r),
    .mm_ack_o(ack),

    .cs_adr_i(4'h0),
    .cs_sel_i(1'b0),
    .cs_we_i(1'b0),
    .cs_dat_i(32'h0),
    .cs_dat_o(/* open */),
    .cs_ack_o(/* open */),

    .spi_mosi(spi_mosi),
    .spi_miso(spi_miso),
    .spi_sck_o(spi_sck),
    .spi_cs_o(spi_cs)
);

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

initial begin
    clk = 0;
    reset = 1;
    fetch_r = 0;

    #20

    reset = 0;

    #31

    addr = 32'h192a3b4c;
    fetch_r = 1;

    /*
    #1860
    addr = 32'h1a2b3c4e;
    fetch_r = 0;
    #20
    fetch_r = 1;
    */
end


always #10 clk <= !clk;

always @(posedge clk) begin
    if (ack)
        addr <= addr + 4;
end

endmodule
