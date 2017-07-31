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

#include <string.h>
#include <stdio.h>
#include <assert.h>

#include "irq.h"
#include "mdio.h"
#include "prog_timer.h"
#include "GPIO.h"

#include "main.h"

#define LED_MASK    (0b111)

static void led_blinker(void* cookie) {
    (void)cookie;
    uint32_t v = gpio_port_get_val(GPIO_PORTA) & LED_MASK;
    uint32_t new_v = (v & (LED_MASK >> 1)) ? (v << 1) : 1;

    gpio_port_set_val(GPIO_PORTA, new_v, v);
}

static void Led_toggle() {
#if GPIO_ENABLED
    uint32_t v = gpio_port_get_val(GPIO_PORTA) & 1;
    uint32_t set = (~v) & 1;

    gpio_port_set_val(GPIO_PORTA, set, v);
#endif
}

static void initAll() {
#if 1
    interrupts_init();
    progtimer_init();

#if GPIO_ENABLED
    gpio_port_init(GPIO_PORTA, LED_MASK);
    progtimer_new(1000, led_blinker, NULL);
#endif

#endif
}

int main(void)
{
    initAll();
    EXIT_CRITICAL();

    while(1) {
    }

    return 0;
}
