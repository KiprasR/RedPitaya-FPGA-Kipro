# Red Pitaya Z10 LEDs. DDR/MIO and FCLK constraints come from the PS IP.
set_property IOSTANDARD LVCMOS33 [get_ports {led_o[*]}]
set_property DRIVE 4 [get_ports {led_o[*]}]
set_property SLEW SLOW [get_ports {led_o[*]}]
set_property PACKAGE_PIN F16 [get_ports {led_o[0]}]
set_property PACKAGE_PIN F17 [get_ports {led_o[1]}]
set_property PACKAGE_PIN G15 [get_ports {led_o[2]}]
set_property PACKAGE_PIN H15 [get_ports {led_o[3]}]
set_property PACKAGE_PIN K14 [get_ports {led_o[4]}]
set_property PACKAGE_PIN G14 [get_ports {led_o[5]}]
set_property PACKAGE_PIN J15 [get_ports {led_o[6]}]
set_property PACKAGE_PIN J14 [get_ports {led_o[7]}]

# LEDs have no synchronous external receiver; internal counter timing is checked.
set_false_path -to [get_ports {led_o[*]}]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pulldown [current_design]
