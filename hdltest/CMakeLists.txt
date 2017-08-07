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
    TESTBENCH_HDL_V
    FOLLOW_SYMLINKS
    "tb_*.v"
    )


set(SPI_FLASH_SIM_DATA_FILE ${CMAKE_CURRENT_BINARY_DIR}/img.txt)
add_custom_command(
    OUTPUT  ${SPI_FLASH_SIM_DATA_FILE}
    DEPENDS application ${FIRMWARE_SIM_IMG_FILE_NAME_BIN}
    COMMAND
        xxd -ps -c 1 ${FIRMWARE_SIM_IMG_FILE_NAME_BIN} > ${SPI_FLASH_SIM_DATA_FILE}
    COMMENT
        "Making SPI Flash image"
    )
add_custom_target(spi_flash_test_image DEPENDS ${SPI_FLASH_SIM_DATA_FILE})

#--------------------------------------------------------------------------

set(TB_CONFIG_FILE_IN   ${CMAKE_CURRENT_SOURCE_DIR}/bench_cfg.vh.in)
set(TB_CONFIG_FILE      ${CMAKE_CURRENT_BINARY_DIR}/bench_cfg.vh)

configure_file(${TB_CONFIG_FILE_IN} ${TB_CONFIG_FILE} @ONLY)

# Fake target: add sources to project tree (Qt Creator)
add_custom_target(testbench_sources
    SOURCES
        ${TESTBENCH_HDL_V} ${TB_CONFIG_FILE_IN}
    )

#-------------------------------------sym---------------------------------------

set(prj_libs altor32 soc memory utils work mdio i2c myminimac wb_spi_flash)
set(testlibs_list)
foreach(l ${prj_libs})
    list(APPEND testlibs_list -lib ${l})
endforeach()

build_prj(XILINX_VERILOG_glbl_PRJ   "verilog work	%f\n"	"${XILINX_VERILOG_glbl}")
build_prj(MEMORY_HDL_SIM_PRJ	    "verilog memory	%f\n"	"${MEMORY_HDL_SIM_V}")

foreach(testfile ${TESTBENCH_HDL_V})
    string(REGEX REPLACE ".*/(.*)\\.v" "\\1" testname ${testfile})
    message(STATUS "Creating testbench target for ${testname}")

    set(test_prj_file	    ${CMAKE_CURRENT_BINARY_DIR}/${testname}.prj)
    set(test_executable	    ${CMAKE_CURRENT_BINARY_DIR}/${testname}.exe)
    set(test_top_lvl_module "tb.${testname}")

    # create prj
    build_prj(TB_PRJ	"verilog tb	%f\n"	"${testfile}")

    file(WRITE ${test_prj_file}.tmp
        ${XST_PRJ_TEXT}
        ${MEMORY_HDL_SIM_PRJ}
        ${TB_PRJ}
        ${XILINX_VERILOG_glbl_PRJ}
        )

    add_custom_target(${testname}.prj
        COMMAND
            ${HDL_SCRIPTS_DIR}/checksrc.sh ${test_prj_file}.tmp ${test_prj_file}
        DEPENDS
            memory_refresh_sim application spi_flash_test_image
        COMMENT
            "Refreshing ${testname}.prj"
        )

    make_Behavioral_testbench(
        "${testlibs_list}"
        ${test_executable}
        ${test_prj_file}
        ${test_top_lvl_module}
        ${CMAKE_CURRENT_BINARY_DIR}
        "${TB_INCLUDE_PATH}"
        )
    add_dependencies(${PROJECT_NAME}_fuse.${test_top_lvl_module} ${testname}.prj)

endforeach()

#------------------------------------/sym---------------------------------------
