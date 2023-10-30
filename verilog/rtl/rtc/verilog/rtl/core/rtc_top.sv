/*********************************************************************************
 SPDX-FileCopyrightText: 2021 , Dinesh Annayya                          
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 SPDX-License-Identifier: Apache-2.0
 SPDX-FileContributor: Created by Dinesh Annayya <dinesh.annayya@gmail.com>

***********************************************************************************/
/**********************************************************************************
                                                              
                   RTC Top Module                                             
                                                              
  Description: RTC Top module Integrate
           A. RTC core
           B. RTC Reg
      
  To Do:                                                      
                                                              
  Author(s):                                                  
      - Dinesh Annayya, dinesh.annayya@gmail.com                 
                                                              
  Revision :                                                  
     0.0  - Oct 15, 2022 
            Initial Version picked from http://www.opencores.org/cores/rtc/
     0.1  - Nov 16, 2022
            Following changes are done
            1. Total design change to implement design running is RTC clock: 32768 Hz
            2. Timer Increment and Reset functionality correction
            3. Inteface change to Register interface instead of WB
            4. Maped the Most of Register to DS3231 format
            5. Alarm1/Alarm2 design correction
     0.2 - Nov 18, 2022
           1. Block is split as core and reg 
           2. Additional feature added
           3. Aligned 64 Bit RTC Time+ Date access support added
           4. RTC Halt/Reset config added
           5. fast mode is connected to register
                                                              
************************************************************************************/
/*********************************************************************************************
   Date Sheet Reference: https://datasheets.maximintegrated.com/en/ds/DS3231.pdf
   Register Decoding

   Addr    Bit-7   Bit-6   Bit-5   Bit-4   Bit-3   Bit-2   Bit-1   Bit-0  Function   Range
   0x00    0       <- 10   Second     ->   <-   Second                ->  Second     00-59
   0x01    0       <- 10   Minute     ->   <-   Minute                ->  Minute     00-59
   0x02    0       12      10 Hour 10 Hour <-   Hours                 ->  Hours      1 - 12
           0       24      PM/AM                                                     +AM/PM
                                                                                     00-23
   0x03    0       0       0       0       0       <-  DAY            ->  Day        01-07
   0x04    0       0       <- 10 Date ->   <-   Date                  ->  Date       01-31
   0x05    0       0       0       10 Month<-    Month                ->  Month      01-12
   0x06    <-  10 Year                ->   <-   Year                  ->  Year       00-99
   0x07    <   10 Century             ->   <-   Century               ->  Century    00-99
   0x08    <-       Alarm0 Time - Second                               ->
   0x09    <-       Alarm0 Time - Minute                               ->
   0x0A    <-       Alarm0 Time - Hour                                 ->
   0x0B    <-       Alarm0 Time - Day/Date                             ->
   0x0C    <-       Alarm1 Time - Second                               ->
   0x0D    <-       Alarm1 Time - Minute                               ->
   0x0E    <-       Alarm1 Time - Hour                                 ->
   0x0F    <-       Alarm1 Time - Day/Date                             ->
   0x10    <-    Alarm1 Ctrl          -><- Alarm0 Ctrl                 ->  Alarm Cntrl
   0x11                                                                -> Interrupt Enable
   0x12                                                                -> Interrupt Status

********************************************************************************************/

module rtc_top(
    input  logic        rst_n, 
    input  logic        sys_clk, 


    input  logic        reg_cs, 
    input  logic [4:0]  reg_addr, 
    input  logic [31:0] reg_wdata, 
    input  logic [3:0]  reg_be, 
    input  logic        reg_wr, 
	output logic [31:0] reg_rdata, 
    output logic        reg_ack, 


    // RTC clock Domain
	input  logic        rtc_clk, 


    output logic        rtc_intr,

   // Debug Signals
    output  logic       inc_time_s,
    output  logic       inc_date_d

);

//--------------------------------------------------
// Local Wire decleration
//--------------------------------------------------
//--------------------------------------------------
// RTC Register I/F
//--------------------------------------------------
logic        rtc_reg_cs       ;
logic [4:0]  rtc_reg_addr     ;
logic [31:0] rtc_reg_wdata    ;
logic [3:0]  rtc_reg_be       ;
logic        rtc_reg_wr       ;
logic [31:0] rtc_reg_rdata    ;
logic        rtc_reg_ack      ;

//--------------------------------------------------
// RTC Core Config I/f
//--------------------------------------------------
logic        cfg_rtc_update   ; // Update RTC core time/date with config
logic        cfg_rtc_capture  ; // Capture RTC core time/date with config
logic        cfg_rtc_halt     ; // Halt RTC Operation
logic        cfg_rtc_reset    ; // Reset RTC Operation
logic        cfg_fast_time    ; // Run Time is Fast Mode
logic        cfg_fast_date    ; // Run Date is Fast Mode
logic        cfg_hmode        ; // 12/24 hour mode
logic [31:0] cfg_time         ;
logic [31:0] cfg_date         ;

//---------------------------------------
// Increment Pulse
//----------------------------------------

//input logic             inc_time_s      ; // increment second
logic             inc_time_ts     ; // increment tenth second
logic             inc_time_m      ; // increment minute
logic             inc_time_tm     ; // increment tenth minute
logic             inc_time_h      ; // increment hour
logic             inc_time_th     ; // increment tenth hour
logic             inc_time_dow    ; // increment date of week
//logic             inc_date_d      ; // increment date
logic             inc_date_td     ; // increment tenth date
logic             inc_date_m      ; // increment month
logic             inc_date_tm     ; // increment tength month
logic             inc_date_y      ; // increment year
logic             inc_date_ty     ; // increment tenth year
logic             inc_date_c      ; // increment century
logic             inc_date_tc     ; // increment tenth century

// Counters of RTC Time Register
//
logic	[3:0]		time_s          ;// Seconds counter
logic	[2:0]		time_ts         ;// Ten seconds counter
logic	[3:0]		time_m          ;// Minutes counter
logic	[2:0]		time_tm         ;// Ten minutes counter
logic	[3:0]		time_h          ;// Hours counter
logic	[1:0]		time_th         ;// Ten hours counter
logic	[2:0]		time_dow        ;// Day of week counter
    
//
// Counter of RTC Date Register
//
logic	[3:0]		date_d          ;// Days counter
logic	[1:0]		date_td         ;// Ten days counter
logic	[3:0]		date_m          ;// Months counter
logic			    date_tm         ;// Ten months counter
logic	[3:0]		date_y          ;// Years counter
logic	[3:0]		date_ty         ;// Ten years counter
logic	[3:0]		date_c          ;// Centuries counter
logic	[3:0]		date_tc         ;// Ten centuries counter

logic               rst_sn          ;// Reset sync to sys clk
logic               rst_rn          ;// Reset sync to rtc clk

/***************************************
  Reset Sync to System Clock
***************************************/

reset_sync   u_sync_sclk(
	  .scan_mode  ( 1'b0    ),
      .dclk       ( sys_clk ), 
	  .arst_n     ( rst_n   ), 
      .srst_n     ( rst_sn  )
      );

/***************************************
  Reset Sync to RTC Clock
***************************************/

reset_sync   u_sync_rclk(
	  .scan_mode  ( 1'b0    ),
      .dclk       ( rtc_clk ), 
	  .arst_n     ( rst_n   ), 
      .srst_n     ( rst_rn  )
      );


async_reg_bus #(.AW(5), .TIMEOUT_ENB(0)) u_async_reg_bus(
    // Initiator declartion
        .in_clk                    (sys_clk    ),
        .in_reset_n                (rst_sn     ),
       // Reg Bus Master
       // outputs
         .in_reg_rdata             (reg_rdata  ),
         .in_reg_ack               (reg_ack    ),
         .in_reg_timeout           (),

       // Inputs
         .in_reg_cs                (reg_cs     ),
         .in_reg_addr              (reg_addr   ),
         .in_reg_wdata             (reg_wdata  ),
         .in_reg_wr                (reg_wr     ),
         .in_reg_be                (reg_be     ),

    // Target Declaration
         .out_clk                  (rtc_clk   ),
         .out_reset_n              (rst_rn    ) ,
      // Reg Bus Slave
      // output
         .out_reg_cs               (rtc_reg_cs      ),
         .out_reg_addr             (rtc_reg_addr    ),
         .out_reg_wdata            (rtc_reg_wdata   ),
         .out_reg_wr               (rtc_reg_wr      ),
         .out_reg_be               (rtc_reg_be      ),

      // Inputs
         .out_reg_rdata            (rtc_reg_rdata   ),
         .out_reg_ack              (rtc_reg_ack     )
   );


/********************************
   RTC CORE
*********************************/
rtc_core   u_core (
	// WISHBONE Interface
	.rtc_clk         (rtc_clk         ), 
    .rst_n           (rst_rn          ), 

    // Counters of RTC Time Register
    //
    .time_s         (time_s        ) ,// Seconds counter
    .time_ts        (time_ts       ) ,// Ten seconds counter
    .time_m         (time_m        ) ,// Minutes counter
    .time_tm        (time_tm       ) ,// Ten minutes counter
    .time_h         (time_h        ) ,// Hours counter
    .time_th        (time_th       ) ,// Ten hours counter
    .time_dow       (time_dow      ) ,// Day of week counter
    
    //
    // Counter of RTC Date Register
    //
    .date_d         (date_d      ) ,// Days counter
    .date_td        (date_td     ) ,// Ten days counter
    .date_m         (date_m      ) ,// Months counter
    .date_tm        (date_tm     ) ,// Ten months counter
    .date_y         (date_y      ) ,// Years counter
    .date_ty        (date_ty     ) ,// Ten years counter
    .date_c         (date_c      ) ,// Centuries counter
    .date_tc        (date_tc     ) ,// Ten centuries counter

    // Increment Pulse

    .inc_time_s      (inc_time_s    ), // increment second
    .inc_time_ts     (inc_time_ts   ), // increment tenth second
    .inc_time_m      (inc_time_m    ), // increment minute
    .inc_time_tm     (inc_time_tm   ), // increment tenth minute
    .inc_time_h      (inc_time_h    ), // increment hour
    .inc_time_th     (inc_time_th   ), // increment tenth hour
    .inc_time_dow    (inc_time_dow  ), // increment date of week
    .inc_date_d      (inc_date_d    ), // increment date
    .inc_date_td     (inc_date_td   ), // increment tenth date
    .inc_date_m      (inc_date_m    ), // increment month
    .inc_date_tm     (inc_date_tm   ), // increment tength month
    .inc_date_y      (inc_date_y    ), // increment year
    .inc_date_ty     (inc_date_ty   ), // increment tenth year
    .inc_date_c      (inc_date_c    ), // increment century
    .inc_date_tc     (inc_date_tc   ), // increment tenth century


   // RTC Core I/f
    .fast_sim_time   (cfg_fast_time   ), // Run Time is Fast Mode
    .fast_sim_date   (cfg_fast_date   ), // Run Date is Fast Mode
    .cfg_rtc_update  (cfg_rtc_update  ),
    .cfg_rtc_capture (cfg_rtc_capture ),
    .cfg_rtc_halt    (cfg_rtc_halt    ),
    .cfg_rtc_reset   (cfg_rtc_reset   ),
    .cfg_hmode       (cfg_hmode       ), // 12/24 hour mode
    .cfg_time        (cfg_time        ),
    .cfg_date        (cfg_date        )


);

/********************************
   RTC CORE
*********************************/

rtc_reg   u_reg(
	// WISHBONE Interface
	.rtc_clk         (rtc_clk           ), 
    .rst_n           (rst_rn            ), 

    // Reg I/F

    .reg_cs          (rtc_reg_cs        ), 
    .reg_addr        (rtc_reg_addr      ), 
    .reg_wdata       (rtc_reg_wdata     ), 
    .reg_be          (rtc_reg_be        ), 
    .reg_wr          (rtc_reg_wr        ), 
	.reg_rdata       (rtc_reg_rdata     ), 
    .reg_ack         (rtc_reg_ack       ), 
    .rtc_intr        (rtc_intr          ),

    // Counters of RTC Time Register
    //
    .time_s         (time_s        ) ,// Seconds counter
    .time_ts        (time_ts       ) ,// Ten seconds counter
    .time_m         (time_m        ) ,// Minutes counter
    .time_tm        (time_tm       ) ,// Ten minutes counter
    .time_h         (time_h        ) ,// Hours counter
    .time_th        (time_th       ) ,// Ten hours counter
    .time_dow       (time_dow      ) ,// Day of week counter
    
    //
    // Counter of RTC Date Register
    //
    .date_d         (date_d      ) ,// Days counter
    .date_td        (date_td     ) ,// Ten days counter
    .date_m         (date_m      ) ,// Months counter
    .date_tm        (date_tm     ) ,// Ten months counter
    .date_y         (date_y      ) ,// Years counter
    .date_ty        (date_ty     ) ,// Ten years counter
    .date_c         (date_c      ) ,// Centuries counter
    .date_tc        (date_tc     ) ,// Ten centuries counter

    // Increment Pulse

    .inc_time_s      (inc_time_s    ), // increment second
    .inc_time_ts     (inc_time_ts   ), // increment tenth second
    .inc_time_m      (inc_time_m    ), // increment minute
    .inc_time_tm     (inc_time_tm   ), // increment tenth minute
    .inc_time_h      (inc_time_h    ), // increment hour
    .inc_time_th     (inc_time_th   ), // increment tenth hour
    .inc_time_dow    (inc_time_dow  ), // increment date of week
    .inc_date_d      (inc_date_d    ), // increment date
    .inc_date_td     (inc_date_td   ), // increment tenth date
    .inc_date_m      (inc_date_m    ), // increment month
    .inc_date_tm     (inc_date_tm   ), // increment tength month
    .inc_date_y      (inc_date_y    ), // increment year
    .inc_date_ty     (inc_date_ty   ), // increment tenth year
    .inc_date_c      (inc_date_c    ), // increment century
    .inc_date_tc     (inc_date_tc   ), // increment tenth century



   // RTC Core I/f
    .cfg_rtc_update  (cfg_rtc_update    ), // Update RTC core time/date with config
    .cfg_rtc_capture (cfg_rtc_capture   ), // Capture RTC core time/date with config
    .cfg_rtc_halt    (cfg_rtc_halt      ), // Halt RTC Operation
    .cfg_rtc_reset   (cfg_rtc_reset     ), // Reset RTC Operation
    .cfg_fast_time   (cfg_fast_time     ), // Run Time is Fast Mode
    .cfg_fast_date   (cfg_fast_date     ), // Run Date is Fast Mode
    .cfg_hmode       (cfg_hmode         ), // 12/24 hour mode
    .cfg_time        (cfg_time          ),
    .cfg_date        (cfg_date          )

);

endmodule
