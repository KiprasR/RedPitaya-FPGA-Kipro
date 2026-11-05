# Loaded by the repository's normal open_vivado.bat v0.94 Z10 flow.
# Hardware: one PS7 instance; no AXI peripherals or Red Pitaya application IP.
# Removing PL peripherals also removes their register interfaces to Linux.

if {[get_property PART [current_project]] ne "xc7z010clg400-1"} {
    error "This LED configuration is for MODEL=Z10 (xc7z010clg400-1)."
}
create_bd_design system
set led_ps [create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7]

# Reuse the repository's board-specific DDR, MIO and processor clock settings.
source [file normalize [file join [file dirname [info script]] .. .. barebones ip ps7_config.tcl]]
configure_ps7 $led_ps

# Disable the unused PL interfaces and EMIO peripheral ports.
# The existing MIO peripherals (Ethernet, SD, UART, etc.) are retained.
set_property -dict [list \
    CONFIG.PCW_USE_M_AXI_GP0 {0} \
    CONFIG.PCW_USE_M_AXI_GP1 {0} \
    CONFIG.PCW_USE_S_AXI_GP0 {0} \
    CONFIG.PCW_USE_S_AXI_GP1 {0} \
    CONFIG.PCW_USE_S_AXI_HP0 {0} \
    CONFIG.PCW_USE_S_AXI_HP1 {0} \
    CONFIG.PCW_USE_S_AXI_HP2 {0} \
    CONFIG.PCW_USE_S_AXI_HP3 {0} \
    CONFIG.PCW_USE_S_AXI_ACP {0} \
    CONFIG.PCW_USE_FABRIC_INTERRUPT {0} \
    CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {0} \
    CONFIG.PCW_I2C1_PERIPHERAL_ENABLE {0} \
    CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {0} \
    CONFIG.PCW_CAN0_PERIPHERAL_ENABLE {0} \
    CONFIG.PCW_CAN1_PERIPHERAL_ENABLE {0} \
    CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {0} \
    CONFIG.PCW_EN_CLK0_PORT {1} \
    CONFIG.PCW_EN_RST0_PORT {1} \
    CONFIG.PCW_EN_CLK1_PORT {0} \
    CONFIG.PCW_EN_CLK2_PORT {0} \
    CONFIG.PCW_EN_CLK3_PORT {0} \
    CONFIG.PCW_EN_RST1_PORT {0} \
    CONFIG.PCW_EN_RST2_PORT {0} \
    CONFIG.PCW_EN_RST3_PORT {0} \
    CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
    CONFIG.PCW_FPGA_FCLK1_ENABLE {0} \
    CONFIG.PCW_FPGA_FCLK2_ENABLE {0} \
    CONFIG.PCW_FPGA_FCLK3_ENABLE {0} \
    CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {125.000000} \
] $led_ps

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR
create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO
connect_bd_intf_net [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7/DDR]
connect_bd_intf_net [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7/FIXED_IO]

# Copy the PS pin metadata exactly (Vivado may report 124999999 Hz).
set led_fclk_hz [get_property CONFIG.FREQ_HZ [get_bd_pins processing_system7/FCLK_CLK0]]
create_bd_port -dir O -type clk -freq_hz $led_fclk_hz FCLK_CLK0
create_bd_port -dir O -type rst FCLK_RESET0_N
set_property CONFIG.ASSOCIATED_RESET {FCLK_RESET0_N} [get_bd_ports FCLK_CLK0]
set_property CONFIG.POLARITY {ACTIVE_LOW} [get_bd_ports FCLK_RESET0_N]
connect_bd_net [get_bd_pins processing_system7/FCLK_CLK0] [get_bd_ports FCLK_CLK0]
connect_bd_net [get_bd_pins processing_system7/FCLK_RESET0_N] [get_bd_ports FCLK_RESET0_N]

validate_bd_design
save_bd_design
