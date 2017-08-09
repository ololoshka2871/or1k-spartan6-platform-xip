/****************************************************************************
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

#include <stddef.h>
#include <string.h>
#include <stdint.h>

#include "timer.h"

#if 0

#include "minimac2.h"
#include "mdio.h"
#include "GPIO.h"
#include "i2c.h"
#include "crc32.h"
#include "boot_spi.h"

#endif

static void test_multiplication() {
    volatile int32_t a = -15;
    volatile int32_t b = 48;
    volatile uint32_t res;
#ifdef HW_MUL_MODULE
    res = a * b;
#else
    asm volatile("l.mul %0, %1, %2" : "=r" (res) : "r" (a), "r" (b)); // sim to 130us
#endif
}

static void test_systimer() {
    volatile uint32_t now1 = hires_timer_now();
    volatile uint32_t now2 = hires_timer_now();
}

#if 0

static void test_mdio() {
    // Test MDIO
    for(uint8_t i = 0; i < 5; ++i) {
        MDIO_WriteREG(i, PHY_ANNPTR - i, PHY_BMCR_SPEED100MB | PHY_BMCR_FULL_DUPLEX);
        MDIO_ReadREG_sync(i, PHY_ANNPTR - i);
    }
}

static void test_minmac() {
    memcpy(0x11300000, 0x11300100, 0x100);

#if 0
    miniMAC_control(true, true);

    for (uint8_t i = 0; i < 5; ++i) {
        uint8_t* ptx_slot = miniMAC_tx_slot_allocate((12 * sizeof(uint32_t) - 2) * (i + 1));
        miniMAC_slot_complite_and_send(ptx_slot);
        while (!(IRQ_STATUS & (1 << IRQ_MINIMAC_TX)));
        IRQ_STATUS = (1 << IRQ_MINIMAC_TX);
        while (!(IRQ_STATUS & (1 << IRQ_MINIMAC_RX)));
        IRQ_STATUS = (1 << IRQ_MINIMAC_RX);
    }
#else
    miniMAC_init();
    for (uint8_t i = 0; i < 5; ++i) {
        miniMAC_startTransmission((12 * sizeof(uint32_t) - 2) * (i + 1));
        while (!miniMAC_isReadyToTx());
    }
#endif
    miniMAC_acceptSlot(miniMAC_findReadySlot());
    miniMAC_rxCount(MINIMAC_RX_SLOT1);
    memcpy(miniMAC_txSlotData(), miniMAC_rxSlotData(MINIMAC_RX_SLOT2),miniMAC_rxCount(MINIMAC_RX_SLOT2));
    miniMAC_resetRxSlot(MINIMAC_RX_SLOT3);
}

static void test_i2c() {
    uint8_t res[10];
#ifndef IICMB_I2C
    gpio_port_init(GPIO_PORTA, 0);
#endif
    i2c_init();

    i2c_read_bus(0, 0x10, res);
    i2c_read_bus_mul(0, 0, res, sizeof(res));
}

static void test_spi() {
    uint8_t res[10] = {0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0xff, 0xfe, 0xaa, 0x55};

    boot_spi_init(SPI_CLOCK_DEV_2, SPI_MODE3);

    boot_spi_transfer_buf(res, res, sizeof(res));
}

static void test_minmac_slotlogick() {
    miniMAC_control(true, true);

    uint8_t* ptx_slot = miniMAC_tx_slot_allocate((12 * sizeof(uint32_t) - 2));
    miniMAC_slot_complite_and_send(ptx_slot);
    miniMAC_reset_rx_slot(MINIMAC_RX_SLOT0);
    while (!(IRQ_STATUS & (1 << IRQ_MINIMAC_TX)));
    miniMAC_slot_complite_and_send(ptx_slot);
    miniMAC_reset_rx_slot(MINIMAC_RX_SLOT0);
}

static void test_gpio() {
    GPIO gpio = gpio_port_init(GPIO_PORTA, 0xffffffff);

    gpio_port_set_all(gpio, 0xA5A5A5A5);
    gpio_port_set_all(gpio, ~0xA5A5A5A5);
}

static void test_crc32() {
    static const char test_data[] = "Test_Data_string01zd";
    uint32_t res = 0;
    while(res != 0xE4D2E6C2)
        res = crc32(test_data, sizeof(test_data));
}

#endif

void run_tests() {

#ifdef SIM_TEST_MULTIPLICATION
    test_multiplication();
#endif

#ifdef SIM_TEST_SYS_TIMER
    test_systimer();
#endif

#ifdef SIM_TEST_MDIO
    test_mdio();
#endif

#ifdef SIM_TEST_MINIMAC_SLOT_LOGICK
    test_minmac_slotlogick();
#endif

#ifdef SIM_TEST_MINIMAC
    test_minmac();
#endif

#ifdef SIM_TEST_I2C
    test_i2c();
#endif

#ifdef SIM_TEST_SPI
    test_spi();
#endif

#ifdef SIM_TEST_GPIO
    test_gpio();
#endif

#ifdef SIM_TEST_CRC32
    test_crc32();
#endif
}
