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

cmake_minimum_required(VERSION 3.0.2)


file(GLOB_RECURSE
    WB_SPI_FLASH_HDL_V
    FOLLOW_SYMLINKS
    "*.v"
    )

file(GLOB_RECURSE
    WB_SPI_FLASH_HDL_VHDL
    FOLLOW_SYMLINKS
    "*.vhd*"
    )

# Fake target: add sources to project tree (Qt Creator)
add_custom_target(wb_spi_flash_sources
    SOURCES
        ${WB_SPI_FLASH_HDL_V} ${WB_SPI_FLASH_HDL_VHDL}
    )

set(WB_SPI_FLASH_HDL_V              ${WB_SPI_FLASH_HDL_V}           PARENT_SCOPE)
set(WB_SPI_FLASH_HDL_VHDL           ${WB_SPI_FLASH_HDL_VHDL}        PARENT_SCOPE)
set(WB_SPI_FLASH_INCLUDE_PATH       ${CMAKE_CURRENT_SOURCE_DIR}     PARENT_SCOPE)
