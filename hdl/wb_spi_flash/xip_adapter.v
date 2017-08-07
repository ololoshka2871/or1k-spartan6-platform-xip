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
//****************************************************************************/

module xip_adapter
#(
    parameter MASTER_CLK_FREQ_HZ            = 50000000,
    // need alignment X & 2'b11 == 2'b00
    parameter RAM_PROGRAMM_MEMORY_START         = 32'h0,
    parameter SPI_FLASH_PROGRAMM_START          = 32'h0
)
(
    input   wire                            rst_i,
    input   wire                            clk_i,

    // memory mapped flash interface
    input   wire    [23:0]                  mm_addr_i,
    output  wire    [31:0]                  mm_dat_o,
    output  wire    [31:0]                  mm_dat_i,
    input   wire                            mm_we,
    input   wire                            mm_cyc_i,
    output  reg                             mm_ack_o,

    // classic spi module interface
    input   wire    [5:0]                   cs_adr_i,
    input   wire                            cs_stb_i,
    input   wire                            cs_we_i,
    input   wire    [31:0]                  cs_dat_i,
    output  wire    [31:0]                  cs_dat_o,
    output  wire                            cs_ack_o,

    // spi interface
    output  wire                            spi_mosi,
    input   wire                            spi_miso,
    output  wire                            spi_sck_o,
    output  wire                            spi_cs_o
);

// WARNING!!! Write not working!

///

reg     [1:0]       byte_n;
reg                 spi_transaction;
reg     [7:0]       data_buf[3:0];
reg                 busy;

reg                 cs_cycle;

///

parameter FLASH_OFFSET  = RAM_PROGRAMM_MEMORY_START - SPI_FLASH_PROGRAMM_START;

wire    [31:0]      flash_addr         = { 8'h0, { mm_addr_i[23:2] - FLASH_OFFSET[23:2], byte_n }};

wire                spi_transaction_ack;
wire    [7:0]       spi_data;

assign mm_dat_o = { data_buf[0], data_buf[1], data_buf[2], data_buf[3] };

///

always @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        busy <= 1'b0;
        spi_transaction <= 1'b0;
        byte_n <= 2'b0;
        mm_ack_o <= 1'b0;
    end else begin
        mm_ack_o <= 1'b0;
        if (busy) begin
            if (~mm_cyc_i) begin
                // termination
                spi_transaction <= 1'b0;
                busy <= 1'b0;
            end else begin
                // continue
                spi_transaction <= 1'b1;
                if (spi_transaction_ack) begin
                    data_buf[byte_n] <= spi_data;
                    spi_transaction <= 1'b0;
                    byte_n <= byte_n + 1;
                    if (byte_n == 2'b11) begin
                        // end
                        busy <= 1'b0;
                        mm_ack_o <= 1'b1;
                    end
                end
            end
        end else if (mm_cyc_i & ~mm_ack_o) begin
            // start
            busy <= 1'b1;
            spi_transaction <= 1'b1;
        end
    end
end

// sell-ack for classic spi module interface
always @(posedge clk_i or posedge rst_i) begin
    if (rst_i)
        cs_cycle <= 1'b0;
    else begin
        if (cs_stb_i & ~cs_cycle)
            cs_cycle <= 1'b1;
        else if (cs_ack_o)
            cs_cycle <= 1'b0;
    end
end

///

spi_flash_sys_init
#(
    .SYS_CLK_RATE(MASTER_CLK_FREQ_HZ / 400.0), // idle timeout -> min
    .FLASH_IDLE(1),
    .DECODE_BITS(1),
    .DEF_R_4(32'h0), // No initialisation
    .DEF_R_5(32'h00000001)  // Enable memory-mapped interface at startup
) controller (
    .sys_rst_n(~rst_i),
    .sys_clk(clk_i),
    .sys_clk_en(1'b1),

    .adr_i(cs_adr_i[5:2]),
    .sel_i(cs_cycle),
    .we_i(cs_we_i),
    .dat_i(cs_dat_i),
    .dat_o(cs_dat_o),
    .ack_o(cs_ack_o),

    .fl_adr_i(flash_addr),
    .fl_sel_i(spi_transaction),
    .fl_we_i(1'b0),
    .fl_dat_i(8'b0),
    .fl_dat_o(spi_data),
    .fl_ack_o(spi_transaction_ack),

    .init_adr_o(/* open */),
    .init_dat_o(/* open */),
    .init_cyc_o(/* open */),
    .init_ack_i(1'b0),
    .init_fin_o(/* open */),

    .spi_adr_o(/* open */),
    .spi_cs_o(spi_cs_o),
    .spi_sck_o(spi_sck_o),
    .spi_so_o(spi_mosi),
    .spi_si_i(spi_miso)
);

endmodule
