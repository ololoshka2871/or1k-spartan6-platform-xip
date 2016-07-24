/****************************************************************************
 * boot_spi.c
 *
 *   Copyright (C) 2016 Shilo_XyZ_. All rights reserved.
 *   Author:  Shilo_XyZ_ <Shilo_XyZ_<at>mail.ru>
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 * 3. Neither the name NuttX nor the names of its contributors may be
 *    used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
 * ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 ****************************************************************************/

#include "boot_spi.h"

#define  JEDEC_ID_COMMAND        0x9f
#define  DATA_READ_COMMAND       0x03
#define  DATA_READ_FAST_COMMAND  0x0B

static void GDB_STUB_SECTION_TEXT wait_transmitted() {
    volatile uint8_t t;
    volatile union SPSR_bits* pSpsr = (volatile union SPSR_bits*)&BOOT_SPI_SPSR;
    while (pSpsr->WFEMPTY); // wait for prew data transmitted
    while (!pSpsr->RFEMPTY) {
        t = BOOT_SPI_SPDR;
        t++;
    }
}

void GDB_STUB_SECTION_TEXT boot_spi_init(enum enSPIClockDevider clockDevider,
                                         enum enSPIMode mode) {
    union SPER_bits sper;
    sper.ESPR = clockDevider >> 2;
    sper.ICNT = 0;

    union SPCR_bits spcr;
    spcr.SPR = clockDevider & 0b11;
    spcr.CPHA = mode & 1;
    spcr.CPOL = mode >> 1;
    spcr.MSTR = 1;
    spcr.SPE = 1;
    spcr.SPIE = 0;

    union SPSR_bits spsr;
    spsr.SPIF = 1; // clear intrrrupt flag
    spsr.WCOL = 1; // clear collision flag

    BOOT_SPI_SPER = sper.ESPR;
    BOOT_SPI_SPSR = spsr.SPSR;
    BOOT_SPI_SPCR = spcr.SPCR;

    BOOT_SPI_CS_SEL = 0;

    wait_transmitted();
}

void GDB_STUB_SECTION_TEXT boot_spi_disable() {
    union SPCR_bits* spcr = (union SPCR_bits*)&BOOT_SPI_SPCR;
    spcr->SPE = 0;
}

enum enSpiErr GDB_STUB_SECTION_TEXT boot_spi_read(uint8_t* dest) {
    volatile union SPSR_bits* pSpsr = (volatile union SPSR_bits*)&BOOT_SPI_SPSR;
    if (pSpsr->RFEMPTY)
        return SPI_NO_DATA_AVALABLE;
    else {
        *dest = BOOT_SPI_SPDR;
        return SPI_OK;
    }
}

enum enSpiErr GDB_STUB_SECTION_TEXT boot_spi_write(uint8_t byte_to_transmitt) {
    volatile union SPSR_bits* pSpsr = (volatile union SPSR_bits*)&BOOT_SPI_SPSR;
    if (pSpsr->WFFULL)
        return SPI_FIFO_FULL;
    else {
        BOOT_SPI_SPDR = byte_to_transmitt;
        return SPI_OK;
    }
}

uint8_t GDB_STUB_SECTION_TEXT boot_spi_transfer(uint8_t byte_to_transmitt) {
    volatile union SPSR_bits* pSpsr = (volatile union SPSR_bits*)&BOOT_SPI_SPSR;
    wait_transmitted();
    BOOT_SPI_SPDR = byte_to_transmitt;
    while (pSpsr->RFEMPTY); // wait for transfer
    return BOOT_SPI_SPDR;
}


struct Flash_ID GDB_STUB_SECTION_TEXT spi_probe_flash(uint8_t cs_from,
                                                      uint8_t cs_to) {
    struct Flash_ID result;

    boot_spi_init(SPI_CLOCK_DEV_1024, SPI_MODE3);
    while(cs_from <= cs_to) {
        BOOT_SPI_CS_SEL = cs_from;

        boot_spi_transfer(JEDEC_ID_COMMAND);
        for(uint8_t i = 0; i < 3; ++i)
            ((uint8_t*)&result)[i] = boot_spi_transfer(0); // read 3 bytes

        BOOT_SPI_CS_SEL = 0;

        if (result.Manufacturer && result.Manufacturer != 0xff) {
            result.cs_found = cs_from;
            break;
        }

        ++cs_from;
        for (uint8_t i = 0; i < 10; ++i)
            asm volatile("l.nop");
    }
    boot_spi_disable();

    return result;
}

void GDB_STUB_SECTION_TEXT spi_flash_read(uint8_t cs_num, uint32_t offset,
                    uint8_t* dest, uint32_t size) {
    boot_spi_init(SPI_CLOCK_DEV_2, SPI_MODE3);
    BOOT_SPI_CS_SEL = cs_num;

    boot_spi_transfer(size > 1 ? DATA_READ_FAST_COMMAND : DATA_READ_COMMAND);
    for(uint8_t i = 16; i < 0xff; i -= 8)
        boot_spi_transfer(offset >> i);

    if (size > 1) {
        boot_spi_transfer(0);
        while(size--) {
            *dest = boot_spi_transfer(0);
            ++dest;
        }
    } else {
        *dest = boot_spi_transfer(0); // one byte to read and exit
    }

    BOOT_SPI_CS_SEL = 0;
}
