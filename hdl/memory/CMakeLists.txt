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
#* 3. Neither the name NuttX nor the names of its contributors may be
#*    used to endorse or promote products derived from this software
#*    without specific prior written permission.
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

SET(MEMORY_HDL_V)

SET(SYSTEM_MEMORY_FILE_NAME	wb_dp_ram.v)

SET(SYSTEM_MEMORY_MODULE	${CMAKE_CURRENT_BINARY_DIR}/${SYSTEM_MEMORY_FILE_NAME})
SET(SYSTEM_MEMORY_MODULE_IN	${CMAKE_CURRENT_SOURCE_DIR}/${SYSTEM_MEMORY_FILE_NAME})

configure_file(${SYSTEM_MEMORY_MODULE_IN} ${SYSTEM_MEMORY_MODULE}.tmp @ONLY)

#force rebuild, if bootloader changed
add_custom_target(memory_refresh
    COMMAND
	${SCRIPTS_DIR}/checkmemory.sh ${SYSTEM_MEMORY_MODULE}.tmp
	    ${SYSTEM_MEMORY_MODULE} ${BOOTLOADER_IMAGE}
    DEPENDS
	bootloader
    )

add_custom_target(memory_sources
    SOURCES
	${SYSTEM_MEMORY_MODULE_IN}
    )

list(APPEND MEMORY_HDL_V ${SYSTEM_MEMORY_MODULE})

set(MEMORY_HDL_V	${MEMORY_HDL_V}		PARENT_SCOPE)
