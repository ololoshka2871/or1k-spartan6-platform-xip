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

#ifndef BOOT_SPI_H
#define BOOT_SPI_H

#include <stdint.h>
#include "gdb-stub-sections.h"

#define REG32               (volatile unsigned int*)

#define IO_BASE             0x12000000

#define BOOT_SPI_BASE		(IO_BASE + 0x300)

#define BOOT_SPI_SPCR       (*(REG32 (BOOT_SPI_BASE + 0x00)))
#define BOOT_SPI_SPSR       (*(REG32 (BOOT_SPI_BASE + 0x04)))
#define BOOT_SPI_SPDR       (*(REG32 (BOOT_SPI_BASE + 0x08)))
#define BOOT_SPI_SPER       (*(REG32 (BOOT_SPI_BASE + 0x0C)))
#define BOOT_SPI_CS_SEL     (*(REG32 (BOOT_SPI_BASE + 0x10)))

enum enSpiErr {
    SPI_OK = 0,
    SPI_NO_DATA_AVALABLE = 1,
    SPI_FIFO_FULL = 2,
};

enum enSPIMode {
    SPI_MODE0 = 0,
    SPI_MODE1 = 1,
    SPI_MODE2 = 2,
    SPI_MODE3 = 3,
};

enum enSPIClockDevider {
    SPI_CLOCK_DEV_2 = 0,
    SPI_CLOCK_DEV_4 = 1,
    SPI_CLOCK_DEV_16 = 2,
    SPI_CLOCK_DEV_32 = 3,
    SPI_CLOCK_DEV_8 = 4,
    SPI_CLOCK_DEV_64 = 5,
    SPI_CLOCK_DEV_128 = 6,
    SPI_CLOCK_DEV_256 = 7,
    SPI_CLOCK_DEV_512 = 8,
    SPI_CLOCK_DEV_1024 = 9,
    SPI_CLOCK_DEV_2048 = 10,
    SPI_CLOCK_DEV_4096 = 11,
};

union SPSR_bits {
    struct {
        unsigned SPIF:1;     // Serial Peripheral Interrupt Flag
        unsigned WCOL:1;     // Write Collision
        unsigned Reserved:2; //
        unsigned WFFULL:1;   // Write FIFO Full
        unsigned WFEMPTY:1;  // Write FIFO Empty
        unsigned RFFULL:1;   // Read FIFO Full
        unsigned RFEMPTY:1;  // Read FIFO Empty /* bit 0*/
    } __attribute__((packed));
    uint8_t SPSR;
};

union SPCR_bits {
    struct {
        unsigned SPIE:1;     // Serial Peripheral Interrupt Enable
        unsigned SPE:1;      // Serial Peripheral Enable
        unsigned Reserved:1; //
        unsigned MSTR:1;     // Master Mode Select
        unsigned CPOL:1;     // Clock Polarity
        unsigned CPHA:1;     // Clock Phase
        unsigned SPR:2;      // SPI Clock Rate Select
    } __attribute__((packed));
    uint8_t SPCR;
};

union SPER_bits {
    struct {
        unsigned ICNT:2;      // Interrupt Count
        unsigned Reserved:4;
        unsigned ESPR:2;      // Extended SPI Clock Rate Select
    } __attribute__((packed));
    uint8_t SPER;
};

struct Flash_ID {
    uint8_t Manufacturer;
    uint8_t Memory_Type;
    uint8_t Capacity;

    uint8_t cs_found;
};

struct Flash_ID GDB_STUB_SECTION_TEXT spi_probe_flash(uint8_t cs_from,
                                                      uint8_t cs_to);
void GDB_STUB_SECTION_TEXT spi_flash_read(uint8_t cs_num, uint32_t offset,
                    uint8_t* dest, uint32_t size);

#endif // BOOT_SPI_H
