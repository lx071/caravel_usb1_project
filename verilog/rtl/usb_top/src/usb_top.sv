
module usb_top 

     (  
`ifdef USE_POWER_PINS
   input logic         vccd1,// User area 1 1.8V supply
   input logic         vssd1,// User area 1 digital ground
`endif
    // clock skew adjust
   input logic [3:0]   cfg_cska_usb,
   input logic	       wbd_clk_int,
   output logic	       wbd_clk_usb,

   input logic         usb_rstn    ,  // async reset
   input logic         app_clk     ,
   input logic         usb_clk     ,   // 48Mhz usb clock

        // Reg Bus Interface Signal
   input logic         reg_cs,
   input logic         reg_wr,
   input logic [8:0]   reg_addr,
   input logic [31:0]  reg_wdata,
   input logic [3:0]   reg_be,

        // Outputs
   output logic [31:0] reg_rdata,
   output logic        reg_ack,


   // USB 1.1 HOST I/F
   input  logic        usb_in_dp              ,
   input  logic        usb_in_dn              ,

   output logic        usb_out_dp             ,
   output logic        usb_out_dn             ,
   output logic        usb_out_tx_oen         ,
   
   output logic        usb_intr_o            

     );

// usb clock skew control
clk_skew_adjust u_skew_usb
       (
`ifdef USE_POWER_PINS
               .vccd1      (vccd1                      ),// User area 1 1.8V supply
               .vssd1      (vssd1                      ),// User area 1 digital ground
`endif
	       .clk_in     (wbd_clk_int                 ), 
	       .sel        (cfg_cska_usb               ), 
	       .clk_out    (wbd_clk_usb                ) 
       );

`define SEL_USB   3'b010

//----------------------------------------
//  Register Response Path Mux
//  --------------------------------------

logic [31:0]  reg_usb_rdata;
logic         reg_usb_ack;


assign reg_rdata = reg_usb_rdata;
assign reg_ack   = reg_usb_ack;


wire reg_usb_cs    = (reg_addr[8:6] == `SEL_USB)   ? reg_cs : 1'b0;


usb1_host u_usb_host (
    .usb_clk_i      (usb_clk       ),
    .usb_rstn_i     (usb_rstn      ),

    // USB D+/D-
    .in_dp          (usb_in_dp     ),
    .in_dn          (usb_in_dn     ),

    .out_dp         (usb_out_dp    ),
    .out_dn         (usb_out_dn    ),
    .out_tx_oen     (usb_out_tx_oen),

    // Master Port
    .wbm_rst_n      (usb_rstn      ),  // Regular Reset signal
    .wbm_clk_i      (app_clk       ),  // System clock
    .wbm_stb_i      (reg_usb_cs    ),  // strobe/request
    .wbm_adr_i      (reg_addr[5:0]),  // address
    .wbm_we_i       (reg_wr        ),  // write
    .wbm_dat_i      (reg_wdata     ),  // data output
    .wbm_sel_i      (reg_be        ),  // byte enable
    .wbm_dat_o      (reg_usb_rdata ),  // data input
    .wbm_ack_o      (reg_usb_ack   ),  // acknowlegement
    .wbm_err_o      (              ),  // error

    // Outputs
    .usb_intr_o    ( usb_intr_o    )

    );


endmodule

