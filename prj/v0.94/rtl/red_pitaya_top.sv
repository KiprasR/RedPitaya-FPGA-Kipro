// Red Pitaya Z10: PS interface and LED counter only.
module red_pitaya_top #(
    parameter bit [159:0] GITH = '0
) (
    inout wire [53:0] FIXED_IO_mio,
    inout wire FIXED_IO_ps_clk, FIXED_IO_ps_porb, FIXED_IO_ps_srstb,
    inout wire FIXED_IO_ddr_vrn, FIXED_IO_ddr_vrp,
    inout wire [14:0] DDR_addr,
    inout wire [2:0] DDR_ba,
    inout wire DDR_cas_n, DDR_ck_n, DDR_ck_p, DDR_cke, DDR_cs_n,
    inout wire [3:0] DDR_dm,
    inout wire [31:0] DDR_dq,
    inout wire [3:0] DDR_dqs_n, DDR_dqs_p,
    inout wire DDR_odt, DDR_ras_n, DDR_reset_n, DDR_we_n,
    output wire [7:0] led_o
);
    wire fclk, clk, resetn;
    system system_i (.FCLK_CLK0(fclk), .FCLK_RESET0_N(resetn), .*);
    BUFG clock_buffer (.I(fclk), .O(clk));

    (* ASYNC_REG = "TRUE" *) reg [1:0] reset_sync = 2'b00;
    always @(posedge clk or negedge resetn)
        if (!resetn) reset_sync <= 2'b00;
        else         reset_sync <= {reset_sync[0], 1'b1};

    reg [26:0] counter = '0;
    always @(posedge clk)
        if (!reset_sync[1]) counter <= '0;
        else                counter <= counter + 1'b1;

    // 125 MHz / 2^27 = 0.9313 Hz: about 0.537 seconds per state.
    assign led_o = {8{counter[26]}};
endmodule
