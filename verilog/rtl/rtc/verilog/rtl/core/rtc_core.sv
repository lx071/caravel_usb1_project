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
                                                              
               RTC Core Module                                             
                                                              
  Description                                                 
     Manages all rtc related timer
     
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

 

module rtc_core(
	// WISHBONE Interface
	input  logic        rtc_clk, 
    input  logic        rst_n, 
    input  logic        fast_sim_time, // Run Time is Fast Mode
    input  logic        fast_sim_date, // Run Date is Fast Mode

    // Counters of RTC Time Register
    //
    output logic	[3:0]		time_s          ,// Seconds counter
    output logic	[2:0]		time_ts         ,// Ten seconds counter
    output logic	[3:0]		time_m          ,// Minutes counter
    output logic	[2:0]		time_tm         ,// Ten minutes counter
    output logic	[3:0]		time_h          ,// Hours counter
    output logic	[1:0]		time_th         ,// Ten hours counter
    output logic	[2:0]		time_dow        ,// Day of week counter
    
    //
    // Counter of RTC Date Register
    //
    output logic	[3:0]		date_d          ,// Days counter
    output logic	[1:0]		date_td         ,// Ten days counter
    output logic	[3:0]		date_m          ,// Months counter
    output logic			    date_tm         ,// Ten months counter
    output logic	[3:0]		date_y          ,// Years counter
    output logic	[3:0]		date_ty         ,// Ten years counter
    output logic	[3:0]		date_c          ,// Centuries counter
    output logic	[3:0]		date_tc         ,// Ten centuries counter

    // Increment Pulse

    output logic                inc_time_s      , // increment second
    output logic                inc_time_ts     , // increment tenth second
    output logic                inc_time_m      , // increment minute
    output logic                inc_time_tm     , // increment tenth minute
    output logic                inc_time_h      , // increment hour
    output logic                inc_time_th     , // increment tenth hour
    output logic                inc_time_dow    , // increment date of week
    output logic                inc_date_d      , // increment date
    output logic                inc_date_td     , // increment tenth date
    output logic                inc_date_m      , // increment month
    output logic                inc_date_tm     , // increment tength month
    output logic                inc_date_y      , // increment year
    output logic                inc_date_ty     , // increment tenth year
    output logic                inc_date_c      , // increment century
    output logic                inc_date_tc     , // increment tenth century

   // RTC Core I/f
    input  logic                cfg_rtc_update,
    input  logic                cfg_rtc_capture,
    input  logic                cfg_rtc_halt,
    input  logic                cfg_rtc_reset,
    input  logic                cfg_hmode,
    input  logic [31:0]         cfg_time,
    input  logic [31:0]         cfg_date


);


//------------------------------
// RTC Clock Divider and 1 Second Pulse Gen
//------------------------------
logic   [14:0]      rtc_div         ;// rtc clock div
logic               pulse_1s        ;



// In fast Sim Time Mode, 1second run in RTC_DIV/2
wire pulse_1s_f = (fast_sim_time) ? rtc_div[0] : pulse_1s;


// In fast Sim Date Mode, 1second run in RTC_DIV/2
wire rst_time_th_f = (fast_sim_date) ? rtc_div[0] : rst_time_th;

//
// Control of counters:
//
// Secon Roll Over
wire  rst_time_s   = (time_s == 4'd9) & pulse_1s_f ;    

// Tenth Second Roll Over
wire  rst_time_ts  = (time_ts == 3'd5) & rst_time_s ; 

// Minute Roll Over
wire  rst_time_m   = (time_m == 4'd9) & rst_time_ts ; 

// Tenth Minute Roll Over
wire  rst_time_tm  = (time_tm == 3'd5) & rst_time_m ;  

// Hour Roll over in 12/24 hour mode
wire  rst_time_h   = (cfg_hmode == 1'b0) ? ((time_th[0]== 1'b1) ? (time_h == 4'd1) & rst_time_tm:(time_h == 4'd9) & rst_time_tm) :
		           	                        ((time_th== 2'd2) ? (time_h == 4'd3) & rst_time_tm:(time_h == 4'd9) & rst_time_tm) ;

// Tength Rool Over in 12/24 Hour Mode
wire  rst_time_th = (cfg_hmode == 1'b0) ? (time_th == 2'd3) & rst_time_h  : (time_th == 2'd2) & rst_time_h  ;

// Day of Week Roll Over
wire  rst_time_dow = (time_dow == 3'd7) & rst_time_th ;

// Date Roll Over + Handle Feb 28/29 Based on Leap Year
// When Leap Year, Roll Over at Feb at 29
// When Not Leap Year, Roll Over at Feb at 28
// Other Month Roll Over at 
wire  rst_date_d   = 
                      date_tm == 4'd0 && date_m == 4'd1 && (date_td == 2'd3) ?  (date_d == 4'd1) & rst_time_th_f :  // Jan - 31
                      date_tm == 4'd0 && date_m == 4'd2 && (date_td == 2'd2) && ~leapyear ?  (date_d == 4'd8) & rst_time_th_f : // Feb Non Leap - 28
                      date_tm == 4'd0 && date_m == 4'd2 && (date_td == 2'd2) && leapyear  ?  (date_d == 4'd9) & rst_time_th_f : // Feb Leap - 29
                      date_tm == 4'd0 && date_m == 4'd3 && (date_td == 2'd3) ?  (date_d == 4'd1) & rst_time_th_f:  // Mar - 31
                      date_tm == 4'd0 && date_m == 4'd4 && (date_td == 2'd3) ?  (date_d == 4'd0) & rst_time_th_f:  // April - 30
                      date_tm == 4'd0 && date_m == 4'd5 && (date_td == 2'd3) ?  (date_d == 4'd1) & rst_time_th_f:  // May - 31
                      date_tm == 4'd0 && date_m == 4'd6 && (date_td == 2'd3) ?  (date_d == 4'd0) & rst_time_th_f:  // June - 30
                      date_tm == 4'd0 && date_m == 4'd7 && (date_td == 2'd3) ?  (date_d == 4'd1) & rst_time_th_f:  // July - 31
                      date_tm == 4'd0 && date_m == 4'd8 && (date_td == 2'd3) ?  (date_d == 4'd1) & rst_time_th_f:  // August -31
                      date_tm == 4'd0 && date_m == 4'd9 && (date_td == 2'd3) ?  (date_d == 4'd0) & rst_time_th_f:  // Sept - 30
                      date_tm == 4'd1 && date_m == 4'd0 && (date_td == 2'd3) ?  (date_d == 4'd1) & rst_time_th_f:  // Oct - 31
                      date_tm == 4'd1 && date_m == 4'd1 && (date_td == 2'd3) ?  (date_d == 4'd0) & rst_time_th_f:  // Nov - 30
                      date_tm == 4'd1 && date_m == 4'd2 && (date_td == 2'd3) ?  (date_d == 4'd1) & rst_time_th_f:  // Dec - 31
                      date_d  == 4'd9 & rst_time_th_f; // Normal Roll Over

wire  rst_date_td =  date_tm == 4'd0 && date_m == 4'd1 ?  (date_td == 2'd3) & (date_d == 4'd1) & rst_date_d :  // Jan-31
                      date_tm == 4'd0 && date_m == 4'd2 && (date_td == 2'd2) && ~leapyear ?  (date_d == 4'd8) & rst_date_d :         // Feb Non Leap
                      date_tm == 4'd0 && date_m == 4'd2 && (date_td == 2'd2) && leapyear  ?  (date_d == 4'd9) & rst_date_d :         // Feb Leap
                      date_tm == 4'd0 && date_m == 4'd3 ?  (date_td == 2'd3) & (date_d == 4'd1) & rst_date_d :  // Mar - 31
                      date_tm == 4'd0 && date_m == 4'd4 ?  (date_td == 2'd3) & (date_d == 4'd0) & rst_date_d :  // April- 30
                      date_tm == 4'd0 && date_m == 4'd5 ?  (date_td == 2'd3) & (date_d == 4'd1) & rst_date_d :  // May -  31
                      date_tm == 4'd0 && date_m == 4'd6 ?  (date_td == 2'd3) & (date_d == 4'd0) & rst_date_d :  // June - 30
                      date_tm == 4'd0 && date_m == 4'd7 ?  (date_td == 2'd3) & (date_d == 4'd1) & rst_date_d :  // July - 31
                      date_tm == 4'd0 && date_m == 4'd8 ?  (date_td == 2'd3) & (date_d == 4'd1) & rst_date_d :  // August-31
                      date_tm == 4'd0 && date_m == 4'd9 ?  (date_td == 2'd3) & (date_d == 4'd0) & rst_date_d :  // Sept - 30
                      date_tm == 4'd1 && date_m == 4'd0 ?  (date_td == 2'd3) & (date_d == 4'd1) & rst_date_d :  // Oct - 31
                      date_tm == 4'd1 && date_m == 4'd1 ?  (date_td == 2'd3) & (date_d == 4'd0) & rst_date_d :  // Nov - 30
                      date_tm == 4'd1 && date_m == 4'd2 ?  (date_td == 2'd3) & (date_d == 4'd1) & rst_date_d :  // Dec - 31
                      1'b0;


// Month Roll Over 0 -> 9 -> 0 and 12 -> 0
wire  rst_date_m = date_tm == 1'b0 ? (date_m == 4'd9) & rst_date_td : (date_m == 4'd2) & rst_date_td;

wire  rst_date_tm = date_tm == 1'b1  & (date_m == 4'd2) & rst_date_m;
wire  rst_date_y  = (date_y == 4'd9) & rst_date_tm;
wire  rst_date_ty = (date_ty == 4'd9)& rst_date_y;
wire  rst_date_c  = (date_c == 4'd9) & rst_date_ty;
wire  rst_date_tc = (date_tc == 4'd9) & rst_date_c;

//
// Control for counter increment
//
assign inc_time_s   = pulse_1s_f;
assign inc_time_ts  = rst_time_s;
assign inc_time_m   = rst_time_ts;
assign inc_time_tm  = rst_time_m;
assign inc_time_h   = rst_time_tm;
assign inc_time_th  = rst_time_h;
assign inc_time_dow = rst_time_th;
assign inc_date_d   = rst_time_th_f;
assign inc_date_td  = rst_date_d;
assign inc_date_m   = rst_date_td;
assign inc_date_tm  = rst_date_m;
assign inc_date_y   = rst_date_tm;
assign inc_date_ty  = rst_date_y;
assign inc_date_c   = rst_date_ty;
assign inc_date_tc  = rst_date_c;

//-----------------------------------------------------------------------------
// Assumption: RTC clk: 32768, So 15 bit counter overflow at 1 second interval
//   32768/2^15 = 1
// RTC Domain 1 Second Pulse Generation
//---------------------------------------------

always @(posedge rtc_clk or negedge rst_n)
if (rst_n == 1'b0) begin
	rtc_div    <= 15'b0;
	pulse_1s   <= 1'b0;
end else if(cfg_rtc_update || cfg_rtc_reset) begin
    // Reset the counter, when rtc time/date update
    rtc_div    <= 15'b0;
    pulse_1s   <= 1'b0;
end else if (!cfg_rtc_halt) begin
    rtc_div     <= rtc_div + 1;
    if(&rtc_div) pulse_1s <= 1'b1;
    else pulse_1s <= 1'b0;
end else begin 
    // To handle clash condition halt + Pulse generation at same time
    pulse_1s <= 1'b0;
end
                   
//
// RRTC_TIME[S] - Second
//  Address : 0x00, Bit [3:0] 
always @(posedge rtc_clk or negedge rst_n)
	if (rst_n == 1'b0)
		time_s <=  4'b0;
	else if (cfg_rtc_update)
		time_s <= cfg_time[3:0];
	else if (rst_time_s)
		time_s <=  4'b0;
	else if (inc_time_s)
		time_s <= time_s + 1;

//
// RRTC_TIME[TS] - Ten Second
//
//  Address : 0x00, Bit [6:4] 
always @(posedge rtc_clk or negedge rst_n)
	if (rst_n == 1'b0)
		time_ts <= 3'b0;
	else if (cfg_rtc_update)
		time_ts <= cfg_time[6:4];
	else if (rst_time_ts)
		time_ts <= 3'b0;
	else if (inc_time_ts)
		time_ts <= time_ts + 1;

//
// RRTC_TIME[M] - Minute
//
//  Address : 0x01, Bit [3:0] 
always @(posedge rtc_clk or negedge rst_n)
	if (rst_n == 1'b0)
		time_m <= 4'b0;
	else if (cfg_rtc_update)
		time_m <= cfg_time[11:8];
	else if (rst_time_m)
		time_m <= 4'b0;
	else if (inc_time_m)
		time_m <= time_m + 1;

//
// RRTC_TIME[TM] - Ten Minute
//  Address : 0x01, Bit [6:4] 
always @(posedge rtc_clk or negedge rst_n)
	if (rst_n == 1'b0)
		time_tm <= 3'b0;
	else if (cfg_rtc_update)
		time_tm <= cfg_time[14:12];
	else if (rst_time_tm)
		time_tm <= 3'b0;
	else if (inc_time_tm)
		time_tm <= time_tm + 1;

//
// RRTC_TIME[H] - Hour 
//
//  Address : 0x02, Bit [3:0] 
always @(posedge rtc_clk or negedge rst_n)
	if (rst_n == 1'b0)
		time_h <= 4'b0;
	else if (cfg_rtc_update)
		time_h <= cfg_time[19:16];
	else if (rst_time_h)
		time_h <= 4'b0;
	else if (inc_time_h)
		time_h <= time_h + 1;

//
// RRTC_TIME[TH] - Tenth Hour
//
//  Address : 0x02, Bit [5:4] 
always @(posedge rtc_clk or negedge rst_n)
	if (rst_n == 1'b0)
		time_th <= 2'b0;
	else if (cfg_rtc_update)
		time_th <= cfg_time[21:20];
	else if (rst_time_th)
		time_th <= 2'b0;
	else if (inc_time_th)
		time_th <= time_th + 1;

//
// RRTC_TIME[DOW] - Date of Week
//
//  Address : 0x03, Bit [2:0] 
always @(posedge rtc_clk or negedge rst_n)
	if (rst_n == 1'b0)
		time_dow <= 3'h1;
	else if (cfg_rtc_update)
		time_dow <= cfg_time[26:24];
	else if (rst_time_dow)
		time_dow <= 3'h1;
	else if (inc_time_dow)
		time_dow <= time_dow + 1;


//
// RRTC_DATE[D] - Date
//
//  Address : 0x04, Bit [3:0] 
always @(posedge rtc_clk or negedge rst_n)
	if (rst_n == 1'b0)
		date_d <= 4'h1;
	else if (cfg_rtc_update)
		date_d <= cfg_date[3:0];
	else if (rst_date_d && inc_date_m )
		date_d <= 4'h1;
	else if (rst_date_d)
		date_d <= 4'h0;
	else if (inc_date_d)
		date_d <= date_d + 1;

//
// RRTC_DATE[TD] - Tenth Date
//
//  Address : 0x04, Bit [5:4] 
always @(posedge rtc_clk or negedge rst_n)
	if (rst_n == 1'b0)
		date_td <= 2'b0;
	else if (cfg_rtc_update)
		date_td <= cfg_date[5:4];
	else if (rst_date_td)
		date_td <= 2'b0;
	else if (inc_date_td)
		date_td <= date_td + 1;

//
// RRTC_DATE[M] - Month
//
//  Address : 0x05, Bit [3:0] 
always @(posedge rtc_clk or negedge rst_n)
	if (rst_n == 1'b0)
		date_m <= 4'h1;
	else if (cfg_rtc_update)
		date_m <= cfg_date[11:8];
	else if (rst_date_m && date_tm)
		date_m <= 4'h1;
	else if (rst_date_m)
		date_m <= 4'h0;
	else if (inc_date_m)
		date_m <= date_m + 1;

//
// RRTC_DATE[TM] - Tenth Month
//
//  Address : 0x05, Bit [5:4] 
always @(posedge rtc_clk or negedge rst_n)
	if (rst_n == 1'b0)
		date_tm <= 1'b0;
	else if (cfg_rtc_update)
		date_tm <= cfg_date[13:12];
	else if (rst_date_tm)
		date_tm <= 1'b0;
	else if (inc_date_tm)
		date_tm <= date_tm + 1;

//
// RRTC_DATE[Y] - Year
//
//  Address : 0x06, Bit [3:0] 
always @(posedge rtc_clk or negedge rst_n)
	if (rst_n == 1'b0)
		date_y <= 4'b0;
	else if (cfg_rtc_update)
		date_y <= cfg_date[19:16];
	else if (rst_date_y)
		date_y <= 4'b0;
	else if (inc_date_y)
		date_y <= date_y + 1;

//
// RRTC_DATE[TY] - Tenth Year
//
//  Address : 0x06, Bit [7:4] 
always @(posedge rtc_clk or negedge rst_n)
	if (rst_n == 1'b0)
		date_ty <= 4'b0;
	else if (cfg_rtc_update)
		date_ty <= cfg_date[23:20];
	else if (rst_date_ty)
		date_ty <= 4'b0;
	else if (inc_date_ty)
		date_ty <= date_ty + 1;

//
// RRTC_DATE[C] - Century
//
//  Address : 0x07, Bit [3:0] 
always @(posedge rtc_clk or negedge rst_n)
	if (rst_n == 1'b0)
		date_c <= 4'b0;
	else if (cfg_rtc_update)
		date_c <= cfg_date[27:24];
	else if (rst_date_c)
		date_c <= 4'b0;
	else if (inc_date_c)
		date_c <= date_c + 1;

//
// RRTC_DATE[TC] - Tenth Century
//
//  Address : 0x07, Bit [7:4] 
always @(posedge rtc_clk or negedge rst_n)
	if (rst_n == 1'b0)
		date_tc <= 4'b0;
	else if (cfg_rtc_update)
		date_tc <= cfg_date[31:28];
	else if (rst_date_tc)
		date_tc <= 4'b0;
	else if (inc_date_tc)
		date_tc <= date_tc + 1;


//
// Leap year calculation
//
assign leapyear =
	(({date_ty, date_y} == 8'h00) &				// xx00
	 (( date_tc[0] & ~date_c[3] & (date_c[1:0] == 2'b10)) |	// 12xx, 16xx, 32xx ...
	  (~date_tc[0] & (date_c[1:0] == 2'b00) &		// 00xx, 04xx, 08xx, 20xx, 24xx ...
	   ((date_c[3:2] == 2'b01) | ~date_c[2])))) |
	(~date_ty[0] & (date_y[1:0] == 2'b00) & ({date_ty, date_y} != 8'h00)) | // xx04, xx08, xx24 ...
	(date_ty[0] & (date_y[1:0] == 2'b10));			// xx12, xx16, xx32 ...



endmodule
