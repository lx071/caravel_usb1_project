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
                                                              
                   RTC Test Bench
                                                              
                                                              
  Author(s):                                                  
      - Dinesh Annayya, dinesh.annayya@gmail.com                 
                                                              
  Revision :                                                  
     0.0  - Nov 16, 2022 
            Initial Version 
     0.1  - Nov 21, 2022 
            A.Sys-clk and RTC clock domain are seperated.
            B.Register are moved to seperate module
            
************************************************************************************/
/************************************************************************************
                      Copyright (C) 2000-2002 
              Dinesh Annayya <dinesh.annayya@gmail.com>
                                                             
       This source file may be used and distributed without        
       restriction provided that this copyright statement is not   
       removed from the file and that any derivative work contains 
       the original copyright notice and the associated disclaimer.
                                                                   
           THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY     
       EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED   
       TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS   
       FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR      
       OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,         
       INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES    
       (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE   
       GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR        
       BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  
       LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT  
       (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT  
       OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         
       POSSIBILITY OF SUCH DAMAGE.                                 
                                                             
************************************************************************************/

`timescale 1 ns / 1 ps


`ifdef GL
     `define USE_POWER_PINS
     `define UNIT_DELAY #0.1
`endif

`define  REG_CMD    5'h0
`define  REG_TIME   5'h4
`define  REG_DATE   5'h8
`define  REG_ALRM1  5'hC
`define  REG_ALRM2  5'h10
`define  REG_CTRL   5'h14

`define  CMD_C_INIT       4'h0 // Initialize the C PLI Timer
`define  CMD_C_NEXT_TIME  4'h1 // Get Next Second Value
`define  CMD_C_NEXT_DATE  4'h2 // Het Next Date value

module tb_top;

parameter RTC_PERIOD = 30518; // 32768 Hz
parameter SYS_PERIOD = 10000; // 100Khz

reg		    sys_clk;
reg		    rtc_clk;
reg		    rst_n;
reg         test_fail;
reg [15:0]  error_cnt;

//---------------------
// Register I/F
reg         reg_cs;
reg [4:0]   reg_addr;
reg [3:0]   reg_be;
reg         reg_wr;
reg [31:0]  reg_wdata;
wire [31:0] reg_rdata;
wire        reg_ack;
wire        rtc_intr;
wire        trig_s;
wire        trig_d;
reg         fast_sim_time;
reg         fast_sim_date;


// Wishbone Interface

always #(RTC_PERIOD/2) rtc_clk = ~rtc_clk;
always #(SYS_PERIOD/2) sys_clk = ~sys_clk;

initial
   begin
    test_fail     = 0;
	sys_clk       = 0;
	rtc_clk       = 0;
	rst_n         = 0;
	error_cnt     = 0;
    reg_cs        = 0;
    reg_addr      = 'h0;
    reg_wr        = 'b0;
    reg_be        = 'h0;
    reg_wdata     = 'h0;
    fast_sim_time = 'h0;
    fast_sim_date = 'h0;

	$display("\n\n");
	$display("*****************************************************");
	$display("* RTC Test bench ...");
	$display("*****************************************************");
	$display("\n");


    normal_test;
    fast_test1;
    fast_test2;

	repeat(1000)	@(posedge sys_clk);

	$display("");
	$display("");
    if(error_cnt > 0) begin
	   $display("STATUS: RTC TEST FAILED  Found %0d Errors.", error_cnt);
    end else begin
	   $display("STATUS: RTC TEST PASSED.");
    end
	$display("");
	$display("");
	repeat(10)	@(posedge sys_clk);
	$finish;
end

`ifdef WFDUMP
   initial begin
   	  $dumpfile("simx.vcd");
   	  $dumpvars(0, tb_top);
   end
`endif

task reset;
begin
	rst_n         = 0;
	repeat(4)	@(posedge sys_clk);
	rst_n = 1;
	repeat(20)	@(posedge sys_clk);
end
endtask


wire [7:0] rtl_time   = {1'b0, u_dut.time_ts,u_dut.time_s};
wire [7:0] rtl_minute = {1'b0, u_dut.time_tm,u_dut.time_m};
wire [7:0] rtl_hour   = {1'b0, u_dut.time_th,u_dut.time_h};
wire [7:0] rtl_dow    = {5'b0, u_dut.time_dow};

wire [7:0] rtl_date   = {2'b0,u_dut.date_td,u_dut.date_d};
wire [7:0] rtl_month  = {2'b0,u_dut.date_tm,u_dut.date_m};
wire [15:0] rtl_year  = {u_dut.date_tc,u_dut.date_c,u_dut.date_ty,u_dut.date_y};
wire [7:0] rtl_cent   = {u_dut.date_tc,u_dut.date_c};

//---------------------------
// Normal Test Without any Over-ride
task normal_test;
reg [31:0] exp_time;
reg [31:0] cfg_time;
reg [31:0] cfg_date;
integer i;
begin
    //initialize the Timer Structure in C-PLI
   $c_rtc(`CMD_C_INIT,2022,10,19,0,0,0);
   reset();

   reg_write(`REG_TIME,{8'h01,8'h0,8'h0,8'h0});
   reg_write(`REG_DATE,{16'h2022,8'h10,8'h19});
   reg_write(`REG_CMD ,{30'h0,2'b01});

   for(i=0; i < 1000; i = i+1) begin
     repeat(1)	@(negedge trig_s);
     exp_time = $c_rtc(1);
     reg_write(`REG_CMD ,{30'h0,2'b10});
     reg_read(`REG_TIME,cfg_time);
     reg_read(`REG_DATE,cfg_date);

     if(exp_time == {cfg_date[7:0],cfg_time[23:0]}) begin
        $display("STATUS: Exp: [Day: %02x Hour: %02x Minute: %02x Second: %02x] RTL: [Day: %02x Hour: %02x Minute: %02x Second: %02x]",
                      exp_time[31:24],exp_time[23:16],exp_time[15:8],exp_time[7:0],cfg_date[7:0],cfg_time[23:16],cfg_time[15:8],cfg_time[7:0]);
     end else begin
        error_cnt = error_cnt+1;
        $display("ERROR: Exp: [Day: %02x Hour: %02x Minute: %02x Second: %02x] RTL: [Day: %02x Hour: %02x Minute: %02x Second: %02x]",
                      exp_time[31:24],exp_time[23:16],exp_time[15:8],exp_time[7:0],cfg_date[7:0],cfg_time[23:16],cfg_time[15:8],cfg_time[7:0]);
        repeat(10) @(posedge clock);
        $finish;
     end
   end
   if(error_cnt > 0)
      $display("STATUS: Normal Test[Day, Hour,Minute,Second] without Over-ride Failed");
   else
      $display("STATUS: Normal Test[Day, Hour, Minute,Second] without Over-ride Passed");


end
endtask

//------------------------------------------------------
// Fast Time Test With Over-ride fast_sim_time=1
//------------------------------------------------------
task fast_test1;
reg [31:0] exp_time;
integer i;
begin
  //initialize the Timer Structure in C-PLI
   $c_rtc(`CMD_C_INIT,2022,10,19,0,0,0);

   reset();

   reg_write(`REG_TIME,{8'h01,8'h0,8'h0,8'h0});
   reg_write(`REG_DATE,{16'h2022,8'h10,8'h19});
   reg_write(`REG_CMD ,{30'h0,2'b01});

   fork
   begin
      //fast_sim_time=1;
      reg_write(`REG_CTRL ,{16'h0,2'b01,14'h400});
   end
   begin
      for(i=0; i < (65536*10); i = i+1) begin
        repeat(1)	@(negedge trig_s);
        exp_time = $c_rtc(`CMD_C_NEXT_TIME);
        if(exp_time == {rtl_date,rtl_hour,rtl_minute,rtl_time}) begin
           $display("STATUS: Exp: [Day: %02x Hour: %02x Minute: %02x Second: %02x] RTL: [Year:%04x Month: %02x Day: %02x Hour: %02x Minute: %02x Second: %02x]",
                         exp_time[31:24],exp_time[23:16],exp_time[15:8],exp_time[7:0],rtl_year,rtl_month,rtl_date,rtl_hour,rtl_minute,rtl_time);
        end else begin
           error_cnt = error_cnt+1;
           $display("ERROR: Exp: [Day: %02x Hour: %02x Minute: %02x Second: %02x] RTL: [Year:%04x Month: %02x Day: %02x Hour: %02x Minute: %02x Second: %02x]",
                         exp_time[31:24],exp_time[23:16],exp_time[15:8],exp_time[7:0],rtl_year,rtl_month,rtl_date,rtl_hour,rtl_minute,rtl_time);
           repeat(10) @(posedge clock);
           $finish;
        end
      end
    end
    join

   //fast_sim_time=0;
   reg_write(`REG_CTRL ,{16'h0,2'b00,14'h400});

   if(error_cnt > 0)
      $display("STATUS: Fast Test1 with (Fast Time) Over-ride Failed");
   else
      $display("STATUS: Fast Test1 with (Fast Time) Over-ride Passed");
end
endtask

//------------------------------------------------------
// Fast Time Test With Over-ride fast_sim_date=1
//------------------------------------------------------
task fast_test2;
reg [31:0] exp_date;
integer i;
begin
  //initialize the Timer Structure in C-PLI
   $c_rtc(`CMD_C_INIT,2022,10,19,0,0,0);

   reset();

   reg_write(`REG_TIME,{8'h01,8'h0,8'h0,8'h0});
   reg_write(`REG_DATE,{16'h2022,8'h10,8'h19});
   reg_write(`REG_CMD ,{30'h0,2'b01});

   fork
   begin
      //fast_sim_date=1;
      reg_write(`REG_CTRL ,{16'h0,2'b10,14'h400});
      repeat(1) @(posedge clock);
   end
   begin
      for(i=0; i < (65536*10); i = i+1) begin
        repeat(1)	@(negedge trig_d);
        exp_date = $c_rtc(`CMD_C_NEXT_DATE);
        if(exp_date == {rtl_year,rtl_month,rtl_date}) begin
           $display("STATUS: Exp: [Year: %04x Month: %02x Date: %02x] RTL: [Year:%04x Month: %02x Day: %02x]",
                         exp_date[31:16],exp_date[15:8],exp_date[7:0],rtl_year,rtl_month,rtl_date);
        end else begin
           error_cnt = error_cnt+1;
           $display("ERROR: Exp: [Year: %04x Month: %02x Date: %02x] RTL: [Year:%04x Month: %02x Day: %02x]",
                         exp_date[31:16],exp_date[15:8],exp_date[7:0],rtl_year,rtl_month,rtl_date);
           repeat(10) @(posedge clock);
           $finish;
        end
      end
   end
   join

   //fast_sim_date=0;
   reg_write(`REG_CTRL ,{16'h0,2'b00,14'h0});

   if(error_cnt > 0)
      $display("STATUS: Fast Test2 with (Fast Date) Over-ride Failed");
   else
      $display("STATUS: Fast Test2 with (Fast Date) Over-ride Passed");
end
endtask



rtc_top u_dut (
`ifdef USE_POWER_PINS
    .vccd1           (1'b1),    // User area 1 1.8V supply
    .vssd1           (1'b0),    // User area 1 digital ground
`endif
    .sys_clk         (sys_clk), 
    .rtc_clk         (rtc_clk), 
    .rst_n           (rst_n), 

    .reg_cs          (reg_cs), 
    .reg_addr        (reg_addr), 
    .reg_wdata       (reg_wdata), 
    .reg_be          (reg_be), 
    .reg_wr          (reg_wr), 
    .reg_rdata       (reg_rdata), 
    .reg_ack         (reg_ack), 
    .rtc_intr        (rtc_intr),

    .inc_time_s      (trig_s), // Second Trigger
    .inc_date_d      (trig_d)  // Date Trigger

);

wire clock = sys_clk;

//-------------------------------
// Reg Write
//-------------------------------
task reg_write;
input [4:0] address;
input [31:0] data;
begin
  repeat (1) @(posedge clock);
  #1;
  reg_addr      =address;  // address
  reg_wr        ='h1;  // write
  reg_wdata     =data;  // data output
  reg_be        ='hF;  // byte enable
  reg_cs        ='h1;  // strobe/request
  wait(reg_ack == 1);
  repeat (1) @(posedge clock);
  #1;
  reg_cs     ='h0;  // strobe/request
  reg_wr     ='h0;  // strobe/request
  reg_addr   ='h0;  // address
  reg_wdata  ='h0;  // data output
  reg_be     ='h0;  // byte enable
  $display("DEBUG REG WRITE Address : %x, Data : %x",address,data);
  repeat (1) @(posedge clock);
end
endtask


//--------------------------------------
// Reg Read
//--------------------------------------
task  reg_read;
input [4:0] address;
output [31:0] data;
reg    [31:0] data;
begin
  repeat (1) @(posedge clock);
  #1;
  reg_addr  =address;  // address
  reg_wr    ='h0;  // write
  reg_wdata ='0;  // data output
  reg_be    ='hF;  // byte enable
  reg_cs    ='h1;  // strobe/request
  wait(reg_ack == 1);
  repeat (1) @(negedge clock);
  data  = reg_rdata;  
  repeat (1) @(posedge clock);
  #1;
  reg_cs      ='h0;  // strobe/request
  reg_addr    ='h0;  // address
  reg_wr      ='h0;  // write
  reg_wdata   ='h0;  // data output
  reg_be      ='h0;  // byte enable
  $display("DEBUG REG READ Address : %x, Data : %x",address,data);
  repeat (1) @(posedge clock);
end
endtask

//--------------------------------------
// Reg Read and compare
//--------------------------------------
task  reg_read_check;
input [4:0] address;
output [31:0] data;
input [31:0] cmp_data;
reg    [31:0] data;
begin
  repeat (1) @(posedge clock);
  #1;
  reg_addr  =address;  // address
  reg_wr    ='h0;  // write
  reg_wdata ='0;  // data output
  reg_be    ='hF;  // byte enable
  reg_cs    ='h1;  // strobe/request
  wait(reg_ack == 1);
  repeat (1) @(negedge clock);
  data  = reg_rdata;  
  repeat (1) @(posedge clock);
  #1;
  reg_cs     ='h0;  // strobe/request
  reg_addr   ='h0;  // address
  reg_wr     ='h0;  // write
  reg_wdata  ='h0;  // data output
  reg_be     ='h0;  // byte enable
  if(data !== cmp_data) begin
     $display("ERROR : REG READ  Address : 0x%x, Exd: 0x%x Rxd: 0x%x ",address,cmp_data,data);
     test_fail = 1;
  end else begin
     $display("STATUS: REG READ  Address : 0x%x, Data : 0x%x",address,data);
  end
  repeat (1) @(posedge clock);
end
endtask


task  reg_read_cmp;
input [4:0] address;
input [31:0] cmp_data;
reg    [31:0] data;
begin
  repeat (1) @(posedge clock);
  #1;
  reg_addr  =address;  // address
  reg_wr    ='h0;  // write
  reg_wdata ='0;  // data output
  reg_be    ='hF;  // byte enable
  reg_cs    ='h1;  // strobe/request
  wait(reg_ack == 1);
  repeat (1) @(negedge clock);
  data  = reg_rdata;  
  repeat (1) @(posedge clock);
  #1;
  reg_cs     ='h0;  // strobe/request
  reg_addr   ='h0;  // address
  reg_wr     ='h0;  // write
  reg_wdata  ='h0;  // data output
  reg_be     ='h0;  // byte enable
  if(data !== cmp_data) begin
     $display("ERROR : REG READ  Address : 0x%x, Exd: 0x%x Rxd: 0x%x ",address,cmp_data,data);
     test_fail = 1;
  end else begin
     $display("STATUS: REG READ  Address : 0x%x, Data : 0x%x",address,data);
  end
  repeat (1) @(posedge clock);
end
endtask


endmodule


