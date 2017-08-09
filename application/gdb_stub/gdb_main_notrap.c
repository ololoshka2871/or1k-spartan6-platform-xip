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

#include "gdb_hw.h"

extern void main();
extern int coremark_main(int argc, char *argv[]);
extern void run_tests();

//-----------------------------------------------------------------
// gdb_main
//-----------------------------------------------------------------
void __attribute__((noreturn)) gdb_main(void)
{
#ifndef NDEBUG
    gdb_putchar('.');
#endif /* NDEBUG */

#ifdef SIM
    run_tests();
#ifdef SYSTEM_PERFORM_COREMARK_AT_BOOT
    coremark_main(0, NULL);
#endif /* SYSTEM_PERFORM_COREMARK_AT_BOOT */
#else /* SIM */
#ifdef SYSTEM_PERFORM_COREMARK_AT_BOOT
    putstr("\nStarting coremark testing...\n");
    coremark_main(0, NULL);
#else /* SYSTEM_PERFORM_COREMARK_AT_BOOT */
    main();
#endif
#endif /* SIM */
    while(1);
}
