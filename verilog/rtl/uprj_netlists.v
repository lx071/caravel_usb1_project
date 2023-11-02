// SPDX-FileCopyrightText: 2020 Efabless Corporation
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

// Include caravel global defines for the number of the user project IO pads 
`include "defines.v"
`define USE_POWER_PINS
`define UNIT_DELAY #0.1

`ifdef GL
       `include "libs.ref/sky130_fd_sc_hd/verilog/primitives.v"
       `include "libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v"
       `include "libs.ref/sky130_fd_sc_hvl/verilog/primitives.v"
       `include "libs.ref/sky130_fd_sc_hvl/verilog/sky130_fd_sc_hvl.v"
       `include "libs.ref//sky130_fd_sc_hd/verilog/sky130_ef_sc_hd__fakediode_2.v"

        `include "wb_interconnect.v"
        `include "user_project_wrapper.v"
        `include "wb_host.v"
	`include "clk_buf.v"

`else
     `include "libs.ref/sky130_fd_sc_hd/verilog/primitives.v"
     `include "libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v"
     `include "libs.ref/sky130_fd_sc_hvl/verilog/primitives.v"
     `include "libs.ref/sky130_fd_sc_hvl/verilog/sky130_fd_sc_hvl.v"


     `ifndef FULL_CHIP_SIM 
        `include "sram_macros/sky130_sram_2kbyte_1rw1r_32x512_8.v"
     `endif
     `include "pinmux/src/pinmux.sv"
     `include "pinmux/src/pinmux_reg.sv"
     `include "pinmux/src/gpio_intr.sv"
     `include "pinmux/src/pwm.sv"
     `include "pinmux/src/timer.sv"
     `include "lib/pulse_gen_type1.sv"
     `include "lib/pulse_gen_type2.sv"

     `include "uart/src/uart_rxfsm.sv"
     `include "uart/src/uart_txfsm.sv"
     `include "lib/async_fifo_th.sv"  
     `include "lib/reset_sync.sv"  
     `include "lib/double_sync_low.v"  
     `include "lib/clk_buf.v"  

     `include "usb1_host/src/core/usbh_core.sv"
     `include "usb1_host/src/core/usbh_crc16.sv"
     `include "usb1_host/src/core/usbh_crc5.sv"
     `include "usb1_host/src/core/usbh_fifo.sv"
     `include "usb1_host/src/core/usbh_sie.sv"
     `include "usb1_host/src/phy/usb_fs_phy.v"
     `include "usb1_host/src/phy/usb_transceiver.v"
     `include "usb1_host/src/top/usb1_host.sv"

     `include "usb_top/src/usb_top.sv"

     `include "lib/async_fifo.sv"  
     `include "lib/registers.v"
     `include "lib/clk_ctl.v"
     `include "lib/ser_inf_32b.sv"
     `include "lib/ser_shift.sv"

     `include "wb_host/src/wb_host.sv"
     `include "lib/async_wb.sv"

     `include "lib/sync_wbb.sv"
     `include "lib/sync_fifo2.sv"
     `include "wb_interconnect/src/wb_arb.sv"
     `include "wb_interconnect/src/wb_slave_port.sv"
     `include "wb_interconnect/src/wb_interconnect.sv"

     `include "lib/sync_fifo.sv"

    `include "uart2wb/src/uart2wb.sv" 
    `include "uart2wb/src/uart2_core.sv" 
    `include "uart2wb/src/uart_msg_handler.v" 
     `include "lib/async_reg_bus.sv"

     `include "user_project_wrapper.v"
     // we are using netlist file for clk_skew_adjust as it has 
     // standard cell + power pin
     `include "lib/clk_skew_adjust.gv"
     `include "lib/ctech_cells.sv"

`endif
