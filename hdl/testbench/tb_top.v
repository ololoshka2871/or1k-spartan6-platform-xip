`include "../timescale.v"

////////////////////////////////////////////////////////////////////////////////
//
// Create Date:   11:16:19 04/10/2016
// Design Name:   tb_top
// 
////////////////////////////////////////////////////////////////////////////////

`include "config.v"

module tb_top;

	// Inputs
	reg clk;
        reg rx;
	
	// Outputs
        wire tx;
	
	reg rst = 1'b1;

        wire     flash_CS;
        wire     sck_o;
        wire     mosi_o;

        wire     phy_tx_en;
        reg      rmii_clk;
        wire     mii_mdclk;
        wire     mii_mdio;
        wire  [1:0]   rmii_tx_data;

        wire [`GPIO_COUNT-1:0]     gpio;

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
            .sck_o(sck_o),
            .mosi_o(mosi_o),
            .miso_i(mosi_o)
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
            // Wait 100 ns for global reset to finish
            #100;

            // Add stimulus here

	end
	
	always #10 clk <= !clk;

        always #11 rmii_clk <= !rmii_clk;
      
endmodule

