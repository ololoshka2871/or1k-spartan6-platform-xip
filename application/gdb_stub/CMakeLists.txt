#****************************************************************************
#*
#*   Copyright (C) 2016 Shilo_XyZ_. All rights reserved.
#*   Author:  Shilo_XyZ_ <Shilo_XyZ_<at>mail.ru>
#*
#* Redistribution and use in source and binary forms, with or without
#* modification, are permitted provided that the following conditions
#* are met:
#*
#* 1. Redistributions of source code must retain the above copyright
#*    notice, this list of conditions and the following disclaimer.
#* 2. Redistributions in binary form must reproduce the above copyright
#*    notice, this list of conditions and the following disclaimer in
#*    the documentation and/or other materials provided with the
#*    distribution.
#*
#* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
#* "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
#* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
#* FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
#* COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
#* INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
#* BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
#* OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
#* AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
#* LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
#* ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
#* POSSIBILITY OF SUCH DAMAGE.
#*
#****************************************************************************/

cmake_minimum_required(VERSION 2.8.5)

SET(GDB_HW_SRC		    gdb_hw.c gdb.c)
SET(GDB_NORMAL_SRC	    gdb_main.c)
SET(GDB_NOTRAP_SRC	    gdb_main_notrap.c)

INCLUDE_DIRECTORIES(${APP_INCLUDE_DIR})

add_library(gdb_stub            STATIC ${GDB_HW_SRC} ${GDB_NORMAL_SRC})
add_library(gdb_stub_notrap     STATIC ${GDB_HW_SRC} ${GDB_NOTRAP_SRC})
add_library(gdb_stub_sim        STATIC ${GDB_HW_SRC} ${GDB_NOTRAP_SRC})

set_target_properties(gdb_stub              PROPERTIES COMPILE_DEFINITIONS "${COMMON_DIFENITIONS}")
set_target_properties(gdb_stub_notrap       PROPERTIES COMPILE_DEFINITIONS "${COMMON_DIFENITIONS}")
set_target_properties(gdb_stub_sim          PROPERTIES COMPILE_DEFINITIONS "${SIM_DIFENITIONS}")

if (CMAKE_BUILD_TYPE STREQUAL "Release")
    set(BOOT_LIB gdb_stub_notrap)
else()
    set(BOOT_LIB gdb_stub)
endif()

set(BOOT_LIB        ${BOOT_LIB}                         PARENT_SCOPE)
