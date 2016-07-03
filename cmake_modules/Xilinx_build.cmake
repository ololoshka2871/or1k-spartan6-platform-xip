#****************************************************************************
#* hard/cmake_modules/recursively_include_src.cmake
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

function(make_prj PRJ_FILE_NAME PRJ_TEXT)
    file(WRITE ${PRJ_FILE_NAME} ${PRJ_TEXT})
    add_custom_command(
	OUTPUT
	    ${PRJ_FILE_NAME}
	COMMAND
	    $(CMAKE_COMMAND) -E touch_nocreate ${PRJ_FILE_NAME}
#	DEPENDS
#	    altor32_sources soc_sources top_hdl_sources memory_sources
	COMMENT
	    "Building PRJ file"
	)
    add_custom_target(${PROJECT_NAME}_prj DEPENDS ${PRJ_FILE_NAME})
endfunction(make_prj)

function(make_xst SYR_FILE NGC_FILE PRJ_FILE_NAME XST_FILE_NAME)
    add_custom_command(
	OUTPUT
	    ${SYR_FILE}
	    ${NGC_FILE}
	COMMAND
	    ${XILINX_xst} -ifn ${XST_FILE_NAME} -ofn ${SYR_FILE}
	DEPENDS
	    ${PRJ_FILE_NAME} ${XST_FILE_NAME}
	COMMENT
	    "Compile HDL files"
	)

    add_custom_target(${PROJECT_NAME}_xst ALL DEPENDS ${SYR_FILE}) #
endfunction(make_xst)

function(make_ngdbuild NGD_FILE NGO_DIR UCF_FILE_NAME NGC_FILE)
    add_custom_command(OUTPUT ${NGD_FILE}
	COMMAND
	    ${XILINX_ngdbuild} -dd ${NGO_DIR}
		-nt timestamp
		-uc ${UCF_FILE_NAME}
		-p ${PART_NAME}
		${NGC_FILE} ${NGD_FILE}
	DEPENDS
	    ${NGC_FILE} ${UCF_FILE_NAME}
	COMMENT
	    "Starting ngdbuild"
	)

    add_custom_target(${PROJECT_NAME}_ngdbuild DEPENDS ${NGD_FILE})
endfunction(make_ngdbuild)

function(make_map MAP_FILE PCF_FILE PART_NAME NGD_FILE)
    add_custom_command(
	OUTPUT
	    ${MAP_FILE}
	    ${PCF_FILE}
	COMMAND
	    ${XILINX_map} -p ${PART_NAME}
		-w -logic_opt off
		-ol high -t 1 -xt 0
		-register_duplication off
		-global_opt off
		-mt off -ir off
		-pr off -lc off
		-power off
		-o ${MAP_FILE}
		${NGD_FILE}
		${PCF_FILE}
	DEPENDS
	    ${NGD_FILE}
	COMMENT
	    "Maping"
	)

    add_custom_target(${PROJECT_NAME}_map
	DEPENDS
	    ${MAP_FILE}
	    ${PCF_FILE}
	)
endfunction(make_map)

function(make_par NCD_FILE MAP_FILE PCF_FILE)
    add_custom_command(
	OUTPUT
	    ${NCD_FILE}
	COMMAND
	    ${XILINX_par}
		-ol high
		-mt off
		${MAP_FILE}
		-w ${NCD_FILE}
		${PCF_FILE}
	DEPENDS
	    ${MAP_FILE}
	    ${PCF_FILE}
	COMMENT
	    "Paring"
	)

    add_custom_target(${PROJECT_NAME}_par DEPENDS ${NCD_FILE})
endfunction(make_par)

function(make_trce TWX_FILE TWR_FILE NCD_FILE PCF_FILE)
    add_custom_command(
	OUTPUT
	    ${TWX_FILE}
	    ${TWR_FILE}
	COMMAND
	    ${XILINX_trce} -v 3
		-s 2
		-n 3
		-fastpaths
		-xml ${TWX_FILE}
		${NCD_FILE}
		-o ${TWR_FILE}
		${PCF_FILE}
	DEPENDS
	    ${PCF_FILE} ${NCD_FILE}
	COMMENT
	    "Running trce"
	)

    add_custom_target(${PROJECT_NAME}_trace
	DEPENDS
	    ${TWX_FILE}
	    ${TWR_FILE}
	)
endfunction(make_trce)

function(make_bitgen BIT_FILE UT_FILE_NAME NCD_FILE)
    add_custom_command(
	OUTPUT
	    ${BIT_FILE}
	COMMAND
	    ${XILINX_bitgen}
		-f ${UT_FILE_NAME}
		${NCD_FILE}
		${BIT_FILE}
	DEPENDS
	    ${UT_FILE_NAME}
	    ${NCD_FILE}
	COMMENT
	    "Generating bitstream"
	)

    add_custom_target(${PROJECT_NAME}_bitgen ALL DEPENDS ${BIT_FILE})
endfunction(make_bitgen)
