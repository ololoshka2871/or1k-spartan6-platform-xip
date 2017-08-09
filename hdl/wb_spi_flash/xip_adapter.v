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
) (
    input   wire                            rst_i,
    input   wire                            clk_i,

    // memory mapped flash interface 0
    input   wire    [23:0]                  mm0_addr_i,
    output  wire    [31:0]                  mm0_dat_o,
    input   wire    [31:0]                  mm0_dat_i,
    input   wire                            mm0_we,
    input   wire                            mm0_cyc_i,
    input   wire                            mm0_stb_i,
    output  wire                            mm0_ack_o,

    // memory mapped flash interface 1
    input   wire    [23:0]                  mm1_addr_i,
    output  wire    [31:0]                  mm1_dat_o,
    input   wire    [31:0]                  mm1_dat_i,
    input   wire                            mm1_we,
    input   wire                            mm1_cyc_i,
    input   wire                            mm1_stb_i,
    output  wire                            mm1_ack_o,

    // spi interface
    output  wire                            spi_mosi,
    input   wire                            spi_miso,
    output  wire                            spi_sck_o,
    output  wire                            spi_cs_o
);

// WARNING!!! Write not working!

//--------------------------------------------------------

reg     [23:0]      internal_addr;
reg                 spi_transaction;
reg     [7:0]       data_buf[3:0];
reg                 busy;
reg                 word_ack;

reg                 cs_cycle;
reg                 prev_mm_cyc;

///

parameter FLASH_OFFSET  = RAM_PROGRAMM_MEMORY_START - SPI_FLASH_PROGRAMM_START;

wire    [23:2]      flash_addr_corrected =
                        ((arbiter_state == 2'b01) ? mm0_addr_i[23:2] : mm1_addr_i[23:2])
                        - FLASH_OFFSET[23:2];

wire    [31:0]      flash_addr;

wire                spi_transaction_ack;
wire    [7:0]       spi_data;

wire    [31:0]      mm_dat_o = { data_buf[0], data_buf[1], data_buf[2], data_buf[3] };

wire    [1:0]       byte_n = internal_addr[1:0];


/// -------- arbiter --------

parameter   ARBITER_NO_SELECTION = 3'b000;
parameter   ARBITER_SEL0         = 3'b001;
parameter   ARBITER_SEL1         = 3'b010;
parameter   ARBITER_AWAIT_DESEL0 = 3'b101;
parameter   ARBITER_AWAIT_DESEL1 = 3'b110;
parameter   ARBITER_DESEL        = 3'b111;

reg     [2:0]       arbiter_state;
reg     [1:0]       strobes;
reg     [1:0]       continues;

///

wire    [1:0]       master_selected = arbiter_state[1:0];

wire    [1:0]       master_select = {mm1_cyc_i, mm0_cyc_i};

// output allways is same
assign  mm0_dat_o = mm_dat_o;
assign  mm1_dat_o = mm_dat_o;

// ack
assign mm0_ack_o = (arbiter_state == 2'b01) & word_ack;
assign mm1_ack_o = (arbiter_state == 2'b10) & word_ack;


always @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        arbiter_state <= ARBITER_NO_SELECTION;
        strobes <= 2'b00;
        continues <= 2'b00;

        busy <= 1'b0;
        spi_transaction <= 1'b0;
        internal_addr <= 0;
        word_ack <= 1'b0;
    end else begin
        strobes <= { mm1_stb_i, mm0_stb_i } | strobes;
        continues <= 2'b00;

        case (arbiter_state)
        ARBITER_NO_SELECTION: begin
            // select chanel, 0 have priority
            arbiter_state <= {1'b0, (master_select == 2'b11) ?
                                2'b01 : master_select};
        end

        ARBITER_SEL0: begin
            if (~mm0_cyc_i)
                arbiter_state <= ARBITER_DESEL;
            else begin
                if ((strobes[0] | continues[0])  & ~busy) begin
                    // start
                    busy <= 1'b1;
                    strobes[0] <= 1'b0;
                    if (strobes[0])
                        internal_addr <= {flash_addr_corrected, 2'b00};
                end
                if (word_ack)
                    arbiter_state <= ARBITER_AWAIT_DESEL0;
            end
        end

        ARBITER_SEL1: begin
            if (~mm1_cyc_i)
                arbiter_state <= ARBITER_DESEL;
            else begin
                if ((strobes[1] | continues[1]) & ~busy) begin
                    // start
                    busy <= 1'b1;
                    strobes[1] <= 1'b0;
                    if (strobes[1])
                        internal_addr <= {flash_addr_corrected, 2'b00};
                end
                if (word_ack)
                    arbiter_state <= ARBITER_AWAIT_DESEL1;
            end
        end

        ARBITER_AWAIT_DESEL0: begin
            if (~word_ack) begin
                arbiter_state <= mm0_cyc_i ? ARBITER_SEL0 : ARBITER_DESEL;
                continues[0] <= 1'b1;
            end
        end

        ARBITER_AWAIT_DESEL1: begin
            if (~word_ack) begin
                arbiter_state <= mm1_cyc_i ? ARBITER_SEL1 : ARBITER_DESEL;
                continues[1] <= 1'b1;
            end
        end

        ARBITER_DESEL: begin
            spi_transaction <= 1'b0;
            busy <= 1'b0;
            arbiter_state <= ARBITER_NO_SELECTION;
        end

        endcase

        word_ack <= 1'b0;
        if (busy) begin
            // continue
            spi_transaction <= 1'b1;
            if (spi_transaction_ack) begin
                data_buf[byte_n] <= spi_data;
                spi_transaction <= 1'b0;
                internal_addr <= internal_addr + 1;
                if (byte_n == 2'b11) begin
                    // end
                    busy <= 1'b0;
                    word_ack <= 1'b1;
                end
            end
        end
    end
end


/// ------- /arbiter --------

spi_flash_sys_init
#(
    .SYS_CLK_RATE(MASTER_CLK_FREQ_HZ * 1.0), // idle timeout -> min
    .FLASH_IDLE(1),
    .DECODE_BITS(1),
    .DEF_R_4(32'h0), // No initialisation
    .DEF_R_5(32'h00000001)  // Enable memory-mapped interface at startup
) controller (
    .sys_rst_n(~rst_i),
    .sys_clk(clk_i),
    .sys_clk_en(1'b1),

    .adr_i(4'h0),
    .sel_i(1'b0),
    .we_i(1'b0),
    .dat_i(32'h0),
    .dat_o(/* open */),
    .ack_o(/* open */),

    .fl_adr_i({8'b0, internal_addr}),
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
