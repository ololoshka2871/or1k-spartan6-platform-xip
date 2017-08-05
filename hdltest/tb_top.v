`include "../timescale.v"

////////////////////////////////////////////////////////////////////////////////
//
// Create Date:   11:16:19 04/10/2016
// Design Name:   tb_top
// 
////////////////////////////////////////////////////////////////////////////////

`include "bench_cfg.vh"

module tb_top;

	`ifdef CLOCK_USE_PLL
	parameter CLK_HZ = `DEVICE_REF_CLOCK_HZ * `CLOCK_CPU_PLL_MULTIPLYER / `CLOCK_CPU_CLOCK_DEVIDER * 1.0;
	`else
	parameter CLK_HZ = `DEVICE_REF_CLOCK_HZ * 1.0;
	`endif

	// Inputs
	reg clk;
        reg rx;
	
	// Outputs
        wire tx;
	
        reg      rst;

        wire     flash_CS;
        wire     sck;
        wire     mosi;

        wire     phy_tx_en;
        reg      rmii_clk;
        wire     mii_mdclk;
        wire     mii_mdio;
        wire    [1:0]                   rmii_tx_data;

        wire    [`GPIO_COUNT-1:0]       gpio;

        wire sda;
        wire scl;

	// Bidirs

	// Instantiate the Unit Under Test (UUT)
	top uut (
            .clk_i(clk),
            .rx0(rx),
            .tx0(tx),

            .rst_i(rst),
            .flash_CS(flash_CS),
            .sck_o(sck),
            .mosi_o(mosi),
            .miso_i(miso)
`ifdef ETHERNET_ENABLED
            ,
            .phy_rmii_rx_data(rmii_tx_data),
            .phy_rmii_crs(phy_tx_en),
            .phy_rmii_tx_data(rmii_tx_data),
            .phy_tx_en(phy_tx_en),
            .phy_rmii_clk(rmii_clk),
            .phy_mdclk(mii_mdclk),
            .phy_mdio(mii_mdio)
`endif

`ifdef I2C_PRESENT
            ,
            .i2c_sda(sda),
            .i2c_scl(scl)
`endif

`ifdef GPIO_PRESENT
            ,
            .gpio(gpio)
`endif
	);

        PULLUP PULLUP_sda (
            .O(sda)
        ), PULLUP_scl (
            .O(scl)
        );

        spi_flash_simulator
        #(
            .SYS_CLK_RATE(CLK_HZ),
            .FLASH_ADR_BITS(8),
            .FLASH_INIT(`SPI_FLASH_SIM_DATA_FILE)
        ) spi_flash_0 (
            .sys_rst_n(rst),
            .sys_clk(clk),
            .sys_clk_en(1'b1),

            .spi_cs_i(flash_CS),
            .spi_sck_i(sck),
            .spi_si_i(mosi),
            .spi_so_o(miso)
        );

        genvar gpio_p;

        generate
            for (gpio_p = 0; gpio_p < `GPIO_COUNT - 2; gpio_p = gpio_p + 1)
                PULLDOWN PULLDOWN_gpio (
                    .O(gpio[gpio_p])
                );
        endgenerate

	initial begin
            // Initialize Inputs
            clk = 0;
            rx = 0;
            rmii_clk = 1;
            rst = 0;
            #100
            rst = 1;

            // Wait 100 ns for global reset to finish
            #100;

            // Add stimulus here

	end
	
	always #10 clk <= !clk;

        always #11 rmii_clk <= !rmii_clk;
      
endmodule

