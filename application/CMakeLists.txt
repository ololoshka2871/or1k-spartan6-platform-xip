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

project(or1k-spartan6-platform-xip_firmware ASM C)

set(LD_SCRIPT_FILE_IN  "${CMAKE_CURRENT_SOURCE_DIR}/link.ld.in")
set(LD_SCRIPT_FILE     "${CMAKE_CURRENT_BINARY_DIR}/link.ld")

math(EXPR MAIN_MEMORY_SIZE_B "${SYSTEM_FPGA_BMEMORY_USE} * ${MEMORY_UNIT_SIZE} / 8")
configure_file(${LD_SCRIPT_FILE_IN} ${LD_SCRIPT_FILE} @ONLY)

set(CURRENT_MEMORY_SIZE_FILE    MEMSIZE)
# Эта штука для ситуации когда изменено ${SYSTEM_FPGA_BMEMORY_USE}, нужно пересобрать бинарники
add_custom_target(ldsctipt
    DEPENDS ${LD_SCRIPT_FILE}
    COMMAND
        if [ `cat ${CURRENT_MEMORY_SIZE_FILE}` != ${SYSTEM_FPGA_BMEMORY_USE} ]\; then rm ${FIRMWARE_IMG_FILE_NAME} ${FIRMWARE_SIM_IMG_FILE_NAME}\; fi\; echo ${SYSTEM_FPGA_BMEMORY_USE} > ${CURRENT_MEMORY_SIZE_FILE}
    )

set(FIRMWARE_IMG_FILE_NAME          firmware.res)
set(FIRMWARE_SIM_IMG_FILE_NAME      firmware.sim)

message(STATUS "System memory size: ${MAIN_MEMORY_SIZE_B} B")

INCLUDE("or1k_toolchain")

set(COMMON_DIFENITIONS
    F_CPU=${CPU_CLOCK_HZ}
    BB_I2C_BAUD=${BAUD_I2C}
    SYSTEM_HEAP_SIZE=${SYSTEM_HEAP_SIZE}
    MACTX_HEAP_BASE=${MAC_TX_MEM_BASE}
    MACTX_HEAP_SIZE=${MAC_TX_MEM_SIZE}
    BYTE_ORDER=__BYTE_ORDER__
    LITTLE_ENDIAN=__ORDER_LITTLE_ENDIAN__
    BIG_ENDIAN=__ORDER_BIG_ENDIAN__
    )

if(SYSTEM_PERFORM_COREMARK_AT_BOOT)
    list(APPEND COMMON_DIFENITIONS SYSTEM_PERFORM_COREMARK_AT_BOOT)
endif()

if (SYSTEM_FRINTF_FLOAT_SUPPORT)
    list(APPEND COMMON_DIFENITIONS HAS_FLOAT)
endif()

set(SIM_DIFENITIONS
    ${COMMON_DIFENITIONS}
    SIM
    )

include_directories(${TOOLCHAIN_INCLUDE_PATH})

add_subdirectory(include)
add_subdirectory(boot)
add_subdirectory(gdb_stub)
add_subdirectory(libbase)
add_subdirectory(coremark)
add_subdirectory(libhw)
add_subdirectory(hwtest)

set_property(SOURCE ${BOOT_S} PROPERTY LANGUAGE C)

set(APP_MAIN_SRC    main.c)
add_custom_target(app_src_files SOURCES ${APP_MAIN_SRC} ${LD_SCRIPT_FILE_IN})

add_executable(${FIRMWARE_IMG_FILE_NAME}
    ${BOOT_S}
    ${APP_MAIN_SRC}
    )
target_link_libraries(${FIRMWARE_IMG_FILE_NAME}
    -Wl,--start-group ${BOOT_LIB} base coremark hw -Wl,--end-group
    )
set_target_properties(${FIRMWARE_IMG_FILE_NAME} PROPERTIES COMPILE_DEFINITIONS "${COMMON_DIFENITIONS}")
set_target_properties(${FIRMWARE_IMG_FILE_NAME} PROPERTIES LINK_DEPENDS ${LD_SCRIPT_FILE})
add_dependencies(${FIRMWARE_IMG_FILE_NAME} ldsctipt)

add_executable(${FIRMWARE_SIM_IMG_FILE_NAME}
    ${BOOT_S}
    ${APP_MAIN_SRC}
    )
target_link_libraries(${FIRMWARE_SIM_IMG_FILE_NAME}
    -Wl,--start-group gdb_stub_sim base coremark hw hwtest -Wl,--end-group
    )
set_target_properties(${FIRMWARE_SIM_IMG_FILE_NAME} PROPERTIES COMPILE_DEFINITIONS "${SIM_DIFENITIONS}")
set_target_properties(${FIRMWARE_SIM_IMG_FILE_NAME} PROPERTIES LINK_DEPENDS ${LD_SCRIPT_FILE})
add_dependencies(${FIRMWARE_SIM_IMG_FILE_NAME} ldsctipt)

set(FIRMWARE_IMG_FILE_NAME_BIN          ${CMAKE_CURRENT_BINARY_DIR}/${FIRMWARE_IMG_FILE_NAME}.bin)
set(FIRMWARE_SIM_IMG_FILE_NAME_BIN      ${CMAKE_CURRENT_BINARY_DIR}/${FIRMWARE_SIM_IMG_FILE_NAME}.bin)

elf2bin(${FIRMWARE_IMG_FILE_NAME}       ${FIRMWARE_IMG_FILE_NAME_BIN})
elf2bin(${FIRMWARE_SIM_IMG_FILE_NAME}   ${FIRMWARE_SIM_IMG_FILE_NAME_BIN})

add_custom_target(application
    DEPENDS
        ${FIRMWARE_IMG_FILE_NAME} ${FIRMWARE_SIM_IMG_FILE_NAME}
        ${FIRMWARE_IMG_FILE_NAME_BIN} ${FIRMWARE_SIM_IMG_FILE_NAME_BIN}
    )

#----------------------------------------------------------------

set(FIRMWARE_IMG_FILE_NAME_BIN          ${FIRMWARE_IMG_FILE_NAME_BIN}       PARENT_SCOPE)
set(FIRMWARE_SIM_IMG_FILE_NAME_BIN      ${FIRMWARE_SIM_IMG_FILE_NAME_BIN}   PARENT_SCOPE)
