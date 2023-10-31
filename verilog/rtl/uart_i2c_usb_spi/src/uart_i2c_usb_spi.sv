
//////////////////////////////////////////////////////////////////////////////
// SPDX-FileCopyrightText: 2021 , Dinesh Annayya                          
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0
// SPDX-FileContributor: Created by Dinesh Annayya <dinesha@opencores.org>
//
//////////////////////////////////////////////////////////////////////
////                                                              ////
////  integrated UART,I2C Master, SPU Master & USB1.1 Host        ////
////                                                              ////
////                                                              ////
////  This file is part of the riscduino cores project            ////
////  https://github.com/dineshannayya/riscduino.git              ////
////                                                              ////
////  Description: This module integarte Uart , I2C Master        ////
////   SPI Master and USB 1.1 Host.                               ////
////                                                              ////
////                                                              ////
////  To Do:                                                      ////
////    nothing                                                   ////
////                                                              ////
////  Author(s):                                                  ////
////      - Dinesh Annayya, dinesha@opencores.org                 ////
////                                                              ////
////  Revision :                                                  ////
////         0.2 - 7 April 2022, Dinesh-A                         ////
////               2nd Uart Integrated                            ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2000 Authors and OPENCORES.ORG                 ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

module uart_i2c_usb_spi_top 

     (  
`ifdef USE_POWER_PINS
   input logic         vccd1,// User area 1 1.8V supply
   input logic         vssd1,// User area 1 digital ground
`endif
    // clock skew adjust
   input logic [3:0]   cfg_cska_uart,
   input logic	       wbd_clk_int,
   output logic	       wbd_clk_uart,

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

// uart clock skew control
clk_skew_adjust u_skew_uart
       (
`ifdef USE_POWER_PINS
               .vccd1      (vccd1                      ),// User area 1 1.8V supply
               .vssd1      (vssd1                      ),// User area 1 digital ground
`endif
	       .clk_in     (wbd_clk_int                 ), 
	       .sel        (cfg_cska_uart               ), 
	       .clk_out    (wbd_clk_uart                ) 
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

