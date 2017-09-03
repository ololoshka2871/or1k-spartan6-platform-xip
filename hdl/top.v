//-----------------------------------------------------------------
//                           AltOR32 
//                Alternative Lightweight OpenRisc 
//                            V2.0
//                     Ultra-Embedded.com
//                   Copyright 2011 - 2013
//
//               Email: admin@ultra-embedded.com
//
//                       License: LGPL
//-----------------------------------------------------------------
//
// Copyright (C) 2011 - 2013 Ultra-Embedded.com
//
// This source file may be used and distributed without         
// restriction provided that this copyright statement is not    
// removed from the file and that any derivative work contains  
// the original copyright notice and the associated disclaimer. 
//
// This source file is free software; you can redistribute it   
// and/or modify it under the terms of the GNU Lesser General   
// Public License as published by the Free Software Foundation; 
// either version 2.1 of the License, or (at your option) any   
// later version.
//
// This source is distributed in the hope that it will be       
// useful, but WITHOUT ANY WARRANTY; without even the implied   
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      
// PURPOSE.  See the GNU Lesser General Public License for more 
// details.
//
// You should have received a copy of the GNU Lesser General    
// Public License along with this source; if not, write to the 
// Free Software Foundation, Inc., 59 Temple Place, Suite 330, 
// Boston, MA  02111-1307  USA
// 
// Modified by Shilo_XyZ_ or32-boot for spartan-6 lx9
//-----------------------------------------------------------------

`include "timescale.v"
`include "config.v"

//-----------------------------------------------------------------
// TOP
//-----------------------------------------------------------------
module top
(
    // input clock
    input               clk_i,

    // UART
    input               rx0,
    output              tx0,

    // reset CPU key
    input wire          rst_i,

    inout  wire         flash_CS,      // spi flash CS wire
    output wire         sck_o,         // serial clock output
    output wire         mosi_o,        // MasterOut SlaveIN
    input  wire         miso_i         // MasterIn SlaveOut

    // Ethernet RMII interface
`ifdef ETHERNET_ENABLED
    ,
    input  wire         phy_rmii_clk,   // 50 MHZ input
    output wire         phy_mdclk,      // MDCLK
    inout  wire         phy_mdio,       // MDIO
    input  wire         phy_rmii_crs,   // Ressiver ressiving data
    output wire [1:0]   phy_rmii_tx_data,// transmit data bis
    input  wire [1:0]   phy_rmii_rx_data,// ressive data bus
    output wire         phy_tx_en       // transmitter enable
`endif

`ifdef I2C_PRESENT
    ,
    inout  wire         i2c_sda,        // I2C SDA
    inout  wire         i2c_scl         // I2C SCL
`endif

`ifdef GPIO_PRESENT
    ,
    inout wire [`GPIO_COUNT-1:0]     gpio
`endif
);

//-----------------------------------------------------------------
// Params
//-----------------------------------------------------------------

parameter           LEVEL_0_ADDRESS_WIDTH = 24;

parameter FPGA_RAM_SIZE_BYTES   = `NUM_OF_SYS_MEM_UNITS * `MEMORY_UNIT_SIZE / 8;
parameter RAM_ADDRESS_LEN	= $clog2(FPGA_RAM_SIZE_BYTES);

`ifdef CLOCK_USE_PLL
parameter CLK_KHZ = `DEVICE_REF_CLOCK_HZ * `CLOCK_CPU_PLL_MULTIPLYER / `CLOCK_CPU_CLOCK_DEVIDER / 1000;
`else
parameter CLK_KHZ = `DEVICE_REF_CLOCK_HZ / 1000;
`endif

//-----------------------------------------------------------------
// Ports
//-----------------------------------------------------------------

//-----------------------------------------------------------------
// Registers / Wires
//-----------------------------------------------------------------

// imem root bus
wire[31:0]                              imem_address;
wire[31:0]                              imem_data;
wire                                    imem_cyc;
wire                                    imem_stb;
wire                                    imem_ack;


// dmem root bus
wire[31:0]                              dmem_addr;
wire[31:0]                              dmem_data_w;
wire[31:0]                              dmem_data_r;
wire[3:0]                               dmem_sel;
wire                                    dmem_we;
wire                                    dmem_stb;
wire                                    dmem_cyc;
wire                                    dmem_ack;
wire                                    dmem_stall;

// ram
wire[LEVEL_0_ADDRESS_WIDTH-1:0]         ram_addr;
wire[31:0]                              ram_data_w;
wire[31:0]                              ram_data_r;
wire                                    ram_we;
wire[3:0]                               ram_sel;
wire                                    ram_stb;
wire                                    ram_ack;
wire                                    ram_cyc;
wire                                    ram_stall;

// flash mapped bus
wire[LEVEL_0_ADDRESS_WIDTH-1:0]         rom_addr;
wire[31:0]                              rom_data_w;
wire[31:0]                              rom_data_r;
wire                                    rom_we;
wire                                    rom_stb;
wire                                    rom_ack;
wire                                    rom_cyc;

// soc
wire[LEVEL_0_ADDRESS_WIDTH-1:0]         soc_addr;
wire[31:0]                              soc_data_w;
wire[31:0]                              soc_data_r;
wire                                    soc_we;
wire                                    soc_stb;
wire                                    soc_cyc;
wire                                    soc_ack;

// foc fast
wire[LEVEL_0_ADDRESS_WIDTH-1:0]         sf_addr;
wire[31:0]                              sf_data_w;
wire[31:0]                              sf_data_r;
wire[3:0]                               sf_sel;
wire                                    sf_we;
wire                                    sf_stb;
wire                                    sf_cyc;
wire                                    sf_ack;
wire                                    sf_stall;

//-----------------------------------------------------------------

// Reset
reg                                     reset           = 1'b1;

wire                                    clk;
wire                                    clk_ref;

wire                                    clk_io;

wire[2:0]                               ext_intr;

wire                                    rmii_clk;

//-----------------------------------------------------------------
// Instantiation
//-----------------------------------------------------------------


//-----------------------------------------------------------------
// RAM
//-----------------------------------------------------------------
wb_dp_ram_primitive
#(
    //.LOAD_IMAGE(1),
    .NUM_OF_MEM_UNITS_TO_USE(`NUM_OF_SYS_MEM_UNITS),
    .DATA_WIDTH(32)
)
sys_ram
(
    .rst_i(reset),

    .a_clk(1'b0),
    .a_adr_i(16'b0),
    .a_dat_i(32'b0),
    .a_dat_o(/*open*/),
    .a_we_i(1'b0),
    .a_sel_i(4'b0),
    .a_stb_i(1'b0),
    .a_ack_o(/*open*/),
    .a_cyc_i(1'b0),
    .a_stall_o(/*open*/),

    .b_clk(clk),
    .b_adr_i(ram_addr[RAM_ADDRESS_LEN-1:0]),
    .b_dat_i(ram_data_w),
    .b_dat_o(ram_data_r),
    .b_we_i(ram_we),
    .b_sel_i(ram_sel),
    .b_stb_i(ram_stb),
    .b_ack_o(ram_ack),
    .b_cyc_i(ram_cyc),
    .b_stall_o(ram_stall)
);

//-----------------------------------------------------------------
// CPU core
//-----------------------------------------------------------------
cpu
#(
    .BOOT_VECTOR(`BOOT_VECTOR),
    .ISR_VECTOR(`BOOT_VECTOR),
    .REGISTER_FILE_TYPE("XILINX"),
    .ENABLE_ICACHE("ENABLED"),
    .ENABLE_DCACHE("DISABLED")
)
u1_cpu
(
    .clk_i(clk),
    .rst_i(reset),

    .intr_i(soc_irq),
    .nmi_i(1'b0),

    // Status
    .fault_o(/* open */),
    .break_o(/* open */),

    // Instruction memory
    .imem_addr_o(imem_address),
    .imem_dat_i(imem_data),
    .imem_cti_o(/* open */),
    .imem_cyc_o(imem_cyc),
    .imem_stb_o(imem_stb),
    .imem_stall_i(1'b0),
    .imem_ack_i(imem_ack),

    // Data memory
    .dmem_addr_o(dmem_addr),
    .dmem_dat_o(dmem_data_w),
    .dmem_dat_i(dmem_data_r),
    .dmem_sel_o(dmem_sel),
    .dmem_cti_o(/* open */),
    .dmem_cyc_o(dmem_cyc),
    .dmem_we_o(dmem_we),
    .dmem_stb_o(dmem_stb),
    .dmem_stall_i(dmem_stall),
    .dmem_ack_i(dmem_ack)
);


//-----------------------------------------------------------------
// Top levet bus MUX
//-----------------------------------------------------------------
wb_mux4
#(
    .OUT_ADDR_WIDTH(LEVEL_0_ADDRESS_WIDTH)
) mux0 (
    // Input
    .mem_addr_i(dmem_addr[LEVEL_0_ADDRESS_WIDTH + 2 - 1:0]),
    .mem_data_i(dmem_data_w),
    .mem_data_o(dmem_data_r),
    .mem_sel_i(dmem_sel),
    .mem_we_i(dmem_we),
    .mem_stb_i(dmem_stb),
    .mem_cyc_i(dmem_cyc),
    .mem_ack_o(dmem_ack),
    .mem_stall_o(dmem_stall),

    // memory-mapped SPI flash  (0x00000000)
    .out0_addr_o(rom_addr),
    .out0_data_o(rom_data_w),
    .out0_data_i(rom_data_r),
    .out0_sel_o(/* open */),
    .out0_we_o(rom_we),
    .out0_stb_o(rom_stb),
    .out0_cyc_o(rom_cyc),
    .out0_ack_i(rom_ack),
    .out0_stall_i(1'b0),

    // RAM                      (0x01000000)
    .out1_addr_o(ram_addr),
    .out1_data_o(ram_data_w),
    .out1_data_i(ram_data_r),
    .out1_sel_o(ram_sel),
    .out1_we_o(ram_we),
    .out1_stb_o(ram_stb),
    .out1_cyc_o(ram_cyc),
    .out1_ack_i(ram_ack),
    .out1_stall_i(ram_stall),

    // SOC                      (0x02000000)
    .out2_addr_o(soc_addr),
    .out2_data_o(soc_data_w),
    .out2_data_i(soc_data_r),
    .out2_sel_o(/* open */),
    .out2_we_o(soc_we),
    .out2_stb_o(soc_stb),
    .out2_cyc_o(soc_cyc),
    .out2_ack_i(soc_ack),
    .out2_stall_i(1'b0),

    // SOC fast                 (0x03000000)
    .out3_addr_o(sf_addr),
    .out3_data_o(sf_data_w),
    .out3_data_i(sf_data_r),
    .out3_sel_o(sf_sel),
    .out3_we_o(sf_we),
    .out3_stb_o(sf_stb),
    .out3_cyc_o(sf_cyc),
    .out3_ack_i(sf_ack),
    .out3_stall_i(sf_stall)
);

//-----------------------------------------------------------------
// SPI Flash memory mapper
//-----------------------------------------------------------------
xip_adapter
#(
    .MASTER_CLK_FREQ_HZ(CLK_KHZ),
    .RAM_PROGRAMM_MEMORY_START(`BOOT_VECTOR),
`ifdef XILINX_ISIM
    .SPI_FLASH_PROGRAMM_START(0)
`else
    .SPI_FLASH_PROGRAMM_START(`SPI_FLASH_PROGRAMM_START)
`endif
) flash_mapper (
    .rst_i(reset),
    .clk_i(clk),

    .mm0_addr_i(imem_address[23:0]),
    .mm0_dat_o(imem_data),
    .mm0_dat_i(32'h0),
    .mm0_we(1'b0),
    .mm0_cyc_i(imem_cyc),
    .mm0_stb_i(imem_stb),
    .mm0_ack_o(imem_ack),

    .mm1_addr_i(rom_addr),
    .mm1_dat_o(rom_data_r),
    .mm1_dat_i(rom_data_w),
    .mm1_we(rom_we),
    .mm1_cyc_i(rom_cyc),
    .mm1_stb_i(rom_stb),
    .mm1_ack_o(rom_ack),

    .spi_mosi(mosi_o),
    .spi_miso(miso_i),
    .spi_sck_o(sck_o),
    .spi_cs_o(flash_CS)
);

//-----------------------------------------------------------------
// CPU SOC
//-----------------------------------------------------------------
soc
#(
    .CLK_KHZ(CLK_KHZ),
    .ENABLE_SYSTICK_TIMER("ENABLED"),
    .ENABLE_HIGHRES_TIMER("ENABLED"),
    .BAUD_UART0(`BAUD_UART0),
    .BAUD_MDIO(`BAUD_MDIO),
    .BAUD_I2C(`BAUD_I2C),
    .EXTERNAL_INTERRUPTS(3)
) u_soc (
    // General - clocking & reset
    .clk_i(clk),
    .rst_i(reset),
    .ext_intr_i(ext_intr),
    .intr_o(soc_irq),

    // Memory Port
    .io_addr_i({{(32-LEVEL_0_ADDRESS_WIDTH){1'b0}}, soc_addr}),
    .io_data_i(soc_data_w),
    .io_data_o(soc_data_r),
    .io_we_i(soc_we),
    .io_stb_i(soc_stb),
    .io_ack_o(soc_ack),
    .io_cyc_i(soc_cyc),

    .uart0_tx_o(tx0),
    .uart0_rx_i(rx0)

`ifdef ETHERNET_ENABLED
    ,
    .mdclk_o(phy_mdclk),
    .mdio(phy_mdio)
`endif

`ifdef I2C_PRESENT
    ,
    .i2c_sda(i2c_sda),
    .i2c_scl(i2c_scl)
`endif

`ifdef GPIO_PRESENT
    ,
    .gpio(gpio)
`endif
);

//-----------------------------------------------------------------
// Fast perepherial
//-----------------------------------------------------------------
soc_fast
#(
    .ADDR_WITH(LEVEL_0_ADDRESS_WIDTH)
) sf (
    .clk_i(clk),
    .rst_i(reset),

    .cyc_i(sf_cyc),
    .stb_i(sf_stb),
    .adr_i(sf_addr),
    .we_i(sf_we),
    .dat_i(sf_data_w),
    .dat_o(sf_data_r),
    .ack_o(sf_ack),
    .stall_o(sf_stall),
    .sel_i(sf_sel),

`ifdef ETHERNET_ENABLED
    .phy_rmii_clk(rmii_clk),
    .phy_rmii_crs(phy_rmii_crs),
    .phy_rmii_tx_data(phy_rmii_tx_data),
    .phy_rmii_rx_data(phy_rmii_rx_data),
    .phy_tx_en(phy_tx_en),
`endif

    .interrupts_o(ext_intr)
);

//-----------------------------------------------------------------
// clocking provider
//-----------------------------------------------------------------
clock_provider clk_prov
(
    .clk_i(clk_i),
    .rmii_clk_to_PHY_i(phy_rmii_clk),

    .sys_clk_o(clk),
    .rmii_logick_clk_o(rmii_clk)
);

//-----------------------------------------------------------------
// Implementation
//-----------------------------------------------------------------

// Reset Generator
always @(posedge clk)
if (rst_i == 1'b0)
    reset       <= 1'b1;
else
    reset       <= 1'b0;
//else 
//    rst_next    <= 1'b0;

//-----------------------------------------------------------------
// Unused pins
//-----------------------------------------------------------------

endmodule
