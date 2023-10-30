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
                                                              
               RTC Reg Module                                             
                                                              
  Description                                                 
     Manages all rtc Register timer
     
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
                                                              
************************************************************************************/

module rtc_reg(
	// WISHBONE Interface
	input  logic            rtc_clk, 
    input  logic            rst_n, 

    // Reg I/F

    input  logic            reg_cs          , 
    input  logic [4:0]      reg_addr        , 
    input  logic [31:0]     reg_wdata       , 
    input  logic [3:0]      reg_be          , 
    input  logic            reg_wr          , 
	output logic [31:0]     reg_rdata       , 
    output logic            reg_ack         , 
    output logic            rtc_intr        ,

    // Increment Pulse

    input logic             inc_time_s      , // increment second
    input logic             inc_time_ts     , // increment tenth second
    input logic             inc_time_m      , // increment minute
    input logic             inc_time_tm     , // increment tenth minute
    input logic             inc_time_h      , // increment hour
    input logic             inc_time_th     , // increment tenth hour
    input logic             inc_time_dow    , // increment date of week
    input logic             inc_date_d      , // increment date
    input logic             inc_date_td     , // increment tenth date
    input logic             inc_date_m      , // increment month
    input logic             inc_date_tm     , // increment tength month
    input logic             inc_date_y      , // increment year
    input logic             inc_date_ty     , // increment tenth year
    input logic             inc_date_c      , // increment century
    input logic             inc_date_tc     , // increment tenth century
    // Counters of RTC Time Register
    //
    input logic	[3:0]		time_s          ,// Seconds counter
    input logic	[2:0]		time_ts         ,// Ten seconds counter
    input logic	[3:0]		time_m          ,// Minutes counter
    input logic	[2:0]		time_tm         ,// Ten minutes counter
    input logic	[3:0]		time_h          ,// Hours counter
    input logic	[1:0]		time_th         ,// Ten hours counter
    input logic	[2:0]		time_dow        ,// Day of week counter
    
    //
    // Counter of RTC Date Register
    //
    input logic	[3:0]		date_d          ,// Days counter
    input logic	[1:0]		date_td         ,// Ten days counter
    input logic	[3:0]		date_m          ,// Months counter
    input logic			    date_tm         ,// Ten months counter
    input logic	[3:0]		date_y          ,// Years counter
    input logic	[3:0]		date_ty         ,// Ten years counter
    input logic	[3:0]		date_c          ,// Centuries counter
    input logic	[3:0]		date_tc         ,// Ten centuries counter

   // RTC Core I/f
    output logic        cfg_rtc_update, // Update RTC core time/date with config
    output logic        cfg_rtc_capture,// Capture RTC core time/date with config
    output logic        cfg_rtc_halt,   // Halt RTC Operation
    output logic        cfg_rtc_reset,  // Reset RTC Operation
    output logic        cfg_fast_time,  // Run Time is Fast Mode
    output logic        cfg_fast_date,  // Run Date is Fast Mode
    output logic        cfg_hmode, // Hour 12/24 Mode selection; 0 -> 12 Hour mode
    output logic [31:0] cfg_time,
    output logic [31:0] cfg_date

);
parameter RTC_REG_CMD   =3'h0;
parameter RTC_REG_TIME  =3'h1;
parameter RTC_REG_DATE  =3'h2;
parameter RTC_REG_ALRM1 =3'h3;
parameter RTC_REG_ALRM2 =3'h4;
parameter RTC_REG_CTRL  =3'h5;
//
// Configuration Register
//
logic   [31:0]      cfg_alarm1      ;// Alarm config
logic   [31:0]      cfg_alarm2      ;// Alarm config
logic   [15:0]      cfg_ctrl        ;// Control Register
logic   [1:0]       intr_stat       ;
//
//
// Internal wires & regs
//
logic			cfg_cmd_sel         ;// Cmd Register Select
logic			cfg_time_sel        ;// Time Register Select
logic			cfg_date_sel        ;// Date Register Select
logic			cfg_alrm1_sel       ;// Alarm1 Register Select
logic			cfg_alrm2_sel       ;// Alarm2 Register Select
logic			cfg_ctrl_sel        ;// Control Register Select
//-----------------------------------
// Interrupt Generation
//------------------------------------
logic			alrm1_intr         ;// Alarm1 Interrupt
logic			alrm2_intr         ;// Alarm2 Interrupt
//--------------------------------
// Misc Decleration
//---------------------------------
logic [31:0]    reg_out             ;
logic [3:0]     cfg_alrm1_mode      ; 
logic [3:0]     cfg_alrm2_mode      ;
logic           cfg_alrm1_ie        ;
logic           cfg_alrm2_ie        ;
logic [31:0]    rtc_time            ;
logic [31:0]    rtc_date            ;



//----------------------------------------
// Map RTC Time/Date
//----------------------------------------

assign  rtc_time = {5'b0, time_dow,
                   2'b0, time_th, time_h,
                   1'b0, time_tm,time_m,
                   1'b0, time_ts,time_s};

assign rtc_date = {date_tc,date_c,
                   date_ty,date_y,
                   2'b0,date_tm,date_m,
                   2'b0,date_td,date_d};



//
// RTC registers address decoder
//
assign cfg_cmd_sel   = reg_cs & (reg_addr[4:2] == RTC_REG_CMD) ;
assign cfg_time_sel  = reg_cs & (reg_addr[4:2] == RTC_REG_TIME) ;
assign cfg_date_sel  = reg_cs & (reg_addr[4:2] == RTC_REG_DATE) ;
assign cfg_alrm1_sel = reg_cs & (reg_addr[4:2] == RTC_REG_ALRM1);
assign cfg_alrm2_sel = reg_cs & (reg_addr[4:2] == RTC_REG_ALRM2);
assign cfg_ctrl_sel  = reg_cs & (reg_addr[4:2] == RTC_REG_CTRL);

always @ (posedge rtc_clk or negedge rst_n)
begin 
   if (rst_n == 1'b0) begin
      reg_rdata  <= 'h0;
      reg_ack    <= 1'b0;
   end else if (reg_cs && !reg_ack) begin
      reg_rdata  <= reg_out;
      reg_ack    <= 1'b1;
   end else begin
      reg_ack    <= 1'b0;
   end
end
//----------------------------------------------------
// 
//
// CMD
//
// Address : 0x0 - 0x3
// cfg_rtc_update => 1 => update 0x4 to 0B to Time & Date Register
// cfg_rtc_capture => 1 => Capture Time and Data to 0x4 to 0xB register to support 64bit alined data
always @(posedge rtc_clk or negedge rst_n)
	if (rst_n == 1'b0) begin
	   cfg_rtc_update  <= 1'b0;
	   cfg_rtc_capture <= 1'b0;
	end else if (cfg_cmd_sel && reg_wr && !reg_ack) begin
	   if(reg_be[0] &&  reg_wdata[0] ) cfg_rtc_update <= 1;
	   if(reg_be[0] &&  reg_wdata[1] ) cfg_rtc_capture <= 1;
	end  else begin
	   cfg_rtc_update  <= 1'b0;
	   cfg_rtc_capture <= 1'b0;
    end
//
// cfg_time
//
// Address : 0x4 - 0x7
always @(posedge rtc_clk or negedge rst_n)
	if (rst_n == 1'b0)
		cfg_time <= 32'b0;
	else if (cfg_time_sel && reg_wr) begin
		if(reg_be[0]) cfg_time[7:0]   <= reg_wdata[7:0];
		if(reg_be[1]) cfg_time[15:8]  <= reg_wdata[15:8];
		if(reg_be[2]) cfg_time[23:16] <= reg_wdata[23:16];
		if(reg_be[3]) cfg_time[31:24] <= reg_wdata[31:24];
	end else if(cfg_rtc_capture & reg_ack) begin
		cfg_time   <= rtc_time[31:0];
    end
//
// cfg_date
//
// Address : 0x8 - 0xB
always @(posedge rtc_clk or negedge rst_n)
	if (rst_n == 1'b0)
		cfg_date <= 32'b0;
	else if (cfg_date_sel && reg_wr) begin
		if(reg_be[0]) cfg_date[7:0]   <= reg_wdata[7:0];
		if(reg_be[1]) cfg_date[15:8]  <= reg_wdata[15:8];
		if(reg_be[2]) cfg_date[23:16] <= reg_wdata[23:16];
		if(reg_be[3]) cfg_date[31:24] <= reg_wdata[31:24];
	end else if(cfg_rtc_capture & reg_ack) begin
		cfg_date   <= rtc_date[31:0];
    end

//
// Alarm1
//
// Address : 0xC - 0xF
always @(posedge rtc_clk or negedge rst_n)
	if (rst_n == 1'b0)
		cfg_alarm1 <= 32'b0;
	else if (cfg_alrm1_sel && reg_wr) begin
		if(reg_be[0]) cfg_alarm1[7:0]   <= reg_wdata[7:0];
		if(reg_be[1]) cfg_alarm1[15:8]  <= reg_wdata[15:8];
		if(reg_be[2]) cfg_alarm1[23:16] <= reg_wdata[23:16];
		if(reg_be[3]) cfg_alarm1[31:24] <= reg_wdata[31:24];
	end 

//
// Alarm2
//
// Address : 0x10 - 0x13
always @(posedge rtc_clk or negedge rst_n)
	if (rst_n == 1'b0)
		cfg_alarm2 <= 32'b0;
	else if (cfg_alrm2_sel && reg_wr) begin
		if(reg_be[0]) cfg_alarm2[7:0]   <= reg_wdata[7:0];
		if(reg_be[1]) cfg_alarm2[15:8]  <= reg_wdata[15:8];
		if(reg_be[2]) cfg_alarm2[23:16] <= reg_wdata[23:16];
		if(reg_be[3]) cfg_alarm2[31:24] <= reg_wdata[31:24];
	end 

//
// Control
//
// Address : 0x14 - 0x17
always @(posedge rtc_clk or negedge rst_n)
	if (rst_n == 1'b0)
		cfg_ctrl <= 16'h400;
	else if (cfg_ctrl_sel && reg_wr) begin
		if(reg_be[0]) cfg_ctrl[7:0]   <= reg_wdata[7:0];
		if(reg_be[1]) cfg_ctrl[15:8]  <= reg_wdata[15:8];
	end 

assign cfg_alrm1_mode  = cfg_ctrl[3:0];
assign cfg_alrm2_mode  = cfg_ctrl[7:4];
assign cfg_alrm1_ie    = cfg_ctrl[8]; // Alarm1 Interrupt enable
assign cfg_alrm2_ie    = cfg_ctrl[9]; // Alarm2 Interrupt enable
assign cfg_hmode       = cfg_ctrl[10]; // Hour Mode, 0 - 12 , 1 - 24
assign cfg_rtc_halt    = cfg_ctrl[11]; // Halt RTC Timer
assign cfg_rtc_reset   = cfg_ctrl[12]; // Reset RTC Timer
assign cfg_fast_time   = cfg_ctrl[14]; // Run Time is Fast Mode
assign cfg_fast_date   = cfg_ctrl[15]; // Run Date is Fast Mode
//----------------------------------------------------------------
// Interrupt status register
// Interrupt can be cleared by setting '1' to corresponding bit
//-----------------------------------------------------------------
always @(posedge rtc_clk or negedge rst_n)
	if (rst_n == 1'b0)
		intr_stat <= 2'b0;
	else if (cfg_ctrl_sel && reg_wr) begin
		if(reg_be[2] & reg_wdata[16]) intr_stat[0]   <= alrm1_intr; // Handing Cfg Clr clash with new interrupt
		if(reg_be[2] & reg_wdata[17]) intr_stat[1]   <= alrm2_intr; // Handing Cfg Clr clash with new interrupt
	end else begin
		intr_stat[0]   <= intr_stat[0] | alrm1_intr;
		intr_stat[1]   <= intr_stat[1] | alrm2_intr;
    end
/*********************************************
  Alarm Mode
  4'b0000   - Interrupt on Every Second
  4'b0001   - Interrupt on Every Minute
  4'b0010   - Interrupt on Every Hour
  4'b0011   - Interrupt on Second  = Alarm Reg
  4'b0100   - Interrupt on Second + Minute == Alarm Reg
  4'b0101   - Interrupt on Second + Minute + Hour == Alarm Reg
  4'b0110   - Interrupt on Second + Minute + Hour + Day == Alarm Reg
  4'b0111   - Interrupt on Second + Minute + Hour + Date == Alarm Reg
***********************************************/

always_comb
begin
   alrm1_intr = 0;
   case(cfg_alrm1_mode)
   4'b0001: alrm1_intr = inc_time_s;
   4'b0010: alrm1_intr = inc_time_m;
   4'b0011: alrm1_intr = inc_time_h;
   4'b0100: alrm1_intr = cfg_alarm1[3:0]   == time_s[3:0] && cfg_alarm1[6:4]   == time_ts[2:0];
   4'b0101: alrm1_intr = cfg_alarm1[3:0]   == time_s[3:0] && cfg_alarm1[6:4]   == time_ts[2:0]&&
                         cfg_alarm1[11:8]  == time_m[3:0] && cfg_alarm1[14:12] == time_tm[2:0];
   4'b0110: alrm1_intr = cfg_alarm1[3:0]   == time_s[3:0] && cfg_alarm1[6:4]   == time_ts[2:0] &&
                         cfg_alarm1[11:8]  == time_m[3:0] && cfg_alarm1[14:12] == time_tm[2:0]&&
                         cfg_alarm1[11:8]  == time_h[3:0] && cfg_alarm1[13:12] == time_tm[1:0];
   4'b0111: alrm1_intr = cfg_alarm1[3:0]   == time_s[3:0] && cfg_alarm1[6:4]   == time_ts[2:0] &&
                         cfg_alarm1[11:8]  == time_m[3:0] && cfg_alarm1[14:12] == time_tm[2:0] &&
                         cfg_alarm1[11:8]  == time_h[3:0] && cfg_alarm1[13:12] == time_tm[1:0] &&
                         cfg_alarm1[14:12] == time_dow[2:0];
   4'b1000: alrm1_intr = cfg_alarm1[3:0]   == time_s[3:0] && cfg_alarm1[6:4]   == time_ts[2:0] &&
                         cfg_alarm1[11:8]  == time_m[3:0] && cfg_alarm1[14:12] == time_tm[2:0] &&
                         cfg_alarm1[11:8]  == time_h[3:0] && cfg_alarm1[13:12] == time_tm[1:0] &&
                         cfg_alarm1[15:12] == date_d[3:0] && cfg_alarm1[17:16] == date_td;
   default: alrm1_intr = 0;


   endcase


end

always_comb
begin
   alrm2_intr = 0;
   case(cfg_alrm2_mode)
   4'b0001: alrm2_intr = inc_time_s;
   4'b0010: alrm2_intr = inc_time_m;
   4'b0011: alrm2_intr = inc_time_h;
   4'b0100: alrm2_intr = cfg_alarm2[3:0]   == time_s[3:0] && cfg_alarm2[6:4]   == time_ts[2:0];
   4'b0101: alrm2_intr = cfg_alarm2[3:0]   == time_s[3:0] && cfg_alarm2[6:4]   == time_ts[2:0] &&
                         cfg_alarm2[11:8]  == time_m[3:0] && cfg_alarm2[14:12] == time_tm[2:0];
   4'b0110: alrm2_intr = cfg_alarm2[3:0]   == time_s[3:0] && cfg_alarm2[6:4]   == time_ts[2:0] &&
                         cfg_alarm2[11:8]  == time_m[3:0] && cfg_alarm2[14:12] == time_tm[2:0] &&
                         cfg_alarm2[11:8]  == time_h[3:0] && cfg_alarm2[13:12] == time_tm[1:0];
   4'b0111: alrm2_intr = cfg_alarm2[3:0]   == time_s[3:0] && cfg_alarm2[6:4]   == time_ts[2:0] &&
                         cfg_alarm2[11:8]  == time_m[3:0] && cfg_alarm2[14:12] == time_tm[2:0] &&
                         cfg_alarm2[11:8]  == time_h[3:0] && cfg_alarm2[13:12] == time_tm[1:0] &&
                         cfg_alarm2[14:12] == time_dow[2:0];
   4'b1000: alrm2_intr = cfg_alarm2[3:0]   == time_s[3:0] && cfg_alarm2[6:4]   == time_ts[2:0] &&
                         cfg_alarm2[11:8]  == time_m[3:0] && cfg_alarm2[14:12] == time_tm[2:0] &&
                         cfg_alarm2[11:8]  == time_h[3:0] && cfg_alarm2[13:12] == time_tm[1:0] &&
                         cfg_alarm2[15:12] == date_d[3:0] && cfg_alarm2[17:16] == date_td;

   default: alrm2_intr = 0;

   endcase


end


//
// Generate an interrupt request
//
assign rtc_intr = (alrm1_intr & cfg_alrm1_ie) | (alrm2_intr & cfg_alrm2_ie);


//------------------------------------
// Register Decode
//------------------------------------
always_comb
begin 
  reg_out [31:0] = 32'h0;

  case (reg_addr [4:2])
    RTC_REG_CMD     : reg_out [31:0] = 'h0;
    RTC_REG_TIME    : reg_out [31:0] = cfg_time;
    RTC_REG_DATE    : reg_out [31:0] = cfg_date;
    RTC_REG_ALRM1   : reg_out [31:0] = cfg_alarm1;
    RTC_REG_ALRM2   : reg_out [31:0] = cfg_alarm2;
    RTC_REG_CTRL    : reg_out [31:0] = {14'h0,intr_stat,cfg_ctrl};
    default         : reg_out [31:0] = 32'h0;
  endcase
end


endmodule
