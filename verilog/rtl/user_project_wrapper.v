`include "user_params.svh"

module user_project_wrapper (
`ifdef USE_POWER_PINS
    inout vdda1,	// User area 1 3.3V supply
    inout vdda2,	// User area 2 3.3V supply
    inout vssa1,	// User area 1 analog ground
    inout vssa2,	// User area 2 analog ground
    inout vccd1,	// User area 1 1.8V supply
    inout vccd2,	// User area 2 1.8v supply
    inout vssd1,	// User area 1 digital ground
    inout vssd2,	// User area 2 digital ground
`endif
    input   wire                       wb_clk_i        ,  // System clock
    input   wire                       user_clock2     ,  // user Clock
    input   wire                       wb_rst_i        ,  // Regular Reset signal

    input   wire                       wbs_cyc_i       ,  // strobe/request
    input   wire                       wbs_stb_i       ,  // strobe/request
    input   wire [WB_WIDTH-1:0]        wbs_adr_i       ,  // address
    input   wire                       wbs_we_i        ,  // write
    input   wire [WB_WIDTH-1:0]        wbs_dat_i       ,  // data output
    input   wire [3:0]                 wbs_sel_i       ,  // byte enable
    output  wire [WB_WIDTH-1:0]        wbs_dat_o       ,  // data input
    output  wire                       wbs_ack_o       ,  // acknowlegement

    // Analog (direct connection to GPIO pad---use with caution)
    // Note that analog I/O is not available on the 7 lowest-numbered
    // GPIO pads, and so the analog_io indexing is offset from the
    // GPIO indexing by 7 (also upper 2 GPIOs do not have analog_io).
    inout [28:0] analog_io,
 
    // Logic Analyzer Signals
    input  wire [127:0]                la_data_in      ,
    output wire [127:0]                la_data_out     ,
    input  wire [127:0]                la_oenb         ,
 

    // IOs
    input  wire  [37:0]                io_in           ,
    output wire  [37:0]                io_out          ,
    output wire  [37:0]                io_oeb          ,

    output wire  [2:0]                 user_irq             

);

//---------------------------------------------------
// Local Parameter Declaration
// --------------------------------------------------

parameter     WB_WIDTH      = 32; // WB ADDRESS/DARA WIDTH



//---------------------------------------------------------------------
// WB HOST Interface
//---------------------------------------------------------------------
wire                           wbd_int_cyc_i                          ; // strobe/request
wire                           wbd_int_stb_i                          ; // strobe/request
wire   [WB_WIDTH-1:0]          wbd_int_adr_i                          ; // address
wire                           wbd_int_we_i                           ; // write
wire   [WB_WIDTH-1:0]          wbd_int_dat_i                          ; // data output
wire   [3:0]                   wbd_int_sel_i                          ; // byte enable
wire   [WB_WIDTH-1:0]          wbd_int_dat_o                          ; // data input
wire                           wbd_int_ack_o                          ; // acknowlegement
wire                           wbd_int_err_o                          ; // error


//---------------------------------------------------------------------
//    Global Register Wishbone Interface
//---------------------------------------------------------------------
wire                           wbd_pinmux_stb_o                       ; // strobe/request
wire   [10:0]                  wbd_pinmux_adr_o                       ; // address
wire                           wbd_pinmux_we_o                        ; // write
wire   [WB_WIDTH-1:0]          wbd_pinmux_dat_o                       ; // data output
wire   [3:0]                   wbd_pinmux_sel_o                       ; // byte enable
wire                           wbd_pinmux_cyc_o                       ;
wire   [WB_WIDTH-1:0]          wbd_pinmux_dat_i                       ; // data input
wire                           wbd_pinmux_ack_i                       ; // acknowlegement
wire                           wbd_pinmux_err_i                       ; // error

//---------------------------------------------------------------------
//    Global Register Wishbone Interface
//---------------------------------------------------------------------
wire                           wbd_usb_stb_o                         ; // strobe/request
wire   [8:0]                   wbd_usb_adr_o                         ; // address
wire                           wbd_usb_we_o                          ; // write
wire   [31:0]                  wbd_usb_dat_o                         ; // data output
wire   [3:0]                   wbd_usb_sel_o                         ; // byte enable
wire                           wbd_usb_cyc_o                         ;
wire   [31:0]                  wbd_usb_dat_i                         ; // data input
wire                           wbd_usb_ack_i                         ; // acknowlegement
wire                           wbd_usb_err_i                         ;  // error


wire                           usb_rst_n                              ; // i2c reset

wire                           usb_clk                                ;
wire                           wbd_clk_int                            ;
wire                           wbd_clk_wh                             ;

wire                           wbd_clk_pinmux                         ;
wire                           wbd_int_rst_n                          ;
wire                           wbd_pll_rst_n                          ;


wire [31:0]                    cfg_clk_skew_ctrl1                     ;
wire [31:0]                    cfg_clk_skew_ctrl2                     ;
wire [3:0]                     cfg_wcska_wi                           ; // clock skew adjust for wishbone interconnect
wire [3:0]                     cfg_wcska_wh                           ; // clock skew adjust for web host



// Progammable Clock Skew inserted signals
wire                           wbd_clk_wi_skew                        ; // clock for wishbone interconnect with clock skew

wire                           wbd_clk_usb_skew                      ; // clock for usb with clock skew


wire [31:0]                    spi_debug                              ;
wire [31:0]                    pinmux_debug                           ;
wire [63:0]                    riscv_debug                            ;

// USB I/F
wire                           usb_dp_o                               ;
wire                           usb_dn_o                               ;
wire                           usb_oen                                ;
wire                           usb_dp_i                               ;
wire                           usb_dn_i                               ;

wire                           usb_intr_o                             ;


wire                           usb_mclk                              ;
wire                           pinmux_mclk                            ;



//----------------------------------------------------------------
//  Digital PLL I/F
//  -------------------------------------------------------------
wire                           cfg_pll_enb                            ; // Enable PLL
wire [4:0]                     cfg_pll_fed_div                        ; // PLL feedback division ratio
wire                           cfg_dco_mode                           ; // Run PLL in DCO mode
wire [25:0]                    cfg_dc_trim                            ; // External trim for DCO mode
wire                           pll_ref_clk                            ; // Input oscillator to match
wire [1:0]                     pll_clk_out                            ; // Two 90 degree clock phases

wire                           xtal_clk                               ;
wire                           e_reset_n                              ;
wire                           p_reset_n                              ;
wire                           s_reset_n                              ;

wire                           e_reset_n_rp                           ;
wire                           p_reset_n_rp                           ;
wire                           s_reset_n_rp                           ;


/////////////////////////////////////////////////////////
// System/WB Clock Skew Ctrl
////////////////////////////////////////////////////////

assign cfg_wcska_wi          = cfg_clk_skew_ctrl1[3:0];
assign cfg_wcska_wh          = cfg_clk_skew_ctrl1[7:4];

wire [127:0] la_data_out_int    = {pinmux_debug,spi_debug,riscv_debug};

wire   int_pll_clock       = pll_clk_out[0];


//----------------------------------------------------------
// Bus Repeater Initiatiation
//----------------------------------------------------------
wire  [37:0]                io_in_rp           ;
wire  [37:0]                io_in_rp1          ;
wire  [37:0]                io_in_rp2          ;
wire  [37:0]                io_out_int         ;
wire  [37:0]                io_oeb_int         ;
wire  [37:0]                io_out_rp1         ;
wire  [37:0]                io_oeb_rp1         ;
wire                        user_clock2_rp     ;

`include "bus_repeater.sv"

/***********************************************
 Wishbone HOST
*************************************************/

wb_host u_wb_host(
`ifdef USE_POWER_PINS
          .vccd1                   (vccd1                   ),// User area 1 1.8V supply
          .vssd1                   (vssd1                   ),// User area 1 digital ground
`endif

          .cfg_fast_sim            (cfg_fast_sim            ),
          .user_clock1             (wb_clk_i_rp             ),
          .user_clock2             (user_clock2_rp          ),
          .int_pll_clock           (int_pll_clock           ),

       // to/from Pinmux
          .xtal_clk                (xtal_clk                ),
	      .e_reset_n               (e_reset_n               ),  // external reset
	      .p_reset_n               (p_reset_n               ),  // power-on reset
          .s_reset_n               (s_reset_n               ),  // soft reset


          .wbd_int_rst_n           (wbd_int_rst_n           ),
          .wbd_pll_rst_n           (wbd_pll_rst_n           ),

    // Master Port
          .wbm_rst_i               (wb_rst_i_rp             ),  
          .wbm_clk_i               (wb_clk_i_rp             ),  
          .wbm_cyc_i               (wbs_cyc_i_rp            ),  
          .wbm_stb_i               (wbs_stb_i_rp            ),  
          .wbm_adr_i               (wbs_adr_i_rp            ),  
          .wbm_we_i                (wbs_we_i_rp             ),  
          .wbm_dat_i               (wbs_dat_i_rp            ),  
          .wbm_sel_i               (wbs_sel_i_rp            ),  
          .wbm_dat_o               (wbs_dat_int_o           ),  
          .wbm_ack_o               (wbs_ack_int_o           ),  
          .wbm_err_o               (                        ),  

    // Clock Skeq Adjust
          .wbd_clk_int             (wbd_clk_int             ),
          .wbd_clk_wh              (wbd_clk_wh              ),  
          .cfg_cska_wh             (cfg_wcska_wh             ),

    // Slave Port
          .wbs_clk_out             (wbd_clk_int             ),
          .wbs_clk_i               (wbd_clk_wh              ),  
          .wbs_cyc_o               (wbd_int_cyc_i           ),  
          .wbs_stb_o               (wbd_int_stb_i           ),  
          .wbs_adr_o               (wbd_int_adr_i           ),  
          .wbs_we_o                (wbd_int_we_i            ),  
          .wbs_dat_o               (wbd_int_dat_i           ),  
          .wbs_sel_o               (wbd_int_sel_i           ),  
          .wbs_dat_i               (wbd_int_dat_o           ),  
          .wbs_ack_i               (wbd_int_ack_o           ),  
          .wbs_err_i               (wbd_int_err_o           ),  

          .cfg_clk_skew_ctrl1      (cfg_clk_skew_ctrl1      ),
          .cfg_clk_skew_ctrl2      (cfg_clk_skew_ctrl2      ),

          .la_data_in              (la_data_in_rp[17:0]     ),

          .sdout_oen               (                        )



    );

/****************************************************************
  Digital PLL
*****************************************************************/

// This rtl/gds picked from efabless caravel project 
dg_pll   u_pll(
`ifdef USE_POWER_PINS
    .VPWR                           (vccd1                  ),
    .VGND                           (vssd1                  ),
`endif
    .resetb                         (wbd_pll_rst_n          ), 
    .enable                         (cfg_pll_enb            ), 
    .div                            (cfg_pll_fed_div        ), 
    .dco                            (cfg_dco_mode           ), 
    .ext_trim                       (cfg_dc_trim            ),
    .osc                            (pll_ref_clk            ), 
    .clockp                         (pll_clk_out            ) 
    );



//---------------------------------------------------
// wb_interconnect
//---------------------------------------------------

wb_interconnect  #(
	`ifndef SYNTHESIS
          .CH_CLK_WD          (3                            ),
          .CH_DATA_WD         (158                          )
        `endif
	) u_intercon (
`ifdef USE_POWER_PINS
       .vccd1              (vccd1                        ),// User area 1 1.8V supply
       .vssd1              (vssd1                        ),// User area 1 digital ground
`endif

	  .ch_data_in             ({

                                  p_reset_n,
                                  e_reset_n
                              
			             }                             ),
	  .ch_data_out            ({

                                  p_reset_n_rp,
                                  e_reset_n_rp
                              
                               } ),
     // Clock Skew adjust
          .wbd_clk_int        (wbd_clk_int                  ),// wb clock without skew 
          .cfg_cska_wi        (cfg_wcska_wi                 ), 
          .wbd_clk_wi         (wbd_clk_wi_skew              ),// wb clock with skew

          .mclk_raw           (wbd_clk_int                  ), // wb clock without skew
          .clk_i              (wbd_clk_wi_skew              ), // wb clock with skew
          .rst_n              (wbd_int_rst_n                ),

         // Master 0 Interface
          .m0_wbd_dat_i       (wbd_int_dat_i                ),
          .m0_wbd_adr_i       (wbd_int_adr_i                ),
          .m0_wbd_sel_i       (wbd_int_sel_i                ),
          .m0_wbd_we_i        (wbd_int_we_i                 ),
          .m0_wbd_cyc_i       (wbd_int_cyc_i                ),
          .m0_wbd_stb_i       (wbd_int_stb_i                ),
          .m0_wbd_dat_o       (wbd_int_dat_o                ),
          .m0_wbd_ack_o       (wbd_int_ack_o                ),
          .m0_wbd_err_o       (wbd_int_err_o                ),
         
         
         // Slave 1 Interface
       // .s1_wbd_err_i       (1'b0                         ), - Moved inside IP
          .s1_mclk            (usb_mclk                    ),
          .s1_wbd_dat_i       (wbd_usb_dat_i               ),
          .s1_wbd_ack_i       (wbd_usb_ack_i               ),
          .s1_wbd_dat_o       (wbd_usb_dat_o               ),
          .s1_wbd_adr_o       (wbd_usb_adr_o               ),
          .s1_wbd_sel_o       (wbd_usb_sel_o               ),
          .s1_wbd_we_o        (wbd_usb_we_o                ),  
          .s1_wbd_cyc_o       (wbd_usb_cyc_o               ),
          .s1_wbd_stb_o       (wbd_usb_stb_o               ),
         
         // Slave 2 Interface
       // .s2_wbd_err_i       (1'b0                         ), - Moved inside IP
          .s2_mclk            (pinmux_mclk                  ),
          .s2_wbd_dat_i       (wbd_pinmux_dat_i             ),
          .s2_wbd_ack_i       (wbd_pinmux_ack_i             ),
          .s2_wbd_dat_o       (wbd_pinmux_dat_o             ),
          .s2_wbd_adr_o       (wbd_pinmux_adr_o             ),
          .s2_wbd_sel_o       (wbd_pinmux_sel_o             ),
          .s2_wbd_we_o        (wbd_pinmux_we_o              ),  
          .s2_wbd_cyc_o       (wbd_pinmux_cyc_o             ),
          .s2_wbd_stb_o       (wbd_pinmux_stb_o             )


	);

//-----------------------------------------------
// usb
//-----------------------------------------------

usb_top   u_usb_top (
`ifdef USE_POWER_PINS
          .vccd1              (vccd1                        ),// User area 1 1.8V supply
          .vssd1              (vssd1                        ),// User area 1 digital ground
`endif
          .wbd_clk_int        (usb_mclk                    ), 
          
          .wbd_clk_usb       (wbd_clk_usb_skew            ),

          .usb_rstn           (usb_rst_n                    ), // USB reset
          .app_clk            (wbd_clk_usb_skew            ),
          .usb_clk            (usb_clk                      ),

        // Reg Bus Interface Signal
          .reg_cs             (wbd_usb_stb_o               ),
          .reg_wr             (wbd_usb_we_o                ),
          .reg_addr           (wbd_usb_adr_o[8:0]          ),
          .reg_wdata          (wbd_usb_dat_o               ),
          .reg_be             (wbd_usb_sel_o               ),

       // Outputs
          .reg_rdata          (wbd_usb_dat_i               ),
          .reg_ack            (wbd_usb_ack_i               ),

          .usb_in_dp          (usb_dp_i                     ),
          .usb_in_dn          (usb_dn_i                     ),

          .usb_out_dp         (usb_dp_o                     ),
          .usb_out_dn         (usb_dn_o                     ),
          .usb_out_tx_oen     (usb_oen                      ),
       
          .usb_intr_o         (usb_intr_o                   )

     );

//---------------------------------------
// Pinmux
//---------------------------------------

pinmux_top u_pinmux(
`ifdef USE_POWER_PINS
          .vccd1              (vccd1                        ),// User area 1 1.8V supply
          .vssd1              (vssd1                        ),// User area 1 digital ground
`endif
        //clk skew adjust
          .wbd_clk_int        (pinmux_mclk                  ),
          .wbd_clk_pinmux     (wbd_clk_pinmux_skew          ),

        // System Signals
        // Inputs
          .mclk               (wbd_clk_pinmux_skew          ),
          .e_reset_n          (e_reset_n_rp                 ),
          .p_reset_n          (p_reset_n_rp                 ),
          .s_reset_n          (wbd_int_rst_n                ),

          .user_clock1        (wb_clk_i_rp                  ),
          .user_clock2        (user_clock2_rp               ),
          .int_pll_clock      (int_pll_clock                ),
          .xtal_clk           (xtal_clk                     ),

          .usb_clk            (usb_clk                      ),
	// Reset Control
  
          .usb_rst_n          (usb_rst_n                    ),


        // Reg Bus Interface Signal
          .reg_cs             (wbd_pinmux_stb_o             ),
          .reg_wr             (wbd_pinmux_we_o              ),
          .reg_addr           (wbd_pinmux_adr_o             ),
          .reg_wdata          (wbd_pinmux_dat_o             ),
          .reg_be             (wbd_pinmux_sel_o             ),

       // Outputs
          .reg_rdata          (wbd_pinmux_dat_i             ),
          .reg_ack            (wbd_pinmux_ack_i             ),

          .user_irq           (user_irq                     ),
          .usb_intr           (usb_intr_o                   ),


       // Digital IO
          .digital_io_out     (io_out_int                   ),
          .digital_io_oen     (io_oeb_int                   ),
          .digital_io_in      (io_in_rp                     ),


       // USB I/F
          .usb_dp_o           (usb_dp_o                     ),
          .usb_dn_o           (usb_dn_o                     ),
          .usb_oen            (usb_oen                      ),
          .usb_dp_i           (usb_dp_i                     ),
          .usb_dn_i           (usb_dn_i                     ),

     
          .pinmux_debug       (pinmux_debug                 ),
     
          .cfg_pll_enb        (cfg_pll_enb                  ), 
          .cfg_pll_fed_div    (cfg_pll_fed_div              ), 
          .cfg_dco_mode       (cfg_dco_mode                 ), 
          .cfg_dc_trim        (cfg_dc_trim                  ),
          .pll_ref_clk        (pll_ref_clk                  )
          

   ); 




endmodule : user_project_wrapper
