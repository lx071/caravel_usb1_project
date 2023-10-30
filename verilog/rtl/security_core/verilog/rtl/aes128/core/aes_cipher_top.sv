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
                                                              
                   AES Encription Core Module                                             
                                                              
  Description                                                 
     AES Top module includes 128 bit aes_cipher 
     
  To Do:                                                      
    1. Integration 192/256 AES
                                                              
  Author(s):                                                  
      - Rudolf Usselmann ,rudi@asics.ws                        
      - Dinesh Annayya, dinesh.annayya@gmail.com                 
                                                              
  Revision :                                                  
     0.0  - Oct 15, 2022 
            Initial Version picked from https://opencores.org/ocsvn/aes_core                                    
     0.1  - Nov 3, 2022
            Following changes are done
            1. To reduce the design area 
               A. aes_sbox used sequentially for 16 cycle for text compuation 
               B. 4 cycle for next round key computation
     0.2  - Nov 5, 2022
            A. Added 4 cycle pipe line mix column function -
            B. Moved all the counter and control to FSM logic
************************************************************************************/
/************************************************************************************
                      Copyright (C) 2000-2002 
              Rudolf Usselmann,www.asics.ws <rudi@asics.ws>
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

module aes_cipher_top(
    input  logic           clk, 
    input  logic           rstn, 
    input  logic           ld, 
    output logic           done, 
    input  logic [127:0]   key, 
    input  logic [127:0]   text_in, 
    output logic [127:0]   text_out 
   );

parameter IDLE        = 2'b00;
parameter SBOX_DONE   = 2'b01;
parameter MIX_DONE    = 2'b10;
parameter NEXT_ROUND  = 2'b11;

////////////////////////////////////////////////////////////////////
//
// Local Wires
//

logic 	[31:0]	w0, w1, w2, w3;
logic   [127:0]	text_in_r;
logic   [7:0]   sa00, sa01, sa02, sa03;
logic   [7:0]   sa10, sa11, sa12, sa13;
logic   [7:0]   sa20, sa21, sa22, sa23;
logic   [7:0]   sa30, sa31, sa32, sa33;
logic 	[7:0]   sa00_next, sa01_next, sa02_next, sa03_next;
logic 	[7:0]   sa10_next, sa11_next, sa12_next, sa13_next;
logic 	[7:0]   sa20_next, sa21_next, sa22_next, sa23_next;
logic 	[7:0]   sa30_next, sa31_next, sa32_next, sa33_next;
logic 	[7:0]   sa00_sub, sa01_sub, sa02_sub, sa03_sub;
logic 	[7:0]   sa10_sub, sa11_sub, sa12_sub, sa13_sub;
logic 	[7:0]   sa20_sub, sa21_sub, sa22_sub, sa23_sub;
logic 	[7:0]   sa30_sub, sa31_sub, sa32_sub, sa33_sub;
logic 	[7:0]   sa00_sr, sa01_sr, sa02_sr, sa03_sr;
logic 	[7:0]   sa10_sr, sa11_sr, sa12_sr, sa13_sr;
logic 	[7:0]   sa20_sr, sa21_sr, sa22_sr, sa23_sr;
logic 	[7:0]   sa30_sr, sa31_sr, sa32_sr, sa33_sr;
logic 	[7:0]   sa00_mc, sa01_mc, sa02_mc, sa03_mc;
logic 	[7:0]   sa10_mc, sa11_mc, sa12_mc, sa13_mc;
logic 	[7:0]   sa20_mc, sa21_mc, sa22_mc, sa23_mc;
logic 	[7:0]   sa30_mc, sa31_mc, sa32_mc, sa33_mc;
logic 		    ld_r;
logic 	[3:0]   dcnt;
logic  [3:0]    scnt; // Step count, number step/cycle need to complete one round
logic  [1:0]    mcnt; // Mix count, number cycle need to complete column mix
logic           active_s; // indicate active sbox phase
logic           active_m; // indicate active mix phase
logic           nxt_step;
logic           done_pre;
logic [1:0]     state;
////////////////////////////////////////////////////////////////////
//
// Misc Logic
//

always @(posedge clk) ld_r <= ld;

//
// FSM Logic
//
/**********************************************************************************************************************
  Note: We are not waiting for Next Key ready in each round as it takes only 4 cycle to generate next key, 
        where as SBox+ Mix Col takes 16+4 = 20 cycles, And Key will be uses in final compuation at last cycle (20th cycle)
***********************************************************************************************************************/
always @(posedge clk or negedge rstn) begin
   if(!rstn) begin
       done     <= 1'b0;
       done_pre <= 1'b0; 
       dcnt     <= 4'h0;
       scnt     <= 4'h0;
       mcnt     <= 2'h0;
       active_s <= 1'b0;
       active_m <= 1'b0;
       nxt_step <= 1'b0;
       state    <= IDLE;
   end else begin
      case(state)
      IDLE: begin
           done     <= done_pre; // Generate One cycle delayed
           done_pre <= 1'b0; 
           if(ld_r) begin
              dcnt     <= 4'ha;
              nxt_step <= 1'b0;
              scnt     <= 4'h0;
              active_s <= 1'b1;
              state    <= SBOX_DONE;
           end
        end
      SBOX_DONE: begin
           if(scnt == 4'hF) begin
              active_s  <= 1'b0;
              active_m  <= 1'b1;
              mcnt      <= 2'h0;
              state     <= MIX_DONE;
           end else begin
              scnt <= scnt + 1;
           end
        end
      MIX_DONE: begin
           if(mcnt == 2'h3) begin
              nxt_step <= 1;
              active_s  <= 1'b0;
              active_m  <= 1'b0;
              state     <= NEXT_ROUND;
           end else begin
              mcnt <= mcnt + 1;
           end
      end
      NEXT_ROUND: begin
           nxt_step <= 0;
           dcnt      <= dcnt - 4'h1;
           if(dcnt == 4'b1) begin 
              done_pre <= 1;
              state    <= IDLE;
           end else begin
              scnt     <= 4'h0;
              active_s <= 1'b1;
              state    <= SBOX_DONE;
           end
      end
      endcase
   end
end

////////////////////////////////////////////////////////////////////
//
// Initial Permutation (AddRoundKey)
//

always @(posedge clk)	sa33 <=  ld_r ? text_in[007:000] ^ w3[07:00] : (nxt_step) ? sa33_next : sa33  ;
always @(posedge clk)	sa23 <=  ld_r ? text_in[015:008] ^ w3[15:08] : (nxt_step) ? sa23_next : sa23  ;
always @(posedge clk)	sa13 <=  ld_r ? text_in[023:016] ^ w3[23:16] : (nxt_step) ? sa13_next : sa13  ;
always @(posedge clk)	sa03 <=  ld_r ? text_in[031:024] ^ w3[31:24] : (nxt_step) ? sa03_next : sa03  ;
always @(posedge clk)	sa32 <=  ld_r ? text_in[039:032] ^ w2[07:00] : (nxt_step) ? sa32_next : sa32  ;
always @(posedge clk)	sa22 <=  ld_r ? text_in[047:040] ^ w2[15:08] : (nxt_step) ? sa22_next : sa22  ;
always @(posedge clk)	sa12 <=  ld_r ? text_in[055:048] ^ w2[23:16] : (nxt_step) ? sa12_next : sa12  ;
always @(posedge clk)	sa02 <=  ld_r ? text_in[063:056] ^ w2[31:24] : (nxt_step) ? sa02_next : sa02  ;
always @(posedge clk)	sa31 <=  ld_r ? text_in[071:064] ^ w1[07:00] : (nxt_step) ? sa31_next : sa31  ;
always @(posedge clk)	sa21 <=  ld_r ? text_in[079:072] ^ w1[15:08] : (nxt_step) ? sa21_next : sa21  ;
always @(posedge clk)	sa11 <=  ld_r ? text_in[087:080] ^ w1[23:16] : (nxt_step) ? sa11_next : sa11  ;
always @(posedge clk)	sa01 <=  ld_r ? text_in[095:088] ^ w1[31:24] : (nxt_step) ? sa01_next : sa01  ;
always @(posedge clk)	sa30 <=  ld_r ? text_in[103:096] ^ w0[07:00] : (nxt_step) ? sa30_next : sa30  ;
always @(posedge clk)	sa20 <=  ld_r ? text_in[111:104] ^ w0[15:08] : (nxt_step) ? sa20_next : sa20  ;
always @(posedge clk)	sa10 <=  ld_r ? text_in[119:112] ^ w0[23:16] : (nxt_step) ? sa10_next : sa10  ;
always @(posedge clk)	sa00 <=  ld_r ? text_in[127:120] ^ w0[31:24] : (nxt_step) ? sa00_next : sa00  ;

////////////////////////////////////////////////////////////////////
//
// Round Permutations
//

assign sa00_sr = sa00_sub;
assign sa01_sr = sa01_sub;
assign sa02_sr = sa02_sub;
assign sa03_sr = sa03_sub;
assign sa10_sr = sa11_sub;
assign sa11_sr = sa12_sub;
assign sa12_sr = sa13_sub;
assign sa13_sr = sa10_sub;
assign sa20_sr = sa22_sub;
assign sa21_sr = sa23_sub;
assign sa22_sr = sa20_sub;
assign sa23_sr = sa21_sub;
assign sa30_sr = sa33_sub;
assign sa31_sr = sa30_sub;
assign sa32_sr = sa31_sub;
assign sa33_sr = sa32_sub;

//------------------------------------------------------------------------------------
// To Reduce the total area of the aes, we have divided the mix_col access to 4 cycle
//------------------------------------------------------------------------------------
logic [31:0] mbox_arry[0:3];
logic [31:0] mbox_in;
logic [31:0] mbox_out;

always @(posedge clk)
begin
   mbox_arry[mcnt] <=  mbox_out;
end

always_comb
begin
  mbox_in = 0;
  case(mcnt)
  'h0:  mbox_in = {sa00_sr,sa10_sr,sa20_sr,sa30_sr};
  'h1:  mbox_in = {sa01_sr,sa11_sr,sa21_sr,sa31_sr};
  'h2:  mbox_in = {sa02_sr,sa12_sr,sa22_sr,sa32_sr};
  'h3:  mbox_in = {sa03_sr,sa13_sr,sa23_sr,sa33_sr};
  endcase
end

assign mbox_out = mix_col(mbox_in[31:24],mbox_in[23:16],mbox_in[15:8],mbox_in[7:0]);

assign {sa00_mc, sa10_mc, sa20_mc, sa30_mc}  = mbox_arry[0];
assign {sa01_mc, sa11_mc, sa21_mc, sa31_mc}  = mbox_arry[1];
assign {sa02_mc, sa12_mc, sa22_mc, sa32_mc}  = mbox_arry[2];
assign {sa03_mc, sa13_mc, sa23_mc, sa33_mc}  = mbox_arry[3];

/***
assign {sa00_mc, sa10_mc, sa20_mc, sa30_mc}  = mix_col(sa00_sr,sa10_sr,sa20_sr,sa30_sr);
assign {sa01_mc, sa11_mc, sa21_mc, sa31_mc}  = mix_col(sa01_sr,sa11_sr,sa21_sr,sa31_sr);
assign {sa02_mc, sa12_mc, sa22_mc, sa32_mc}  = mix_col(sa02_sr,sa12_sr,sa22_sr,sa32_sr);
assign {sa03_mc, sa13_mc, sa23_mc, sa33_mc}  = mix_col(sa03_sr,sa13_sr,sa23_sr,sa33_sr);
***/


assign sa00_next = sa00_mc ^ w0[31:24];
assign sa01_next = sa01_mc ^ w1[31:24];
assign sa02_next = sa02_mc ^ w2[31:24];
assign sa03_next = sa03_mc ^ w3[31:24];
assign sa10_next = sa10_mc ^ w0[23:16];
assign sa11_next = sa11_mc ^ w1[23:16];
assign sa12_next = sa12_mc ^ w2[23:16];
assign sa13_next = sa13_mc ^ w3[23:16];
assign sa20_next = sa20_mc ^ w0[15:08];
assign sa21_next = sa21_mc ^ w1[15:08];
assign sa22_next = sa22_mc ^ w2[15:08];
assign sa23_next = sa23_mc ^ w3[15:08];
assign sa30_next = sa30_mc ^ w0[07:00];
assign sa31_next = sa31_mc ^ w1[07:00];
assign sa32_next = sa32_mc ^ w2[07:00];
assign sa33_next = sa33_mc ^ w3[07:00];

////////////////////////////////////////////////////////////////////
//
// Final text output
//

always @(posedge clk) if(done_pre) text_out[127:120] <=  sa00_sr ^ w0[31:24];
always @(posedge clk) if(done_pre) text_out[095:088] <=  sa01_sr ^ w1[31:24];
always @(posedge clk) if(done_pre) text_out[063:056] <=  sa02_sr ^ w2[31:24];
always @(posedge clk) if(done_pre) text_out[031:024] <=  sa03_sr ^ w3[31:24];
always @(posedge clk) if(done_pre) text_out[119:112] <=  sa10_sr ^ w0[23:16];
always @(posedge clk) if(done_pre) text_out[087:080] <=  sa11_sr ^ w1[23:16];
always @(posedge clk) if(done_pre) text_out[055:048] <=  sa12_sr ^ w2[23:16];
always @(posedge clk) if(done_pre) text_out[023:016] <=  sa13_sr ^ w3[23:16];
always @(posedge clk) if(done_pre) text_out[111:104] <=  sa20_sr ^ w0[15:08];
always @(posedge clk) if(done_pre) text_out[079:072] <=  sa21_sr ^ w1[15:08];
always @(posedge clk) if(done_pre) text_out[047:040] <=  sa22_sr ^ w2[15:08];
always @(posedge clk) if(done_pre) text_out[015:008] <=  sa23_sr ^ w3[15:08];
always @(posedge clk) if(done_pre) text_out[103:096] <=  sa30_sr ^ w0[07:00];
always @(posedge clk) if(done_pre) text_out[071:064] <=  sa31_sr ^ w1[07:00];
always @(posedge clk) if(done_pre) text_out[039:032] <=  sa32_sr ^ w2[07:00];
always @(posedge clk) if(done_pre) text_out[007:000] <=  sa33_sr ^ w3[07:00];

////////////////////////////////////////////////////////////////////
//
// Generic Functions
//

function [31:0] mix_col;
input	[7:0]	s0,s1,s2,s3;
reg	[7:0]	s0_o,s1_o,s2_o,s3_o;
begin
mix_col[31:24]=xtime(s0)^xtime(s1)^s1^s2^s3;
mix_col[23:16]=s0^xtime(s1)^xtime(s2)^s2^s3;
mix_col[15:08]=s0^s1^xtime(s2)^xtime(s3)^s3;
mix_col[07:00]=xtime(s0)^s0^s1^s2^xtime(s3);
end
endfunction

function [7:0] xtime;
input [7:0] b; xtime={b[6:0],1'b0}^(8'h1b&{8{b[7]}});
endfunction

////////////////////////////////////////////////////////////////////
//
// Modules
//

aes_key_expand_128 u0(
	.clk    ( clk	      ),
    .rstn   ( rstn        ),
	.kld    ( ld	      ),
    .knxt   ( nxt_step    ),
	.key    ( key	      ),
	.wo_0   ( w0	      ),
	.wo_1   ( w1	      ),
	.wo_2   ( w2	      ),
	.wo_3   ( w3	      ));


//------------------------------------------------------------------------------------
// To Reduce the total area of the aes, we have divided the sbox access to 16 cycle
//------------------------------------------------------------------------------------
reg [7:0] sbox_arry[0:15];
reg [7:0] sbox_in;
reg [7:0] sbox_out;

always @(posedge clk)
begin
     sbox_arry[scnt] <=  sbox_out;
end

always_comb
begin
  sbox_in = 0;
  case(scnt)
  'h0:  sbox_in = sa00;
  'h1:  sbox_in = sa01;
  'h2:  sbox_in = sa02;
  'h3:  sbox_in = sa03;
  'h4:  sbox_in = sa10;
  'h5:  sbox_in = sa11;
  'h6:  sbox_in = sa12;
  'h7:  sbox_in = sa13;
  'h8:  sbox_in = sa20;
  'h9:  sbox_in = sa21;
  'hA:  sbox_in = sa22;
  'hB:  sbox_in = sa23;
  'hC:  sbox_in = sa30;
  'hD:  sbox_in = sa31;
  'hE:  sbox_in = sa32;
  'hF:  sbox_in = sa33;
  endcase
end

assign sa00_sub=sbox_arry[0];
assign sa01_sub=sbox_arry[1];
assign sa02_sub=sbox_arry[2];
assign sa03_sub=sbox_arry[3];
assign sa10_sub=sbox_arry[4];
assign sa11_sub=sbox_arry[5];
assign sa12_sub=sbox_arry[6];
assign sa13_sub=sbox_arry[7];
assign sa20_sub=sbox_arry[8];
assign sa21_sub=sbox_arry[9];
assign sa22_sub=sbox_arry[10];
assign sa23_sub=sbox_arry[11];
assign sa30_sub=sbox_arry[12];
assign sa31_sub=sbox_arry[13];
assign sa32_sub=sbox_arry[14];
assign sa33_sub=sbox_arry[15];

aes_sbox us(	.a(	sbox_in	), .d(	sbox_out	));

/***
aes_sbox us00(	.a(	sa00	), .d(	sa00_sub	));
aes_sbox us01(	.a(	sa01	), .d(	sa01_sub	));
aes_sbox us02(	.a(	sa02	), .d(	sa02_sub	));
aes_sbox us03(	.a(	sa03	), .d(	sa03_sub	));
aes_sbox us10(	.a(	sa10	), .d(	sa10_sub	));
aes_sbox us11(	.a(	sa11	), .d(	sa11_sub	));
aes_sbox us12(	.a(	sa12	), .d(	sa12_sub	));
aes_sbox us13(	.a(	sa13	), .d(	sa13_sub	));
aes_sbox us20(	.a(	sa20	), .d(	sa20_sub	));
aes_sbox us21(	.a(	sa21	), .d(	sa21_sub	));
aes_sbox us22(	.a(	sa22	), .d(	sa22_sub	));
aes_sbox us23(	.a(	sa23	), .d(	sa23_sub	));
aes_sbox us30(	.a(	sa30	), .d(	sa30_sub	));
aes_sbox us31(	.a(	sa31	), .d(	sa31_sub	));
aes_sbox us32(	.a(	sa32	), .d(	sa32_sub	));
aes_sbox us33(	.a(	sa33	), .d(	sa33_sub	));
***/

endmodule


